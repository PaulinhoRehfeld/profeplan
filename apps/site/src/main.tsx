import React, { useEffect, useRef, useState } from 'react';
import { createRoot } from 'react-dom/client';
import {
  ArrowRight,
  BookOpen,
  Brain,
  CalendarRange,
  CheckCircle2,
  ClipboardList,
  FileCheck2,
  GraduationCap,
  Layers3,
  LockKeyhole,
  MessageCircleQuestion,
  PenLine,
  Presentation,
  ShieldCheck,
  Sparkles,
  Users,
} from 'lucide-react';
import './styles.css';

const APP_URL = 'https://app.profeplan.com.br';
const CONTACT_EMAIL = 'suporte@profeplan.com.br';
const SILVER_PURCHASE_URL = `${APP_URL}/signup?plan=silver`;
const SILVER_PROMOTION_CODE = 'TEST_DRIVE';
const GOLD_PURCHASE_URL = `${APP_URL}/signup?plan=gold`;

const legalLinks = [
  { label: 'Política de Privacidade', href: `${APP_URL}/politica-de-privacidade` },
  { label: 'Termos de Uso', href: `${APP_URL}/termos-de-uso` },
  { label: 'Política de Cookies', href: `${APP_URL}/politica-de-cookies` },
  { label: 'Direitos do Titular', href: `${APP_URL}/direitos-do-titular` },
  { label: 'Dados Educacionais', href: `${APP_URL}/dados-educacionais` },
  { label: 'Cancelamento e Reembolso', href: `${APP_URL}/cancelamento-e-reembolso` },
  { label: 'Transparência em IA', href: `${APP_URL}/transparencia-em-ia` },
  { label: 'Segurança e LGPD', href: `${APP_URL}/seguranca-e-lgpd` },
] as const;

const features = [
  {
    icon: CalendarRange,
    title: 'Planejamento trimestral',
    text: 'Apoio para estruturar planejamentos por etapa, componente curricular e objetivos pedagógicos.',
  },
  {
    icon: BookOpen,
    title: 'Planos de aula',
    text: 'Organização de objetivos, metodologia, recursos e avaliação em um rascunho editável pelo professor.',
  },
  {
    icon: FileCheck2,
    title: 'Avaliações',
    text: 'Apoio à elaboração de questões, gabaritos e instrumentos de avaliação com revisão docente.',
  },
  {
    icon: Brain,
    title: 'Assistente pedagógico',
    text: 'Um espaço para tirar dúvidas, organizar ideias e refinar conteúdos pedagógicos com IA.',
  },
  {
    icon: Presentation,
    title: 'Apresentações',
    text: 'Apoio à criação de materiais visuais e apresentações pedagógicas editáveis.',
  },
  {
    icon: ShieldCheck,
    title: 'IA responsável',
    text: 'Uso com supervisão humana, proteção de dados e respeito à autoria pedagógica.',
  },
];

const workflow = [
  'Configure seu contexto pedagógico',
  'Escolha o tipo de apoio necessário',
  'Gere um rascunho com IA',
  'Revise, adapte e finalize',
  'Use o material com sua decisão pedagógica',
];

const safety = [
  'O professor continua no centro da decisão pedagógica.',
  'Todo conteúdo gerado deve ser revisado antes do uso.',
  'Demonstrações públicas devem usar dados fictícios.',
  'Dados de estudantes, diagnósticos e laudos exigem cuidado máximo.',
];

function PromotionModal() {
  const [isOpen, setIsOpen] = useState(true);
  const dialogRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!isOpen) return;

    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    dialogRef.current?.focus();

    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setIsOpen(false);
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => {
      document.body.style.overflow = previousOverflow;
      document.removeEventListener('keydown', handleKeyDown);
    };
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div
      className="promotion-backdrop"
      role="presentation"
      onMouseDown={(event) => {
        if (event.target === event.currentTarget) setIsOpen(false);
      }}
    >
      <div
        ref={dialogRef}
        className="promotion-dialog"
        role="dialog"
        aria-modal="true"
        aria-labelledby="promotion-title"
        aria-describedby="promotion-description"
        tabIndex={-1}
        style={{
          width: 'min(94vw, 900px)',
          maxHeight: '92vh',
          aspectRatio: 'auto',
          overflowY: 'auto',
          padding: 'clamp(1.5rem, 4vw, 2.75rem)',
          background: '#ffffff',
          color: '#0b2338',
        }}
      >
        <button
          type="button"
          className="promotion-close"
          aria-label="Fechar oferta"
          onClick={() => setIsOpen(false)}
          style={{
            top: '1rem',
            right: '1rem',
            width: '2.75rem',
            height: '2.75rem',
            display: 'grid',
            placeItems: 'center',
            background: '#eef7fb',
            color: '#0b3551',
            fontSize: '1.6rem',
            fontWeight: 700,
            lineHeight: 1,
          }}
        >
          ×
        </button>

        <span className="eyebrow">Oferta especial de agosto</span>
        <h2
          id="promotion-title"
          style={{
            margin: '1rem 3.5rem 0.75rem 0',
            fontSize: 'clamp(2rem, 6vw, 3.5rem)',
            lineHeight: 0.98,
            letterSpacing: '-0.06em',
          }}
        >
          Escolha a forma de usar o ProfePlan.
        </h2>
        <p
          id="promotion-description"
          style={{ margin: '0 0 1.5rem', color: '#557086', lineHeight: 1.65 }}
        >
          As condições abaixo refletem os preços e descontos atualmente configurados na Stripe.
        </p>

        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
            gap: '1rem',
          }}
        >
          <a
            href={SILVER_PURCHASE_URL}
            aria-label={`Continuar para o ProfePlan Silver: crie ou acesse sua conta antes do checkout. 40 créditos, pagamento único; primeira compra por R$ 40,00 usando o código ${SILVER_PROMOTION_CODE}; preço regular R$ 50,00.`}
            style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '0.65rem',
              padding: '1.4rem',
              border: '1px solid #bfdbfe',
              borderRadius: '1.25rem',
              background: '#eff6ff',
            }}
          >
            <span style={{ color: '#2563eb', fontWeight: 900, letterSpacing: '0.04em' }}>
              PROFEPLAN SILVER
            </span>
            <strong style={{ fontSize: 'clamp(2rem, 6vw, 3rem)', color: '#1d4ed8' }}>
              R$ 40,00
            </strong>
            <span style={{ color: '#476478', fontWeight: 750 }}>
              primeira compra · pagamento único
            </span>
            <span style={{ color: '#557086', lineHeight: 1.5 }}>
              40 créditos. Preço regular: R$ 50,00.
            </span>
            <span
              style={{
                marginTop: 'auto',
                paddingTop: '0.6rem',
                color: '#1d4ed8',
                fontWeight: 850,
              }}
            >
              Criar conta e continuar →
            </span>
          </a>

          <a
            href={GOLD_PURCHASE_URL}
            aria-label="Continuar para o ProfePlan Gold: crie ou acesse sua conta antes do checkout. R$ 37,50 ao mês durante 6 meses; depois R$ 50,00 ao mês."
            style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '0.65rem',
              padding: '1.4rem',
              border: '1px solid #f59e0b',
              borderRadius: '1.25rem',
              background: '#fffbeb',
            }}
          >
            <span style={{ color: '#b45309', fontWeight: 900, letterSpacing: '0.04em' }}>
              PROFEPLAN GOLD
            </span>
            <strong style={{ fontSize: 'clamp(2rem, 6vw, 3rem)', color: '#b45309' }}>
              R$ 37,50/mês
            </strong>
            <span style={{ color: '#6b4f1d', fontWeight: 750 }}>por 6 meses</span>
            <span style={{ color: '#6b5b3e', lineHeight: 1.5 }}>
              Assinatura mensal. Depois, R$ 50,00/mês.
            </span>
            <span
              style={{
                marginTop: 'auto',
                paddingTop: '0.6rem',
                color: '#b45309',
                fontWeight: 850,
              }}
            >
              Criar conta e continuar →
            </span>
          </a>
        </div>

        <p
          style={{ margin: '1.25rem 0 0', color: '#6b8294', fontSize: '0.82rem', lineHeight: 1.6 }}
        >
          Silver: desconto de R$ 10,00 restrito à primeira transação. Gold: 25% de desconto por 6
          meses. Primeiro você cria ou acessa sua conta ProfePlan; depois, o valor final é
          confirmado no checkout seguro da Stripe.
        </p>
      </div>
    </div>
  );
}

function App() {
  return (
    <main>
      <PromotionModal />
      <header className="nav">
        <a className="brand" href="#top" aria-label="ProfePlan">
          <img className="brand-logo" src="/branding/LOGO%20PROFEPLAN%20SEM%20FUNDO.png" alt="" />
          <span>
            <strong>ProfePlan</strong>
            <small>uma solução WRTech AI</small>
          </span>
        </a>
        <nav aria-label="Navegação principal">
          <a className="nav-section-link" href="#recursos">
            Recursos
          </a>
          <a className="nav-section-link" href="#como-funciona">
            Como funciona
          </a>
          <a className="nav-section-link" href="#seguranca">
            IA responsável
          </a>
          <a href={`${APP_URL}/login`} className="nav-login">
            Acessar plataforma
          </a>
          <a href={`${APP_URL}/signup`} className="nav-cta">
            Teste grátis
          </a>
        </nav>
      </header>

      <section id="top" className="hero section-shell">
        <div className="hero-copy">
          <div className="eyebrow">
            <Sparkles size={16} /> Inteligência Artificial para a Educação Básica
          </div>
          <h1>Menos burocracia, mais tempo para ensinar.</h1>
          <p className="hero-lead">
            O ProfePlan apoia professores da Educação Básica na organização de planejamentos, planos
            de aula, avaliações e rotina pedagógica com Inteligência Artificial — sempre com revisão
            e decisão do professor.
          </p>
          <div className="hero-actions">
            <a className="button primary" href={`${APP_URL}/signup`}>
              Teste grátis <ArrowRight size={18} />
            </a>
          </div>
          <div className="trust-row" aria-label="Princípios do ProfePlan">
            <span>
              <CheckCircle2 size={16} /> Professor no centro
            </span>
            <span>
              <LockKeyhole size={16} /> Dados protegidos
            </span>
            <span>
              <Layers3 size={16} /> Fluxo pedagógico
            </span>
          </div>
        </div>

        <div className="hero-panel" aria-label="Exemplo visual fictício do ProfePlan">
          <div className="browser-bar">
            <span /> <span /> <span />
            <small>profeplan.com.br</small>
          </div>
          <div className="mock-dashboard">
            <aside>
              <div className="mini-logo">
                <img src="/branding/LOGO%20PROFEPLAN%20SEM%20FUNDO.png" alt="ProfePlan" />
              </div>
              {[CalendarRange, BookOpen, FileCheck2, Brain].map((Icon, index) => (
                <div className="side-icon" key={index}>
                  <Icon size={18} />
                </div>
              ))}
            </aside>
            <div className="mock-content">
              <span className="demo-badge">dados fictícios</span>
              <h2>Organize sua rotina pedagógica</h2>
              <p>Planejamento, aula, avaliação e acompanhamento em um fluxo mais claro.</p>
              <div className="mock-grid">
                <div>
                  <CalendarRange size={22} />
                  <strong>Planejamento</strong>
                  <small>Trimestral</small>
                </div>
                <div>
                  <PenLine size={22} />
                  <strong>Plano de aula</strong>
                  <small>Editável</small>
                </div>
                <div>
                  <ClipboardList size={22} />
                  <strong>Avaliação</strong>
                  <small>Com revisão</small>
                </div>
                <div>
                  <MessageCircleQuestion size={22} />
                  <strong>Assistente</strong>
                  <small>IA de apoio</small>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="pain section-shell">
        <div className="section-heading">
          <span className="eyebrow">Dor real</span>
          <h2>O professor não precisa enfrentar sozinho toda a burocracia escolar.</h2>
          <p>
            Planejamentos, avaliações, registros, relatórios e adaptações fazem parte da rotina. O
            problema é quando tudo fica fragmentado, repetitivo e difícil de organizar.
          </p>
        </div>
        <div className="pain-grid">
          {[
            'Planejamento fora do horário',
            'Registros e relatórios',
            'Avaliações e gabaritos',
            'Adaptações pedagógicas',
          ].map((item) => (
            <article key={item}>
              <CheckCircle2 size={20} />
              <span>{item}</span>
            </article>
          ))}
        </div>
      </section>

      <section id="recursos" className="features section-shell">
        <div className="section-heading">
          <span className="eyebrow">Recursos</span>
          <h2>Uma plataforma para organizar etapas reais da rotina pedagógica.</h2>
          <p>
            Cada recurso foi pensado como apoio ao trabalho docente. A tecnologia ajuda a
            estruturar; o professor revisa, adapta e decide.
          </p>
        </div>
        <div className="feature-grid">
          {features.map(({ icon: Icon, title, text }) => (
            <article className="feature-card" key={title}>
              <Icon size={26} />
              <h3>{title}</h3>
              <p>{text}</p>
            </article>
          ))}
        </div>
      </section>

      <section id="como-funciona" className="workflow section-shell">
        <div className="section-heading left">
          <span className="eyebrow">Como funciona</span>
          <h2>Do planejamento à aula: um fluxo mais organizado.</h2>
          <p>
            O ProfePlan apoia a criação de rascunhos e estruturas pedagógicas. A versão final sempre
            passa pela leitura, adaptação e decisão do professor.
          </p>
        </div>
        <ol className="workflow-list">
          {workflow.map((item, index) => (
            <li key={item}>
              <span>{String(index + 1).padStart(2, '0')}</span>
              <p>{item}</p>
            </li>
          ))}
        </ol>
      </section>

      <section id="seguranca" className="safety section-shell">
        <div className="safety-card">
          <div>
            <span className="eyebrow">IA responsável</span>
            <h2>Inteligência Artificial a serviço do professor.</h2>
            <p>
              O ProfePlan não substitui o professor. Ele apoia a organização do trabalho pedagógico
              com cuidado, clareza e supervisão humana.
            </p>
          </div>
          <ul>
            {safety.map((item) => (
              <li key={item}>
                <ShieldCheck size={18} /> {item}
              </li>
            ))}
          </ul>
        </div>
      </section>

      <section className="audience section-shell">
        <div className="section-heading">
          <span className="eyebrow">Para quem é</span>
          <h2>Criado para professores da Educação Básica brasileira.</h2>
          <p>
            O ProfePlan atende professores da Educação Básica. Na primeira fase de comunicação e
            aquisição, há prioridade para professores dos anos finais do Ensino Fundamental e do
            Ensino Médio.
          </p>
        </div>
        <div className="audience-grid">
          <article>
            <GraduationCap size={24} /> Professores
          </article>
          <article>
            <Users size={24} /> Coordenadores
          </article>
          <article>
            <ShieldCheck size={24} /> Inclusão e apoio
          </article>
          <article>
            <ClipboardList size={24} /> Gestão pedagógica
          </article>
        </div>
      </section>

      <section className="final-cta section-shell">
        <h2>Pronto para testar o ProfePlan?</h2>
        <p>
          Crie sua conta gratuitamente e veja como a plataforma pode apoiar a organização do
          trabalho pedagógico com IA responsável.
        </p>
        <a className="button primary" href={`${APP_URL}/signup`}>
          Teste grátis <ArrowRight size={18} />
        </a>
      </section>

      <footer className="footer">
        <div className="footer-grid">
          <div className="footer-company">
            <img
              className="wrtech-logo"
              src="/branding/LOGO%20COMPLETO.jpeg"
              alt="WRTech — Tecnologia e Performance"
            />
            <p>Planejamento pedagógico com inteligência artificial para professores.</p>
            <p>
              Produto digital desenvolvido e operado por:
              <br />
              <strong>WR TECH INOVA SIMPLES (I.S.)</strong>
              <br />
              CNPJ 65.458.067/0001-10
              <br />
              Rua Varginha, nº 92, Bairro Planalto
              <br />
              Capelinha — MG — CEP 39682-036 — Brasil
            </p>
            <a href={`mailto:${CONTACT_EMAIL}`}>{CONTACT_EMAIL}</a>
          </div>

          <nav aria-label="Privacidade e documentos legais">
            <strong>Privacidade e Legal</strong>
            <ul>
              {legalLinks.map((link) => (
                <li key={link.href}>
                  <a href={link.href}>{link.label}</a>
                </li>
              ))}
            </ul>
          </nav>

          <nav aria-label="Acesso à plataforma">
            <strong>Acesso</strong>
            <ul>
              <li>
                <a href={`${APP_URL}/login`}>Login</a>
              </li>
              <li>
                <a href={`${APP_URL}/signup`}>Criar conta</a>
              </li>
            </ul>
          </nav>
        </div>

        <div className="footer-bottom">
          <span>
            © 2026 ProfePlan — WR TECH INOVA SIMPLES (I.S.). Todos os direitos reservados.
          </span>
          <span>uma solução WRTech AI</span>
        </div>
      </footer>
    </main>
  );
}

createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
