
import React from 'react';
import { LayoutDashboard, BookOpen, PenTool, Accessibility, FileText, Settings, ShieldCheck, X, Crown, FolderClosed, Home, ChevronLeft, ChevronRight } from 'lucide-react';
import { ToolMode, UserRole } from '../types';

interface SidebarProps {
  activeMode: ToolMode;
  setActiveMode: (mode: ToolMode) => void;
  onOpenSettings: () => void;
  isOpen: boolean; // Controls mobile overlay
  onClose: () => void;
  userRole?: UserRole;
  isDesktopExpanded: boolean; // New prop: controls desktop width (expanded vs collapsed)
  onToggleDesktopExpand: () => void; // New prop: function to toggle desktop width
}

const Sidebar: React.FC<SidebarProps> = ({ 
  activeMode, 
  setActiveMode, 
  onOpenSettings, 
  isOpen, 
  onClose, 
  userRole,
  isDesktopExpanded, // Use this for desktop width
  onToggleDesktopExpand // Use this for desktop toggle
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
    // Only close the mobile sidebar on selection
    if (isOpen) {
      onClose(); 
    }
  };

  return (
    <>
      {isOpen && (
        <div 
          className="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-[60] lg:hidden"
          onClick={onClose}
        />
      )}
      
      <div 
        className={`bg-slate-900 h-screen text-slate-300 flex flex-col fixed left-0 top-0 z-[70] transition-all duration-300 
          ${isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'} 
          ${isDesktopExpanded ? 'lg:w-64' : 'lg:w-20'}
        `}
      >
        <div className="p-6 flex flex-col h-full">
          <div className="flex items-center justify-between mb-8 relative">
            <button 
              onClick={() => handleModeSelection(ToolMode.CHAT)}
              className="flex items-center gap-2 hover:opacity-80 transition-opacity text-left group overflow-hidden"
              style={{ width: isDesktopExpanded ? 'auto' : '24px' }} // Adjusted for icon only
            >
              <div className="bg-blue-600 p-2 rounded-lg group-hover:scale-110 transition-transform flex-shrink-0">
                <PenTool className="text-white w-6 h-6" />
              </div>
              {isDesktopExpanded && <h1 className="text-xl font-bold text-white tracking-tight flex-grow">PROFEPLAN</h1>}
            </button>
            <button onClick={onClose} className="lg:hidden p-1 text-slate-500 hover:text-white">
              <X className="w-6 h-6" />
            </button>
          </div>

          <nav className="space-y-1 flex-1 overflow-y-auto pr-2 scrollbar-hide">
            {menuItems.map((item) => (
              <button
                key={item.id}
                onClick={() => handleModeSelection(item.id)}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group 
                  ${activeMode === item.id 
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20 font-bold' 
                    : 'hover:bg-slate-800 hover:text-white'}
                  ${!isDesktopExpanded ? 'justify-center !px-2' : ''}
                `}
                title={!isDesktopExpanded ? item.label : ''} // Tooltip on collapsed state
              >
                <item.icon className={`w-5 h-5 flex-shrink-0 ${activeMode === item.id ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`} />
                {isDesktopExpanded && <span className="text-sm flex-grow">{item.label}</span>}
              </button>
            ))}

            {userRole === 'ADMIN' && (
              <div className="pt-4 mt-4 border-t border-slate-800">
                {isDesktopExpanded && <p className="text-[10px] font-bold text-slate-500 uppercase px-4 mb-2 tracking-widest">Administração</p>}
                <button
                  onClick={() => handleModeSelection(ToolMode.ADMIN)}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group 
                    ${activeMode === ToolMode.ADMIN 
                      ? 'bg-amber-600 text-white shadow-lg shadow-amber-600/20 font-bold' 
                      : 'hover:bg-slate-800 hover:text-white'}
                    ${!isDesktopExpanded ? 'justify-center !px-2' : ''}
                  `}
                  title={!isDesktopExpanded ? 'Painel de Controle' : ''}
                >
                  <Crown className={`w-5 h-5 flex-shrink-0 ${activeMode === ToolMode.ADMIN ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`} />
                  {isDesktopExpanded && <span className="text-sm flex-grow">Painel de Controle</span>}
                </button>
              </div>
            )}
          </nav>

          <div className="mt-6 pt-6 border-t border-slate-800 space-y-2">
            <button 
              onClick={() => { onOpenSettings(); onClose(); }}
              className={`flex items-center gap-3 px-4 py-3 w-full rounded-xl hover:bg-slate-800 transition-colors text-slate-400 hover:text-white
                ${!isDesktopExpanded ? 'justify-center !px-2' : ''}
              `}
              title={!isDesktopExpanded ? 'Configurações' : ''}
            >
              <Settings className="w-5 h-5 flex-shrink-0" />
              {isDesktopExpanded && <span className="text-sm flex-grow">Configurações</span>}
            </button>
            <button 
              onClick={() => {
                localStorage.removeItem('profeplan_session');
                window.location.reload();
              }}
              className={`flex items-center gap-3 px-4 py-3 w-full rounded-xl hover:bg-red-900/20 transition-colors text-slate-400 hover:text-red-400
                ${!isDesktopExpanded ? 'justify-center !px-2' : ''}
              `}
              title={!isDesktopExpanded ? 'Sair do Sistema' : ''}
            >
              <X className="w-5 h-5 flex-shrink-0" />
              {isDesktopExpanded && <span className="text-sm flex-grow">Sair do Sistema</span>}
            </button>
            {/* Toggle button for desktop sidebar expansion */}
            <button
              onClick={onToggleDesktopExpand}
              className={`hidden lg:flex p-3 w-full rounded-xl transition-colors text-slate-400 hover:text-white hover:bg-slate-800 mt-4 
                ${!isDesktopExpanded ? 'justify-center' : 'justify-end'}
              `}
              title={isDesktopExpanded ? 'Recolher menu' : 'Expandir menu'}
            >
              {isDesktopExpanded ? <ChevronLeft className="w-5 h-5" /> : <ChevronRight className="w-5 h-5" />}
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Sidebar;