import { useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { getUserProfile, checkAndRewardReferrer } from '../services/userService';
import { getRoleByEmail } from '../utils/authUtils';
import { UserSession, UserProfile } from '../types';

export const useProfeplanAuth = () => {
    const [session, setSession] = useState<UserSession | null>(() => {
        try {
            const saved = localStorage.getItem('profeplan_session');
            return saved ? JSON.parse(saved) : null;
        } catch (e) {
            return null;
        }
    });

    const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (session?.id) {
            const initSession = async () => {
                let profileData = null;
                try {
                    profileData = await getUserProfile(session.id);
                } catch (e) { console.warn("Primary fetch failed, attempting healing..."); }

                // SELF-HEALING: If ID invalid/mismatch (DbRole=null), try by Email
                if (!profileData && session.email) {
                    console.warn(`[App] Profile not found for ID ${session.id}. Attempting recovery by email...`);
                    try {
                        const { getProfileByEmail } = await import('../services/userService');
                        const { data: recoveredProfile } = await getProfileByEmail(session.email);

                        if (recoveredProfile) {
                            console.log(`[App] 🩹 SESSION HEALED! ID Mismatch detected.`);
                            console.log(`Old ID: ${session.id} -> New ID: ${recoveredProfile.id}`);

                            // Patch Session
                            session.id = recoveredProfile.id;
                            profileData = recoveredProfile;

                            // Update Storage immediately
                            localStorage.setItem('profeplan_session', JSON.stringify(session));
                            localStorage.setItem('supabase_user_id', recoveredProfile.id);
                        }
                    } catch (err) {
                        console.error("Healing failed:", err);
                    }
                }

                // 3. EMERGENCY FALLBACK: Blocked by RLS? Construct Fake Admin
                if (!profileData && session.email === 'prehfeld@hotmail.com') {
                    console.warn('[App] 🚨 RLS Blocked Profile Read. Constructing Emergency Admin Profile.');
                    profileData = {
                        id: session.id,
                        email: session.email,
                        role: 'admin',
                        is_admin: true,
                        tier: 'GOLD',
                        is_unlimited: true,
                        credits: 9999,
                        allowed_features: ['all'],
                        created_at: new Date().toISOString()
                    } as any;
                }

                if (profileData) {
                    // --- GOD MODE & ROLE FIX ---
                    const hardcodedAdminEmails = ['prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br'];
                    const isHardcodedAdmin = profileData.email && hardcodedAdminEmails.includes(profileData.email.toLowerCase());

                    if (isHardcodedAdmin) {
                        console.log('[App] 🛡️ Applying GOD MODE override');
                        profileData.role = 'admin';
                        profileData.is_admin = true;
                        profileData.tier = 'GOLD';
                        profileData.is_unlimited = true;
                    }

                    console.log('[App] Profile loaded:', profileData);
                    setUserProfile(profileData);

                    // AUTO-CORRECT SESSION ROLE FROM PROFILE
                    const derivedRole = profileData.role === 'manager'
                        ? 'SCHOOL_MANAGER'
                        : (isHardcodedAdmin || profileData.is_admin || profileData.role === 'admin' ? 'ADMIN' : 'TEACHER');

                    if (session.role !== derivedRole) {
                        console.log(`[App] Correcting Session Role: ${session.role} -> ${derivedRole}`);
                        const newSession = { ...session, role: derivedRole };
                        setSession(newSession);
                        localStorage.setItem('profeplan_session', JSON.stringify(newSession));
                    }
                } else {
                    console.error('[App] Failed to load user profile (Fatal)');
                }
                setLoading(false);
            };

            initSession();
        } else {
            setLoading(false);
        }
    }, [session?.id]); // Only re-run if session ID changes (login)

    // Listener para mudanças de autenticação (Web e Mobile)
    useEffect(() => {
        const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, authSession) => {
            console.log('[App] Auth State Change:', event, authSession?.user?.email);

            if (event === 'SIGNED_IN' && authSession) {
                let profile = await getUserProfile(authSession.user.id);

                if (!profile) {
                    console.log('[App] Profile not found, creating default profile...');
                    const { error: insertError } = await supabase.from('profiles').insert({
                        id: authSession.user.id,
                        email: authSession.user.email,
                        role: getRoleByEmail(authSession.user.email || ''),
                        tier: 'SILVER',
                        credits: 10,
                        is_unlimited: false,
                        is_admin: false,
                        allowed_features: ['all']
                    });

                    if (insertError) {
                        console.error('[App] Failed to create profile:', insertError);
                    } else {
                        console.log('[App] Profile created successfully');
                        await checkAndRewardReferrer(authSession.user.email || '');
                        profile = await getUserProfile(authSession.user.id);
                        console.log('[App] Profile reloaded after creation:', profile);
                    }
                } else {
                    console.log('[App] Profile found:', profile);
                }

                const newSession: UserSession = {
                    id: authSession.user.id,
                    email: authSession.user.email || '',
                    role: profile?.is_admin || profile?.role === 'admin' ? 'ADMIN' : (profile?.role === 'manager' ? 'SCHOOL_MANAGER' : 'TEACHER'),
                    accessLevel: (profile?.tier as any) || 'BASICO',
                    isLoggedIn: true,
                    isEmailConfirmed: !!authSession.user.email_confirmed_at
                };

                console.log('[App] Updating session after auth state change:', newSession);
                setSession(newSession);
                setUserProfile(profile);
                localStorage.setItem('profeplan_session', JSON.stringify(newSession));
                localStorage.setItem('supabase_user_id', authSession.user.id);
            } else if (event === 'SIGNED_OUT') {
                console.log('[App] User signed out');
                setSession(null);
                setUserProfile(null);
                localStorage.removeItem('profeplan_session');
                localStorage.removeItem('supabase_user_id');
            }
        });

        // Capacitor Deep Links
        import('@capacitor/app').then(({ App }) => {
            App.addListener('appUrlOpen', (data) => {
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
            });
        }).catch(() => { });

        return () => {
            subscription.unsubscribe();
        };
    }, []);

    // Helper for Settings Modal or Refresh Actions
    const refreshProfile = async () => {
        if (session?.id) {
            const profileData = await getUserProfile(session.id, session.email);
            if (profileData) {
                setUserProfile(profileData);
                const derivedRole = profileData.role === 'manager'
                    ? 'SCHOOL_MANAGER'
                    : (profileData.is_admin || profileData.role === 'admin' ? 'ADMIN' : 'TEACHER');

                if (session.role !== derivedRole) {
                    const updatedSession = { ...session, role: derivedRole };
                    setSession(updatedSession);
                    localStorage.setItem('profeplan_session', JSON.stringify(updatedSession));
                }
            }
        }
    }

    return { session, setSession, userProfile, setUserProfile, loading, refreshProfile };
};
