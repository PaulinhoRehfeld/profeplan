import React, { Suspense } from 'react';
import { Loader2, Lock, AlertCircle } from 'lucide-react';
import { ToolMode, UserSession, UserProfile, UserSettings } from '../types';
import { isAdmin, isProfileCompleteForMainFlows } from '../services/ProfileService';

// Lazy Load Features
const HomePage = React.lazy(() => import('../features/Home/HomePage'));
const DriveExplorer = React.lazy(() => import('../components/DriveExplorer'));
const AdminPanel = React.lazy(() =>
  import('../components/Admin/AdminPanel').then((module) => ({ default: module.AdminPanel }))
);
const HistoryList = React.lazy(() => import('../components/HistoryList'));
const ClassManager = React.lazy(() => import('../components/ClassManager'));
const PresentationCreator = React.lazy(() => import('../components/PresentationCreator'));
const AssessmentManager = React.lazy(() => import('../features/Assessment/AssessmentManager'));
const PlanningManager = React.lazy(() => import('../features/Planning/PlanningManager'));
const PDIManager = React.lazy(() => import('../features/PDI/PDIManager'));
const TermPlanningManager = React.lazy(
  () => import('../features/TermPlanning/TermPlanningManager')
);
const SchoolDashboard = React.lazy(() => import('../pages/SchoolDashboard'));
const MyDocumentsManager = React.lazy(() => import('../features/MyDocuments/MyDocumentsManager'));

const PageLoader = () => (
  <div className="flex items-center justify-center h-full w-full bg-slate-50 text-slate-400">
    <Loader2 className="animate-spin mr-2" />
    <span className="text-sm font-medium">Carregando...</span>
  </div>
);

interface FeatureRendererProps {
  activeMode: ToolMode;
  session: UserSession;
  userProfile: UserProfile | null;
  settings: UserSettings;
  availableClasses?: any[];
  selectedClassId?: string;
  quarter?: string;
  enemArea?: string;
  setCustomSidebar: (node: React.ReactNode) => void;
  setIsSettingsOpen: (open: boolean) => void;
  setActiveMode: (mode: ToolMode) => void;
}

export const FeatureRenderer: React.FC<FeatureRendererProps> = ({
  activeMode,
  session,
  userProfile,
  settings,
  availableClasses = [],
  selectedClassId = '',
  quarter = '',
  enemArea = 'Ciências Humanas',
  setCustomSidebar,
  setIsSettingsOpen,
  setActiveMode,
}) => {
  const isProfileComplete = isProfileCompleteForMainFlows(userProfile, settings);

  const renderProfileBlocker = () => (
    <div className="flex-1 flex flex-col items-center justify-center bg-slate-50 px-4 text-center">
      <div className="flex flex-col items-center gap-3 max-w-md">
        <div className="w-12 h-12 rounded-full bg-amber-100 flex items-center justify-center">
          <AlertCircle className="w-6 h-6 text-amber-600" />
        </div>
        <h2 className="text-sm font-black uppercase tracking-widest text-amber-700">
          Complete seu Perfil Profissional
        </h2>
        <p className="text-xs text-slate-600 font-medium">
          Para gerar planos, PDIs e avaliações, preencha primeiro seu Perfil Profissional em{' '}
          <span className="font-semibold">Configurações &gt; Perfil e Preferências</span>.
        </p>
        <button
          type="button"
          onClick={() => setIsSettingsOpen(true)}
          className="mt-2 inline-flex items-center justify-center px-5 py-2 rounded-full bg-slate-900 text-white text-[11px] font-black uppercase tracking-widest shadow-md hover:bg-slate-800 transition-colors"
        >
          Abrir Configurações
        </button>
      </div>
    </div>
  );

  return (
    <Suspense fallback={<PageLoader />}>
      {activeMode === ToolMode.HOME ? (
        <HomePage setActiveMode={setActiveMode} userProfile={userProfile} session={session} />
      ) : activeMode === ToolMode.FILES ? (
        <div className="flex-1 overflow-hidden h-full w-full bg-slate-50">
          <DriveExplorer userId={session.id} userEmail={session.email} settings={settings} />
        </div>
      ) : activeMode === ToolMode.ADMIN ? (
        isAdmin(userProfile) ? (
          <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10">
            <AdminPanel />
          </div>
        ) : (
          <div className="flex-1 flex items-center justify-center flex-col text-slate-400">
            <Lock size={48} className="mb-4 text-slate-300" />
            <p>Acesso Restrito</p>
          </div>
        )
      ) : activeMode === ToolMode.HISTORY ? (
        <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
          <HistoryList
            userId={session.id}
            onSelectLesson={(content) => {
              const storageKey = `profeplan_chat_${session.email}`;
              const saved = JSON.parse(localStorage.getItem(storageKey) || '[]');
              saved.push({
                id: Date.now().toString(),
                role: 'model',
                content: content,
                timestamp: new Date(),
              });
              localStorage.setItem(storageKey, JSON.stringify(saved));
              setActiveMode(ToolMode.CHAT);
            }}
          />
        </div>
      ) : activeMode === ToolMode.CLASSES ? (
        <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
          <ClassManager userId={session.id} userProfile={userProfile} />
        </div>
      ) : activeMode === ToolMode.PRESENTATIONS ? (
        <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
          <PresentationCreator userId={session.id} setSidebarContent={setCustomSidebar} />
        </div>
      ) : activeMode === ToolMode.INCLUSION ? (
        isProfileComplete ? (
          <div className="flex-1 overflow-hidden h-full">
            <PDIManager
              userId={session.id}
              userProfile={userProfile}
              setSidebarContent={setCustomSidebar}
            />
          </div>
        ) : (
          renderProfileBlocker()
        )
      ) : activeMode === ToolMode.ASSESSMENT ? (
        isProfileComplete ? (
          <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
            <AssessmentManager
              userId={session.id}
              settings={settings}
              setSidebarContent={setCustomSidebar}
            />
          </div>
        ) : (
          renderProfileBlocker()
        )
      ) : activeMode === ToolMode.QUARTERLY_PLANNING ? (
        isProfileComplete ? (
          <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar bg-slate-50/50">
            <div className="max-w-6xl mx-auto space-y-6">
              <React.Suspense fallback={<PageLoader />}>
                {/*
                                  Lista de planejamentos salvos.
                                  Aparece no topo em largura total.
                                */}
                <React.Suspense fallback={null}>
                  {React.createElement(
                    React.lazy(() => import('../features/TermPlanning/TermPlanningList')),
                    {
                      userId: session.id,
                      onOpenPlan: () => {
                        const el = document.getElementById('term-planning-editor');
                        if (el) {
                          el.scrollIntoView({ behavior: 'smooth', block: 'start' });
                        }
                      },
                    } as any
                  )}
                </React.Suspense>
              </React.Suspense>
              <div id="term-planning-editor">
                <TermPlanningManager
                  userId={session.id}
                  settings={settings}
                  setSidebarContent={setCustomSidebar}
                />
              </div>
            </div>
          </div>
        ) : (
          renderProfileBlocker()
        )
      ) : activeMode === ToolMode.SCHOOL_MANAGER ? (
        <SchoolDashboard
          userProfile={
            userProfile ||
            ({
              id: session.id,
              role: 'manager',
              email: session.email,
              school_name: 'Minha Escola',
              school_id: '',
            } as any)
          }
          onOpenSettings={() => setIsSettingsOpen(true)}
        />
      ) : activeMode === ToolMode.MY_DOCUMENTS ? (
        isProfileComplete ? (
          <div className="flex-1 overflow-hidden h-full">
            <MyDocumentsManager userId={session.id} setSidebarContent={setCustomSidebar} />
          </div>
        ) : (
          renderProfileBlocker()
        )
      ) : // DEFAULT / CHAT / PLANNING
      isProfileComplete || activeMode !== ToolMode.PLANNING ? (
        <PlanningManager
          userId={session.id}
          activeMode={activeMode}
          availableClasses={availableClasses}
          settings={settings}
          selectedClassId={selectedClassId}
          quarter={quarter}
          enemArea={enemArea}
          setSidebarContent={setCustomSidebar}
          setActiveMode={setActiveMode}
        />
      ) : (
        renderProfileBlocker()
      )}
    </Suspense>
  );
};
