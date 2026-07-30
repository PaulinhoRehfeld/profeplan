import React, { ReactNode } from 'react';
import { Menu } from 'lucide-react';
import Sidebar from '../components/Sidebar';
import SettingsModal from '../components/SettingsModal';
import SubscriptionModal from '../components/SubscriptionModal';
import { SchoolSwitcher } from '../components/SchoolSwitcher';
import { UserSession, UserProfile, ToolMode, UserSettings } from '../types';
import { FirstRunTour } from '../components/FirstRunTour';
import { IconButton } from '../components/ui';

interface MainLayoutProps {
  children: ReactNode;
  session: UserSession;
  userProfile: UserProfile | null;
  settings: UserSettings;
  activeMode: ToolMode;
  setActiveMode: (mode: ToolMode) => void;
  isMobileNavOpen: boolean;
  setIsMobileNavOpen: (open: boolean) => void;
  isLeftNavExpanded: boolean;
  setIsLeftNavExpanded: React.Dispatch<React.SetStateAction<boolean>>;
  customSidebar: ReactNode | null;
  isSettingsOpen: boolean;
  setIsSettingsOpen: (open: boolean) => void;
  isSubscriptionOpen: boolean;
  setIsSubscriptionOpen: (open: boolean) => void;
  onLogout: () => void;
  onRefreshProfile: () => Promise<void>;
  setSettings: (settings: UserSettings) => void;
}

const modeLabels: Partial<Record<ToolMode, { group: string; title: string }>> = {
  [ToolMode.HOME]: { group: 'Início', title: 'Visão geral' },
  [ToolMode.CHAT]: { group: 'Início', title: 'Assistente pedagógico' },
  [ToolMode.QUARTERLY_PLANNING]: { group: 'Planejamento', title: 'Planejamento trimestral' },
  [ToolMode.PLANNING]: { group: 'Planejamento', title: 'Planos de aula' },
  [ToolMode.INCLUSION]: { group: 'Inclusão', title: 'Adaptações PDI e DUA' },
  [ToolMode.SIMULATION]: { group: 'Avaliações', title: 'Simulados ENEM e Saeb' },
  [ToolMode.PRESENTATIONS]: { group: 'Conteúdo', title: 'Apresentações e slides' },
  [ToolMode.ASSESSMENT]: { group: 'Avaliações', title: 'Avaliações contextualizadas' },
  [ToolMode.FILES]: { group: 'Organização', title: 'Meus arquivos' },
  [ToolMode.CLASSES]: { group: 'Organização', title: 'Minhas turmas' },
  [ToolMode.MY_DOCUMENTS]: { group: 'Organização', title: 'Meus documentos' },
  [ToolMode.HISTORY]: { group: 'Organização', title: 'Histórico' },
  [ToolMode.SCHOOL_MANAGER]: { group: 'Gestão', title: 'Gestão escolar' },
  [ToolMode.ADMIN]: { group: 'Administração', title: 'Painel administrativo' },
};

export const MainLayout: React.FC<MainLayoutProps> = ({
  children,
  session,
  userProfile,
  settings,
  activeMode,
  setActiveMode,
  isMobileNavOpen,
  setIsMobileNavOpen,
  isLeftNavExpanded,
  setIsLeftNavExpanded,
  isSettingsOpen,
  setIsSettingsOpen,
  isSubscriptionOpen,
  setIsSubscriptionOpen,
  onLogout,
  onRefreshProfile,
  setSettings,
}) => {
  const mode = modeLabels[activeMode] || { group: 'ProfePlan', title: String(activeMode) };
  const userInitial = (settings.userName || session.email || 'P').trim().charAt(0).toUpperCase();

  return (
    <div className="app-container flex h-screen overflow-hidden bg-slate-50 font-sans">
      <Sidebar
        activeMode={activeMode}
        setActiveMode={setActiveMode}
        onOpenSettings={() => setIsSettingsOpen(true)}
        isOpen={isMobileNavOpen}
        onClose={() => setIsMobileNavOpen(false)}
        userRole={session.role}
        isDesktopExpanded={isLeftNavExpanded}
        onToggleDesktopExpand={() => setIsLeftNavExpanded((previous) => !previous)}
        userProfile={userProfile}
        onOpenSubscription={() => setIsSubscriptionOpen(true)}
        onLogout={onLogout}
      />

      <main
        className={`main-content relative flex h-full min-w-0 flex-1 flex-col transition-[margin] duration-200 ui-reduce-motion ${
          isLeftNavExpanded ? 'lg:ml-64' : 'lg:ml-20'
        }`}
      >
        <header className="sticky top-0 z-50 flex min-h-16 items-center justify-between gap-3 border-b border-slate-200 bg-white px-3 py-2 sm:px-5 lg:px-6">
          <div className="flex min-w-0 items-center gap-3">
            <IconButton
              label="Abrir menu principal"
              icon={<Menu aria-hidden="true" className="h-6 w-6" />}
              onClick={() => setIsMobileNavOpen(true)}
              className="lg:hidden"
            />
            <div className="min-w-0">
              <p className="truncate text-sm font-medium text-slate-500">{mode.group}</p>
              <h1 className="truncate text-lg font-semibold leading-6 text-slate-950 sm:text-xl">
                {mode.title}
              </h1>
            </div>
          </div>

          <div className="flex shrink-0 items-center gap-2 sm:gap-3">
            <div className="min-w-0">
              <SchoolSwitcher userProfile={userProfile} onSchoolChange={onRefreshProfile} />
            </div>
            <div className="hidden h-8 w-px bg-slate-200 sm:block" aria-hidden="true" />
            <div className="flex items-center gap-2.5">
              <div className="hidden max-w-40 text-right sm:block">
                <p className="truncate text-sm font-semibold text-slate-900">{settings.userName}</p>
                <p className="truncate text-xs text-slate-500">
                  {userProfile?.school_name || session.email}
                </p>
              </div>
              <div
                className="hidden h-10 w-10 items-center justify-center rounded-full bg-blue-700 text-base font-semibold text-white sm:flex"
                aria-label={`Usuário: ${settings.userName || session.email}`}
                title={settings.userName || session.email}
              >
                {userInitial}
              </div>
            </div>
          </div>
        </header>

        <div className="layout-wrapper relative flex min-h-0 flex-1 flex-col overflow-hidden bg-white">
          {children}
          <FirstRunTour activeModeLabel={`${mode.group} · ${mode.title}`} />
        </div>
      </main>

      {isSettingsOpen && (
        <SettingsModal
          isOpen={isSettingsOpen}
          onClose={() => setIsSettingsOpen(false)}
          settings={settings}
          setSettings={setSettings}
          userEmail={session.email}
          userProfile={userProfile}
          onRefreshProfile={onRefreshProfile}
        />
      )}

      <SubscriptionModal
        isOpen={isSubscriptionOpen}
        onClose={() => setIsSubscriptionOpen(false)}
        userProfile={userProfile}
      />
    </div>
  );
};
