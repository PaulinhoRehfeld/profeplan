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
        // 0. Preferential path: SECURITY DEFINER RPC bypasses RLS and resolves Ghost ID
        //    server-side. Avoids the entire class of "profile not found" errors caused by
        //    RLS USING (auth.uid() = id) blocking rows whose id ≠ auth.uid() (Ghost ID).
        const { data: rpcProfile, error: rpcError } = await supabase.rpc('get_my_profile');
        const rpcUnavailable =
            rpcError?.code === 'PGRST202' ||
            /function.*get_my_profile.*does not exist/i.test(rpcError?.message || '') ||
            /could not find the function/i.test(rpcError?.message || '');

        if (!rpcError && rpcProfile) {
            // RPC succeeded — skip direct table queries and go straight to school join
            const data = rpcProfile as any;
            let schoolName: string | undefined;
            let inepCode: string | undefined;
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
                } catch { /* optional */ }
            }
            const profileData: UserProfile = {
                ...data,
                full_name: data.full_name || data.userName || '',
                school_name: schoolName || data.school_name,
                inep_code: inepCode,
            };
            console.log('[userService] Profile Loaded (via RPC):', profileData.full_name);
            if (IS_BETA_TESTING) {
                return { ...profileData, tier: 'GOLD', is_unlimited: true, credits: 9999 };
            }
            return profileData;
        }

        if (rpcError && !rpcUnavailable) {
            // RPC exists but errored (auth issue, network, etc.) — log and fall through
            console.warn('[userService] get_my_profile RPC error (falling through):', rpcError.message);
        }

        if (rpcUnavailable) {
            console.warn('[userService] get_my_profile RPC not deployed — run 20260624_get_my_profile_rpc.sql in Supabase.');
        }

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
        // 1. Prepare updates for the profile table (only include defined, non-undefined values)
        const rawUpdates: Record<string, unknown> = {
            full_name: profileData.userName?.trim(),
            email: profileData.institutionalEmail?.trim().toLowerCase(),
            masp: profileData.masp?.trim(),
            city: profileData.city?.trim(),
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

        // Remove undefined/null keys so we don't send garbage to the DB
        const updates: Record<string, unknown> = {};
        for (const [key, value] of Object.entries(rawUpdates)) {
            if (value !== undefined && value !== null) {
                updates[key] = value;
            }
        }

        // NOTE: Do NOT set updated_at here — the RPC and the trigger handle it.
        // Sending it explicitly can cause timezone/format conflicts.

        let message: string | undefined = undefined;

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
        //      Se a RPC falhar com erro de auth, tenta refresh da sessão e retry.
        let rpcResult = await supabase.rpc('update_my_profile', { p_updates: updates });
        let rpcError = rpcResult.error;
        let rpcData = rpcResult.data;

        // Retry logic: se o erro for de autenticação, tenta refresh da sessão e retry
        if (rpcError && /autenticado|auth|jwt|token|expir|session|bearer/i.test(rpcError.message || '')) {
            console.warn('[userService] 🔄 RPC update_my_profile falhou com erro de auth, tentando refresh de sessão...');
            try {
                const { data: { session }, error: refreshErr } = await supabase.auth.refreshSession();
                if (!refreshErr && session) {
                    console.log('[userService] 🔄 Sessão renovada, retentando RPC...');
                    rpcResult = await supabase.rpc('update_my_profile', { p_updates: updates });
                    rpcError = rpcResult.error;
                    rpcData = rpcResult.data;
                }
            } catch (refreshErr) {
                console.error('[userService] ❌ Exceção no refresh de sessão:', refreshErr);
            }
        }

        // RPC succeeded but returned NULL data — o UPDATE não afetou nenhuma linha
        // (Ghost ID não resolvido, perfil não existe, ou FK quebrada)
        if (!rpcError && !rpcData) {
            console.error('[userService] ⚠️ RPC update_my_profile retornou NULL (0 linhas afetadas) — perfil pode não existir ou Ghost ID não resolvido.');
            // Não retorna sucesso falso — cai no fallback para diagnóstico completo
        }

        if (!rpcError && rpcData) {
            console.log('[userService] ✅ Perfil salvo via update_my_profile RPC. ID:', rpcData.id);
            return { success: true, message };
        }

        // RPC falhou — loga o motivo em ERROR (não WARN) para visibilidade no console
        const fnMissing =
            (rpcError as any)?.code === 'PGRST202' ||
            /function .*update_my_profile.* does not exist/i.test(rpcError.message || '') ||
            /could not find the function/i.test(rpcError.message || '');
        if (fnMissing) {
            console.error('[userService] ❌ RPC update_my_profile NÃO ENCONTRADA — execute a migration 20260709_fix_production_profile_save.sql no Supabase.');
        } else {
            console.error('[userService] ❌ RPC update_my_profile FALHOU:', rpcError.message || rpcError, '| code:', (rpcError as any)?.code, '| details:', (rpcError as any)?.details);
        }

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

        // 5. 0 linhas afetadas: Ghost ID ou perfil inexistente.
        //    Em vez de upsert (que bate na RLS), usa get_my_profile RPC
        //    (SECURITY DEFINER) para achar o perfil real e atualizar por ele.
        if (!updatedRows || updatedRows.length === 0) {
            console.warn('[userService] Update afetou 0 linhas (Ghost ID provável) — buscando perfil via get_my_profile RPC...');
            
            // Usa a RPC get_my_profile que bypassa RLS e resolve Ghost ID por email
            const { data: realProfile, error: lookupErr } = await supabase.rpc('get_my_profile');
            
            if (!lookupErr && realProfile?.id) {
                const realId = realProfile.id;
                console.log('[userService] 🔍 Perfil real encontrado via RPC, id:', realId);
                
                // Tenta update com o ID real do perfil
                const { error: retryErr } = await supabase
                    .from('profiles')
                    .update(updates)
                    .eq('id', realId);
                
                if (!retryErr) {
                    console.log('[userService] ✅ Perfil atualizado com ID real (Ghost ID resolvido).');
                    return { success: true, message };
                }
                console.error('[userService] ❌ Update com ID real falhou:', retryErr.message);
                
                // Se o update falhou com RLS, o problema é outro — repassamos o erro
                if (retryErr.message?.includes('row-level security')) {
                    return {
                        success: false,
                        error: `Erro de segurança (RLS) ao salvar perfil: ${retryErr.message}. Verifique as políticas RLS no Supabase.`
                    };
                }
                return { success: false, error: retryErr.message };
            }
            
            // get_my_profile também falhou — último recurso: upsert
            console.warn('[userService] get_my_profile RPC falhou ou retornou vazio — tentando upsert de recuperação.');
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
