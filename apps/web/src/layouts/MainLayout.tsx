import React, { ReactNode } from 'react';
import { Menu, Crown } from 'lucide-react';
import Sidebar from '../components/Sidebar';
import SettingsModal from '../components/SettingsModal';
import SubscriptionModal from '../components/SubscriptionModal';
import { SchoolSwitcher } from '../components/SchoolSwitcher';
import { UserSession, UserProfile, ToolMode, UserSettings } from '../types';
import DonationWidget from '../components/DonationWidget';

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
                            <h2 className="font-black text-slate-900 tracking-tighter uppercase italic text-lg leading-none">PROFEPLAN V3.9.1</h2>
                            <div className="flex items-center gap-2 mt-1">
                                <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full animate-pulse"></span>
                                <span className="text-[9px] font-black text-slate-400 uppercase tracking-widest">{String(activeMode).toUpperCase()}</span>
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
                </div>
            </main>

            {/* RIGHT SIDEBAR (ASIDE) */}
            <aside className={`h-screen bg-white border-l border-slate-100 shrink-0 lg:flex lg:flex-col lg:w-64 p-6 space-y-6 overflow-y-auto ${activeMode === ToolMode.QUARTERLY_PLANNING ? 'hidden' : 'hidden lg:flex'}`}>
                {customSidebar ? (
                    <div className="animate-in fade-in slide-in-from-right-10 duration-500">
                        {customSidebar}
                    </div>
                ) : (
                    <div>
                        <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-8">PROFEPLAN V3.9.1</h3>
                        <p className="text-xs text-slate-500 font-medium mb-6">Selecione uma ferramenta no menu ou comece uma conversa para planejar sua aula.</p>

                        {/* Banner de Doação na Home */}
                        {activeMode === ToolMode.CHAT && (
                            <DonationWidget />
                        )}
                    </div>
                )}

                <div className="pt-10 border-t border-slate-100 mt-auto">
                    <div className="bg-gradient-to-br from-slate-950 to-slate-900 p-8 rounded-[2.5rem] text-white shadow-2xl relative overflow-hidden group">
                        <div className="absolute top-0 right-0 w-24 h-24 bg-blue-600/10 blur-3xl group-hover:bg-blue-600/20 transition-all"></div>
                        <p className="text-[9px] font-black uppercase tracking-[0.3em] text-blue-400 mb-3 flex items-center gap-2">
                            <Crown size={12} /> Licença Ativa
                        </p>
                        <p className="font-black text-lg tracking-tighter italic mb-4 uppercase">{session.accessLevel} ACCOUNT</p>

                        {userProfile && (
                            <div className="mb-4">
                                <div className="flex justify-between text-[10px] font-bold text-blue-200 mb-1">
                                    <span>{userProfile.tier === 'GOLD' || userProfile.is_unlimited ? 'PLANO' : 'CRÉDITOS'}</span>
                                    <span>{userProfile.tier === 'GOLD' || userProfile.is_unlimited ? 'ILIMITADO' : `${userProfile.credits} Restantes`}</span>
                                </div>
                                {!(userProfile.tier === 'GOLD' || userProfile.is_unlimited) && (
                                    <div className="w-full h-2 bg-blue-900/50 rounded-full overflow-hidden">
                                        <div
                                            className="h-full bg-blue-400 transition-all duration-500"
                                            style={{ width: `${Math.min((userProfile.credits / 50) * 100, 100)}%` }}
                                        ></div>
                                    </div>
                                )}
                            </div>
                        )}

                        <div className="bg-white/5 p-3 rounded-xl border border-white/10 text-[9px] font-bold text-slate-400 uppercase tracking-widest text-center">
                            Sincronizado com Supabase
                        </div>
                    </div>
                </div>
            </aside>

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
