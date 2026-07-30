import React from 'react';
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

function App() {
  return (
    <main>
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
            <a
              className="button primary"
              href={`${APP_URL}/signup`}
            >
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
        <a
          className="button primary"
          href={`${APP_URL}/signup`}
        >
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
