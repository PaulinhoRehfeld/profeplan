import { supabase } from '../supabaseClient';
import { UserProfile } from '../../types';
import { isHardcodedAdmin } from '../../constants';

/**
 * Repositório de perfil — leitura/gravação de profiles e helpers de sessão.
 * Extraído de userService.ts (refatoração Fase 1 — ver docs/REFACTORING_METHODOLOGY.md).
 * Comportamento idêntico ao original; coberto por userService.characterization.test.ts.
 */

// --- CONFIGURATION ---
const IS_BETA_TESTING = false; // Set to TRUE for Play Store Beta (Free Gold for Testers)

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : 'Unknown error';

const getActiveAuthUser = async (): Promise<{ id: string; email?: string } | null> => {
    try {
        // getSession() lê a sessão do storage e renova o access token automaticamente
        // quando expirado, usando um lock interno que deduplica refreshes concorrentes.
        //
        // CRÍTICO: NUNCA chamar refreshSession() manualmente aqui. O fluxo de gerar dispara
        // várias checagens de quota/sessão concorrentes; cada refreshSession() rotaciona o
        // refresh token. A segunda chamada concorrente usa o token já rotacionado, falha com
        // "refresh token already used", e o supabase-js limpa a sessão e dispara SIGNED_OUT.
        // Esse é o bug "sua sessão expirou". O auto-refresh do cliente (autoRefreshToken)
        // já mantém o token válido em background com segurança de concorrência.
        const { data: { session }, error } = await supabase.auth.getSession();
        if (!error && session?.user?.id) {
            return { id: session.user.id, email: session.user.email || undefined };
        }
    } catch (authErr) {
        console.warn("[userService] Auth session fetch failed:", authErr);
    }

    return null;
};

// Helper to recover from Session ID mismatch (Ghost ID)
export const getProfileByEmail = async (email: string) => {
    const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('email', email)
        .order('created_at', { ascending: false });

    if (error) {
        console.error('[userService] Error fetching profile by email:', error);
        return { data: null };
    }

    // Handle duplicates gracefully by taking the most recent match
    const profile = data && data.length > 0 ? data[0] : null;

    return { data: profile };
};

export const getUserProfile = async (userId: string, email?: string): Promise<UserProfile | null> => {
    try {
        const activeAuthUser = await getActiveAuthUser();
        const lookupUserId = activeAuthUser?.id || userId;
        let activeEmail = email || activeAuthUser?.email;

        if (activeAuthUser?.id && activeAuthUser.id !== userId) {
            console.warn(`[userService] Session ID mismatch detected. requested=${userId} auth=${activeAuthUser.id}. Using auth ID.`);
        }

        // 1. Try fetching by ID first
        const { data, error } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', lookupUserId)
            .maybeSingle();

        // 1b. data=null, error=null: linha inexistente ou bloqueio RLS legítimo.
        // NÃO forçar refreshSession() aqui (causa rotação concorrente do refresh token).
        // O auto-refresh do cliente já garante token válido; recuperação por email abaixo.

        // 2. Fallback: If ID not found/mismatched, attempt to resolve email from active session
        if ((error || !data) && !activeEmail) {
            try {
                const { data: { session } } = await supabase.auth.getSession();
                if (session?.user?.email) {
                    activeEmail = session.user.email;
                } else {
                    const { data: { user } } = await supabase.auth.getUser();
                    if (user?.email) {
                        activeEmail = user.email;
                    }
                }
            } catch (authErr) {
                console.warn("[userService] Optional auth session fetch failed:", authErr);
            }
        }

        if ((error || !data) && activeEmail) {
            console.warn(`[userService] Profile not found for ID ${lookupUserId}. Attempting fallback by email: ${activeEmail}`);
            const { data: recoveredProfile } = await getProfileByEmail(activeEmail);
            if (recoveredProfile) {
                console.log('[userService] Profile recovered by email!');
                return recoveredProfile as UserProfile;
            }
        }


        if (error || !data) {
            console.error("[userService] ❌ Error fetching profile:", error);
            const status =
                error && typeof error === 'object' && 'status' in error
                    ? (error as { status?: number }).status
                    : undefined;
            if (error?.code === '42501' || status === 403) {
                console.error("[userService] ⛔ RLS PERMISSION DENIED. Check Supabase Policies for 'profiles' table.");
            }

            // ── Auto-create profile as last resort (trigger may have failed) ──
            try {
                // Reuse activeAuthUser from outer scope (already validated), fallback to fresh getUser()
                let authUser = activeAuthUser;
                let userMetaName: string | undefined;
                if (!authUser) {
                    const { data: { user: freshUser } } = await supabase.auth.getUser();
                    if (freshUser) {
                        authUser = { id: freshUser.id, email: freshUser.email };
                        userMetaName = freshUser.user_metadata?.full_name || freshUser.user_metadata?.name;
                    }
                }

                if (!authUser) {
                    console.warn('[userService] No active auth session — cannot create emergency profile.');
                } else {
                    // If stored userId differs from session (Ghost ID), use session ID
                    const targetId = authUser.id === lookupUserId ? lookupUserId : authUser.id;
                    if (authUser.id !== lookupUserId) {
                        console.warn(`[userService] Ghost ID detected: stored=${lookupUserId} auth=${authUser.id}. Using auth ID.`);
                    }
                    console.warn('[userService] Attempting emergency profile creation for:', targetId);
                    const fallbackEmail = authUser.email || activeEmail || '';
                    const userIsAdmin = isHardcodedAdmin(fallbackEmail);
                    const { data: created, error: createErr } = await supabase
                        .from('profiles')
                        .upsert({
                            id: targetId,
                            email: fallbackEmail,
                            full_name: userMetaName
                                || fallbackEmail.split('@')[0],
                            role: userIsAdmin ? 'admin' : 'teacher',
                            is_admin: userIsAdmin,
                            tier: userIsAdmin ? 'GOLD' : 'FREE',
                            is_unlimited: userIsAdmin,
                            credits: userIsAdmin ? 9999 : 10,
                        }, { onConflict: 'id' })
                        .select()
                        .maybeSingle();

                    if (!createErr && created) {
                        console.log('[userService] ✅ Emergency profile created successfully.');
                        return created as UserProfile;
                    }
                    if (createErr) {
                        console.error('[userService] Emergency profile creation failed:', createErr);
                    } else {
                        // Upsert succeeded but select returned null (RLS on return=representation).
                        // Retry the read separately.
                        console.warn('[userService] Upsert returned null — retrying SELECT after write...');
                        const { data: retryData, error: retryErr } = await supabase
                            .from('profiles')
                            .select('*')
                            .eq('id', targetId)
                            .maybeSingle();
                        if (!retryErr && retryData) {
                            console.log('[userService] ✅ Profile confirmed via retry SELECT.');
                            return retryData as UserProfile;
                        }
                        console.error('[userService] Retry SELECT also failed:', retryErr);
                    }
                }
            } catch (emergencyErr) {
                console.warn('[userService] Emergency profile creation threw:', emergencyErr);
            }

            return null;
        }


        let schoolName = undefined;
        let inepCode = undefined;
        if (data?.school_id) {
            try {
                const { data: schoolData } = await supabase
                    .from('schools')
                    .select('name, inep_code')
                    .eq('id', (data.school_id as string).trim())
                    .maybeSingle();
                if (schoolData) {
                    schoolName = schoolData.name;
                    inepCode = schoolData.inep_code;
                }
            } catch (schoolErr) {
                console.warn("[userService] Optional school fetch failed:", schoolErr);
            }
        }

        // Transform and normalize
        const profileData: UserProfile = {
            ...data,
            full_name: data.full_name || data.userName || '', // Ensure name mapping
            school_name: schoolName || data.school_name,
            inep_code: inepCode
        };

        console.log("[userService] Profile Loaded:", profileData.full_name);
        // schools join removed
        // delete profileData.schools;

        // BETA OVERRIDE: Grant Gold + Unlimited to everyone during testing
        if (IS_BETA_TESTING && data) {
            return {
                ...profileData,
                tier: 'GOLD',
                is_unlimited: true,
                credits: 9999 // Beta visual sugar — production uses DB values
            };
        }

        return profileData as UserProfile;
    } catch (err) {
        console.error("[userService] Fatal Exception in getUserProfile:", err);
        return null;
    }
};

/**
 * Updates a user profile and deterministically links to a school via INEP code.
 * Follows the government unique ID logic (MASP for Teachers, INEP for Schools).
 */
export const updateUserProfile = async (
    userId: string,
    profileData: {
        userName?: string;
        institutionalEmail?: string;
        masp?: string;
        city?: string;
        inep_code?: string;
        [key: string]: unknown;
    }
): Promise<{ success: boolean; message?: string; error?: string }> => {
    try {
        // 1. Prepare updates for the profile table
        const updates: Record<string, unknown> = {
            full_name: profileData.userName?.trim(),
            email: profileData.institutionalEmail?.trim().toLowerCase(),
            masp: profileData.masp?.trim(),
            city: profileData.city?.trim(),
            // NOTA: o nome da escola (institution) é texto livre e NÃO é coluna de
            // `profiles` — fica apenas nas settings locais (documentos). O vínculo
            // formal da escola é feito SOMENTE pelo código INEP via reconcileTeacherByInep.
            // Pedagogical settings
            favorite_methodology: profileData.favoriteMethodology,
            teaching_style: profileData.teachingStyle,
            assessment_focus: profileData.assessmentFocus,
            tone_of_voice: profileData.toneOfVoice,
            // Document personalization
            header_text: profileData.headerText,
            footer_text: profileData.footerText,
            logo_base64: profileData.logoBase64
        };

        let message = undefined;

        // 2. School Linking is now handled via teacher_schools table
        // DO NOT update profiles.school_id here - this is legacy behavior
        // The ProfileTab calls reconcileTeacherByInep which creates proper links
        if (profileData.inep_code) {
            const cleanInep = profileData.inep_code.trim();
            console.log('[userService] ℹ️ INEP code provided:', cleanInep);
            console.log('[userService] ℹ️ School linking is handled by teacherSchoolService, not here.');
            // NOTE: We don't update school_id anymore to prevent overwriting
            // The teacher_schools table is the source of truth for multi-school support
        }

        // 2.5. Caminho preferencial: RPC SECURITY DEFINER update_my_profile.
        //      Usa auth.uid() no servidor e resolve Ghost ID por email, sem esbarrar
        //      em RLS nem mexer na PK (que quebraria foreign keys).
        const { error: rpcError } = await supabase.rpc('update_my_profile', { p_updates: updates });
        if (!rpcError) {
            console.log('[userService] ✅ Perfil salvo via update_my_profile RPC.');
            return { success: true, message };
        }
        const fnMissing =
            (rpcError as any)?.code === 'PGRST202' ||
            /function .*update_my_profile.* does not exist/i.test(rpcError.message || '') ||
            /could not find the function/i.test(rpcError.message || '');
        if (!fnMissing) {
            console.error('[userService] update_my_profile RPC error:', rpcError);
            return { success: false, error: rpcError.message };
        }
        console.warn('[userService] RPC update_my_profile ausente — usando update direto (rode a migration 20260624_update_my_profile_rpc.sql).');

        // 3. Fallback legado: resolve o id canônico do auth.uid(). O RLS de UPDATE exige
        //    auth.uid() = id; se o userId passado divergir (Ghost ID), afeta 0 linhas.
        let targetId = userId;
        try {
            const { data: { user } } = await supabase.auth.getUser();
            if (user?.id) {
                if (user.id !== userId) {
                    console.warn(`[userService] updateUserProfile: id divergente (param=${userId} auth=${user.id}). Usando auth id.`);
                }
                targetId = user.id;
            }
        } catch { /* segue com o userId recebido */ }

        // 4. Update com .select() para detectar 0 linhas afetadas. RLS bloqueado ou linha
        //    inexistente retornam sucesso com 0 linhas — antes o app reportava "salvo"
        //    sem ter salvado nada.
        console.log("[userService] Sending update to Supabase for user:", targetId, updates);

        const { data: updatedRows, error: updateError } = await supabase
            .from('profiles')
            .update(updates)
            .eq('id', targetId)
            .select('id');

        if (updateError) {
            console.error("[userService] Supabase Update Error:", updateError);
            // If it's a column missing error, it's a critical hint
            if (updateError.message.includes('column') && updateError.message.includes('does not exist')) {
                return {
                    success: false,
                    error: `Erro de Estrutura: Algumas colunas de configuração ainda não existem no seu banco de dados. Por favor, execute o script SQL de migração. (${updateError.message})`
                };
            }
            return { success: false, error: updateError.message };
        }

        // 5. 0 linhas afetadas: a linha pode não existir → tenta upsert (criar/atualizar).
        if (!updatedRows || updatedRows.length === 0) {
            console.warn('[userService] Update afetou 0 linhas — tentando upsert de recuperação.');
            const { data: upserted, error: upsertErr } = await supabase
                .from('profiles')
                .upsert({ id: targetId, ...updates }, { onConflict: 'id' })
                .select('id')
                .maybeSingle();

            if (upsertErr || !upserted) {
                console.error('[userService] Upsert de recuperação falhou:', upsertErr);
                return {
                    success: false,
                    error: upsertErr?.message || 'As alterações não foram salvas. Verifique se sua sessão está ativa e tente novamente.'
                };
            }
            console.log('[userService] ✅ Perfil criado/atualizado via upsert.');
            return { success: true, message };
        }

        console.log("[userService] ✅ Update successful. Rows affected:", updatedRows.length);
        return { success: true, message };
    } catch (err: unknown) {
        console.error("[userService] Fatal error in updateUserProfile:", err);
        return { success: false, error: getErrorMessage(err) || "Erro fatal ao conectar com o banco de dados" };
    }
};

export const isAdmin = (profile: UserProfile | null) => {
    // Strict check: Must be explicitly 'admin' role or is_admin flag.
    // School Managers are NOT System Admins.
    return (profile?.is_admin === true || profile?.role === 'admin') && profile?.role !== 'manager';
};

export const hasFeaturePattern = (userFeatures: string[] | null | undefined, requiredFeature: string): boolean => {
    if (!userFeatures || !Array.isArray(userFeatures)) return false;
    if (userFeatures.includes('all')) return true;
    return userFeatures.includes(requiredFeature);
};
