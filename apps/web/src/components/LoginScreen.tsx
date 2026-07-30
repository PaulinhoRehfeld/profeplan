import React, { useState, useEffect } from 'react';
import { Mail, Lock, ArrowRight, ShieldCheck, Sparkles, Loader2, AlertCircle } from 'lucide-react';
import { UserSession } from '../types';
import { supabase } from '../services/supabaseClient';
import { isRetryableAuthError } from '../utils/authUtils';

interface LoginScreenProps {
  onLogin: (session: UserSession) => void;
  initialMode?: 'login' | 'signup';
}

const RETRY_DELAYS_MS = [700, 1500];

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

const isRateLimitError = (err: any): boolean => {
  if (Number(err?.status) === 429) return true;
  const message = String(err?.message || '').toLowerCase();
  const code = String(err?.code || '').toLowerCase();
  return (
    code.includes('over_email_send_rate_limit') ||
    message.includes('rate limit') ||
    message.includes('email rate') ||
    message.includes('over_email_send_rate_limit') ||
    message.includes('for security purposes') ||
    message.includes('request this after')
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
  const [termsAccepted, setTermsAccepted] = useState(false);
  const [marketingConsent, setMarketingConsent] = useState(false);

  const isMounted = React.useRef(true);
  useEffect(() => {
    return () => {
      isMounted.current = false;
    };
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

  const sendAuthEvent = async (
    event: 'login' | 'logout',
    email: string,
    success: boolean,
    errorMsg?: string
  ) => {
    try {
      await fetch('/api/auth/event', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          event,
          email,
          success,
          error: errorMsg,
        }),
      });
    } catch (e) {
      console.error('[LoginScreen] Erro ao enviar evento de auth para o backend:', e);
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

        if (!termsAccepted) {
          setError('Você precisa aceitar os Termos de Uso para criar sua conta.');
          setLoading(false);
          clearTimeout(safetyTimeout);
          return;
        }

        const isEducacao = cleanEmail.toLowerCase().endsWith('@educacao.mg.gov.br');

        // Cadastro via endpoint server-side — elimina rate limit do Supabase
        const signupResp = await fetch('/api/auth/signup', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            email: cleanEmail,
            password,
            fullName,
            termsAccepted: true,
            termsVersion: '2026-07-27',
            privacyNoticeVersion: '2026-07-27',
            marketingConsent,
          }),
        });

        const signupData = await signupResp.json().catch(() => ({}));

        if (!signupResp.ok) {
          // Suporta erro como string ou objeto (formato Vercel internal error)
          const errMsg =
            typeof signupData?.error === 'string'
              ? signupData.error
              : signupData?.error?.message ||
                signupData?.message ||
                `Erro ${signupResp.status} ao criar conta.`;
          throw Object.assign(new Error(errMsg), { status: signupResp.status });
        }

        if (isEducacao) {
          setSuccessMsg('Conta criada! Verifique seu e-mail de confirmação e depois faça login.');
          setIsSignUp(false);
        } else {
          setSuccessMsg(
            signupData?.message ||
              'Conta criada! Verifique seu e-mail (e o Spam) para confirmar o cadastro.'
          );
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
      console.error('Auth Error:', err);
      if (!isSignUp) {
        // Notify backend of failed login (fire-and-forget to avoid blocking the UI)
        sendAuthEvent('login', cleanEmail, false, err.message || 'Erro desconhecido');
      }
      if (isMounted.current) {
        setLoading(false); // Only stop loading on error
        if (err.message === 'Invalid login credentials' || err.status === 400) {
          setError('E-mail ou senha incorretos. Verifique suas credenciais.');
        } else if (err.message?.toLowerCase().includes('email not confirmed')) {
          setError(
            'E-mail ainda não confirmado. Verifique sua caixa de entrada (e o Spam) para ativar sua conta.'
          );
        } else if (
          err.code === 'user_already_exists' ||
          err.message?.toLowerCase().includes('already registered')
        ) {
          setError('Este e-mail já possui uma conta cadastrada. Faça login.');
        } else if (isRateLimitError(err)) {
          setError(
            'Estamos recebendo muitas solicitações de cadastro neste momento. Tente novamente em alguns minutos ou entre em contato com o suporte.'
          );
        } else if (isRetryableAuthError(err)) {
          setError(
            'Estamos com instabilidade momentânea no servidor de autenticação. Tente novamente em alguns segundos.'
          );
        } else {
          setError(
            'Ocorreu um erro ao processar sua solicitação. Tente novamente ou entre em contato com o suporte.'
          );
          console.error('[LoginScreen] Erro de auth não mapeado:', err);
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
    <main className="min-h-screen bg-slate-50 lg:grid lg:grid-cols-[minmax(360px,0.85fr)_minmax(560px,1.15fr)]">
      <section className="relative hidden overflow-hidden bg-[#071a2d] px-12 py-10 text-white lg:flex lg:flex-col lg:justify-between xl:px-16">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_15%_10%,rgba(37,99,235,0.32),transparent_34%),radial-gradient(circle_at_90%_85%,rgba(14,165,233,0.18),transparent_30%)]" />
        <a href="https://www.profeplan.com.br" className="relative flex items-center gap-3">
          <img
            src="/logo-profeplan.png"
            alt=""
            className="h-12 w-12 rounded-xl bg-white object-contain p-1 shadow-sm"
          />
          <span>
            <strong className="block text-xl font-bold tracking-tight">ProfePlan</strong>
            <span className="block text-sm text-blue-100">uma solução WRTech AI</span>
          </span>
        </a>
        <div className="relative max-w-xl">
          <p className="mb-5 text-sm font-semibold uppercase tracking-[0.14em] text-sky-300">
            Inteligência pedagógica para professores
          </p>
          <h1 className="max-w-lg text-4xl font-bold leading-tight tracking-tight xl:text-5xl">
            Menos tempo com burocracia. Mais tempo para ensinar.
          </h1>
          <p className="mt-6 max-w-lg text-lg leading-8 text-slate-300">
            Organize planejamentos, planos de aula e avaliações em um ambiente seguro, claro e
            pensado para a rotina docente.
          </p>
          <ul className="mt-9 space-y-4 text-sm text-slate-200">
            <li className="flex items-center gap-3">
              <ShieldCheck aria-hidden="true" className="h-5 w-5 text-sky-300" />
              Seus dados e materiais permanecem protegidos.
            </li>
            <li className="flex items-center gap-3">
              <Sparkles aria-hidden="true" className="h-5 w-5 text-sky-300" />
              Você sempre revisa e decide antes de finalizar.
            </li>
          </ul>
        </div>
        <p className="relative text-xs text-slate-400">© 2026 ProfePlan — WR TECH INOVA SIMPLES</p>
      </section>

      <section className="relative flex min-h-screen items-center justify-center overflow-hidden px-4 py-8 sm:px-8 lg:px-12">
      {/* Background Decorativo */}
      <div className="absolute top-[-20%] left-[-10%] w-[60%] h-[60%] bg-blue-100/70 rounded-full blur-[120px]"></div>
      <div
        className="absolute bottom-[-20%] right-[-10%] w-[60%] h-[60%] bg-sky-100/70 rounded-full blur-[120px]"
      ></div>

      <div className="w-full max-w-lg z-10">
        <div className="mb-8 text-center lg:hidden">
          <div className="mb-3 inline-flex items-center justify-center">
            <img
              src="/logo-profeplan.png"
              alt="PROFEPLAN"
              className="h-12 w-12 rounded-xl bg-white object-contain p-1 shadow-sm"
            />
          </div>
          <h1 className="mb-1 text-2xl font-bold tracking-tight text-slate-950">ProfePlan</h1>
          <p className="text-xs font-medium text-slate-500">
            Ecossistema de Inteligência Pedagógica
          </p>
        </div>

        <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-[0_18px_50px_rgba(15,23,42,0.08)] md:p-9">
          <p className="mb-2 text-sm font-semibold text-blue-700">
            {isSignUp ? 'Comece gratuitamente' : 'Bem-vindo(a) de volta'}
          </p>
          <h2 className="mb-2 text-3xl font-bold tracking-tight text-slate-950">
            {isSignUp ? 'Criar nova conta' : 'Acessar plataforma'}
          </h2>
          <p className="mb-7 text-sm leading-6 text-slate-600">
            {isSignUp
              ? 'Crie seu acesso e comece a organizar sua rotina pedagógica.'
              : 'Entre com seu e-mail e senha para continuar seu trabalho.'}
          </p>

          <form onSubmit={handleEmailAuth} className="space-y-5">
            {isSignUp && (
              <div className="space-y-1.5">
                <label htmlFor="full-name" className="block text-sm font-semibold text-slate-800">
                  Nome Completo
                </label>
                <div className="relative">
                  <div className="pointer-events-none absolute left-4 top-1/2 flex h-5 w-5 -translate-y-1/2 items-center justify-center text-xs font-bold text-slate-400">
                    Aa
                  </div>
                  <input
                    id="full-name"
                    type="text"
                    required={isSignUp}
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                    placeholder="Ex: Maria Silva"
                    autoComplete="name"
                    className="min-h-12 w-full rounded-xl border border-slate-300 bg-white py-2.5 pl-11 pr-4 text-base text-slate-950 outline-none transition-colors placeholder:text-slate-400 focus:border-blue-600 focus:ring-4 focus:ring-blue-100"
                  />
                </div>
              </div>
            )}

            <div className="space-y-1.5">
              <label htmlFor="email" className="block text-sm font-semibold text-slate-800">
                E-mail
              </label>
              <div className="relative">
                <Mail className="pointer-events-none absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400" />
                <input
                  id="email"
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="Seu melhor e-mail"
                  autoComplete="email"
                  className="min-h-12 w-full rounded-xl border border-slate-300 bg-white py-2.5 pl-11 pr-4 text-base text-slate-950 outline-none transition-colors placeholder:text-slate-400 focus:border-blue-600 focus:ring-4 focus:ring-blue-100"
                />
              </div>
            </div>

            <div className="space-y-1.5">
              <label htmlFor="password" className="block text-sm font-semibold text-slate-800">
                Senha
              </label>
              <div className="relative">
                <Lock className="pointer-events-none absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400" />
                <input
                  id="password"
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  autoComplete={isSignUp ? 'new-password' : 'current-password'}
                  className="min-h-12 w-full rounded-xl border border-slate-300 bg-white py-2.5 pl-11 pr-4 text-base text-slate-950 outline-none transition-colors placeholder:text-slate-400 focus:border-blue-600 focus:ring-4 focus:ring-blue-100"
                />
              </div>
            </div>

            {error && (
              <div role="alert" className="flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 p-4">
                <AlertCircle className="mt-0.5 h-5 w-5 shrink-0 text-red-700" />
                <p className="text-sm font-medium leading-5 text-red-800">{error}</p>
              </div>
            )}

            {successMsg && (
              <div role="status" className="flex items-start gap-3 rounded-xl border border-emerald-200 bg-emerald-50 p-4">
                <Sparkles className="mt-0.5 h-5 w-5 shrink-0 text-emerald-700" />
                <p className="text-sm font-medium leading-5 text-emerald-800">{successMsg}</p>
              </div>
            )}

            {/* ── Termos de Uso & Privacidade (apenas no cadastro) ── */}
            {isSignUp && (
              <>
                <div className="space-y-3 border-t border-slate-200 pt-4">
                  {/* Aceite dos Termos de Uso (obrigatório) */}
                  <label className="flex cursor-pointer items-start gap-3">
                    <input
                      type="checkbox"
                      checked={termsAccepted}
                      onChange={(e) => setTermsAccepted(e.target.checked)}
                      className="mt-0.5 h-4 w-4 rounded border-slate-300 text-blue-600 focus:ring-2 focus:ring-blue-500"
                    />
                    <span className="text-sm leading-5 text-slate-600">
                      Li e concordo com os{' '}
                      <a
                        href="/termos-de-uso"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="font-semibold text-blue-700 underline underline-offset-2 hover:text-blue-800"
                        onClick={(e) => e.stopPropagation()}
                      >
                        Termos de Uso
                      </a>
                      .
                    </span>
                  </label>

                  {/* Aviso de Privacidade (informativo, não é consentimento) */}
                  <p className="pl-7 text-xs leading-5 text-slate-500">
                    Seus dados pessoais serão tratados conforme nossa{' '}
                    <a
                      href="/politica-de-privacidade"
                      target="_blank"
                      rel="noopener noreferrer"
                      className="font-medium text-blue-700 underline underline-offset-2 hover:text-blue-800"
                    >
                      Política de Privacidade
                    </a>
                    .
                  </p>

                  {/* Comunicações de marketing (opcional, desmarcado) */}
                  <label className="flex cursor-pointer items-start gap-3">
                    <input
                      type="checkbox"
                      checked={marketingConsent}
                      onChange={(e) => setMarketingConsent(e.target.checked)}
                      className="mt-0.5 h-4 w-4 rounded border-slate-300 text-blue-600 focus:ring-2 focus:ring-blue-500"
                    />
                    <span className="text-sm leading-5 text-slate-500">
                      Desejo receber novidades, conteúdos e comunicações comerciais do ProfePlan.
                    </span>
                  </label>
                </div>
              </>
            )}

            <button
              type="submit"
              disabled={loading}
              aria-busy={loading || undefined}
              className="flex min-h-12 w-full items-center justify-center gap-2 rounded-xl bg-blue-600 px-5 py-3 font-semibold text-white transition-colors hover:bg-blue-700 focus:outline-none focus:ring-4 focus:ring-blue-200 disabled:cursor-not-allowed disabled:opacity-60"
            >
              {loading ? (
                <Loader2 aria-hidden="true" className="h-5 w-5 animate-spin" />
              ) : (
                <>
                  {isSignUp ? 'Criar Conta Grátis' : 'Acessar Workspace'}{' '}
                  <ArrowRight className="w-5 h-5" />
                </>
              )}
            </button>
          </form>

          <div className="mt-6 border-t border-slate-200 pt-5 text-center">
            <button
              type="button"
              onClick={() => {
                setIsSignUp(!isSignUp);
                setError('');
                setSuccessMsg('');
              }}
              className="rounded-md text-sm font-semibold text-blue-700 underline-offset-4 hover:text-blue-800 hover:underline focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              {isSignUp ? 'Já tem uma conta? Fazer Login' : 'Ainda não tem conta? Criar cadastro'}
            </button>
          </div>

          <div className="mt-6 flex justify-center">
            <div className="flex items-center gap-2 text-xs text-slate-500">
              <div
                className={`h-2 w-2 rounded-full ${supabase.auth ? 'bg-emerald-500' : 'bg-red-600'}`}
              ></div>
              <span>Conexão segura</span>
            </div>
          </div>
        </div>

        <div className="mt-6 text-center">
          <p className="text-xs text-slate-500">
            ProfePlan v1.0.2
          </p>
        </div>
      </div>
      </section>
    </main>
  );
};

export default LoginScreen;
