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

    // Initial Load & Self-Healing
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
                        const { data: recoveredProfile } = await supabase
                            .from('profiles')
                            .select('*')
                            .eq('email', session.email)
                            .maybeSingle();

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

                // EMERGENCY FALLBACK (Bypass RLS/Auth issues for admin)
                if (!profileData && (session.email === 'prehfeld@hotmail.com' || session.email === 'suporte@profeplan.com.br')) {
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
                    // --- GOD MODE ---
                    const hardcodedAdminEmails = ['prehfeld@hotmail.com', 'suporte@profeplan.com.br'];
                    const isHardcodedAdmin = profileData.email && hardcodedAdminEmails.includes(profileData.email.toLowerCase());

                    if (isHardcodedAdmin) {
                        profileData.role = 'admin';
                        profileData.is_admin = true;
                        profileData.tier = 'GOLD';
                        profileData.is_unlimited = true;
                    }

                    setUserProfile(profileData);

                    // AUTO-CORRECT SESSION ROLE
                    const derivedRole = profileData.role === 'manager'
                        ? 'SCHOOL_MANAGER'
                        : (isHardcodedAdmin || profileData.is_admin || profileData.role === 'admin' ? 'ADMIN' : 'TEACHER');

                    if (session.role !== derivedRole) {
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
    }, [session?.id]);

    // Listener for Auth Changes (Login, Signout, Deep Links)
    useEffect(() => {
        const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, authSession) => {
            console.log('[App] Auth State Change:', event, authSession?.user?.email);

            if (event === 'SIGNED_IN' && authSession) {
                const userId = authSession.user.id;
                const userEmail = authSession.user.email;
                let profile = await getUserProfile(userId);

                // If profile not found by ID, try recovery by email (Healing inside Listener)
                if (!profile && userEmail) {
                    console.log('[App] Profile not found by ID. Checking for existing profile by email...');
                    const { data: recoveredProfile } = await supabase
                        .from('profiles')
                        .select('*')
                        .eq('email', userEmail)
                        .maybeSingle();

                    if (recoveredProfile) {
                        console.log('[App] Existing profile found by email. Using it.');
                        profile = recoveredProfile;
                        // Note: We authenticate with `userId` (Supabase Auth ID), but profile might be different?
                        // If they are different, we might have a split brain. 
                        // But usually we want to respect the profile.
                    }
                }

                if (!profile) {
                    console.log('[App] Profile not found (Standard or Recovered), creating new profile...');

                    // Use Upsert to be safe
                    const { error: upsertError } = await supabase.from('profiles').upsert({
                        id: userId, // Link to the current Auth ID
                        email: userEmail,
                        full_name: authSession.user.user_metadata?.full_name || '',
                        role: getRoleByEmail(userEmail || ''),
                        tier: 'SILVER',
                        credits: 10,
                        is_unlimited: false,
                        is_admin: false,
                        allowed_features: ['all']
                    }, { onConflict: 'id' });

                    if (upsertError) {
                        console.error('[App] Failed to create profile:', upsertError);
                    } else {
                        console.log('[App] Profile created successfully');
                        await checkAndRewardReferrer(userEmail || '');
                        profile = await getUserProfile(userId);
                    }
                }

                // Construct Session
                // Fallback role if profile is still missing (shouldn't happen unless DB error)
                const role = profile?.is_admin || profile?.role === 'admin' ? 'ADMIN' : (profile?.role === 'manager' ? 'SCHOOL_MANAGER' : 'TEACHER');

                const newSession: UserSession = {
                    id: profile?.id || userId,
                    email: userEmail || '',
                    role: role,
                    accessLevel: (profile?.tier as any) || 'BASICO',
                    isLoggedIn: true,
                    isEmailConfirmed: !!authSession.user.email_confirmed_at
                };

                console.log('[App] Updating session after auth state change:', newSession);
                setSession(newSession);
                setUserProfile(profile);

                localStorage.setItem('profeplan_session', JSON.stringify(newSession));
                localStorage.setItem('supabase_user_id', userId);

            } else if (event === 'SIGNED_OUT') {
                console.log('[App] User signed out');
                setSession(null);
                setUserProfile(null);
                localStorage.clear(); // Clear all to be safe
            }
        });

        // Capacitor Deep Links logic...
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
