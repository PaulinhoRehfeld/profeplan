import React from 'react';
import {
  MessageSquare,
  CalendarRange,
  LayoutDashboard,
  Accessibility,
  FileText,
  Projector,
  ClipboardCheck,
  FolderClosed,
  BookOpen,
  LibraryBig,
  Users,
  ArrowRight,
} from 'lucide-react';
import { ToolMode, UserProfile, UserSession } from '../../types';

interface HomePageProps {
  setActiveMode: (mode: ToolMode) => void;
  userProfile: UserProfile | null;
  session: UserSession;
}

interface NavCard {
  mode: ToolMode;
  icon: React.ElementType;
  title: string;
  description: string;
  iconColor: string;
  iconBg: string;
  gradient: string;
}

const HomePage: React.FC<HomePageProps> = ({ setActiveMode, userProfile, session }) => {
  const firstName = (userProfile?.full_name || session.email || '').split(' ')[0] || 'Professor';

  const isAdminOrManager =
    userProfile?.is_admin || userProfile?.role === 'admin' || userProfile?.role === 'manager';

  const planningCards: NavCard[] = [
    {
      mode: ToolMode.QUARTERLY_PLANNING,
      icon: CalendarRange,
      title: 'Planejamento Trimestral',
      description: 'Organize objetivos e conteúdos por trimestre letivo',
      iconColor: 'text-indigo-600',
      iconBg: 'bg-indigo-100',
      gradient: 'from-indigo-50/80 to-white',
    },
    {
      mode: ToolMode.PLANNING,
      icon: LayoutDashboard,
      title: 'Planos de Aula',
      description: 'Crie e personalize planos de aula com IA',
      iconColor: 'text-violet-600',
      iconBg: 'bg-violet-100',
      gradient: 'from-violet-50/80 to-white',
    },
  ];

  const contentCards: NavCard[] = [
    {
      mode: ToolMode.INCLUSION,
      icon: Accessibility,
      title: 'Adaptações PDI/DUA',
      description: 'Gere adaptações pedagógicas individualizadas',
      iconColor: 'text-emerald-600',
      iconBg: 'bg-emerald-100',
      gradient: 'from-emerald-50/80 to-white',
    },
    {
      mode: ToolMode.SIMULATION,
      icon: FileText,
      title: 'Simulados ENEM/Saeb',
      description: 'Crie simulados contextualizados ao currículo',
      iconColor: 'text-teal-600',
      iconBg: 'bg-teal-100',
      gradient: 'from-teal-50/80 to-white',
    },
    {
      mode: ToolMode.PRESENTATIONS,
      icon: Projector,
      title: 'Apresentações & Slides',
      description: 'Gere slides prontos para suas aulas',
      iconColor: 'text-cyan-600',
      iconBg: 'bg-cyan-100',
      gradient: 'from-cyan-50/80 to-white',
    },
    {
      mode: ToolMode.ASSESSMENT,
      icon: ClipboardCheck,
      title: 'Avaliações Contextualizadas',
      description: 'Avaliações com feedback automático',
      iconColor: 'text-sky-600',
      iconBg: 'bg-sky-100',
      gradient: 'from-sky-50/80 to-white',
    },
  ];

  const managementCards: NavCard[] = [
    {
      mode: ToolMode.FILES,
      icon: FolderClosed,
      title: 'Meus Arquivos',
      description: 'Armazene e organize seus materiais',
      iconColor: 'text-amber-600',
      iconBg: 'bg-amber-100',
      gradient: 'from-amber-50/80 to-white',
    },
    {
      mode: ToolMode.CLASSES,
      icon: BookOpen,
      title: 'Minhas Turmas',
      description: 'Gerencie turmas, alunos e chamadas',
      iconColor: 'text-orange-600',
      iconBg: 'bg-orange-100',
      gradient: 'from-orange-50/80 to-white',
    },
    {
      mode: ToolMode.MY_DOCUMENTS,
      icon: LibraryBig,
      title: 'Meus Documentos',
      description: 'Documentos gerados e histórico de trabalho',
      iconColor: 'text-rose-600',
      iconBg: 'bg-rose-100',
      gradient: 'from-rose-50/80 to-white',
    },
    ...(isAdminOrManager
      ? [
          {
            mode: ToolMode.SCHOOL_MANAGER,
            icon: Users,
            title: 'Gestão Escolar',
            description: 'Painel de gestão e relatórios da escola',
            iconColor: 'text-purple-600',
            iconBg: 'bg-purple-100',
            gradient: 'from-purple-50/80 to-white',
          } as NavCard,
        ]
      : []),
  ];

  const SectionLabel = ({ children }: { children: React.ReactNode }) => (
    <p className="text-[10px] font-black uppercase tracking-[0.25em] text-slate-400 mb-4 px-0.5">
      {children}
    </p>
  );

  const Card = ({ card }: { card: NavCard }) => (
    <button
      onClick={() => setActiveMode(card.mode)}
      className={`flex flex-col gap-4 p-5 rounded-2xl bg-gradient-to-br ${card.gradient} border border-slate-100 hover:border-slate-200 hover:shadow-lg hover:-translate-y-1 transition-all duration-200 text-left group w-full`}
    >
      <div
        className={`w-11 h-11 rounded-xl ${card.iconBg} flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform duration-200`}
      >
        <card.icon className={`w-5 h-5 ${card.iconColor}`} />
      </div>
      <div>
        <p className="text-sm font-bold text-slate-800 leading-tight">{card.title}</p>
        <p className="text-xs text-slate-500 mt-1 leading-relaxed">{card.description}</p>
      </div>
    </button>
  );

  return (
    <div className="flex-1 overflow-y-auto bg-slate-50 custom-scrollbar">
      <div className="max-w-3xl mx-auto px-4 md:px-8 pt-8 pb-14">
        {/* Cabeçalho */}
        <div className="mb-8">
          <h1 className="text-2xl font-black text-slate-900 tracking-tight">Olá, {firstName}!</h1>
          <p className="text-sm text-slate-500 mt-1">O que vamos fazer hoje?</p>
        </div>

        <div className="space-y-9">
          {/* Hero — Assistente */}
          <div>
            <SectionLabel>Assistente</SectionLabel>
            <button
              onClick={() => setActiveMode(ToolMode.CHAT)}
              className="w-full flex items-center gap-5 p-6 rounded-2xl bg-gradient-to-br from-blue-600 to-indigo-700 hover:from-blue-500 hover:to-indigo-600 text-white shadow-lg shadow-blue-500/20 hover:shadow-xl hover:shadow-blue-500/30 hover:-translate-y-0.5 transition-all duration-200 group text-left"
            >
              <div className="w-12 h-12 rounded-xl bg-white/20 flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform duration-200">
                <MessageSquare className="w-6 h-6 text-white" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-black text-base tracking-tight">Início (Assistente)</p>
                <p className="text-sm text-blue-100 mt-0.5">
                  Converse com a IA pedagógica e gere conteúdos didáticos
                </p>
              </div>
              <ArrowRight className="w-5 h-5 text-white/50 group-hover:text-white group-hover:translate-x-1 transition-all duration-200 shrink-0" />
            </button>
          </div>

          {/* Planejamento */}
          <div>
            <SectionLabel>Planejamento</SectionLabel>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {planningCards.map((c) => (
                <Card key={c.mode} card={c} />
              ))}
            </div>
          </div>

          {/* Conteúdo & Avaliação */}
          <div>
            <SectionLabel>Conteúdo & Avaliação</SectionLabel>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {contentCards.map((c) => (
                <Card key={c.mode} card={c} />
              ))}
            </div>
          </div>

          {/* Gestão */}
          <div>
            <SectionLabel>Gestão</SectionLabel>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {managementCards.map((c) => (
                <Card key={c.mode} card={c} />
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
