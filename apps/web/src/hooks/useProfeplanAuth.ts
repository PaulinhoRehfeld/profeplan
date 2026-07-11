import React, { createContext, useContext, useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { getUserProfile, checkAndRewardReferrer, getProfileByEmail } from '../services/ProfileService';
import { getRoleByEmail, clearLocalSession } from '../utils/authUtils';
import { UserSession, UserProfile } from '../types';
import { isHardcodedAdmin } from '../constants';

const applyAdminOverride = (profile: UserProfile, email: string | null | undefined): UserProfile => {
    if (!isHardcodedAdmin(email)) return profile;
    return { ...profile, role: 'admin', is_admin: true, tier: 'GOLD', is_unlimited: true };
};

interface ProfeplanAuthContextValue {
    session: UserSession | null;
    setSession: React.Dispatch<React.SetStateAction<UserSession | null>>;
    userProfile: UserProfile | null;
    setUserProfile: React.Dispatch<React.SetStateAction<UserProfile | null>>;
    loading: boolean;
    refreshProfile: () => Promise<void>;
}

const ProfeplanAuthContext = createContext<ProfeplanAuthContextValue | null>(null);

const useProvideProfeplanAuth = (): ProfeplanAuthContextValue => {
    const [session, setSession] = useState<UserSession | null>(() => {
        try {
            const saved = localStorage.getItem('profeplan_session');
            console.log('[Auth] Initializing session state from LS:', !!saved);
            return saved ? JSON.parse(saved) : null;
        } catch (e) {
            console.error('[Auth] Initial LS parse failed:', e);
            return null;
        }
    });

    const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
    const [loading, setLoading] = useState(true);

    // CENTRALIZED AUTH LOGIC
    useEffect(() => {
        console.log('[Auth] Initializing Listener...');
        let cancelled = false;

        const handleLogin = async (authSession: any) => {
            let profile: UserProfile | null = null;
            try {
                const userId = authSession?.user?.id;
                const userEmail = authSession?.user?.email;

                if (!userId) throw new Error("No User ID in session");

                console.log(`[Auth] 🔑 Starting Login Sequence for: ${userEmail}`);

                // 1. Fetch Profile
                console.log('[Auth] 📡 Fetching profile...');
                profile = await getUserProfile(userId, userEmail);

                if (!profile) {
                    console.warn(`[Auth] ⚠️ Profile not found for ID ${userId}. Status: Mismatch/Missing.`);
                } else {
                    console.log('[Auth] ✅ Profile found:', {
                        role: profile.role,
                        isAdmin: profile.is_admin,
                        tier: profile.tier
                    });
                }

                // 2. GHOST ID: If profile not found by ID but exists by Email, use it directly.
                // NÃO tentamos mais fazer UPDATE profiles SET id=... aqui: a RLS
                // (auth.uid() = id) bloqueia esse UPDATE vindo do cliente — afeta 0 linhas
                // sem erro (por definição, é o caso Ghost ID), então o "healing" nunca
                // funcionava de fato. Isso mascarava a falha e levava ao passo de Emergency
                // Creation logo abaixo, criando um perfil DUPLICADO (órfão o registro real,
                // com créditos/histórico) e deixando o usuário preso sem erro visível.
                // Em vez disso, usamos a linha encontrada por email diretamente — mesmo
                // padrão que getUserProfile()/getProfileByEmail() já aplicam.
                if (!profile && userEmail) {
                    console.warn(`[Auth] 🩹 Profile not found for ID ${userId}. Searching by email (Ghost ID)...`);
                    const { data: existing } = await getProfileByEmail(userEmail);

                    if (existing) {
                        console.log('[Auth] 🩹 Ghost ID detectado — usando perfil encontrado por email (sem alterar a PK).');
                        profile = existing as UserProfile;
                    }
                }

                // 3. EMERGENCY CREATION: If still no profile, create a new one
                if (!profile) {
                    console.warn(`[Auth] 🩹 Profile STILL null for ID ${userId}. Attempting emergency creation...`);
                    const isAdminEmail = isHardcodedAdmin(userEmail);
                    const { data: upsertData, error: upsertError } = await supabase.from('profiles').upsert({
                        id: userId,
                        email: userEmail,
                        full_name: authSession.user.user_metadata?.full_name || '',
                        role: isAdminEmail ? 'admin' : getRoleByEmail(userEmail || ''),
                        tier: isAdminEmail ? 'GOLD' : 'SILVER',
                        credits: isAdminEmail ? 9999 : 10,
                        is_unlimited: isAdminEmail,
                        is_admin: isAdminEmail,
                        allowed_features: ['all']
                    }, { onConflict: 'id' });

                    if (!upsertError) {
                        profile = await getUserProfile(userId, userEmail);
                        if (userEmail) await checkAndRewardReferrer(userEmail);
                    } else {
                        console.error('[Auth] ❌ Profile creation failed:', upsertError);
                    }
                }

                // 4. ADMIN SYNC: Ensure hardcoded admins have correct flags
                if (profile && userEmail) {
                    profile = applyAdminOverride(profile, userEmail);
                }

                // 5. CONSOLIDATE SESSION
                const roleMapping = (profile?.is_admin || profile?.role === 'admin') ? 'ADMIN' : (profile?.role === 'manager' ? 'SCHOOL_MANAGER' : 'TEACHER');

                const newSession: UserSession = {
                    id: userId, // Always use the AUTH ID as primary
                    email: userEmail || '',
                    role: roleMapping as any,
                    accessLevel: (profile?.tier as any) || 'BASICO',
                    isLoggedIn: true,
                    isEmailConfirmed: !!(authSession.user?.email_confirmed_at || authSession.user?.confirmed_at)
                };

                // 6. STABLE STATE UPDATE
                // Guard cancelled para evitar atualizar estado de componente desmontado
                if (!cancelled) {
                    setSession(prev => {
                        const isIdentical = prev?.id === newSession.id && prev?.role === newSession.role && prev?.accessLevel === newSession.accessLevel;
                        if (isIdentical) {
                            console.log('[Auth] Session stable. Skipping update.');
                            return prev;
                        }
                        console.log('[Auth] Updating session state.');
                        return newSession;
                    });

                    if (profile) {
                        setUserProfile(profile);
                    }
                }

                // 7. PERSISTENCE (Selective - No more clear())
                try {
                    localStorage.setItem('profeplan_session', JSON.stringify(newSession));
                    localStorage.setItem('supabase_user_id', userId);
                } catch (e) {
                    console.warn('[Auth] LS Storage failed (Chromebook limit?)', e);
                }

                console.log('[Auth] ✅ Login sequence finished.');
            } catch (err: any) {
                console.error('[Auth] 🚨 Fatal error in handleLogin:', err?.message || err);
                if (!cancelled) setUserProfile(null);
            } finally {
                console.log('[Auth] 🏁 handleLogin finalized.');
                if (!cancelled) setLoading(false);
            }
        };

        const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, authSession) => {
            console.log(`[Auth] 📡 Event: ${event} | User: ${authSession?.user?.email || 'none'}`);

            if (event === 'SIGNED_IN' || event === 'INITIAL_SESSION' || event === 'USER_UPDATED') {
                if (authSession) {
                    handleLogin(authSession).catch(err => {
                        console.error("[Auth] 🚨 handleLogin failed inside listener:", err);
                        setLoading(false);
                    });
                } else {
                    if (event === 'INITIAL_SESSION') {
                        // Supabase confirma sem sessão ativa — limpa sessão customizada stale
                        // Evita estado quebrado: UI mostra logado mas JWT morto bloqueia todas as queries
                        console.warn('[Auth] ⚠️ INITIAL_SESSION sem authSession — limpando sessão stale.');
                        clearLocalSession();
                        if (!cancelled) {
                            setSession(null);
                            setUserProfile(null);
                        }
                        setLoading(false);
                    }
                }
            } else if (event === 'SIGNED_OUT') {
                console.log('[Auth] 🚪 Sign out detected. Cleaning auth keys.');
                setSession(null);
                setUserProfile(null);
                // SAFE CLEANING: Do NOT use clear(), keep settings!
                clearLocalSession();
                setLoading(false);
            } else {
                setLoading(false);
            }
        });

        // Deep Link Logic (Preserved and sanitized)
        const initCapacitor = async () => {
            try {
                const { App } = await import('@capacitor/app');
                App.addListener('appUrlOpen', (data) => {
                    try {
                        if (!data?.url) return;
                        const url = new URL(data.url);
                        if (url.searchParams.get('success') === 'true') {
                            alert('✅ Pagamento processado! Seus créditos serão atualizados em instantes.');
                        }
                        const hash = url.hash.substring(1);
                        const params = new URLSearchParams(hash);
                        const access_token = params.get('access_token');
                        const refresh_token = params.get('refresh_token');

                        if (access_token && refresh_token) {
                            supabase.auth.setSession({ access_token, refresh_token });
                        }
                    } catch (urlErr) {
                        console.error("[Auth] DeepLink Parse Fail:", urlErr);
                    }
                });
            } catch (capErr) {
                console.log("[Auth] Capacitor App plugin not available/mobile features skipped.");
            }
        };

        if (typeof window !== 'undefined') {
            initCapacitor();
        }

        return () => {
            cancelled = true;
            subscription.unsubscribe();
        };
    }, []);

    const refreshProfile = async () => {
        if (session?.id) {
            const rawProfile = await getUserProfile(session.id, session.email);
            if (rawProfile) {
                const profileData = applyAdminOverride(rawProfile, session.email);
                setUserProfile(profileData);
                const derivedRole = profileData.role === 'manager'
                    ? 'SCHOOL_MANAGER'
                    : (profileData.is_admin || profileData.role === 'admin' ? 'ADMIN' : 'TEACHER');

                if (session.role !== derivedRole) {
                    const updatedSession = { ...session, role: derivedRole as any };
                    setSession(updatedSession);
                    localStorage.setItem('profeplan_session', JSON.stringify(updatedSession));
                }
            }
        }
    };

    return { session, setSession, userProfile, setUserProfile, loading, refreshProfile };
};

export const ProfeplanAuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const value = useProvideProfeplanAuth();
    return React.createElement(ProfeplanAuthContext.Provider, { value }, children);
};

export const useProfeplanAuth = () => {
    const context = useContext(ProfeplanAuthContext);
    if (!context) {
        throw new Error('useProfeplanAuth must be used within ProfeplanAuthProvider');
    }
    return context;
};
