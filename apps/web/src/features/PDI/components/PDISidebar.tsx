import React from 'react';
import { FileDown, FileText } from 'lucide-react';

interface PDISidebarProps {
    studentsCount: number;
    adaptationsCount: number;
    pendingCount: number;
    completedCount: number;
    validatedCount: number;
    onExportDoc: () => void;
    onGenerateReport: () => void;
    hasAdaptations: boolean;
    error?: string;
}

const PDISidebar: React.FC<PDISidebarProps> = ({
    studentsCount,
    adaptationsCount,
    pendingCount,
    completedCount,
    validatedCount,
    onExportDoc,
    onGenerateReport,
    hasAdaptations,
    error
}) => {
    return (
        <div className="flex flex-col gap-6 animate-in slide-in-from-right duration-500">
            <div>
                <h3 className="text-xs font-black text-slate-900 uppercase tracking-tight mb-4">Comando Central</h3>

                <div className="space-y-3">
                    <button
                        onClick={onExportDoc}
                        disabled={!hasAdaptations}
                        className="w-full py-4 bg-slate-900 text-white rounded-2xl font-black text-[10px] uppercase tracking-widest shadow-xl shadow-slate-200 hover:bg-slate-800 active:scale-95 transition-all flex items-center justify-center gap-3 disabled:opacity-50"
                    >
                        <FileDown size={18} />
                        Gerar Documento (.DOC)
                    </button>

                    <button
                        onClick={onGenerateReport}
                        className="w-full py-4 bg-white text-teal-700 border-2 border-teal-100 rounded-2xl font-black text-[10px] uppercase tracking-widest hover:bg-teal-50 active:scale-95 transition-all flex items-center justify-center gap-3"
                    >
                        <FileText size={18} />
                        Relatório Bimestral
                    </button>
                </div>
            </div>

            <div className="bg-slate-50 rounded-2xl p-6 border border-slate-100 mt-auto">
                <h4 className="font-black text-[10px] text-slate-400 uppercase tracking-widest mb-4">Estatísticas DUA</h4>
                <div className="space-y-4">
                    <div className="flex justify-between items-center text-xs">
                        <span className="text-slate-500 font-bold">Alunos Monitorados</span>
                        <span className="font-black text-slate-900">{studentsCount}</span>
                    </div>
                    <div className="flex justify-between items-center text-xs">
                        <span className="text-slate-500 font-bold">Adaptações Geradas</span>
                        <span className="font-black text-teal-600">{adaptationsCount}</span>
                    </div>
                    <div className="h-px bg-slate-100" />
                    <div className="flex justify-between items-center text-[11px]">
                        <span className="text-slate-500 font-bold">Pendentes</span>
                        <span className="font-black text-slate-500">{pendingCount}</span>
                    </div>
                    <div className="flex justify-between items-center text-[11px]">
                        <span className="text-slate-500 font-bold">Em andamento</span>
                        <span className="font-black text-amber-600">{completedCount}</span>
                    </div>
                    <div className="flex justify-between items-center text-[11px]">
                        <span className="text-slate-500 font-bold">Concluídas</span>
                        <span className="font-black text-emerald-600">{validatedCount}</span>
                    </div>
                </div>
            </div>

            {error && (
                <div className="p-4 bg-red-50 text-red-600 rounded-xl text-[10px] font-bold border border-red-100">
                    {error}
                </div>
            )}
        </div>
    );
};

export default PDISidebar;
