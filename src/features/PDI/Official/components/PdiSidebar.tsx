import React from 'react';
import {
    LayoutDashboard,
    User,
    Stethoscope,
    Activity,
    Brain,
    MessageSquare,
    GraduationCap
} from 'lucide-react';

interface SidebarProps {
    activeSection: string;
    onSelectSection: (id: string) => void;
}

const MENU_ITEMS = [
    { id: 'institutional', label: 'I. Dados Institucionais', icon: LayoutDashboard },
    { id: 'student_data', label: 'II. Dados do Estudante', icon: User },
    // { id: 'responsibles', label: 'III. Responsáveis', icon: Users }, // Merged? Or separate? Schema has distinct?
    // Based on Schema 'student_data' covers basic. 
    // Let's stick to the high level Schema keys for now or logical groups.
    { id: 'clinical_health', label: 'IV/V. Dados Clínicos', icon: Stethoscope },
    { id: 'psychomotor', label: 'VI. Asp. Psicomotores', icon: Activity },
    { id: 'cognitive', label: 'VII. Asp. Cognitivos', icon: Brain },
    { id: 'communication', label: 'VIII. Comunicação', icon: MessageSquare },
    { id: 'teacher_evaluations', label: 'X. Avaliação Docente', icon: GraduationCap },
];

export const PdiSidebar: React.FC<SidebarProps> = ({ activeSection, onSelectSection }) => {
    return (
        <aside className="w-72 bg-slate-900 text-white flex flex-col h-full border-r border-slate-800">
            <div className="p-6 border-b border-slate-800">
                <div className="flex items-center gap-3">
                    <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                        <span className="font-black text-white text-xs">PDI</span>
                    </div>
                    <div>
                        <span className="block text-[10px] text-slate-400 uppercase tracking-widest font-bold">Módulo Gestor</span>
                        <span className="block font-bold">Navegação</span>
                    </div>
                </div>
            </div>

            <nav className="flex-1 overflow-y-auto py-6 px-4 space-y-1">
                {MENU_ITEMS.map((item) => {
                    const isActive = activeSection === item.id;
                    const Icon = item.icon;
                    return (
                        <button
                            key={item.id}
                            onClick={() => onSelectSection(item.id)}
                            className={`w-full flex items-center gap-3 px-4 py-3.5 rounded-xl transition-all group ${isActive
                                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-900/50'
                                    : 'text-slate-400 hover:bg-slate-800 hover:text-white'
                                }`}
                        >
                            <Icon className={`w-5 h-5 ${isActive ? 'text-white' : 'text-slate-500 group-hover:text-white transition-colors'}`} />
                            <span className="text-xs font-bold uppercase tracking-wide text-left leading-relaxed">
                                {item.label}
                            </span>
                            {isActive && (
                                <div className="ml-auto w-1.5 h-1.5 rounded-full bg-white animate-pulse" />
                            )}
                        </button>
                    );
                })}
            </nav>

            <div className="p-4 border-t border-slate-800">
                <div className="bg-slate-800/50 rounded-xl p-4">
                    <p className="text-[10px] text-slate-400 leading-relaxed text-center">
                        Preencha todas as seções obrigatórias para liberar a impressão final.
                    </p>
                </div>
            </div>
        </aside>
    );
};
