import React from 'react';
import {
  LayoutDashboard,
  BookOpen,
  PenTool,
  Accessibility,
  FileText,
  Settings,
  ShieldCheck,
  X,
  Crown,
  FolderClosed,
  Home,
  ChevronLeft,
  ChevronRight,
  CalendarRange,
  LibraryBig,
  Projector,
  Clock,
  Users,
  ClipboardCheck,
  MessageSquare,
} from 'lucide-react';
import { ToolMode, UserRole, UserProfile } from '../types';
import { supabase } from '../services/supabaseClient';
import DonationWidget from './DonationWidget';
import { isAdmin } from '../services/ProfileService';
import { isHardcodedAdmin } from '../constants';

interface SidebarProps {
  activeMode: ToolMode;
  setActiveMode: (mode: ToolMode) => void;
  onOpenSettings: () => void;
  isOpen: boolean;
  onClose: () => void;
  userRole?: UserRole;
  // Added missing props passed from App.tsx
  isDesktopExpanded?: boolean;
  onToggleDesktopExpand?: () => void;
  userProfile?: UserProfile | null;
  onOpenSubscription: () => void;
  onLogout: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({
  activeMode,
  setActiveMode,
  onOpenSettings,
  isOpen,
  onClose,
  userRole,
  isDesktopExpanded = true,
  onToggleDesktopExpand,
  userProfile,
  onOpenSubscription,
  onLogout,
}) => {
  const menuItems = [
    { id: ToolMode.HOME, icon: Home, label: 'Início', feature: 'home', group: 'home' },
    { id: ToolMode.CHAT, icon: MessageSquare, label: 'Assistente', feature: 'home', group: 'home' },
    {
      id: ToolMode.QUARTERLY_PLANNING,
      icon: CalendarRange,
      label: 'Planejamento Trimestral',
      feature: 'planning',
      group: 'planning',
    },
    {
      id: ToolMode.PLANNING,
      icon: LayoutDashboard,
      label: 'Planos de Aula',
      feature: 'planning',
      group: 'planning',
    },
    {
      id: ToolMode.INCLUSION,
      icon: Accessibility,
      label: 'Adaptações PDI/DUA',
      feature: 'pdi',
      group: 'content',
    },
    {
      id: ToolMode.SIMULATION,
      icon: FileText,
      label: 'Simulados ENEM/Saeb',
      feature: 'enem',
      group: 'content',
    },
    {
      id: ToolMode.PRESENTATIONS,
      icon: Projector,
      label: 'Apresentações & Slides',
      feature: 'content',
      group: 'content',
    },
    {
      id: ToolMode.ASSESSMENT,
      icon: ClipboardCheck,
      label: 'Avaliações Contextualizadas',
      feature: 'content',
      group: 'content',
    },
    {
      id: ToolMode.FILES,
      icon: FolderClosed,
      label: 'Meus Arquivos',
      feature: 'management',
      group: 'management',
    },
    {
      id: ToolMode.CLASSES,
      icon: BookOpen,
      label: 'Minhas Turmas',
      feature: 'management',
      group: 'management',
    },
    {
      id: ToolMode.MY_DOCUMENTS,
      icon: LibraryBig,
      label: 'Meus Documentos',
      feature: 'management',
      group: 'management',
    },
  ];

  // Add School Management for admins and managers
  const isAdminOrManager =
    isHardcodedAdmin(userProfile?.email) ||
    userProfile?.is_admin ||
    userProfile?.role === 'admin' ||
    userProfile?.role === 'manager' ||
    userRole === 'SCHOOL_MANAGER' ||
    activeMode === ToolMode.SCHOOL_MANAGER;
  const allMenuItems = isAdminOrManager
    ? [
        ...menuItems,
        {
          id: ToolMode.SCHOOL_MANAGER,
          icon: Users,
          label: 'Gestão Escolar',
          feature: 'management',
          group: 'management',
        },
      ]
    : menuItems;

  const filteredItems = allMenuItems;
  const groupedItems = {
    home: filteredItems.filter((i) => i.group === 'home'),
    planning: filteredItems.filter((i) => i.group === 'planning'),
    content: filteredItems.filter((i) => i.group === 'content'),
    management: filteredItems.filter((i) => i.group === 'management'),
  };

  const handleModeSelection = (mode: ToolMode) => {
    setActiveMode(mode);
    onClose();
  };

  return (
    <>
      {isOpen && (
        <div
          className="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-[9998] lg:hidden"
          onClick={onClose}
        />
      )}

      {/* Adjusted width based on expansion state */}
      <div
        className={`
        fixed top-0 left-0 h-screen bg-slate-900 text-slate-300 flex flex-col z-[9999] transition-transform duration-300
        ${isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'}
        w-[85vw] lg:w-auto ${isDesktopExpanded ? 'lg:w-56' : 'lg:w-16'}
      `}
      >
        <div className="p-4 flex flex-col h-full overflow-hidden">
          <div className="flex items-center justify-between mb-6">
            <button
              onClick={() => handleModeSelection(ToolMode.HOME)}
              className="flex items-center gap-2 hover:opacity-80 transition-opacity text-left group overflow-hidden"
            >
              <div className="p-1 rounded-lg group-hover:scale-110 transition-transform shrink-0">
                <img src="/logo-profeplan.png" alt="P" className="w-7 h-7 object-contain" />
              </div>
              {/* Only show title when expanded */}
              {isDesktopExpanded && (
                <h1 className="text-lg font-bold text-white tracking-tight whitespace-nowrap">
                  PROFEPLAN
                </h1>
              )}
            </button>
            <div className="flex items-center">
              <button onClick={onClose} className="lg:hidden p-1 text-slate-500 hover:text-white">
                <X className="w-6 h-6" />
              </button>
              {/* Desktop toggle button for collapsing/expanding the sidebar */}
              <button
                onClick={onToggleDesktopExpand}
                className="hidden lg:flex p-1 text-slate-500 hover:text-white transition-colors"
                title={isDesktopExpanded ? 'Recolher menu' : 'Expandir menu'}
              >
                {isDesktopExpanded ? (
                  <ChevronLeft className="w-6 h-6" />
                ) : (
                  <ChevronRight className="w-6 h-6" />
                )}
              </button>
            </div>
          </div>

          <nav className="flex-1 overflow-y-auto pr-2 scrollbar-hide grid grid-cols-2 gap-2 lg:block lg:space-y-1 content-start">
            {groupedItems.home.map((item) => (
              <button
                key={item.id}
                onClick={() => handleModeSelection(item.id)}
                className={`w-full flex lg:flex-row flex-col items-center justify-center lg:justify-start gap-2 lg:gap-3 px-2 lg:px-3 py-3 lg:py-2 rounded-xl transition-all duration-200 group ${
                  activeMode === item.id
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20 font-bold'
                    : 'bg-slate-800/50 lg:bg-transparent hover:bg-slate-800 hover:text-white'
                }`}
                title={!isDesktopExpanded ? item.label : undefined}
              >
                <item.icon
                  className={`w-5 h-5 lg:w-4 lg:h-4 shrink-0 ${activeMode === item.id ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`}
                />
                {isDesktopExpanded && (
                  <span className="text-xs lg:text-xs text-center lg:text-left leading-tight">
                    {item.label}
                  </span>
                )}
              </button>
            ))}

            {isDesktopExpanded && (
              <p className="hidden lg:block mt-2 mb-1 px-1 text-[9px] font-bold uppercase tracking-[0.25em] text-slate-500">
                Planejamento
              </p>
            )}
            {groupedItems.planning.map((item) => (
              <button
                key={item.id}
                onClick={() => handleModeSelection(item.id)}
                className={`w-full flex lg:flex-row flex-col items-center justify-center lg:justify-start gap-2 lg:gap-3 px-2 lg:px-3 py-3 lg:py-2 rounded-xl transition-all duration-200 group ${
                  activeMode === item.id
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20 font-bold'
                    : 'bg-slate-800/50 lg:bg-transparent hover:bg-slate-800 hover:text-white'
                }`}
                title={!isDesktopExpanded ? item.label : undefined}
              >
                <item.icon
                  className={`w-5 h-5 lg:w-4 lg:h-4 shrink-0 ${activeMode === item.id ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`}
                />
                {isDesktopExpanded && (
                  <span className="text-xs lg:text-xs text-center lg:text-left leading-tight">
                    {item.label}
                  </span>
                )}
              </button>
            ))}

            {isDesktopExpanded && (
              <p className="hidden lg:block mt-3 mb-1 px-1 text-[9px] font-bold uppercase tracking-[0.25em] text-slate-500">
                Conteúdo & Avaliação
              </p>
            )}
            {groupedItems.content.map((item) => (
              <button
                key={item.id}
                onClick={() => handleModeSelection(item.id)}
                className={`w-full flex lg:flex-row flex-col items-center justify-center lg:justify-start gap-2 lg:gap-3 px-2 lg:px-3 py-3 lg:py-2 rounded-xl transition-all duration-200 group ${
                  activeMode === item.id
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20 font-bold'
                    : 'bg-slate-800/50 lg:bg-transparent hover:bg-slate-800 hover:text-white'
                }`}
                title={!isDesktopExpanded ? item.label : undefined}
              >
                <item.icon
                  className={`w-5 h-5 lg:w-4 lg:h-4 shrink-0 ${activeMode === item.id ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`}
                />
                {isDesktopExpanded && (
                  <span className="text-xs lg:text-xs text-center lg:text-left leading-tight">
                    {item.label}
                  </span>
                )}
              </button>
            ))}

            {isDesktopExpanded && (
              <p className="hidden lg:block mt-3 mb-1 px-1 text-[9px] font-bold uppercase tracking-[0.25em] text-slate-500">
                Gestão
              </p>
            )}
            {groupedItems.management.map((item) => (
              <button
                key={item.id}
                onClick={() => handleModeSelection(item.id)}
                className={`w-full flex lg:flex-row flex-col items-center justify-center lg:justify-start gap-2 lg:gap-3 px-2 lg:px-3 py-3 lg:py-2 rounded-xl transition-all duration-200 group ${
                  activeMode === item.id
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20 font-bold'
                    : 'bg-slate-800/50 lg:bg-transparent hover:bg-slate-800 hover:text-white'
                }`}
                title={!isDesktopExpanded ? item.label : undefined}
              >
                <item.icon
                  className={`w-5 h-5 lg:w-4 lg:h-4 shrink-0 ${activeMode === item.id ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`}
                />
                {isDesktopExpanded && (
                  <span className="text-xs lg:text-xs text-center lg:text-left leading-tight">
                    {item.label}
                  </span>
                )}
              </button>
            ))}

            {/* ADMINISTRAÇÃO DO SISTEMA (Apenas Admin) */}
            {(isAdmin(userProfile) || userRole === 'ADMIN') && (
              <div className="pt-2">
                {isDesktopExpanded && (
                  <p className="text-[10px] font-bold text-slate-500 uppercase px-4 mb-2 tracking-widest whitespace-nowrap">
                    Admin Sistema
                  </p>
                )}
                <button
                  onClick={() => handleModeSelection(ToolMode.ADMIN)}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
                    activeMode === ToolMode.ADMIN
                      ? 'bg-amber-600 text-white shadow-lg shadow-amber-600/20 font-bold'
                      : 'hover:bg-slate-800 hover:text-white'
                  }`}
                  title={!isDesktopExpanded ? 'Painel de Controle' : undefined}
                >
                  <ShieldCheck
                    className={`w-5 h-5 shrink-0 ${activeMode === ToolMode.ADMIN ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`}
                  />
                  {isDesktopExpanded && (
                    <span className="text-sm whitespace-nowrap">Painel Administrativo</span>
                  )}
                </button>
              </div>
            )}
          </nav>

          <div className="mt-auto pt-6 border-t border-slate-800">
            <div className="px-4 mb-4">
              {userProfile?.tier === 'GOLD' || userProfile?.is_unlimited ? (
                isDesktopExpanded ? (
                  <div className="bg-amber-500/10 border border-amber-500/20 p-2 rounded-lg text-amber-500 font-bold text-xs flex items-center gap-2 justify-center">
                    <Crown size={14} /> GOLD (Ilimitado)
                  </div>
                ) : (
                  <Crown size={20} className="text-amber-500 mx-auto" />
                )
              ) : (
                <div
                  onClick={onOpenSubscription}
                  className="cursor-pointer hover:opacity-80 transition-opacity"
                  title="Gerenciar Assinatura e Créditos"
                >
                  {isDesktopExpanded ? (
                    <div className="bg-blue-500/10 border border-blue-500/20 p-2 rounded-lg text-blue-400 font-bold text-xs flex items-center gap-2 justify-center">
                      <FolderClosed size={14} /> {userProfile?.credits || 0} Créditos
                    </div>
                  ) : (
                    <div className="text-xs font-bold text-blue-400 text-center">
                      {userProfile?.credits || 0}
                    </div>
                  )}
                </div>
              )}

              {/* Botão de Renovar / Mudar Plano (EXPLICITO) */}
              <button
                onClick={onOpenSubscription}
                className="w-full mt-2 bg-gradient-to-r from-emerald-500 to-emerald-600 hover:from-emerald-400 hover:to-emerald-500 text-white font-bold text-[10px] uppercase tracking-wide py-2 rounded-lg shadow-lg shadow-emerald-500/20 transition-all flex items-center justify-center gap-2"
              >
                <Crown size={12} />
                {isDesktopExpanded && <span>Mudar de Plano</span>}
              </button>
            </div>

            <div className="space-y-2">
              <button
                onClick={() => {
                  onOpenSettings();
                  onClose();
                }}
                className="flex items-center gap-3 px-3 py-2 w-full rounded-xl hover:bg-slate-800 transition-colors text-slate-400 hover:text-white"
                title={!isDesktopExpanded ? 'Configurações' : undefined}
              >
                <Settings className="w-5 h-5 shrink-0" />
                {isDesktopExpanded && (
                  <span className="text-sm whitespace-nowrap">Configurações</span>
                )}
              </button>
              <button
                onClick={async () => {
                  await onLogout();
                }}
                className="w-full flex items-center gap-3 px-4 py-3 text-slate-400 hover:bg-red-500/10 hover:text-red-500 transition-all rounded-xl group"
                title={!isDesktopExpanded ? 'Sair do Sistema' : undefined}
              >
                <X className="w-5 h-5 shrink-0" />
                {isDesktopExpanded && (
                  <span className="text-sm whitespace-nowrap">Sair do Sistema</span>
                )}
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Sidebar;
