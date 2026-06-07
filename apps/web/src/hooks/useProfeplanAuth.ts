import { useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { getUserProfile, checkAndRewardReferrer, getProfileByEmail } from '../services/ProfileService';
import { getRoleByEmail } from '../utils/authUtils';
import { UserSession, UserProfile } from '../types';

export const useProfeplanAuth = () => {
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

                // 2. GHOST ID HEALING: If profile not found by ID but exists by Email
                if (!profile && userEmail) {
                    console.warn(`[Auth] 🩹 Profile not found for ID ${userId}. Searching by email...`);
                    const { data: existing } = await getProfileByEmail(userEmail);

                    if (existing) {
                        console.log(`[Auth] 🩹🩹 GHOST ID DETECTED. Healing Database...`);
                        // Instead of patching the session JS object (which causes loops), 
                        // we patch the Profiles table to point to the current session ID.
                        const { error: healError } = await supabase
                            .from('profiles')
                            .update({ id: userId }) // Match DB to current Auth ID
                            .eq('email', userEmail);

                        if (!healError) {
                            console.log('[Auth] ✅ Database healed successfully.');
                            profile = await getUserProfile(userId, userEmail);
                        } else {
                            console.error('[Auth] ❌ Healing failed at DB level:', healError);
                        }
                    }
                }

                // 3. EMERGENCY CREATION: If still no profile, create a new one
                if (!profile) {
                    console.warn(`[Auth] 🩹 Profile STILL null for ID ${userId}. Attempting emergency creation...`);
                    const { data: upsertData, error: upsertError } = await supabase.from('profiles').upsert({
                        id: userId,
                        email: userEmail,
                        full_name: authSession.user.user_metadata?.full_name || '',
                        role: getRoleByEmail(userEmail || ''),
                        tier: 'SILVER',
                        credits: 10,
                        is_unlimited: false,
                        is_admin: false,
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
                const hardcodedAdmins = ['prehfeld@hotmail.com', 'suporte@profeplan.com.br'];
                if (profile && userEmail && hardcodedAdmins.includes(userEmail.toLowerCase())) {
                    profile.role = 'admin';
                    profile.is_admin = true;
                    profile.tier = 'GOLD';
                    profile.is_unlimited = true;
                }

                // 5. CONSOLIDATE SESSION
                const roleMapping = (profile?.is_admin || profile?.role === 'admin') ? 'ADMIN' : (profile?.role === 'manager' ? 'SCHOOL_MANAGER' : 'TEACHER');

                const newSession: UserSession = {
                    id: userId, // Always use the AUTH ID as primary
                    email: userEmail || '',
                    role: roleMapping as any,
                    accessLevel: (profile?.tier as any) || 'BASICO',
                    isLoggedIn: true,
                    isEmailConfirmed: true // BYPASS Loop
                };

                // 6. STABLE STATE UPDATE
                // We only update if something changed to avoid re-render loops
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
                    setUserProfile(profile); // Simplify: React handles identical values well for simple objects
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
                setUserProfile(null);
            } finally {
                console.log('[Auth] 🏁 handleLogin finalized.');
                setLoading(false);
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
                    // Logic for INITIAL_SESSION with no authSession
                    if (event === 'INITIAL_SESSION') {
                        console.log('[Auth] ℹ️ Initial session checked - No active persistent session found.');
                        setLoading(false);
                    }
                }
            } else if (event === 'SIGNED_OUT') {
                console.log('[Auth] 🚪 Sign out detected. Cleaning auth keys.');
                setSession(null);
                setUserProfile(null);
                // SAFE CLEANING: Do NOT use clear(), keep settings!
                try {
                    localStorage.removeItem('profeplan_session');
                    localStorage.removeItem('supabase_user_id');
                    localStorage.removeItem('supabase.auth.token'); // standard supabase key
                } catch (e) { }
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
            subscription.unsubscribe();
        };
    }, []);

    const refreshProfile = async () => {
        if (session?.id) {
            const profileData = await getUserProfile(session.id, session.email);
            if (profileData) {
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
