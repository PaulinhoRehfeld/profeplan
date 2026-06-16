import React, { useState, useEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import {
  BookOpen, Users, Brain, Clock, FileCheck, Target,
  BarChart, ArrowRight, Sparkles, Check, ChevronDown,
  Menu, X, Star, Zap, Shield, Award, GraduationCap,
  FileText, Calendar, Mic, Building2
} from 'lucide-react';

/* ─────────────────────────────────────────────────────────────
   INLINE STYLES / KEYFRAMES (evita dependência de CSS global)
───────────────────────────────────────────────────────────── */
const inlineStyles = `
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');

  .lp-root {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    background: #070b14;
    color: #f1f5f9;
    overflow-x: hidden;
    -webkit-font-smoothing: antialiased;
  }

  /* ── Animations ── */
  @keyframes lp-fade-up {
    from { opacity: 0; transform: translateY(28px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  @keyframes lp-fade-in {
    from { opacity: 0; }
    to   { opacity: 1; }
  }
  @keyframes lp-glow-pulse {
    0%, 100% { box-shadow: 0 0 20px rgba(59,130,246,0.3), 0 0 60px rgba(59,130,246,0.1); }
    50%       { box-shadow: 0 0 40px rgba(59,130,246,0.6), 0 0 120px rgba(59,130,246,0.2); }
  }
  @keyframes lp-float {
    0%, 100% { transform: translateY(0px); }
    50%       { transform: translateY(-10px); }
  }
  @keyframes lp-shimmer {
    0%   { background-position: -200% center; }
    100% { background-position: 200% center; }
  }
  @keyframes lp-spin-slow {
    from { transform: rotate(0deg); }
    to   { transform: rotate(360deg); }
  }
  @keyframes lp-counter {
    from { opacity: 0; transform: translateY(10px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  @keyframes lp-blob {
    0%, 100% { border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%; }
    50%       { border-radius: 30% 60% 70% 40% / 50% 60% 30% 60%; }
  }
  @keyframes lp-gradient-shift {
    0%   { background-position: 0% 50%; }
    50%  { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
  }

  .lp-animate-fade-up  { animation: lp-fade-up 0.7s ease forwards; }
  .lp-animate-fade-in  { animation: lp-fade-in 0.5s ease forwards; }
  .lp-animate-float    { animation: lp-float 4s ease-in-out infinite; }
  .lp-animate-glow     { animation: lp-glow-pulse 3s ease-in-out infinite; }
  .lp-animate-spin-slow{ animation: lp-spin-slow 20s linear infinite; }
  .lp-animate-blob     { animation: lp-blob 8s ease-in-out infinite; }

  /* ── Delay helpers ── */
  .lp-delay-100 { animation-delay: 0.1s; opacity: 0; }
  .lp-delay-200 { animation-delay: 0.2s; opacity: 0; }
  .lp-delay-300 { animation-delay: 0.3s; opacity: 0; }
  .lp-delay-400 { animation-delay: 0.4s; opacity: 0; }
  .lp-delay-500 { animation-delay: 0.5s; opacity: 0; }
  .lp-delay-600 { animation-delay: 0.6s; opacity: 0; }
  .lp-delay-700 { animation-delay: 0.7s; opacity: 0; }

  /* ── Shimmer text ── */
  .lp-shimmer-text {
    background: linear-gradient(90deg, #60a5fa 0%, #a5b4fc 25%, #f0abfc 50%, #60a5fa 75%, #a5b4fc 100%);
    background-size: 200% auto;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    animation: lp-shimmer 4s linear infinite;
  }

  /* ── Gradient text ── */
  .lp-grad-text {
    background: linear-gradient(135deg, #3b82f6 0%, #6366f1 50%, #8b5cf6 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .lp-grad-text-gold {
    background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 50%, #fde68a 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  /* ── Glass card ── */
  .lp-glass {
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.08);
    backdrop-filter: blur(12px);
  }
  .lp-glass:hover {
    background: rgba(255,255,255,0.07);
    border-color: rgba(59,130,246,0.3);
    transform: translateY(-3px);
    transition: all 0.3s ease;
  }

  /* ── Noise texture overlay ── */
  .lp-noise::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.03'/%3E%3C/svg%3E");
    opacity: 0.4;
    pointer-events: none;
  }

  /* ── Nav scroll effect ── */
  .lp-nav-scrolled {
    background: rgba(7,11,20,0.95) !important;
    border-bottom: 1px solid rgba(255,255,255,0.08) !important;
    box-shadow: 0 4px 30px rgba(0,0,0,0.5) !important;
  }

  /* ── Pricing card highlight ── */
  .lp-pricing-featured {
    background: linear-gradient(135deg, rgba(59,130,246,0.15) 0%, rgba(99,102,241,0.1) 100%);
    border: 1px solid rgba(59,130,246,0.4);
    position: relative;
  }
  .lp-pricing-featured::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(135deg, rgba(59,130,246,0.1), transparent);
    pointer-events: none;
  }

  /* ── CTA button glow ── */
  .lp-btn-primary {
    background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
    box-shadow: 0 4px 15px rgba(37,99,235,0.4), 0 0 0 0 rgba(37,99,235,0.2);
    transition: all 0.3s ease;
  }
  .lp-btn-primary:hover {
    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
    box-shadow: 0 8px 30px rgba(37,99,235,0.6), 0 0 0 4px rgba(37,99,235,0.1);
    transform: translateY(-2px);
  }
  .lp-btn-primary:active { transform: translateY(0); }

  .lp-btn-ghost {
    border: 1px solid rgba(255,255,255,0.15);
    transition: all 0.3s ease;
  }
  .lp-btn-ghost:hover {
    border-color: rgba(59,130,246,0.5);
    background: rgba(59,130,246,0.08);
    transform: translateY(-1px);
  }

  /* ── Feature icon ── */
  .lp-icon-wrap {
    background: linear-gradient(135deg, rgba(59,130,246,0.2) 0%, rgba(99,102,241,0.1) 100%);
    border: 1px solid rgba(59,130,246,0.25);
  }

  /* ── Orb backgrounds ── */
  .lp-orb-blue {
    background: radial-gradient(circle, rgba(59,130,246,0.25) 0%, transparent 70%);
    pointer-events: none;
  }
  .lp-orb-indigo {
    background: radial-gradient(circle, rgba(99,102,241,0.2) 0%, transparent 70%);
    pointer-events: none;
  }
  .lp-orb-violet {
    background: radial-gradient(circle, rgba(139,92,246,0.15) 0%, transparent 70%);
    pointer-events: none;
  }

  /* ── Stat counter ── */
  .lp-stat-card {
    border-left: 3px solid #3b82f6;
    padding-left: 1.5rem;
  }

  /* ── Testimonial ── */
  .lp-testimonial-stars { color: #fbbf24; }

  /* ── FAQ ── */
  .lp-faq-item {
    border-bottom: 1px solid rgba(255,255,255,0.06);
    transition: all 0.3s ease;
  }
  .lp-faq-answer {
    overflow: hidden;
    transition: max-height 0.4s ease, opacity 0.3s ease;
  }

  /* ── Scrollbar ── */
  .lp-root::-webkit-scrollbar { width: 6px; }
  .lp-root::-webkit-scrollbar-track { background: #070b14; }
  .lp-root::-webkit-scrollbar-thumb { background: rgba(59,130,246,0.4); border-radius: 3px; }

  /* ── Mobile menu ── */
  .lp-mobile-menu {
    background: rgba(7,11,20,0.98);
    backdrop-filter: blur(20px);
    border-bottom: 1px solid rgba(255,255,255,0.06);
  }

  /* ── Section divider ── */
  .lp-divider {
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(59,130,246,0.3), rgba(99,102,241,0.3), transparent);
  }

  /* ── Badge ── */
  .lp-badge {
    background: linear-gradient(135deg, rgba(59,130,246,0.15), rgba(99,102,241,0.1));
    border: 1px solid rgba(59,130,246,0.3);
    color: #93c5fd;
  }

  /* ── Highlight band ── */
  .lp-band {
    background: linear-gradient(135deg, #1e3a5f 0%, #1e1b4b 100%);
    border-top: 1px solid rgba(59,130,246,0.2);
    border-bottom: 1px solid rgba(99,102,241,0.2);
  }

  /* ── Green accent for free plan ── */
  .lp-plan-free { border-color: rgba(16,185,129,0.3); }
  .lp-plan-silver { border-color: rgba(148,163,184,0.4); }
  .lp-plan-gold { border-color: rgba(245,158,11,0.5); }
  .lp-plan-b2b { border-color: rgba(139,92,246,0.4); }

  /* ── Scroll indicator ── */
  @keyframes lp-bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(6px); }
  }
  .lp-bounce { animation: lp-bounce 1.5s ease-in-out infinite; }

  /* ── Responsive ── */
  @media (max-width: 768px) {
    .lp-hero-title { font-size: clamp(2rem, 8vw, 3.5rem) !important; }
    .lp-section-title { font-size: clamp(1.75rem, 6vw, 3rem) !important; }
  }
`;

/* ─────────────────────────────────────────────────────────────
   DATA
───────────────────────────────────────────────────────────── */
const FEATURES = [
  {
    icon: <Calendar size={24} />,
    title: 'Planejamento Trimestral',
    desc: 'Plano completo alinhado à BNCC para o trimestre inteiro gerado em minutos. Agente RAG consulta os documentos oficiais — zero alucinação.',
    badge: '⭐ Feature Estrela',
    badgeColor: '#fbbf24',
  },
  {
    icon: <BookOpen size={24} />,
    title: 'Planos de Aula Diários',
    desc: 'Cada aula gerada com contexto do trimestre completo. Introdução, desenvolvimento, fechamento e critério avaliativo formatados para imprimir.',
    badge: null,
    badgeColor: null,
  },
  {
    icon: <FileCheck size={24} />,
    title: 'Avaliações & Simulados',
    desc: '17.000 questões ENEM/SAEB + geração inédita. Versões A/B/C antifraude com gabarito embaralhado e exportação PDF.',
    badge: null,
    badgeColor: null,
  },
  {
    icon: <Target size={24} />,
    title: 'PDI Automático',
    desc: 'Plano de Desenvolvimento Individual vinculado ao perfil de cada aluno. Estratégias inclusivas sem expor diagnóstico clínico.',
    badge: '🛡️ Ética & Privacidade',
    badgeColor: '#34d399',
  },
  {
    icon: <Mic size={24} />,
    title: 'Agente de Planejamento IA',
    desc: 'IA Multi-Agentes que coordena planejamento trimestral, planos de aula, avaliações e PDI em um fluxo unificado. Resultados em minutos, não horas.',
    badge: '🤖 IA Avançada',
    badgeColor: '#a78bfa',
  },
  {
    icon: <Building2 size={24} />,
    title: 'Gestão Escolar B2B',
    desc: 'Painel para gestores com visibilidade total dos planejamentos, padronização de documentos e integração escola→professor via INEP.',
    badge: null,
    badgeColor: null,
  },
];

const TESTIMONIALS = [
  {
    name: 'Prof.ª Ana Paula Ferreira',
    role: 'Professora de História • EE João Pessoa — MG',
    avatar: 'A',
    avatarColor: '#3b82f6',
    text: 'Eu gastava 4 horas todo domingo preparando planos de aula. Com o PROFEPLAN, faço em 8 minutos e ainda fica melhor formatado do que eu fazia. Recuperei meus fins de semana.',
    stars: 5,
  },
  {
    name: 'Prof. Carlos Eduardo Lima',
    role: 'Coordenador Pedagógico • EMEF Tiradentes — SP',
    avatar: 'C',
    avatarColor: '#6366f1',
    text: 'O PDI automático resolveu um problema que tinha há anos. Os professores conseguem documentar as necessidades dos alunos com inclusão real, sem burocracia e com rastreabilidade completa.',
    stars: 5,
  },
  {
    name: 'Prof.ª Marina Oliveira',
    role: 'Professora de Ciências • EEB Marechal Floriano — SC',
    avatar: 'M',
    avatarColor: '#8b5cf6',
    text: 'Trabalho em duas escolas. O modo Multi-Escolas mudou minha vida. Um único login, contextos separados, e ainda posso gerar avaliações versão A e B com gabarito automático.',
    stars: 5,
  },
  {
    name: 'Prof. Roberto Santos',
    role: 'Professor de Matemática • CEFET-MG',
    avatar: 'R',
    avatarColor: '#10b981',
    text: 'A integração com a BNCC é impecável. Ele nunca inventa código de habilidade. Já tentei outras ferramentas de IA e todas alucinavam. O PROFEPLAN é o único que consulta a base de verdade.',
    stars: 5,
  },
];

const FAQS = [
  {
    q: 'O PROFEPLAN inventa conteúdo ou alucina habilidades da BNCC?',
    a: 'Não. Utilizamos uma arquitetura RAG (Retrieval-Augmented Generation) com os documentos oficiais da BNCC indexados. O sistema está proibido de inventar códigos de habilidade — ele consulta a base de dados real antes de gerar qualquer planejamento.',
  },
  {
    q: 'Como funciona o PDI? Os diagnósticos dos alunos ficam expostos?',
    a: 'O PDI é gerado a partir do perfil pedagógico do aluno cadastrado pelo professor. O documento final nunca expõe termos clínicos como TDAH, TEA ou Dislexia — foca 100% em estratégias pedagógicas inclusivas. Ética e privacidade são guardrails obrigatórios do sistema.',
  },
  {
    q: 'Posso usar em mais de uma escola?',
    a: 'Sim. O PROFEPLAN suporta vínculo com múltiplas escolas (modo Multi-Escola). Você alterna entre contextos com um clique, sem fazer logout, com dados e turmas separados por instituição.',
  },
  {
    q: 'O que são Créditos e como funcionam?',
    a: 'Cada operação de IA (gerar plano de aula, avaliação, PDI, etc.) consome 1 crédito. Novos usuários recebem 10 créditos grátis. O plano Silver oferece 50 créditos pré-pagos por R$ 30,00. O plano Gold inclui 120 créditos mensais + funções premium por R$ 50,00/mês.',
  },
  {
    q: 'As escolas e secretarias têm plano próprio?',
    a: 'Sim. Oferecemos planos B2B para escolas e B2G para secretarias de educação, redes municipais e estaduais, e entidades como ONU/ODS. Entre em contato para uma proposta personalizada.',
  },
  {
    q: 'Como o PROFEPLAN garante alinhamento com o currículo de MG?',
    a: 'O PROFEPLAN possui uma base de conhecimento com todos os Planos de Curso oficiais da SEE-MG 2026 para o Ensino Médio e Fundamental. Cada plano gerado é automaticamente vinculado à disciplina, ano e bimestre corretos, com habilidades BNCC e descritores SAEB.',
  },
];

const STATS = [
  { value: '3', suffix: 'min', label: 'Para gerar um plano de aula completo' },
  { value: '17', suffix: 'mil', label: 'Questões ENEM/SAEB no banco de dados' },
  { value: '100', suffix: '%', label: 'Alinhado à BNCC e PNLD oficial' },
  { value: '0', suffix: '', label: 'Alucinação de conteúdo pedagógico' },
];

/* ─────────────────────────────────────────────────────────────
   COMPONENTES INTERNOS
───────────────────────────────────────────────────────────── */
const StarRating: React.FC<{ count: number }> = ({ count }) => (
  <div className="flex gap-1">
    {Array.from({ length: count }).map((_, i) => (
      <Star key={i} size={14} fill="#fbbf24" stroke="none" />
    ))}
  </div>
);

const FaqItem: React.FC<{ q: string; a: string }> = ({ q, a }) => {
  const [open, setOpen] = useState(false);
  return (
    <div className="lp-faq-item py-5">
      <button
        onClick={() => setOpen(!open)}
        className="w-full flex items-center justify-between text-left gap-4 group"
        aria-expanded={open}
      >
        <span className="text-base font-semibold text-slate-100 group-hover:text-blue-400 transition-colors">
          {q}
        </span>
        <ChevronDown
          size={18}
          className="text-slate-400 shrink-0 transition-transform duration-300"
          style={{ transform: open ? 'rotate(180deg)' : 'rotate(0deg)' }}
        />
      </button>
      <div
        className="lp-faq-answer"
        style={{ maxHeight: open ? '300px' : '0px', opacity: open ? 1 : 0 }}
      >
        <p className="pt-3 text-slate-400 leading-relaxed text-sm">{a}</p>
      </div>
    </div>
  );
};

/* ─────────────────────────────────────────────────────────────
   MAIN COMPONENT
───────────────────────────────────────────────────────────── */
const LandingPage: React.FC = () => {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const heroRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  // Close mobile menu on route change
  useEffect(() => {
    setMobileOpen(false);
  }, []);

  return (
    <>
      <style>{inlineStyles}</style>

      <div className="lp-root min-h-screen relative">

        {/* ══════════════════════════════════════════
            NAVBAR
        ══════════════════════════════════════════ */}
        <header
          className={`fixed top-0 w-full z-50 transition-all duration-500 ${
            scrolled ? 'lp-nav-scrolled' : 'bg-transparent'
          }`}
        >
          <nav className="max-w-7xl mx-auto px-4 md:px-6 h-18 flex items-center justify-between py-4">
            {/* Logo */}
            <Link to="/" className="flex items-center gap-3 group">
              <div className="w-9 h-9 rounded-xl overflow-hidden lp-animate-glow" style={{ flexShrink: 0 }}>
                <img src="/logo-blue.png" alt="PROFEPLAN" className="w-full h-full object-contain" />
              </div>
              <div className="flex flex-col leading-none">
                <span className="text-base font-black tracking-tight text-white">PROFEPLAN</span>
                <span className="text-[10px] font-medium text-blue-400 tracking-widest uppercase">by WR Tech AI</span>
              </div>
            </Link>

            {/* Desktop links */}
            <div className="hidden lg:flex items-center gap-8">
              {[
                { label: 'Funcionalidades', href: '#funcionalidades' },
                { label: 'Planos', href: '#planos' },
                { label: 'Depoimentos', href: '#depoimentos' },
                { label: 'FAQ', href: '#faq' },
              ].map(link => (
                <a
                  key={link.href}
                  href={link.href}
                  className="text-sm font-medium text-slate-400 hover:text-white transition-colors duration-200"
                >
                  {link.label}
                </a>
              ))}
            </div>

            {/* CTA buttons */}
            <div className="hidden md:flex items-center gap-3">
              <Link
                to="/login"
                className="lp-btn-ghost px-5 py-2 rounded-lg text-sm font-semibold text-slate-300"
              >
                Entrar
              </Link>
              <Link
                to="/signup"
                className="lp-btn-primary px-5 py-2 rounded-lg text-sm font-bold text-white"
              >
                Começar Grátis →
              </Link>
            </div>

            {/* Mobile menu button */}
            <button
              onClick={() => setMobileOpen(!mobileOpen)}
              className="lg:hidden p-2 text-slate-400 hover:text-white transition-colors"
              aria-label="Menu"
            >
              {mobileOpen ? <X size={22} /> : <Menu size={22} />}
            </button>
          </nav>

          {/* Mobile menu */}
          {mobileOpen && (
            <div className="lp-mobile-menu lg:hidden px-4 pb-6 pt-2 flex flex-col gap-4">
              {['#funcionalidades', '#planos', '#depoimentos', '#faq'].map((href, i) => (
                <a
                  key={href}
                  href={href}
                  onClick={() => setMobileOpen(false)}
                  className="text-base font-medium text-slate-300 hover:text-white py-2 border-b border-white/5"
                >
                  {['Funcionalidades', 'Planos', 'Depoimentos', 'FAQ'][i]}
                </a>
              ))}
              <Link to="/signup" className="lp-btn-primary mt-2 px-6 py-3 rounded-xl text-center font-bold text-white">
                Começar Grátis
              </Link>
            </div>
          )}
        </header>

        {/* ══════════════════════════════════════════
            HERO SECTION
        ══════════════════════════════════════════ */}
        <section ref={heroRef} className="relative pt-28 pb-20 md:pt-40 md:pb-32 px-4 overflow-hidden lp-noise">

          {/* Background orbs */}
          <div className="absolute inset-0 overflow-hidden pointer-events-none">
            <div className="lp-orb-blue absolute -top-40 left-1/2 -translate-x-1/2 w-[900px] h-[700px] opacity-60 lp-animate-blob" />
            <div className="lp-orb-indigo absolute top-20 -right-40 w-[500px] h-[500px] opacity-40" />
            <div className="lp-orb-violet absolute bottom-0 -left-40 w-[400px] h-[400px] opacity-30" />
            {/* Grid lines */}
            <div
              className="absolute inset-0 opacity-[0.03]"
              style={{
                backgroundImage: 'linear-gradient(rgba(59,130,246,0.5) 1px, transparent 1px), linear-gradient(90deg, rgba(59,130,246,0.5) 1px, transparent 1px)',
                backgroundSize: '80px 80px',
              }}
            />
          </div>

          <div className="relative max-w-5xl mx-auto text-center">

            {/* Badge */}
            <div className="lp-animate-fade-up lp-delay-100 inline-flex items-center gap-2 px-4 py-2 rounded-full text-xs font-bold uppercase tracking-widest mb-8 lp-badge">
              <Sparkles size={12} className="text-blue-400" />
              Plataforma #1 de IA Pedagógica do Brasil
            </div>

            {/* Headline */}
            <h1
              className="lp-animate-fade-up lp-delay-200 lp-hero-title font-black leading-none tracking-tight mb-6"
              style={{ fontSize: 'clamp(2.8rem, 7vw, 5.5rem)', textWrap: 'balance' }}
            >
              Acabou o{' '}
              <span className="lp-shimmer-text">domingo perdido</span>
              <br />preparando aula.
            </h1>

            {/* Subheadline */}
            <p
              className="lp-animate-fade-up lp-delay-300 text-slate-400 leading-relaxed max-w-2xl mx-auto mb-10"
              style={{ fontSize: 'clamp(1rem, 2.5vw, 1.25rem)', textWrap: 'pretty' }}
            >
              O PROFEPLAN gera Planejamentos, Avaliações e PDIs personalizados em minutos —
              alinhados à <strong className="text-slate-300">BNCC oficial</strong>, sem inventar nada.
              A IA que trabalha <em>por você</em>.
            </p>

            {/* CTAs */}
            <div className="lp-animate-fade-up lp-delay-400 flex flex-col sm:flex-row items-center justify-center gap-4 mb-16">
              <Link
                to="/signup?role=professor"
                className="lp-btn-primary flex items-center gap-2 px-8 py-4 rounded-xl font-bold text-white text-base w-full sm:w-auto justify-center"
              >
                <GraduationCap size={20} />
                Sou Professor — Testar Grátis
              </Link>
              <Link
                to="/signup?role=gestor"
                className="lp-btn-ghost flex items-center gap-2 px-8 py-4 rounded-xl font-semibold text-slate-300 text-base w-full sm:w-auto justify-center"
              >
                <Building2 size={20} />
                Sou Gestor Escolar
              </Link>
            </div>

            {/* Social proof pills */}
            <div className="lp-animate-fade-up lp-delay-500 flex flex-wrap items-center justify-center gap-3 text-xs text-slate-500 mb-16">
              <span className="flex items-center gap-1.5">
                <Check size={12} className="text-green-400" /> Sem cartão de crédito
              </span>
              <span className="text-slate-700">•</span>
              <span className="flex items-center gap-1.5">
                <Check size={12} className="text-green-400" /> 10 créditos grátis ao cadastrar
              </span>
              <span className="text-slate-700">•</span>
              <span className="flex items-center gap-1.5">
                <Check size={12} className="text-green-400" /> BNCC verificada e atualizada
              </span>
            </div>

            {/* App mockup */}
            <div className="lp-animate-fade-up lp-delay-600 relative max-w-4xl mx-auto lp-animate-float">
              <div
                className="rounded-2xl overflow-hidden border border-white/10"
                style={{
                  boxShadow: '0 40px 100px -20px rgba(0,0,0,0.8), 0 0 60px rgba(59,130,246,0.15), 0 0 0 1px rgba(59,130,246,0.1)',
                }}
              >
                <img
                  src="/logo-blue.png"
                  alt="Interface do PROFEPLAN"
                  className="w-full"
                  style={{ display: 'none' }}
                  onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
                />
                {/* Fallback: browser chrome + mock UI */}
                <div style={{ background: '#0d1117', padding: '12px 16px 0', borderBottom: '1px solid rgba(255,255,255,0.06)' }}>
                  <div className="flex items-center gap-2 mb-3">
                    <div className="w-3 h-3 rounded-full" style={{ background: '#ff5f57' }} />
                    <div className="w-3 h-3 rounded-full" style={{ background: '#ffbd2e' }} />
                    <div className="w-3 h-3 rounded-full" style={{ background: '#28ca41' }} />
                    <div className="flex-1 mx-4 h-6 rounded-md flex items-center px-3" style={{ background: 'rgba(255,255,255,0.05)', fontSize: '11px', color: '#64748b' }}>
                      profeplan.com.br/app
                    </div>
                  </div>
                </div>
                <div style={{ background: '#0a0e1a', minHeight: '340px', display: 'flex' }}>
                  {/* Sidebar mock */}
                  <div style={{ width: '60px', background: '#070b14', borderRight: '1px solid rgba(255,255,255,0.06)', display: 'flex', flexDirection: 'column', alignItems: 'center', paddingTop: '20px', gap: '20px' }}>
                    {[BookOpen, Calendar, FileCheck, Target, FileText, Mic].map((Icon, i) => (
                      <div key={i} style={{ width: '36px', height: '36px', borderRadius: '10px', background: i === 0 ? 'rgba(59,130,246,0.25)' : 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center', color: i === 0 ? '#60a5fa' : '#475569' }}>
                        <Icon size={16} />
                      </div>
                    ))}
                  </div>
                  {/* Main content mock */}
                  <div style={{ flex: 1, padding: '20px', display: 'flex', flexDirection: 'column', gap: '12px' }}>
                    {/* Top bar */}
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
                      <div>
                        <div style={{ fontSize: '13px', fontWeight: 800, color: '#f1f5f9' }}>Planejamento Trimestral</div>
                        <div style={{ fontSize: '10px', color: '#64748b' }}>3º Trimestre — História — 9º Ano</div>
                      </div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '10px', color: '#3b82f6', background: 'rgba(59,130,246,0.1)', padding: '4px 10px', borderRadius: '20px', border: '1px solid rgba(59,130,246,0.2)' }}>
                        <Sparkles size={10} />
                        IA Gerando...
                      </div>
                    </div>
                    {/* AI generating card */}
                    <div style={{ background: 'rgba(59,130,246,0.08)', border: '1px solid rgba(59,130,246,0.2)', borderRadius: '12px', padding: '16px' }}>
                      <div style={{ fontSize: '11px', color: '#93c5fd', fontWeight: 700, marginBottom: '8px', display: 'flex', alignItems: 'center', gap: '6px' }}>
                        <Brain size={12} />
                        Agente RAG — Consultando BNCC...
                      </div>
                      <div style={{ height: '4px', borderRadius: '2px', background: 'rgba(59,130,246,0.15)', overflow: 'hidden', marginBottom: '10px' }}>
                        <div style={{ height: '100%', width: '72%', background: 'linear-gradient(90deg, #3b82f6, #6366f1)', borderRadius: '2px', transition: 'width 2s ease' }} />
                      </div>
                      {[
                        '✓ Habilidade EF09HI12 verificada na base',
                        '✓ Competências Gerais 1, 2 e 9 mapeadas',
                        '⟳ Gerando Sequência Didática...',
                      ].map((line, i) => (
                        <div key={i} style={{ fontSize: '10px', color: i === 2 ? '#6366f1' : '#475569', marginBottom: '4px', display: 'flex', alignItems: 'center', gap: '6px' }}>
                          <span>{line}</span>
                        </div>
                      ))}
                    </div>
                    {/* Stats row */}
                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '8px' }}>
                      {[
                        { label: 'Planos Gerados', value: '24' },
                        { label: 'Avaliações', value: '8' },
                        { label: 'PDIs Ativos', value: '3' },
                      ].map((stat) => (
                        <div key={stat.label} style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.06)', borderRadius: '10px', padding: '10px' }}>
                          <div style={{ fontSize: '18px', fontWeight: 900, color: '#f1f5f9' }}>{stat.value}</div>
                          <div style={{ fontSize: '9px', color: '#64748b', marginTop: '2px' }}>{stat.label}</div>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
              {/* Glow under card */}
              <div className="absolute -bottom-10 left-1/2 -translate-x-1/2 w-3/4 h-20 opacity-30" style={{ background: 'radial-gradient(ellipse, rgba(59,130,246,0.5) 0%, transparent 70%)', filter: 'blur(20px)' }} />
            </div>

            {/* Scroll hint */}
            <div className="mt-16 flex flex-col items-center gap-2 text-slate-600 text-xs lp-bounce">
              <span>Role para baixo</span>
              <ChevronDown size={16} />
            </div>
          </div>
        </section>

        {/* ══════════════════════════════════════════
            STATS BAND
        ══════════════════════════════════════════ */}
        <div className="lp-band py-10 px-4">
          <div className="max-w-5xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-8">
            {STATS.map((stat) => (
              <div key={stat.label} className="lp-stat-card">
                <div className="text-3xl font-black text-white mb-1">
                  {stat.value}<span className="text-blue-400 text-lg ml-1">{stat.suffix}</span>
                </div>
                <div className="text-xs text-slate-500 leading-tight">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>

        <div className="lp-divider" />

        {/* ══════════════════════════════════════════
            PROBLEMA / SOLUÇÃO
        ══════════════════════════════════════════ */}
        <section className="py-24 md:py-32 px-4 relative overflow-hidden">
          <div className="lp-orb-indigo absolute right-0 top-0 w-96 h-96 opacity-30" />
          <div className="max-w-5xl mx-auto">
            <div className="grid md:grid-cols-2 gap-16 items-center">

              {/* Left — Problema */}
              <div>
                <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest mb-6" style={{ background: 'rgba(239,68,68,0.1)', border: '1px solid rgba(239,68,68,0.2)', color: '#f87171' }}>
                  😩 A Realidade do Professor Público
                </div>
                <h2 className="font-black mb-6 leading-tight" style={{ fontSize: 'clamp(1.8rem, 4vw, 2.8rem)' }}>
                  Você virou <span style={{ color: '#f87171' }}>secretário(a)</span>,<br />
                  não professor(a).
                </h2>
                <div className="space-y-4">
                  {[
                    '4h+ toda semana formatando planos de aula',
                    'PDIs escritos à mão sem rastreabilidade',
                    'Avaliações copiadas do Google sem alinhamento BNCC',
                    'Fins de semana consumidos pela burocracia',
                    'IA genérica que inventa habilidades inexistentes',
                  ].map((item) => (
                    <div key={item} className="flex items-start gap-3">
                      <div className="w-5 h-5 rounded-full shrink-0 mt-0.5 flex items-center justify-center" style={{ background: 'rgba(239,68,68,0.15)', border: '1px solid rgba(239,68,68,0.2)' }}>
                        <X size={10} className="text-red-400" />
                      </div>
                      <span className="text-slate-400 text-sm">{item}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Right — Solução */}
              <div>
                <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest mb-6 lp-badge">
                  ✨ Com o PROFEPLAN
                </div>
                <h2 className="font-black mb-6 leading-tight" style={{ fontSize: 'clamp(1.8rem, 4vw, 2.8rem)' }}>
                  Você volta a ser<br />
                  <span className="lp-grad-text">educador(a)</span>.
                </h2>
                <div className="space-y-4">
                  {[
                    'Plano de aula completo em menos de 3 minutos',
                    'PDI vinculado ao aluno, com ética e privacidade',
                    'Avaliações criadas só do que foi ensinado',
                    'Fins de semana livres — de verdade',
                    'IA que consulta a BNCC real antes de gerar',
                  ].map((item) => (
                    <div key={item} className="flex items-start gap-3">
                      <div className="w-5 h-5 rounded-full shrink-0 mt-0.5 flex items-center justify-center" style={{ background: 'rgba(16,185,129,0.15)', border: '1px solid rgba(16,185,129,0.2)' }}>
                        <Check size={10} className="text-emerald-400" />
                      </div>
                      <span className="text-slate-300 text-sm font-medium">{item}</span>
                    </div>
                  ))}
                </div>
                <Link
                  to="/signup"
                  className="lp-btn-primary mt-8 inline-flex items-center gap-2 px-6 py-3.5 rounded-xl font-bold text-white text-sm"
                >
                  Experimentar agora <ArrowRight size={16} />
                </Link>
              </div>

            </div>
          </div>
        </section>

        <div className="lp-divider" />

        {/* ══════════════════════════════════════════
            FEATURES
        ══════════════════════════════════════════ */}
        <section id="funcionalidades" className="py-24 md:py-32 px-4 relative">
          <div className="lp-orb-blue absolute left-0 top-1/2 -translate-y-1/2 w-80 h-80 opacity-20" />

          <div className="max-w-6xl mx-auto">
            <div className="text-center mb-16">
              <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest mb-5 lp-badge">
                <Zap size={12} /> Funcionalidades
              </div>
              <h2 className="lp-section-title font-black mb-4" style={{ fontSize: 'clamp(2rem, 5vw, 3.5rem)' }}>
                Tudo que você precisa.<br />
                <span className="lp-grad-text">Nada que você não usa.</span>
              </h2>
              <p className="text-slate-400 max-w-xl mx-auto">
                Cada módulo foi desenhado com professores da rede pública. Sem distrações, sem complexidade desnecessária.
              </p>
            </div>

            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
              {FEATURES.map((feat) => (
                <div
                  key={feat.title}
                  className="lp-glass rounded-2xl p-7 flex flex-col gap-4 transition-all duration-300 group"
                  style={{ cursor: 'default' }}
                >
                  <div className="lp-icon-wrap w-12 h-12 rounded-xl flex items-center justify-center text-blue-400">
                    {feat.icon}
                  </div>
                  <div>
                    <div className="flex items-center gap-2 flex-wrap mb-2">
                      <h3 className="font-bold text-white text-base">{feat.title}</h3>
                      {feat.badge && (
                        <span className="text-[9px] font-black uppercase tracking-wider px-2 py-0.5 rounded-full" style={{ background: `${feat.badgeColor}20`, color: feat.badgeColor!, border: `1px solid ${feat.badgeColor}40` }}>
                          {feat.badge}
                        </span>
                      )}
                    </div>
                    <p className="text-slate-400 text-sm leading-relaxed">{feat.desc}</p>
                  </div>
                </div>
              ))}
            </div>

            {/* RLM differentiator */}
            <div className="mt-10 rounded-2xl p-8 md:p-10 relative overflow-hidden" style={{ background: 'linear-gradient(135deg, rgba(59,130,246,0.08) 0%, rgba(99,102,241,0.06) 100%)', border: '1px solid rgba(59,130,246,0.2)' }}>
              <div className="absolute top-0 left-0 right-0 h-px" style={{ background: 'linear-gradient(90deg, transparent, rgba(59,130,246,0.5), transparent)' }} />
              <div className="flex flex-col md:flex-row gap-6 items-start md:items-center">
                <div className="w-14 h-14 rounded-2xl flex items-center justify-center shrink-0" style={{ background: 'rgba(59,130,246,0.15)', border: '1px solid rgba(59,130,246,0.3)' }}>
                  <Brain size={28} className="text-blue-400" />
                </div>
                <div>
                  <div className="inline-flex items-center gap-1.5 text-[10px] font-black uppercase tracking-widest px-3 py-1 rounded-full mb-3 lp-badge">
                    <Shield size={10} /> Tecnologia Exclusiva — RLM
                  </div>
                  <h3 className="text-xl font-bold text-white mb-2">
                    Por que o PROFEPLAN <span className="lp-grad-text">não alucina</span>?
                  </h3>
                  <p className="text-slate-400 text-sm leading-relaxed max-w-2xl">
                    Usamos <strong className="text-slate-300">Recursive Language Models (RLM)</strong> — a IA planeja, audita e corrige o próprio trabalho antes de entregar.
                    Enquanto outras IAs "completam frases" e inventam códigos BNCC falsos, nosso sistema consulta os documentos oficiais indexados.
                    É a diferença entre um <em className="text-slate-400">estagiário criativo</em> e um{' '}
                    <strong className="text-blue-400">Coordenador Pedagógico rigoroso</strong>.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>

        <div className="lp-divider" />

        {/* ══════════════════════════════════════════
            DEMO SECTION (video/mockup)
        ══════════════════════════════════════════ */}
        <section className="py-24 px-4 relative overflow-hidden">
          <div className="max-w-5xl mx-auto text-center">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest mb-6 lp-badge">
              <BarChart size={12} /> Veja em Ação
            </div>
            <h2 className="font-black mb-4" style={{ fontSize: 'clamp(1.8rem, 4vw, 3rem)' }}>
              De zero a plano completo<br />
              <span className="lp-grad-text">em 3 minutos</span>
            </h2>
            <p className="text-slate-400 mb-10 max-w-xl mx-auto">
              Assista como o PROFEPLAN gera um Planejamento Trimestral completo, alinhado à BNCC, com referências ao livro didático.
            </p>

            {/* Video / mockup container */}
            <div
              className="relative rounded-2xl overflow-hidden mx-auto"
              style={{
                border: '1px solid rgba(59,130,246,0.2)',
                boxShadow: '0 40px 80px -20px rgba(0,0,0,0.7), 0 0 40px rgba(59,130,246,0.1)',
                background: '#0a0e1a',
              }}
            >
              <div style={{ position: 'relative', paddingBottom: '56.25%' }}>
                <video
                  className="absolute top-0 left-0 w-full h-full object-cover"
                  autoPlay
                  loop
                  muted
                  playsInline
                  preload="metadata"
                  aria-label="Demonstração do PROFEPLAN gerando planejamento de aula com IA"
                >
                  <source src="/videos/hero-animation.mp4" type="video/mp4" />
                </video>
                {/* Overlay gradient */}
                <div className="absolute inset-0 pointer-events-none" style={{ background: 'linear-gradient(to top, rgba(7,11,20,0.6) 0%, transparent 40%)' }} />
              </div>
            </div>
          </div>
        </section>

        <div className="lp-divider" />

        {/* ══════════════════════════════════════════
            TESTIMONIALS
        ══════════════════════════════════════════ */}
        <section id="depoimentos" className="py-24 md:py-32 px-4 relative overflow-hidden">
          <div className="lp-orb-violet absolute right-0 bottom-0 w-96 h-96 opacity-20" />

          <div className="max-w-6xl mx-auto">
            <div className="text-center mb-14">
              <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest mb-5 lp-badge">
                <Star size={12} /> Depoimentos
              </div>
              <h2 className="font-black mb-4" style={{ fontSize: 'clamp(2rem, 4vw, 3rem)' }}>
                Professores que <span className="lp-grad-text">recuperaram</span><br />
                o tempo deles
              </h2>
            </div>

            <div className="grid md:grid-cols-2 gap-5">
              {TESTIMONIALS.map((t) => (
                <div
                  key={t.name}
                  className="lp-glass rounded-2xl p-7 flex flex-col gap-5 transition-all duration-300"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div
                        className="w-10 h-10 rounded-full flex items-center justify-center text-sm font-black text-white"
                        style={{ background: t.avatarColor }}
                      >
                        {t.avatar}
                      </div>
                      <div>
                        <div className="font-semibold text-white text-sm">{t.name}</div>
                        <div className="text-xs text-slate-500">{t.role}</div>
                      </div>
                    </div>
                    <StarRating count={t.stars} />
                  </div>
                  <blockquote className="text-slate-400 text-sm leading-relaxed italic">
                    "{t.text}"
                  </blockquote>
                </div>
              ))}
            </div>

            {/* Trust bar */}
            <div className="mt-12 flex flex-wrap items-center justify-center gap-8 text-xs text-slate-600">
              {[
                { icon: <Shield size={14} />, text: 'LGPD Compliant' },
                { icon: <Award size={14} />, text: 'Registro INPI' },
                { icon: <GraduationCap size={14} />, text: 'BNCC Verificada' },
                { icon: <Zap size={14} />, text: 'Azure OpenAI' },
              ].map(({ icon, text }) => (
                <div key={text} className="flex items-center gap-2 text-slate-500">
                  <span className="text-blue-500">{icon}</span>
                  {text}
                </div>
              ))}
            </div>
          </div>
        </section>

        <div className="lp-divider" />

        {/* ══════════════════════════════════════════
            PRICING
        ══════════════════════════════════════════ */}
        <section id="planos" className="py-24 md:py-32 px-4 relative overflow-hidden">
          <div className="lp-orb-blue absolute left-1/2 -translate-x-1/2 top-0 w-full h-80 opacity-10" />

          <div className="max-w-6xl mx-auto">
            <div className="text-center mb-14">
              <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest mb-5 lp-badge">
                <Sparkles size={12} /> Planos
              </div>
              <h2 className="font-black mb-4" style={{ fontSize: 'clamp(2rem, 4vw, 3rem)' }}>
                Comece grátis.<br />
                <span className="lp-grad-text">Evolua conforme sua demanda.</span>
              </h2>
              <p className="text-slate-400 max-w-lg mx-auto">
                Cada crédito = 1 operação de IA (plano de aula, avaliação, PDI, etc.)
              </p>
            </div>

            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-5 items-stretch">

              {/* FREE */}
              <div className="lp-glass lp-plan-free rounded-2xl p-6 flex flex-col gap-5">
                <div>
                  <div className="w-12 h-12 rounded-xl overflow-hidden mb-4" style={{ background: 'rgba(59,130,246,0.1)' }}>
                    <img src="/logo-blue.png" alt="PROFEPLAN FREE" className="w-full h-full object-contain p-2" />
                  </div>
                  <div className="text-xs font-black uppercase tracking-widest text-slate-500 mb-1">Gratuito</div>
                  <div className="text-3xl font-black text-white mb-1">R$ 0</div>
                  <div className="text-xs text-slate-500">Para sempre — sem cartão</div>
                </div>
                <div className="space-y-2.5 flex-1">
                  {[
                    '10 créditos de boas-vindas',
                    'Planos de Aula básicos',
                    'Avaliações simples',
                    'Exportação em PDF',
                    'Suporte por e-mail',
                  ].map((f) => (
                    <div key={f} className="flex items-start gap-2 text-xs text-slate-400">
                      <Check size={12} className="text-emerald-400 shrink-0 mt-0.5" />
                      {f}
                    </div>
                  ))}
                </div>
                <Link to="/signup" className="lp-btn-ghost block text-center py-3 rounded-xl text-sm font-bold text-slate-300">
                  Começar Grátis
                </Link>
              </div>

              {/* SILVER */}
              <div className="lp-glass lp-plan-silver rounded-2xl p-6 flex flex-col gap-5">
                <div>
                  <div className="w-12 h-12 rounded-xl overflow-hidden mb-4">
                    <img src="/PROFEPLAN SILVER.jpg" alt="PROFEPLAN SILVER" className="w-full h-full object-cover" />
                  </div>
                  <div className="text-xs font-black uppercase tracking-widest mb-1" style={{ color: '#94a3b8' }}>Silver — Pré-pago</div>
                  <div className="text-3xl font-black text-white mb-1">R$ 30<span className="text-base font-medium text-slate-400">,00</span></div>
                  <div className="text-xs text-slate-500">Pacote único · 50 créditos</div>
                </div>
                <div className="space-y-2.5 flex-1">
                  {[
                    '50 créditos sem prazo de validade',
                    'Planejamento Trimestral',
                    'PDI com perfil do aluno',
                    'Avaliações com versão A/B',
                    'Multi-Escola (2º cargo)',
                    'Exportação PDF personalizada',
                  ].map((f) => (
                    <div key={f} className="flex items-start gap-2 text-xs text-slate-400">
                      <Check size={12} className="shrink-0 mt-0.5" style={{ color: '#94a3b8' }} />
                      {f}
                    </div>
                  ))}
                </div>
                <Link to="/signup?plan=silver" className="block text-center py-3 rounded-xl text-sm font-bold text-white transition-all" style={{ background: 'rgba(148,163,184,0.15)', border: '1px solid rgba(148,163,184,0.3)' }}>
                  Comprar Silver
                </Link>
              </div>

              {/* GOLD — FEATURED */}
              <div className="lp-pricing-featured rounded-2xl p-6 flex flex-col gap-5 relative overflow-hidden">
                <div className="absolute top-4 right-4 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full" style={{ background: 'rgba(245,158,11,0.15)', border: '1px solid rgba(245,158,11,0.4)', color: '#fbbf24' }}>
                  ⭐ Mais Popular
                </div>
                <div>
                  <div className="w-12 h-12 rounded-xl overflow-hidden mb-4 lp-animate-glow">
                    <img src="/PROFEPLAN GOLD.jpg" alt="PROFEPLAN GOLD" className="w-full h-full object-cover" />
                  </div>
                  <div className="text-xs font-black uppercase tracking-widest mb-1 lp-grad-text-gold">Gold — Assinatura</div>
                  <div className="text-3xl font-black text-white mb-1">R$ 50<span className="text-base font-medium text-slate-400">/mês</span></div>
                  <div className="text-xs text-slate-500">120 créditos mensais renovados</div>
                </div>
                <div className="space-y-2.5 flex-1">
                  {[
                    '120 créditos/mês (renovação automática)',
                    'Tudo do Silver +',
                    'Planejamento com IA Multi-Agentes',
                    'Planejamento com IA Multi-Agentes (BNCC + Currículo MG)',
                    'Simulados ENEM/SAEB (17k questões)',
                    'Integração com Livro PNLD',
                    'Suporte prioritário',
                  ].map((f) => (
                    <div key={f} className="flex items-start gap-2 text-xs text-slate-300">
                      <Check size={12} className="text-yellow-400 shrink-0 mt-0.5" />
                      {f}
                    </div>
                  ))}
                </div>
                <Link
                  to="/signup?plan=gold"
                  className="lp-btn-primary block text-center py-3.5 rounded-xl text-sm font-bold text-white"
                >
                  Assinar Gold
                </Link>
              </div>

              {/* B2B / B2G */}
              <div className="lp-glass lp-plan-b2b rounded-2xl p-6 flex flex-col gap-5">
                <div>
                  <div className="w-12 h-12 rounded-xl flex items-center justify-center mb-4" style={{ background: 'rgba(139,92,246,0.15)', border: '1px solid rgba(139,92,246,0.3)' }}>
                    <Building2 size={22} className="text-violet-400" />
                  </div>
                  <div className="text-xs font-black uppercase tracking-widest mb-1 text-violet-400">Escola / Governo</div>
                  <div className="text-3xl font-black text-white mb-1">Sob consulta</div>
                  <div className="text-xs text-slate-500">B2B · B2G · ODS/ONU</div>
                </div>
                <div className="space-y-2.5 flex-1">
                  {[
                    'Pool de créditos para toda a escola',
                    'Dashboard do gestor centralizado',
                    'RAG com material didático próprio',
                    'Integração SIMADE/SIGAE',
                    'Suporte dedicado e SLA',
                    'Conformidade LGPD documentada',
                  ].map((f) => (
                    <div key={f} className="flex items-start gap-2 text-xs text-slate-400">
                      <Check size={12} className="text-violet-400 shrink-0 mt-0.5" />
                      {f}
                    </div>
                  ))}
                </div>
                <a
                  href="#contato"
                  className="block text-center py-3 rounded-xl text-sm font-bold transition-all"
                  style={{ background: 'rgba(139,92,246,0.12)', border: '1px solid rgba(139,92,246,0.3)', color: '#a78bfa' }}
                >
                  Falar com Comercial
                </a>
              </div>

            </div>

            {/* Guarantee note */}
            <p className="text-center text-xs text-slate-600 mt-8 flex items-center justify-center gap-2">
              <Shield size={12} className="text-slate-500" />
              Pagamentos seguros · Silver é compra única sem prazo de validade · Gold cancelável a qualquer momento
            </p>
          </div>
        </section>

        <div className="lp-divider" />

        {/* ══════════════════════════════════════════
            FAQ
        ══════════════════════════════════════════ */}
        <section id="faq" className="py-24 md:py-32 px-4">
          <div className="max-w-2xl mx-auto">
            <div className="text-center mb-12">
              <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest mb-5 lp-badge">
                Dúvidas Frequentes
              </div>
              <h2 className="font-black" style={{ fontSize: 'clamp(1.8rem, 4vw, 2.8rem)' }}>
                Perguntas & <span className="lp-grad-text">Respostas</span>
              </h2>
            </div>
            <div>
              {FAQS.map((faq) => (
                <FaqItem key={faq.q} q={faq.q} a={faq.a} />
              ))}
            </div>
          </div>
        </section>

        <div className="lp-divider" />

        {/* ══════════════════════════════════════════
            CTA FINAL
        ══════════════════════════════════════════ */}
        <section className="py-24 md:py-32 px-4 relative overflow-hidden">
          <div className="lp-orb-blue absolute inset-0 opacity-20" />
          <div className="relative max-w-3xl mx-auto text-center">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest mb-6 lp-badge">
              <Sparkles size={12} /> Comece Hoje
            </div>
            <h2 className="font-black mb-6 leading-tight" style={{ fontSize: 'clamp(2.2rem, 5vw, 4rem)' }}>
              Pronto para transformar<br />
              sua <span className="lp-shimmer-text">prática pedagógica</span>?
            </h2>
            <p className="text-slate-400 mb-10 text-lg max-w-xl mx-auto">
              Junte-se a professores que estão recuperando horas da vida — e entregando planejamentos melhores.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link
                to="/signup"
                className="lp-btn-primary flex items-center gap-2 px-10 py-4 rounded-xl font-bold text-white text-base w-full sm:w-auto justify-center"
              >
                <GraduationCap size={20} />
                Começar Gratuitamente
              </Link>
              <a
                href="#planos"
                className="lp-btn-ghost flex items-center gap-2 px-8 py-4 rounded-xl font-semibold text-slate-400 text-base w-full sm:w-auto justify-center"
              >
                Ver planos <ArrowRight size={16} />
              </a>
            </div>
            <p className="mt-5 text-xs text-slate-600">
              Sem cartão de crédito · 10 créditos grátis · Cancele quando quiser
            </p>
          </div>
        </section>

        {/* ══════════════════════════════════════════
            FOOTER
        ══════════════════════════════════════════ */}
        <footer id="contato" style={{ background: '#040710', borderTop: '1px solid rgba(255,255,255,0.05)' }}>
          <div className="max-w-7xl mx-auto px-4 py-16">
            <div className="grid md:grid-cols-4 gap-10 mb-12">
              {/* Brand */}
              <div className="md:col-span-1">
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-8 h-8 rounded-xl overflow-hidden">
                    <img src="/logo-blue.png" alt="PROFEPLAN" className="w-full h-full object-contain" />
                  </div>
                  <div>
                    <div className="text-sm font-black text-white">PROFEPLAN</div>
                    <div className="text-[9px] font-medium text-blue-400 tracking-widest uppercase">by WR Tech AI</div>
                  </div>
                </div>
                <p className="text-xs text-slate-600 leading-relaxed mb-4">
                  A plataforma de Engenharia Pedagógica com IA para professores e gestores da educação básica brasileira.
                </p>
                <div className="flex items-center gap-2">
                  <img
                    src="/LOGO WR.jpeg"
                    alt="WR Tech AI"
                    className="h-6 opacity-50 hover:opacity-80 transition-opacity rounded"
                    onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
                  />
                </div>
              </div>

              {/* Links */}
              <div>
                <h4 className="text-xs font-black uppercase tracking-widest text-slate-500 mb-4">Produto</h4>
                <ul className="space-y-2.5">
                  {[
                    { label: 'Funcionalidades', href: '#funcionalidades' },
                    { label: 'Planos & Preços', href: '#planos' },
                    { label: 'Depoimentos', href: '#depoimentos' },
                    { label: 'FAQ', href: '#faq' },
                  ].map(l => (
                    <li key={l.href}>
                      <a href={l.href} className="text-sm text-slate-500 hover:text-slate-300 transition-colors">{l.label}</a>
                    </li>
                  ))}
                </ul>
              </div>

              <div>
                <h4 className="text-xs font-black uppercase tracking-widest text-slate-500 mb-4">Acesso</h4>
                <ul className="space-y-2.5">
                  {[
                    { label: 'Entrar', href: '/login' },
                    { label: 'Criar Conta', href: '/signup' },
                    { label: 'Plano Silver', href: '/signup?plan=silver' },
                    { label: 'Plano Gold', href: '/signup?plan=gold' },
                  ].map(l => (
                    <li key={l.href}>
                      <Link to={l.href} className="text-sm text-slate-500 hover:text-slate-300 transition-colors">{l.label}</Link>
                    </li>
                  ))}
                </ul>
              </div>

              <div>
                <h4 className="text-xs font-black uppercase tracking-widest text-slate-500 mb-4">Legal & Contato</h4>
                <ul className="space-y-2.5">
                  {[
                    { label: 'Política de Privacidade', href: '/privacy' },
                    { label: 'Termos de Uso', href: '/terms' },
                  ].map(l => (
                    <li key={l.href}>
                      <Link to={l.href} className="text-sm text-slate-500 hover:text-slate-300 transition-colors">{l.label}</Link>
                    </li>
                  ))}
                </ul>
                <div className="mt-6">
                  <h4 className="text-xs font-black uppercase tracking-widest text-slate-500 mb-3">Comercial B2B/B2G</h4>
                  <a
                    href="mailto:contato@wrtech-ai.com"
                    className="text-sm text-blue-400 hover:text-blue-300 transition-colors"
                  >
                    contato@wrtech-ai.com
                  </a>
                </div>
              </div>
            </div>

            <div className="lp-divider mb-8" />

            <div className="flex flex-col md:flex-row items-center justify-between gap-4">
              <p className="text-xs text-slate-700">
                © 2026 PROFEPLAN · WR Tech AI. Todos os direitos reservados. v5.0.0
              </p>
              <div className="flex items-center gap-4 text-xs text-slate-700">
                <span className="flex items-center gap-1.5">
                  <Shield size={11} className="text-slate-600" /> LGPD Compliant
                </span>
                <span>·</span>
                <span className="flex items-center gap-1.5">
                  <Award size={11} className="text-slate-600" /> Registro INPI
                </span>
                <span>·</span>
                <span>Powered by Azure OpenAI</span>
              </div>
            </div>
          </div>
        </footer>

      </div>
    </>
  );
};

export default LandingPage;
