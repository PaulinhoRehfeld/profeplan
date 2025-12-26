
import React from 'react';
import { LayoutDashboard, BookOpen, PenTool, Accessibility, FileText, Settings, ShieldCheck, X, Crown, FolderClosed, Home, ChevronLeft, ChevronRight } from 'lucide-react';
import { ToolMode, UserRole } from '../types';

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
}

const Sidebar: React.FC<SidebarProps> = ({ 
  activeMode, 
  setActiveMode, 
  onOpenSettings, 
  isOpen, 
  onClose, 
  userRole,
  isDesktopExpanded = true,
  onToggleDesktopExpand
}) => {
  const menuItems = [
    { id: ToolMode.CHAT, icon: Home, label: 'Início (Assistente)' },
    { id: ToolMode.PLANNING, icon: LayoutDashboard, label: 'Planejamento' },
    { id: ToolMode.FILES, icon: FolderClosed, label: 'Meus Arquivos' },
    { id: ToolMode.AUDITOR, icon: ShieldCheck, label: 'Auditor BNCC' },
    { id: ToolMode.ACTIVITIES, icon: BookOpen, label: 'Atividades e Projetos' },
    { id: ToolMode.INCLUSION, icon: Accessibility, label: 'Adaptação PDI/DUA' },
    { id: ToolMode.SIMULATION, icon: FileText, label: 'Simulados ENEM/Saeb' },
  ];

  const handleModeSelection = (mode: ToolMode) => {
    setActiveMode(mode);
    onClose();
  };

  return (
    <>
      {isOpen && (
        <div 
          className="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-[60] lg:hidden"
          onClick={onClose}
        />
      )}
      
      {/* Adjusted width based on expansion state */}
      <div className={`${isDesktopExpanded ? 'w-64' : 'w-20'} bg-slate-900 h-screen text-slate-300 flex flex-col fixed left-0 top-0 z-[70] transition-all duration-300 transform ${
        isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
      }`}>
        <div className="p-6 flex flex-col h-full overflow-hidden">
          <div className="flex items-center justify-between mb-8">
            <button 
              onClick={() => handleModeSelection(ToolMode.CHAT)}
              className="flex items-center gap-2 hover:opacity-80 transition-opacity text-left group overflow-hidden"
            >
              <div className="bg-blue-600 p-2 rounded-lg group-hover:scale-110 transition-transform shrink-0">
                <PenTool className="text-white w-6 h-6" />
              </div>
              {/* Only show title when expanded */}
              {isDesktopExpanded && (
                <h1 className="text-xl font-bold text-white tracking-tight whitespace-nowrap">PROFEPLAN</h1>
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
                title={isDesktopExpanded ? "Recolher menu" : "Expandir menu"}
              >
                {isDesktopExpanded ? <ChevronLeft className="w-6 h-6" /> : <ChevronRight className="w-6 h-6" />}
              </button>
            </div>
          </div>

          <nav className="space-y-1 flex-1 overflow-y-auto pr-2 scrollbar-hide">
            {menuItems.map((item) => (
              <button
                key={item.id}
                onClick={() => handleModeSelection(item.id)}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
                  activeMode === item.id 
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20 font-bold' 
                    : 'hover:bg-slate-800 hover:text-white'
                }`}
                title={!isDesktopExpanded ? item.label : undefined}
              >
                <item.icon className={`w-5 h-5 shrink-0 ${activeMode === item.id ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`} />
                {isDesktopExpanded && <span className="text-sm whitespace-nowrap">{item.label}</span>}
              </button>
            ))}

            {userRole === 'ADMIN' && (
              <div className="pt-4 mt-4 border-t border-slate-800">
                {isDesktopExpanded && (
                  <p className="text-[10px] font-bold text-slate-500 uppercase px-4 mb-2 tracking-widest whitespace-nowrap">Administração</p>
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
                  <Crown className={`w-5 h-5 shrink-0 ${activeMode === ToolMode.ADMIN ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`} />
                  {isDesktopExpanded && <span className="text-sm whitespace-nowrap">Painel de Controle</span>}
                </button>
              </div>
            )}
          </nav>

          <div className="mt-6 pt-6 border-t border-slate-800 space-y-2">
            <button 
              onClick={() => { onOpenSettings(); onClose(); }}
              className="flex items-center gap-3 px-4 py-3 w-full rounded-xl hover:bg-slate-800 transition-colors text-slate-400 hover:text-white"
              title={!isDesktopExpanded ? 'Configurações' : undefined}
            >
              <Settings className="w-5 h-5 shrink-0" />
              {isDesktopExpanded && <span className="text-sm whitespace-nowrap">Configurações</span>}
            </button>
            <button 
              onClick={() => {
                localStorage.removeItem('profeplan_session');
                window.location.reload();
              }}
              className="flex items-center gap-3 px-4 py-3 w-full rounded-xl hover:bg-red-900/20 transition-colors text-slate-400 hover:text-red-400"
              title={!isDesktopExpanded ? 'Sair do Sistema' : undefined}
            >
              <X className="w-5 h-5 shrink-0" />
              {isDesktopExpanded && <span className="text-sm whitespace-nowrap">Sair do Sistema</span>}
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Sidebar;
