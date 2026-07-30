import React from 'react';
import {
  Accessibility,
  ArrowRight,
  BookOpen,
  CalendarRange,
  ClipboardCheck,
  FileText,
  FolderClosed,
  LayoutDashboard,
  LibraryBig,
  MessageSquare,
  Projector,
  Users,
} from 'lucide-react';
import { Card, PageHeader } from '../../components/ui';
import { ToolMode, UserProfile, UserSession } from '../../types';

interface HomePageProps {
  setActiveMode: (mode: ToolMode) => void;
  userProfile: UserProfile | null;
  session: UserSession;
}

interface HomeAction {
  mode: ToolMode;
  icon: React.ElementType;
  title: string;
  description: string;
  accent: string;
  iconStyle: string;
}

interface ActionCardProps {
  action: HomeAction;
  onSelect: (mode: ToolMode) => void;
  prominent?: boolean;
}

const ActionCard: React.FC<ActionCardProps> = ({ action, onSelect, prominent = false }) => {
  const Icon = action.icon;
  return (
    <button
      type="button"
      onClick={() => onSelect(action.mode)}
      className={`ui-focus-ring ui-reduce-motion group flex min-h-full w-full items-start gap-4 rounded-[var(--ui-radius-panel)] border bg-white p-5 text-left transition-colors hover:border-blue-300 hover:bg-blue-50/40 sm:p-6 ${prominent ? 'border-blue-200' : 'border-slate-200'}`}
      aria-label={`${action.title}. ${action.description}`}
    >
      <span
        className={`flex h-12 w-12 shrink-0 items-center justify-center rounded-xl ${action.iconStyle}`}
      >
        <Icon aria-hidden="true" className="h-6 w-6" />
      </span>
      <span className="min-w-0 flex-1">
        <span className="block text-lg font-semibold leading-6 text-slate-950">{action.title}</span>
        <span className="mt-1 block text-sm leading-5 text-slate-600">{action.description}</span>
        <span
          className={`mt-3 inline-flex items-center gap-1 text-sm font-semibold ${action.accent}`}
        >
          Começar{' '}
          <ArrowRight
            aria-hidden="true"
            className="h-4 w-4 transition-transform group-hover:translate-x-0.5 ui-reduce-motion"
          />
        </span>
      </span>
    </button>
  );
};

const SectionHeader: React.FC<{ id: string; title: string; description: string }> = ({
  id,
  title,
  description,
}) => (
  <div className="mb-4">
    <h2 id={id} className="text-xl font-semibold leading-7 text-slate-950">
      {title}
    </h2>
    <p className="mt-1 text-sm leading-5 text-slate-600">{description}</p>
  </div>
);

const HomePage: React.FC<HomePageProps> = ({ setActiveMode, userProfile, session }) => {
  const firstName = (userProfile?.full_name || session.email || '').split(' ')[0] || 'Professor';
  const schoolName = userProfile?.school?.name || userProfile?.school_name;
  const isAdminOrManager =
    userProfile?.is_admin || userProfile?.role === 'admin' || userProfile?.role === 'manager';

  const primaryActions: HomeAction[] = [
    {
      mode: ToolMode.PLANNING,
      icon: LayoutDashboard,
      title: 'Criar plano de aula',
      description: 'Planeje uma aula completa e personalize o conteúdo com apoio da IA.',
      accent: 'text-blue-700',
      iconStyle: 'bg-blue-100 text-blue-700',
    },
    {
      mode: ToolMode.QUARTERLY_PLANNING,
      icon: CalendarRange,
      title: 'Planejamento trimestral',
      description: 'Organize objetivos, habilidades e conteúdos para o trimestre letivo.',
      accent: 'text-indigo-700',
      iconStyle: 'bg-indigo-100 text-indigo-700',
    },
    {
      mode: ToolMode.ASSESSMENT,
      icon: ClipboardCheck,
      title: 'Criar avaliação',
      description: 'Prepare avaliações contextualizadas com critérios claros para sua turma.',
      accent: 'text-sky-700',
      iconStyle: 'bg-sky-100 text-sky-700',
    },
  ];

  const additionalTools: HomeAction[] = [
    {
      mode: ToolMode.CHAT,
      icon: MessageSquare,
      title: 'Assistente pedagógico',
      description: 'Converse com a IA para tirar dúvidas e criar conteúdos didáticos.',
      accent: 'text-blue-700',
      iconStyle: 'bg-blue-100 text-blue-700',
    },
    {
      mode: ToolMode.SIMULATION,
      icon: FileText,
      title: 'Simulados ENEM e Saeb',
      description: 'Selecione questões e monte simulados alinhados ao currículo.',
      accent: 'text-teal-700',
      iconStyle: 'bg-teal-100 text-teal-700',
    },
    {
      mode: ToolMode.PRESENTATIONS,
      icon: Projector,
      title: 'Apresentações e slides',
      description: 'Crie materiais visuais para apoiar suas aulas.',
      accent: 'text-cyan-700',
      iconStyle: 'bg-cyan-100 text-cyan-700',
    },
  ];

  const managementActions: HomeAction[] = [
    {
      mode: ToolMode.FILES,
      icon: FolderClosed,
      title: 'Meus arquivos',
      description: 'Acesse os materiais que você armazenou no ProfePlan.',
      accent: 'text-amber-800',
      iconStyle: 'bg-amber-100 text-amber-800',
    },
    {
      mode: ToolMode.CLASSES,
      icon: BookOpen,
      title: 'Minhas turmas',
      description: 'Organize turmas, estudantes e informações escolares.',
      accent: 'text-orange-800',
      iconStyle: 'bg-orange-100 text-orange-800',
    },
    {
      mode: ToolMode.MY_DOCUMENTS,
      icon: LibraryBig,
      title: 'Meus documentos',
      description: 'Revise documentos gerados e consulte seu histórico de trabalho.',
      accent: 'text-rose-700',
      iconStyle: 'bg-rose-100 text-rose-700',
    },
    ...(isAdminOrManager
      ? [
          {
            mode: ToolMode.SCHOOL_MANAGER,
            icon: Users,
            title: 'Gestão escolar',
            description: 'Acompanhe equipes, estudantes, turmas e relatórios da escola.',
            accent: 'text-purple-700',
            iconStyle: 'bg-purple-100 text-purple-700',
          } as HomeAction,
        ]
      : []),
  ];

  const inclusionAction: HomeAction = {
    mode: ToolMode.INCLUSION,
    icon: Accessibility,
    title: 'Adaptações PDI e DUA',
    description:
      'Planeje estratégias e adaptações pedagógicas individualizadas para apoiar cada estudante.',
    accent: 'text-emerald-800',
    iconStyle: 'bg-emerald-100 text-emerald-800',
  };

  return (
    <div className="ui-readable flex-1 overflow-y-auto bg-slate-50 custom-scrollbar">
      <main className="mx-auto w-full max-w-[var(--ui-content-wide)] px-4 py-8 sm:px-6 sm:py-10 lg:px-8 lg:py-12">
        <PageHeader
          eyebrow={schoolName ? `Escola atual: ${schoolName}` : 'Seu espaço de trabalho'}
          title={`Olá, ${firstName}`}
          description="Escolha uma tarefa para começar. Você poderá revisar e personalizar tudo antes de finalizar."
        />

        <section className="mt-10" aria-labelledby="primary-actions-title">
          <div className="mb-4">
            <h2
              id="primary-actions-title"
              className="text-2xl font-semibold leading-8 text-slate-950"
            >
              O que você quer fazer hoje?
            </h2>
            <p className="mt-1 text-base leading-6 text-slate-600">
              Comece pelas tarefas mais usadas no planejamento docente.
            </p>
          </div>
          <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
            {primaryActions.map((action) => (
              <ActionCard key={action.mode} action={action} onSelect={setActiveMode} prominent />
            ))}
          </div>
        </section>

        <section className="mt-10" aria-labelledby="inclusion-title">
          <Card className="border-emerald-200 bg-emerald-50/50 p-5 sm:p-6">
            <div className="flex flex-col gap-5 sm:flex-row sm:items-center sm:justify-between">
              <div className="flex items-start gap-4">
                <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-emerald-100 text-emerald-800">
                  <Accessibility aria-hidden="true" className="h-6 w-6" />
                </span>
                <div>
                  <h2
                    id="inclusion-title"
                    className="text-xl font-semibold leading-7 text-slate-950"
                  >
                    Recursos para inclusão
                  </h2>
                  <p className="mt-1 max-w-2xl text-base leading-6 text-slate-700">
                    {inclusionAction.description}
                  </p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setActiveMode(inclusionAction.mode)}
                className="ui-focus-ring ui-reduce-motion inline-flex min-h-11 shrink-0 items-center justify-center gap-2 rounded-[var(--ui-radius-control)] border border-emerald-700 bg-white px-4 text-base font-semibold text-emerald-800 transition-colors hover:bg-emerald-100"
              >
                Abrir PDI e DUA <ArrowRight aria-hidden="true" className="h-5 w-5" />
              </button>
            </div>
          </Card>
        </section>

        <section className="mt-10" aria-labelledby="additional-tools-title">
          <SectionHeader
            id="additional-tools-title"
            title="Outras ferramentas"
            description="Use recursos complementares para preparar aulas e materiais."
          />
          <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
            {additionalTools.map((action) => (
              <ActionCard key={action.mode} action={action} onSelect={setActiveMode} />
            ))}
          </div>
        </section>

        <section className="mt-10" aria-labelledby="management-title">
          <SectionHeader
            id="management-title"
            title="Organização e gestão"
            description="Encontre seus materiais, documentos e informações das turmas."
          />
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {managementActions.map((action) => (
              <ActionCard key={action.mode} action={action} onSelect={setActiveMode} />
            ))}
          </div>
        </section>
      </main>
    </div>
  );
};

export default HomePage;
