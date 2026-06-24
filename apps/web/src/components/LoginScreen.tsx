import React, { useState, useEffect } from 'react';
import { Mail, Lock, ArrowRight, ShieldCheck, Sparkles, Loader2, AlertCircle } from 'lucide-react';
import { UserSession } from '../types';
import { supabase } from '../services/supabaseClient';

interface LoginScreenProps {
  onLogin: (session: UserSession) => void;
  initialMode?: 'login' | 'signup';
}

const RETRYABLE_AUTH_STATUSES = new Set([502, 503, 504]);
const RETRY_DELAYS_MS = [700, 1500];

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

const isRetryableAuthError = (err: any): boolean => {
  const status = Number(err?.status);
  if (RETRYABLE_AUTH_STATUSES.has(status)) return true;

  const name = String(err?.name || '');
  if (name.includes('AuthRetryableFetchError')) return true;

  const message = String(err?.message || '').toLowerCase();
  return (
    message.includes('gateway timeout') ||
    message.includes('failed to fetch') ||
    message.includes('network') ||
    message.includes('timeout')
  );
};

const LoginScreen: React.FC<LoginScreenProps> = ({ onLogin, initialMode = 'login' }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [isSignUp, setIsSignUp] = useState(initialMode === 'signup');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [successMsg, setSuccessMsg] = useState('');

  const isMounted = React.useRef(true);
  useEffect(() => {
    return () => { isMounted.current = false; };
  }, []);

  const signInWithRetry = async (cleanEmail: string, rawPassword: string) => {
    let attempt = 0;
    while (true) {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: cleanEmail,
        password: rawPassword,
      });

      if (!error) return { data, error: null };

      if (!isRetryableAuthError(error) || attempt >= RETRY_DELAYS_MS.length) {
        return { data: null, error };
      }

      const retryIn = RETRY_DELAYS_MS[attempt];
      console.warn(
        `[LoginScreen] Auth retryable error (tentativa ${attempt + 1}). Repetindo em ${retryIn}ms...`,
        error
      );
      await delay(retryIn);
      attempt += 1;
    }
  };

  const sendAuthEvent = async (event: 'login' | 'logout', email: string, success: boolean, errorMsg?: string) => {
    try {
      await fetch("/api/auth/event", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          event,
          email,
          success,
          error: errorMsg,
        }),
      });
    } catch (e) {
      console.error("[LoginScreen] Erro ao enviar evento de auth para o backend:", e);
    }
  };

  const handleEmailAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setSuccessMsg('');

    // Safety Timeout
    const safetyTimeout = setTimeout(() => {
      if (isMounted.current && loading) {
        setLoading(false);
        setError('O login demorou muito. Verifique sua conexão ou tente recarregar.');
      }
    }, 10000);

    const cleanEmail = email.trim();

    try {
      if (isSignUp) {
        if (!fullName.trim()) {
          setError('Por favor, digite seu Nome Completo.');
          setLoading(false);
          clearTimeout(safetyTimeout);
          return;
        }

        const isEducacao = cleanEmail.toLowerCase().endsWith('@educacao.mg.gov.br');

        const { error } = await supabase.auth.signUp({
          email: cleanEmail,
          password,
          options: {
            data: { full_name: fullName }
          }
        });
        if (error) throw error;

        if (isEducacao) {
          setSuccessMsg('Conta educacional verificada! Entrando automaticamente...');

          // Race Condition Fix: Wait for DB triggers to finish
          await new Promise(resolve => setTimeout(resolve, 800));

          const { error: loginError } = await supabase.auth.signInWithPassword({
            email: cleanEmail,
            password,
          });

          if (loginError) {
            // Sign up success but login failed (maybe validation)
            setSuccessMsg('Conta criada! Por favor realize o login.');
            setIsSignUp(false);
          }
        } else {
          setSuccessMsg('Conta criada! Verifique seu e-mail para confirmar a conta (se necessário) ou faça login.');
          setIsSignUp(false);
        }
      } else {
        // --- LOGIN ---
        console.log('[LoginScreen] Attempting Login:', cleanEmail);

        const { data, error } = await signInWithRetry(cleanEmail, password);

        if (error) {
          throw error;
        }

        console.log('[LoginScreen] Supabase Login Success:', data);

        // Notify backend of successful login (fire-and-forget to avoid blocking the UI)
        sendAuthEvent('login', cleanEmail, true);

        // We do NOT manually call handleAuthSuccess or onLogin here anymore.
        // We rely on useProfeplanAuth hook listening to onAuthStateChange.
        // However, we need to keep the spinner spinning until the redirect happens.
        // If we set loading=false, the user sees the form again before redirect.
      }
    } catch (err: any) {
      console.error("Auth Error:", err);
      if (!isSignUp) {
        // Notify backend of failed login (fire-and-forget to avoid blocking the UI)
        sendAuthEvent('login', cleanEmail, false, err.message || 'Erro desconhecido');
      }
      if (isMounted.current) {
        setLoading(false); // Only stop loading on error
        if (err.message === 'Invalid login credentials' || err.status === 400) {
          setError('E-mail ou senha incorretos. Verifique suas credenciais.');
        } else if (err.message?.toLowerCase().includes('email not confirmed')) {
          setError('E-mail ainda não confirmado. Verifique sua caixa de entrada (e o Spam) para ativar sua conta.');
        } else if (isRetryableAuthError(err)) {
          setError('Estamos com instabilidade momentânea no servidor de autenticação. Tente novamente em alguns segundos.');
        } else {
          setError(err.message || 'Erro desconhecido na autenticação.');
        }
      }
    } finally {
      // Do NOT clear timeout or set loading false if success, 
      // because we want to stay in "loading" state until App unmounts us (redirects).
      // But if we are Sign Up (and not auto-login), we should stop loading.
      if (isSignUp && !successMsg.includes('Entrando')) {
        clearTimeout(safetyTimeout);
        if (isMounted.current) setLoading(false);
      }
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

          <form onSubmit={handleEmailAuth} className="space-y-6">

            {isSignUp && (
              <div className="space-y-2 animate-in slide-in-from-top-4 fade-in duration-300">
                <label className="text-[10px] font-black text-slate-500 uppercase tracking-widest ml-1">Nome Completo</label>
                <div className="relative group">
                  <div className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500 flex items-center justify-center font-bold text-xs pointer-events-none group-focus-within:text-blue-500 transition-colors">Aa</div>
                  <input
                    type="text"
                    required={isSignUp}
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                    placeholder="Ex: Maria Silva"
                    autoComplete="name"
                    className="w-full bg-slate-900/50 border border-white/10 rounded-xl py-3 pl-10 pr-4 text-white placeholder:text-slate-700 outline-none focus:ring-2 focus:ring-blue-500/50 transition-all font-medium text-sm"
                  />
                </div>
              </div>
            )}

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
                  autoComplete="email"
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
                  autoComplete={isSignUp ? 'new-password' : 'current-password'}
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

          <div className="mt-8 flex justify-center gap-6 opacity-40">
            <div className="flex items-center gap-2 px-3 py-1 bg-white/5 rounded-full border border-white/5">
              <div className={`w-2 h-2 rounded-full ${supabase.auth ? 'bg-green-500 shadow-[0_0_8px_#22c55e]' : 'bg-red-500'}`}></div>
              <span className="text-[8px] font-black uppercase tracking-widest text-slate-400">Auth Engine Ready</span>
            </div>
          </div>
        </div>

        <div className="mt-10 text-center">
          <p className="text-slate-600 text-[10px] font-black uppercase tracking-[0.2em]">Acesso Seguro • PROFEPLAN IA v4.3.5</p>
        </div>
      </div>
    </div>
  );
};

export default LoginScreen;