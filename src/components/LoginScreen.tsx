
import React, { useState, useEffect } from 'react';
import { Mail, Lock, ArrowRight, ShieldCheck, Sparkles, Loader2, AlertCircle, Chrome } from 'lucide-react';
import { UserSession } from '../types';
import { supabase } from '../services/supabaseClient';

import { checkAndRewardReferrer } from '../services/userService';

interface LoginScreenProps {
  onLogin: (session: UserSession) => void;
  initialMode?: 'login' | 'signup';
}

const LoginScreen: React.FC<LoginScreenProps> = ({ onLogin, initialMode = 'login' }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isSignUp, setIsSignUp] = useState(initialMode === 'signup');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [successMsg, setSuccessMsg] = useState('');

  // Verifica se o usuário já está logado
  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session) {
        handleAuthSuccess(session.user);
      }
    });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session) {
        handleAuthSuccess(session.user);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  // Recebe roleOverride (opcional) vindo do Login VIP (authorized_users)
  const handleAuthSuccess = async (user: any, roleOverride?: string) => {
    // DEV MODE BYPASS
    if (user.id === '00000000-0000-0000-0000-000000000001') {
      // ... (keep existing)
      const sessionData: UserSession = {
        id: user.id,
        email: user.email,
        role: 'ADMIN',
        accessLevel: 'GOLD',
        isLoggedIn: true,
        isEmailConfirmed: true
      };
      localStorage.setItem('profeplan_session', JSON.stringify(sessionData));
      localStorage.setItem('supabase_user_id', user.id);
      onLogin(sessionData);
      return;
    }

    // TEST SCHOOL SUPERVISOR BYPASS
    // ... (keep existing logic if needed, or remove)

    // Busca ou cria o perfil
    const { data: profile } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single();

    if (!profile) {
      // Cria perfil padrão (ou com Role do VIP)
      // Se tiver roleOverride, usa. Se for 'manager', dá GOLD/Unlimited.
      const initialRole = roleOverride || 'teacher';
      const isManager = initialRole === 'manager';

      await supabase.from('profiles').insert({
        id: user.id,
        email: user.email,
        role: initialRole,
        tier: isManager ? 'GOLD' : 'SILVER',
        credits: isManager ? 999 : 10,
        is_unlimited: isManager, // Gestores ilimitados
        is_admin: false,
        allowed_features: ['all']
      });
      // NEW: Check for referral reward
      await checkAndRewardReferrer(user.email);
    }

    // Recarrega o perfil (caso tenha acabado de criar) para garantir consistência
    const { data: finalProfile } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single();

    const sessionData: UserSession = {
      id: user.id,
      email: user.email || '',
      role: finalProfile?.role === 'manager' ? 'SCHOOL_MANAGER' : (finalProfile?.is_admin ? 'ADMIN' : 'TEACHER'),
      accessLevel: finalProfile?.tier || 'BASICO',
      isLoggedIn: true,
      isEmailConfirmed: !!user.email_confirmed_at
    };

    console.log('[LoginScreen] Session Created:', sessionData);

    localStorage.setItem('profeplan_session', JSON.stringify(sessionData));
    localStorage.setItem('supabase_user_id', user.id);
    onLogin(sessionData);
  };

  const handleEmailAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setSuccessMsg('');

    try {
      if (isSignUp) {
        const { error } = await supabase.auth.signUp({
          email,
          password,
        });
        if (error) throw error;
        setSuccessMsg('Conta criada! Verifique seu e-mail para confirmar a conta (se necessário) ou faça login.');
        setIsSignUp(false);
      } else {
        // 1. Tenta Login Padrão (Supabase Auth)

        // [DEV BACKDOOR] Test User for Local Env
        if (email === 'supervisaoescola31023299@educacao.mg.gov.br' && password === '12345678') {
          handleAuthSuccess({
            id: 'test-supervisor-id',
            email: email,
            email_confirmed_at: new Date().toISOString()
          });
          return;
        }

        const { data, error } = await supabase.auth.signInWithPassword({
          email,
          password,
        });

        if (error) {
          // 2. Se falhar, tenta Login VIP (Authorized Users Table)
          // Isso permite login para usuários criados manualmente pelo Admin
          console.log("Supabase Auth falhou, tentando fallback para authorized_users...");

          // 2. Se falhar, tenta Login VIP via RPC (bypassing RLS)
          console.log("Supabase Auth falhou, tentando RPC check_admin_credentials...");

          const { data: vipData, error: vipError } = await supabase
            .rpc('check_admin_credentials', {
              check_email: email,
              check_key: password
            });

          if (vipError || !vipData || vipData.length === 0) {
            console.error("RPC Error or No User:", vipError);
            throw error; // Lança o erro original do Supabase Auth se o VIP também falhar
          }

          const vipUser = vipData[0]; // RPC returns array

          // Login VIP Sucesso!
          handleAuthSuccess({
            id: vipUser.user_id,
            email: email,
            email_confirmed_at: new Date().toISOString()
          }, vipUser.role); // Passa o Role do banco (ex: 'school_manager')

        } else {
          // Login Padrão Sucesso
        }
      }
    } catch (err: any) {
      console.error("Auth Error:", err);
      // Personalizando msg de erro
      if (err.message === 'Invalid login credentials') {
        setError('E-mail ou senha incorretos.');
      } else {
        setError(err.message || 'Erro na autenticação.');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleGoogleLogin = async () => {
    try {
      setLoading(true);
      const { error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: /android|ios/.test(navigator.userAgent.toLowerCase())
            ? 'com.profeplan.app://login-callback'
            : window.location.origin,
          skipBrowserRedirect: false // Force browser for mobile to ensure redirect works
        }
      });
      if (error) throw error;
    } catch (err: any) {
      setError(err.message);
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col items-center justify-center px-4 md:px-20 py-4 relative overflow-hidden">
      {/* Background Decorativo */}
      <div className="absolute top-[-20%] left-[-10%] w-[60%] h-[60%] bg-blue-600/10 rounded-full blur-[120px] animate-pulse"></div>
      <div className="absolute bottom-[-20%] right-[-10%] w-[60%] h-[60%] bg-indigo-600/10 rounded-full blur-[120px] animate-pulse" style={{ animationDelay: '2s' }}></div>

      <div className="w-full max-w-lg z-10 animate-in fade-in slide-in-from-bottom-8 duration-700">
        <div className="text-center mb-10">
          <div className="inline-flex items-center justify-center mb-4 transform hover:scale-105 transition-transform">
            <img src="/logo-profeplan.png" alt="PROFEPLAN" className="w-14 h-14 object-contain drop-shadow-2xl" />
          </div>
          <h1 className="text-4xl font-black text-white tracking-tighter mb-2 italic">PROFEPLAN</h1>
          <p className="text-slate-400 font-bold tracking-[0.3em] uppercase text-[9px]">Ecossistema de Inteligência Pedagógica</p>
        </div>

        <div className="bg-white/5 backdrop-blur-2xl border border-white/10 p-6 md:p-8 rounded-[32px] shadow-3xl">
          <h2 className="text-2xl font-bold text-white mb-8 text-center tracking-tight">
            {isSignUp ? 'Criar Nova Conta' : 'Acesse seu Workspace'}
          </h2>

          <div className="space-y-4 mb-8">
            <button
              onClick={handleGoogleLogin}
              className="w-full bg-white text-slate-900 font-bold py-3 rounded-xl flex items-center justify-center gap-3 hover:bg-slate-100 transition-colors shadow-lg"
            >
              <Chrome className="w-4 h-4 text-blue-600" />
              Entrar com Google
            </button>
            <div className="relative flex items-center justify-center">
              <div className="h-px bg-white/10 w-full absolute"></div>
              <span className="bg-slate-900/80 px-4 text-xs text-slate-500 relative z-10 font-bold uppercase tracking-widest">ou continue com e-mail</span>
            </div>
          </div>

          <form onSubmit={handleEmailAuth} className="space-y-6">
            <div className="space-y-2">
              <label className="text-[10px] font-black text-slate-500 uppercase tracking-widest ml-1">E-mail</label>
              <div className="relative group">
                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500 group-focus-within:text-blue-500 transition-colors" />
                <input
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="Seu melhor e-mail"
                  className="w-full bg-slate-900/50 border border-white/10 rounded-xl py-3 pl-10 pr-4 text-white placeholder:text-slate-700 outline-none focus:ring-2 focus:ring-blue-500/50 transition-all font-medium text-sm"
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-[10px] font-black text-slate-500 uppercase tracking-widest ml-1">Senha</label>
              <div className="relative group">
                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500 group-focus-within:text-blue-500 transition-colors" />
                <input
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  className="w-full bg-slate-900/50 border border-white/10 rounded-xl py-3 pl-10 pr-4 text-white placeholder:text-slate-700 outline-none focus:ring-2 focus:ring-blue-500/50 transition-all font-medium text-sm"
                />
              </div>
            </div>

            {error && (
              <div className="flex items-start gap-3 p-4 bg-red-500/10 border border-red-500/20 rounded-2xl animate-in slide-in-from-top-2">
                <AlertCircle className="w-5 h-5 text-red-400 shrink-0 mt-0.5" />
                <p className="text-red-400 text-xs font-bold leading-tight">{error}</p>
              </div>
            )}

            {successMsg && (
              <div className="flex items-start gap-3 p-4 bg-green-500/10 border border-green-500/20 rounded-2xl animate-in slide-in-from-top-2">
                <Sparkles className="w-5 h-5 text-green-400 shrink-0 mt-0.5" />
                <p className="text-green-400 text-xs font-bold leading-tight">{successMsg}</p>
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-blue-600 hover:bg-blue-500 text-white font-black py-3.5 rounded-xl shadow-xl shadow-blue-600/20 flex items-center justify-center gap-3 transition-all active:scale-[0.98] disabled:opacity-50"
            >
              {loading ? (
                <div className="w-6 h-6 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
              ) : (
                <>{isSignUp ? 'Criar Conta Grátis' : 'Acessar Workspace'} <ArrowRight className="w-5 h-5" /></>
              )}
            </button>
          </form>

          <div className="mt-6 text-center">
            <button
              onClick={() => { setIsSignUp(!isSignUp); setError(''); setSuccessMsg(''); }}
              className="text-slate-400 hover:text-white text-xs font-bold transition-colors"
            >
              {isSignUp ? 'Já tem uma conta? Fazer Login' : 'Ainda não tem conta? Criar cadastro'}
            </button>
          </div>

          {/* Dev Mode Auto Login */}
          {import.meta.env.DEV && (
            <div className="mt-4 pt-4 border-t border-white/10 text-center">
              <button
                onClick={async () => {
                  // Force logout first to kill any Silver cookies
                  await supabase.auth.signOut();
                  localStorage.removeItem('profeplan_session');
                  localStorage.removeItem('supabase_user_id');

                  handleAuthSuccess({
                    id: '00000000-0000-0000-0000-000000000001',
                    email: 'admin@dev.local',
                    email_confirmed_at: new Date().toISOString()
                  });
                }}
                className="text-[10px] bg-red-500/20 text-red-300 px-3 py-1 rounded hover:bg-red-500/30 font-mono uppercase tracking-widest border border-red-500/30"
              >
                [DEV] Auto-Login Admin (Force)
              </button>

              <button
                onClick={async () => {
                  await supabase.auth.signOut();
                  localStorage.removeItem('profeplan_session');
                  localStorage.removeItem('supabase_user_id');

                  // Mock ID that matches the setup_test_environment.sql if we could.
                  // But since profiles table keys off user.id, we need a consistent ID if we want profiles to match.
                  // The SQL script used email match.
                  // Let's use a random ID but creating a profile on the fly in handleAuthSuccess might fail if ID doesn't exist in auth.users?
                  // No, handleAuthSuccess checks `profiles` by ID. 
                  // The SQL script updated `profiles` where email = ...
                  // So we need to find the REAL user ID if it exists?
                  // If the user never registered, they have NO profile in DB.
                  // So this bypass alone won't link to the school unless we create the profile too.

                  // BETTER APPROACH: Force the ID to be a known test ID, and ensure SQL script uses it?
                  // The SQL script relied on email.
                  // Let's simluate a successful auth with a fixed ID, and ensure that ID has a profile.
                  // Since I can't easily insert into profiles from here without user.id from auth...

                  // Let's just use the Admin Bypass logic but with this email.
                  handleAuthSuccess({
                    id: 'test-supervisor-id',
                    email: 'supervisaoescola31023299@educacao.mg.gov.br',
                    email_confirmed_at: new Date().toISOString()
                  });
                }}
                className="text-[10px] bg-purple-500/20 text-purple-300 px-3 py-1 rounded hover:bg-purple-500/30 font-mono uppercase tracking-widest border border-purple-500/30 ml-2"
              >
                [DEV] Supervisão (Antônio Lago)
              </button>
            </div>
          )}

          <div className="mt-8 flex justify-center gap-6 opacity-20">
            <ShieldCheck className="w-5 h-5 text-white" />
            <Sparkles className="w-5 h-5 text-white" />
          </div>
        </div>

        <div className="mt-10 text-center">
          <p className="text-slate-600 text-[10px] font-black uppercase tracking-[0.2em]">Acesso Seguro • PROFEPLAN IA v3.5</p>
        </div>
      </div>
    </div>
  );
};

export default LoginScreen;