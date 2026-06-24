import React, { ReactNode } from 'react';
import { Menu, Crown } from 'lucide-react';
import Sidebar from '../components/Sidebar';
import SettingsModal from '../components/SettingsModal';
import SubscriptionModal from '../components/SubscriptionModal';
import { SchoolSwitcher } from '../components/SchoolSwitcher';
import { UserSession, UserProfile, ToolMode, UserSettings } from '../types';
import DonationWidget from '../components/DonationWidget';
import { FirstRunTour } from '../components/FirstRunTour';

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
    customSidebar,
    isSettingsOpen,
    setIsSettingsOpen,
    isSubscriptionOpen,
    setIsSubscriptionOpen,
    onLogout,
    onRefreshProfile,
    setSettings
}) => {
    const getModeLabel = (mode: ToolMode): string => {
        switch (mode) {
            case ToolMode.CHAT:
                return 'Início · Assistente pedagógico';
            case ToolMode.QUARTERLY_PLANNING:
                return 'Planejamento · Trimestral';
            case ToolMode.PLANNING:
                return 'Planejamento · Planos de Aula';
            case ToolMode.INCLUSION:
                return 'Inclusão · Adaptações PDI/DUA';
            case ToolMode.SIMULATION:
                return 'Avaliação · Simulados ENEM/SAEB';
            case ToolMode.PRESENTATIONS:
                return 'Conteúdo · Apresentações & Slides';
            case ToolMode.ASSESSMENT:
                return 'Avaliação · Provas Contextualizadas';
            case ToolMode.FILES:
                return 'Gestão · Meus Arquivos';
            case ToolMode.CLASSES:
                return 'Gestão · Minhas Turmas';
            case ToolMode.SCHOOL_MANAGER:
                return 'Gestão Escolar';
            case ToolMode.ADMIN:
                return 'Administração do Sistema';
            default:
                return String(mode);
        }
    };

    return (
        <div className="app-container flex h-screen bg-slate-50 overflow-hidden font-sans">
            <Sidebar
                activeMode={activeMode}
                setActiveMode={setActiveMode}
                onOpenSettings={() => setIsSettingsOpen(true)}
                isOpen={isMobileNavOpen}
                onClose={() => setIsMobileNavOpen(false)}
                userRole={session.role}
                isDesktopExpanded={isLeftNavExpanded}
                onToggleDesktopExpand={() => setIsLeftNavExpanded(prev => !prev)}
                userProfile={userProfile}
                onOpenSubscription={() => setIsSubscriptionOpen(true)}
                onLogout={onLogout}
            />

            <main className={`main-content flex-1 flex flex-col relative h-full transition-all duration-300 ${isLeftNavExpanded ? 'lg:ml-64' : 'lg:ml-20'}`}>
                {/* HEADER */}
                <header className="h-16 bg-white/90 backdrop-blur-xl border-b border-slate-100 flex items-center justify-between px-4 md:px-6 z-50 sticky top-0 shadow-sm">
                    <div className="flex items-center gap-4">
                        <button onClick={() => setIsMobileNavOpen(true)} className="lg:hidden p-2 text-slate-500">
                            <Menu size={24} />
                        </button>
                        <div className="flex flex-col">
                            <h2 className="font-black text-slate-900 tracking-tighter uppercase italic text-lg leading-none">PROFEPLAN V4.3.5</h2>
                            <div className="flex items-center gap-2 mt-1">
                                <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full animate-pulse"></span>
                                <div className="flex flex-col">
                                    <span className="text-[9px] font-black text-slate-400 uppercase tracking-widest">
                                        {getModeLabel(activeMode)}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="flex items-center gap-4">
                        {/* School Switcher (apenas para professores com múltiplas escolas) */}
                        <SchoolSwitcher
                            userProfile={userProfile}
                            onSchoolChange={onRefreshProfile}
                        />

                        <div className="h-8 w-px bg-slate-100 mx-2"></div>
                        <div className="flex items-center gap-3">
                            <div className="text-right hidden sm:block">
                                <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Workspace de</p>
                                <p className="text-xs font-black text-slate-900">{settings.userName}</p>
                            </div>
                            <div className="w-10 h-10 bg-slate-900 rounded-2xl flex items-center justify-center text-white font-black text-sm shadow-xl shadow-slate-200">
                                {settings.userName.charAt(0)}
                            </div>
                        </div>
                    </div>
                </header>

                {/* CONTENT AREA */}
                <div className="layout-wrapper flex-1 overflow-hidden relative flex flex-col bg-white">
                    {children}
                    {/* Tour de primeiro uso (só aparece uma vez por usuário) */}
                    <FirstRunTour activeModeLabel={getModeLabel(activeMode)} />
                </div>
            </main>



            {/* MODALS */}
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
