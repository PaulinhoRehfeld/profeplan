import React from 'react';
import { Link } from 'react-router-dom';
import { ArrowLeft, Shield } from 'lucide-react';
import { PUBLIC_LEGAL_LINKS } from '../router/publicRoutes';

interface LegalLayoutProps {
  title: string;
  subtitle?: string;
  children: React.ReactNode;
}

export const LegalLayout: React.FC<LegalLayoutProps> = ({ title, subtitle, children }) => {
  return (
    <div
      className="min-h-screen"
      style={{
        background: '#070b14',
        fontFamily: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
        color: '#f1f5f9',
      }}
    >
      {/* Header */}
      <header
        style={{
          background: 'rgba(7,11,20,0.98)',
          borderBottom: '1px solid rgba(99,102,241,0.15)',
        }}
      >
        <div className="max-w-7xl mx-auto px-4 md:px-6 py-4 flex items-center justify-between">
          <Link to="/" className="flex items-center gap-3 group">
            <img
              src="/LOGO AZUL.png"
              alt="PROFEPLAN"
              className="h-7 md:h-8 w-auto object-contain"
            />
          </Link>
          <Link
            to="/"
            className="inline-flex items-center gap-2 text-sm text-slate-400 hover:text-white transition-colors"
          >
            <ArrowLeft size={18} />
            Voltar ao site
          </Link>
        </div>
      </header>

      <div className="max-w-6xl mx-auto px-4 md:px-6 py-8 md:py-12">
        <div className="flex flex-col lg:flex-row gap-8 lg:gap-12">
          {/* Sidebar — Table of Contents */}
          <aside className="lg:w-64 shrink-0">
            <nav className="lg:sticky lg:top-24">
              <h2 className="text-xs font-black uppercase tracking-widest text-slate-500 mb-4">
                Central Legal
              </h2>
              <ul className="space-y-1">
                {PUBLIC_LEGAL_LINKS.map((link) => (
                  <li key={link.href}>
                    <Link
                      to={link.href}
                      className={`block text-sm py-2 px-3 rounded-lg transition-colors ${
                        window.location.pathname === link.href
                          ? 'bg-indigo-500/10 text-indigo-300 font-semibold border border-indigo-500/20'
                          : 'text-slate-400 hover:text-white hover:bg-white/5'
                      }`}
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </nav>
          </aside>

          {/* Main Content */}
          <main className="flex-1 min-w-0">
            <div className="mb-8">
              <h1
                className="text-2xl md:text-3xl font-black text-white mb-2"
                style={{ letterSpacing: '-0.02em' }}
              >
                {title}
              </h1>
              {subtitle && <p className="text-slate-400 leading-relaxed max-w-2xl">{subtitle}</p>}
              <p className="text-xs text-slate-500 mt-3">Última atualização: 27 de julho de 2026</p>
            </div>

            <div
              className="prose prose-invert prose-slate max-w-none"
              style={
                {
                  '--tw-prose-body': '#cbd5e1',
                  '--tw-prose-headings': '#f1f5f9',
                  '--tw-prose-links': '#818cf8',
                  '--tw-prose-bold': '#e2e8f0',
                  '--tw-prose-counters': '#64748b',
                  '--tw-prose-bullets': '#475569',
                  '--tw-prose-hr': 'rgba(255,255,255,0.08)',
                  '--tw-prose-quotes': '#94a3b8',
                  '--tw-prose-quote-borders': 'rgba(99,102,241,0.3)',
                  '--tw-prose-code': '#e2e8f0',
                  '--tw-prose-pre-bg': 'rgba(0,0,0,0.3)',
                  '--tw-prose-pre-border': 'rgba(255,255,255,0.06)',
                  '--tw-prose-th-borders': 'rgba(255,255,255,0.1)',
                  '--tw-prose-td-borders': 'rgba(255,255,255,0.06)',
                  lineHeight: '1.8',
                  fontSize: '0.95rem',
                } as React.CSSProperties
              }
            >
              {children}
            </div>
          </main>
        </div>
      </div>

      {/* Footer */}
      <footer
        style={{
          background: '#040710',
          borderTop: '1px solid rgba(255,255,255,0.05)',
        }}
      >
        <div className="max-w-6xl mx-auto px-4 md:px-6 py-8">
          <div className="flex flex-col sm:flex-row items-center justify-between gap-4">
            <p className="text-xs text-slate-600">
              © 2026 ProfePlan — WR TECH INOVA SIMPLES (I.S.). CNPJ 65.458.067/0001-10. Todos os
              direitos reservados.
            </p>
            <div className="flex items-center gap-4 text-xs text-slate-600">
              <Link
                to="/politica-de-privacidade"
                className="hover:text-slate-400 transition-colors"
              >
                Privacidade
              </Link>
              <span>·</span>
              <Link to="/termos-de-uso" className="hover:text-slate-400 transition-colors">
                Termos
              </Link>
              <span>·</span>
              <a
                href="mailto:suporte@profeplan.com.br"
                className="hover:text-slate-400 transition-colors"
              >
                suporte@profeplan.com.br
              </a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default LegalLayout;
