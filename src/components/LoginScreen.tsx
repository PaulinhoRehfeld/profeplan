
import React, { useState, useEffect } from 'react';
import { Mail, Lock, ArrowRight, ShieldCheck, Sparkles, Loader2, AlertCircle, Chrome } from 'lucide-react';
import { UserSession } from '../types';
import { supabase } from '../services/supabaseClient';

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

  const handleAuthSuccess = async (user: any) => {
    // Busca ou cria o perfil
    const { data: profile } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single();

    if (!profile) {
      // Cria perfil padrão se não existir
      await supabase.from('profiles').insert({
        id: user.id,
        email: user.email,
        tier: 'FREE',
        credits: 10,
        is_unlimited: false,
        is_admin: false,
        allowed_features: ['all']
      });
    }

    const sessionData: UserSession = {
      id: user.id,
      email: user.email || '',
      role: profile?.is_admin ? 'ADMIN' : 'TEACHER', // Use profile role or default
      accessLevel: profile?.tier || 'BASICO',
      isLoggedIn: true,
    };

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
        const { error } = await supabase.auth.signInWithPassword({
          email,
          password,
        });
        if (error) throw error;
        // O onAuthStateChange vai capturar o sucesso
      }
    } catch (err: any) {
      console.error("Auth Error:", err);
      setError(err.message || 'Erro na autenticação.');
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
          <div className="inline-flex items-center justify-center mb-6 transform hover:scale-105 transition-transform">
            <img src="/logo-profeplan.png" alt="PROFEPLAN" className="w-16 h-16 object-contain drop-shadow-2xl" />
          </div>
          <h1 className="text-5xl font-black text-white tracking-tighter mb-2 italic">PROFEPLAN</h1>
          <p className="text-slate-400 font-bold tracking-[0.3em] uppercase text-[10px]">Ecossistema de Inteligência Pedagógica</p>
        </div>

        <div className="bg-white/5 backdrop-blur-2xl border border-white/10 p-6 md:p-10 rounded-[40px] shadow-3xl">
          <h2 className="text-2xl font-bold text-white mb-8 text-center tracking-tight">
            {isSignUp ? 'Criar Nova Conta' : 'Acesse seu Workspace'}
          </h2>

          <div className="space-y-4 mb-8">
            <button
              onClick={handleGoogleLogin}
              className="w-full bg-white text-slate-900 font-bold py-4 rounded-2xl flex items-center justify-center gap-3 hover:bg-slate-100 transition-colors shadow-lg"
            >
              <Chrome className="w-5 h-5 text-blue-600" />
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
                  className="w-full bg-slate-900/50 border border-white/10 rounded-2xl py-4 pl-12 pr-6 text-white placeholder:text-slate-700 outline-none focus:ring-2 focus:ring-blue-500/50 transition-all font-medium"
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
                  className="w-full bg-slate-900/50 border border-white/10 rounded-2xl py-4 pl-12 pr-6 text-white placeholder:text-slate-700 outline-none focus:ring-2 focus:ring-blue-500/50 transition-all font-medium"
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
              className="w-full bg-blue-600 hover:bg-blue-500 text-white font-black py-5 rounded-2xl shadow-xl shadow-blue-600/20 flex items-center justify-center gap-3 transition-all active:scale-[0.98] disabled:opacity-50"
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