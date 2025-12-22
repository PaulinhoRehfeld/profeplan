
import React, { useState } from 'react';
import { PenTool, Mail, Lock, ArrowRight, ShieldCheck, Sparkles } from 'lucide-react';
import { UserSession } from '../types';

interface LoginScreenProps {
  onLogin: (session: UserSession) => void;
}

const LoginScreen: React.FC<LoginScreenProps> = ({ onLogin }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    // Simulação de delay de rede para feedback visual
    setTimeout(() => {
      // Lógica de acesso solicitado pelo usuário
      const isAdmin = email === 'paulinho.rehfeld@gmail.com' && password === 'PLAN@0403';
      
      const session: UserSession = {
        email: email,
        role: isAdmin ? 'ADMIN' : 'TEACHER',
        accessLevel: isAdmin ? 'PREMIUM' : 'PRO',
        isLoggedIn: true,
        driveConnected: email.includes('mg.gov.br') || isAdmin
      };

      localStorage.setItem('profeplan_session', JSON.stringify(session));
      onLogin(session);
      setLoading(false);
    }, 1200);
  };

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col items-center justify-center p-4 relative overflow-hidden">
      <div className="absolute top-[-20%] left-[-10%] w-[60%] h-[60%] bg-blue-600/10 rounded-full blur-[120px] animate-pulse"></div>
      <div className="absolute bottom-[-20%] right-[-10%] w-[60%] h-[60%] bg-indigo-600/10 rounded-full blur-[120px] animate-pulse" style={{ animationDelay: '2s' }}></div>
      
      <div className="w-full max-w-lg z-10 animate-in fade-in slide-in-from-bottom-8 duration-700">
        <div className="text-center mb-10">
          <div className="inline-flex items-center justify-center p-4 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-3xl shadow-2xl mb-6 transform hover:rotate-6 transition-transform">
            <PenTool className="w-12 h-12 text-white" />
          </div>
          <h1 className="text-5xl font-black text-white tracking-tighter mb-2 italic">PROFEPLAN</h1>
          <p className="text-slate-400 font-medium tracking-wide uppercase text-sm">Sistema de Engenharia Pedagógica</p>
        </div>

        <div className="bg-white/5 backdrop-blur-2xl border border-white/10 p-10 rounded-[40px] shadow-3xl">
          <h2 className="text-2xl font-bold text-white mb-8 text-center">Identificação Docente</h2>
          
          <form onSubmit={handleLogin} className="space-y-6">
            <div className="space-y-2">
              <label className="text-[10px] font-black text-slate-500 uppercase tracking-widest ml-1">E-mail de Trabalho</label>
              <div className="relative group">
                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500 group-focus-within:text-blue-500 transition-colors" />
                <input 
                  type="email" 
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="ex: paulo.rehfeld@educacao.mg.gov.br"
                  className="w-full bg-slate-900/50 border border-white/10 rounded-2xl py-4 pl-12 pr-6 text-white placeholder:text-slate-700 outline-none focus:ring-2 focus:ring-blue-500/50 transition-all font-medium"
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-[10px] font-black text-slate-500 uppercase tracking-widest ml-1">Chave de Acesso</label>
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

            {error && <p className="text-red-400 text-xs font-bold text-center">{error}</p>}

            <button 
              type="submit" 
              disabled={loading}
              className="w-full bg-blue-600 hover:bg-blue-500 text-white font-black py-5 rounded-2xl shadow-xl shadow-blue-600/20 flex items-center justify-center gap-3 transition-all active:scale-[0.98] disabled:opacity-50"
            >
              {loading ? (
                <div className="w-6 h-6 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
              ) : (
                <>Entrar no Workspace <ArrowRight className="w-5 h-5" /></>
              )}
            </button>
          </form>

          <div className="mt-8 flex justify-center gap-6 opacity-30">
            <ShieldCheck className="w-5 h-5 text-white" />
            <Sparkles className="w-5 h-5 text-white" />
          </div>
        </div>

        <div className="mt-10 text-center">
          <p className="text-slate-600 text-xs font-bold uppercase tracking-widest">Powered by PROFEPLAN IA v2.5</p>
        </div>
      </div>
    </div>
  );
};

export default LoginScreen;
