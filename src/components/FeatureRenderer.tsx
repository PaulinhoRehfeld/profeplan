import React, { Suspense } from 'react';
import { Loader2, Lock } from 'lucide-react';
import { ToolMode, UserSession, UserProfile, UserSettings } from '../types';
import { isAdmin } from '../services/userService';

// Lazy Load Features
const DriveExplorer = React.lazy(() => import('../components/DriveExplorer'));
const AdminPanel = React.lazy(() => import('../components/Admin/AdminPanel').then(module => ({ default: module.AdminPanel })));
const HistoryList = React.lazy(() => import('../components/HistoryList'));
const ClassManager = React.lazy(() => import('../components/ClassManager'));
const PresentationCreator = React.lazy(() => import('../components/PresentationCreator'));
const AssessmentManager = React.lazy(() => import('../features/Assessment/AssessmentManager'));
const PlanningManager = React.lazy(() => import('../features/Planning/PlanningManager'));
const PDIManager = React.lazy(() => import('../features/PDI/PDIManager'));
const TermPlanningManager = React.lazy(() => import('../features/TermPlanning/TermPlanningManager'));
const SchoolDashboard = React.lazy(() => import('../pages/SchoolDashboard'));

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
    setActiveMode
}) => {

    return (
        <Suspense fallback={<PageLoader />}>
            {activeMode === ToolMode.FILES ? (
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
                                timestamp: new Date()
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
                <div className="flex-1 overflow-hidden h-full">
                    <PDIManager userId={session.id} userProfile={userProfile} setSidebarContent={setCustomSidebar} />
                </div>
            ) : activeMode === ToolMode.ASSESSMENT ? (
                <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
                    <AssessmentManager userId={session.id} settings={settings} setSidebarContent={setCustomSidebar} />
                </div>
            ) : activeMode === ToolMode.QUARTERLY_PLANNING ? (
                <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar bg-slate-50/50">
                    <TermPlanningManager userId={session.id} settings={settings} setSidebarContent={setCustomSidebar} />
                </div>
            ) : activeMode === ToolMode.SCHOOL_MANAGER ? (
                <SchoolDashboard
                    userProfile={userProfile || { id: session.id, role: 'manager', email: session.email, school_name: 'Minha Escola', school_id: '' } as any}
                    onOpenSettings={() => setIsSettingsOpen(true)}
                />
            ) : (
                // DEFAULT / CHAT / PLANNING
                <PlanningManager
                    userId={session.id}
                    activeMode={activeMode}
                    availableClasses={availableClasses}
                    settings={settings}
                    selectedClassId={selectedClassId}
                    quarter={quarter}
                    enemArea={enemArea}
                    setSidebarContent={setCustomSidebar}
                />
            )}
        </Suspense>
    );
};
