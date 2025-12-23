
import React from 'react';
import { LayoutDashboard, BookOpen, PenTool, Accessibility, FileText, Settings, ShieldCheck, X, Crown, FolderClosed, Home } from 'lucide-react';
import { ToolMode, UserRole } from '../types';

interface SidebarProps {
  activeMode: ToolMode;
  setActiveMode: (mode: ToolMode) => void;
  onOpenSettings: () => void;
  isOpen: boolean;
  onClose: () => void;
  userRole?: UserRole;
}

const Sidebar: React.FC<SidebarProps> = ({ activeMode, setActiveMode, onOpenSettings, isOpen, onClose, userRole }) => {
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
      
      <div className={`w-64 bg-slate-900 h-screen text-slate-300 flex flex-col fixed left-0 top-0 z-[70] transition-transform duration-300 transform ${
        isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
      }`}>
        <div className="p-6 flex flex-col h-full">
          <div className="flex items-center justify-between mb-8">
            <button 
              onClick={() => handleModeSelection(ToolMode.CHAT)}
              className="flex items-center gap-2 hover:opacity-80 transition-opacity text-left group"
            >
              <div className="bg-blue-600 p-2 rounded-lg group-hover:scale-110 transition-transform">
                <PenTool className="text-white w-6 h-6" />
              </div>
              <h1 className="text-xl font-bold text-white tracking-tight">PROFEPLAN</h1>
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
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
                  activeMode === item.id 
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20 font-bold' 
                    : 'hover:bg-slate-800 hover:text-white'
                }`}
              >
                <item.icon className={`w-5 h-5 ${activeMode === item.id ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`} />
                <span className="text-sm">{item.label}</span>
              </button>
            ))}

            {userRole === 'ADMIN' && (
              <div className="pt-4 mt-4 border-t border-slate-800">
                <p className="text-[10px] font-bold text-slate-500 uppercase px-4 mb-2 tracking-widest">Administração</p>
                <button
                  onClick={() => handleModeSelection(ToolMode.ADMIN)}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${
                    activeMode === ToolMode.ADMIN 
                      ? 'bg-amber-600 text-white shadow-lg shadow-amber-600/20 font-bold' 
                      : 'hover:bg-slate-800 hover:text-white'
                  }`}
                >
                  <Crown className={`w-5 h-5 ${activeMode === ToolMode.ADMIN ? 'text-white' : 'text-slate-500 group-hover:text-slate-300'}`} />
                  <span className="text-sm">Painel de Controle</span>
                </button>
              </div>
            )}
          </nav>

          <div className="mt-6 pt-6 border-t border-slate-800 space-y-2">
            <button 
              onClick={() => { onOpenSettings(); onClose(); }}
              className="flex items-center gap-3 px-4 py-3 w-full rounded-xl hover:bg-slate-800 transition-colors text-slate-400 hover:text-white"
            >
              <Settings className="w-5 h-5" />
              <span className="text-sm">Configurações</span>
            </button>
            <button 
              onClick={() => {
                localStorage.removeItem('profeplan_session');
                window.location.reload();
              }}
              className="flex items-center gap-3 px-4 py-3 w-full rounded-xl hover:bg-red-900/20 transition-colors text-slate-400 hover:text-red-400"
            >
              <X className="w-5 h-5" />
              <span className="text-sm">Sair do Sistema</span>
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Sidebar;
