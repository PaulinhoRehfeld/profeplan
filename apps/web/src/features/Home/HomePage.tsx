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
}

interface Section {
  title: string;
  cards: NavCard[];
}

const HomePage: React.FC<HomePageProps> = ({ setActiveMode, userProfile, session }) => {
  const firstName = (userProfile?.full_name || session.email || '').split(' ')[0] || 'Professor';

  const isAdminOrManager =
    userProfile?.is_admin ||
    userProfile?.role === 'admin' ||
    userProfile?.role === 'manager';

  const sections: Section[] = [
    {
      title: 'Assistente',
      cards: [
        {
          mode: ToolMode.CHAT,
          icon: MessageSquare,
          title: 'Início (Assistente)',
          description: 'Converse com a IA pedagógica e gere conteúdos didáticos',
          iconColor: 'text-blue-600',
          iconBg: 'bg-blue-50',
        },
      ],
    },
    {
      title: 'Planejamento',
      cards: [
        {
          mode: ToolMode.QUARTERLY_PLANNING,
          icon: CalendarRange,
          title: 'Planejamento Trimestral',
          description: 'Organize objetivos e conteúdos por trimestre letivo',
          iconColor: 'text-indigo-600',
          iconBg: 'bg-indigo-50',
        },
        {
          mode: ToolMode.PLANNING,
          icon: LayoutDashboard,
          title: 'Planos de Aula',
          description: 'Crie e personalize planos de aula com inteligência artificial',
          iconColor: 'text-violet-600',
          iconBg: 'bg-violet-50',
        },
      ],
    },
    {
      title: 'Conteúdo & Avaliação',
      cards: [
        {
          mode: ToolMode.INCLUSION,
          icon: Accessibility,
          title: 'Adaptações PDI/DUA',
          description: 'Gere adaptações pedagógicas individualizadas para seus alunos',
          iconColor: 'text-emerald-600',
          iconBg: 'bg-emerald-50',
        },
        {
          mode: ToolMode.SIMULATION,
          icon: FileText,
          title: 'Simulados ENEM/Saeb',
          description: 'Crie e aplique simulados contextualizados ao currículo',
          iconColor: 'text-teal-600',
          iconBg: 'bg-teal-50',
        },
        {
          mode: ToolMode.PRESENTATIONS,
          icon: Projector,
          title: 'Apresentações & Slides',
          description: 'Gere apresentações e slides prontos para suas aulas',
          iconColor: 'text-cyan-600',
          iconBg: 'bg-cyan-50',
        },
        {
          mode: ToolMode.ASSESSMENT,
          icon: ClipboardCheck,
          title: 'Avaliações Contextualizadas',
          description: 'Avaliações personalizadas com correção e feedback automático',
          iconColor: 'text-sky-600',
          iconBg: 'bg-sky-50',
        },
      ],
    },
    {
      title: 'Gestão',
      cards: [
        {
          mode: ToolMode.FILES,
          icon: FolderClosed,
          title: 'Meus Arquivos',
          description: 'Armazene e organize seus materiais pedagógicos',
          iconColor: 'text-amber-600',
          iconBg: 'bg-amber-50',
        },
        {
          mode: ToolMode.CLASSES,
          icon: BookOpen,
          title: 'Minhas Turmas',
          description: 'Gerencie suas turmas, alunos e listas de chamada',
          iconColor: 'text-orange-600',
          iconBg: 'bg-orange-50',
        },
        {
          mode: ToolMode.MY_DOCUMENTS,
          icon: LibraryBig,
          title: 'Meus Documentos',
          description: 'Acesse documentos gerados e seu histórico de trabalho',
          iconColor: 'text-rose-600',
          iconBg: 'bg-rose-50',
        },
        ...(isAdminOrManager
          ? [
              {
                mode: ToolMode.SCHOOL_MANAGER,
                icon: Users,
                title: 'Gestão Escolar',
                description: 'Painel de gestão escolar, usuários e relatórios',
                iconColor: 'text-purple-600',
                iconBg: 'bg-purple-50',
              } as NavCard,
            ]
          : []),
      ],
    },
  ];

  return (
    <div className="flex-1 overflow-y-auto bg-slate-50 custom-scrollbar">
      <div className="max-w-5xl mx-auto px-4 md:px-8 pt-8 pb-12">

        {/* Cabeçalho */}
        <div className="mb-8">
          <h1 className="text-2xl font-black text-slate-900 tracking-tight">
            Olá, {firstName}!
          </h1>
          <p className="text-sm text-slate-500 mt-1">
            Bem-vindo ao PROFEPLAN — o que vamos fazer hoje?
          </p>
        </div>

        {/* Seções */}
        <div className="space-y-8">
          {sections.map((section) => (
            <div key={section.title}>
              <p className="text-[10px] font-black uppercase tracking-[0.25em] text-slate-400 mb-3 px-0.5">
                {section.title}
              </p>
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                {section.cards.map((card) => (
                  <button
                    key={card.mode}
                    onClick={() => setActiveMode(card.mode)}
                    className="flex items-start gap-4 p-4 rounded-2xl border border-slate-100 bg-white hover:border-slate-200 hover:shadow-md hover:-translate-y-0.5 transition-all duration-200 text-left group"
                  >
                    <div className={`p-2.5 rounded-xl ${card.iconBg} shrink-0 group-hover:scale-110 transition-transform duration-200`}>
                      <card.icon className={`w-5 h-5 ${card.iconColor}`} />
                    </div>
                    <div className="min-w-0">
                      <p className="text-sm font-bold text-slate-800 leading-tight">
                        {card.title}
                      </p>
                      <p className="text-xs text-slate-500 mt-0.5 leading-snug">
                        {card.description}
                      </p>
                    </div>
                  </button>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default HomePage;
