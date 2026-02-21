

import React, { useState } from 'react';
import { Search, Loader2, Wand2, FileText, X, ArrowUpDown, Download, RefreshCw, CheckCircle2, BookOpen, Plus, CheckCircle } from 'lucide-react';
// 🏭 SIMULATION FACTORY - Módulo isolado (protegido de quebras externas)
import {
    questionBank,
    SimulationQuestion,
    exportSimulationToDocx,
    generateSimulationTitle,
    generateContentSummary,
    shuffleQuestions
} from '../../SimulationFactory';
import { hybridSearchProfeplan } from '../../../services/searchService';
import { savePlan, PlanFolder } from '../PlanningService';


interface SimulationWorkspaceProps {
    userId: string;
    termPlans: any[];
    selectedTermPlanId: string;
    settings: any;
}

export const SimulationWorkspace: React.FC<SimulationWorkspaceProps> = ({
    userId, termPlans, selectedTermPlanId, settings
}) => {
    // --- Simulation Mode State ---
    const [simMode, setSimMode] = useState<'manual' | 'mirror'>('manual');
    const [simSearchQuery, setSimSearchQuery] = useState('');
    const [simSearchResults, setSimSearchResults] = useState<any[]>([]);
    const [simCart, setSimCart] = useState<any[]>([]);
    const [simLoading, setSimLoading] = useState(false);
    const [simObservations, setSimObservations] = useState('');
    const [previewQuestion, setPreviewQuestion] = useState<SimulationQuestion | null>(null);

    // Areas Filter State
    const [selectedAreas, setSelectedAreas] = useState<string[]>([]);

    const toggleArea = (area: string) => {
        setSelectedAreas(prev =>
            prev.includes(area) ? prev.filter(a => a !== area) : [...prev, area]
        );
    };

    // --- Simulation Handlers ---
    const handleSimSearch = async () => {
        if (!simSearchQuery.trim()) return;
        setSimLoading(true);

        try {
            // 🏭 Usa QuestionBank isolado (protegido)
            const result = await questionBank.search({
                query: simSearchQuery,
                areas: selectedAreas,
                limit: 15
            });
            setSimSearchResults(result.questions || []);
        } catch (e) {
            console.error(e);
            alert('Erro na busca de questões');
        } finally {
            setSimLoading(false);
        }
    };

    const handleMirrorSearch = async () => {
        const plan = termPlans.find(p => p.id === selectedTermPlanId);
        if (!plan) {
            alert('Selecione um Planejamento Trimestral no topo primeiro!');
            return;
        }
        setSimLoading(true);
        try {
            const query = `Questões de ${plan.subject} sobre ${plan.grade} ${plan.period}º ${plan.regime}. Tópicos: ${plan.generatedText?.slice(0, 200) || ''}`;
            setSimSearchQuery(query);
            const results = await hybridSearchProfeplan({
                textoBusca: query,
                disciplina: plan.subject,
                limit: 15,
                matchThreshold: 0.5
            });
            setSimSearchResults(results || []);
        } catch (e) {
            console.error(e);
        } finally {
            setSimLoading(false);
        }
    };

    const handleAddToCart = (question: any) => {
        if (!simCart.find(q => q.id === question.id)) {
            setSimCart(prev => [...prev, question]);
        }
    };

    const handleRemoveFromCart = (id: any) => {
        setSimCart(prev => prev.filter(q => q.id !== id));
    };

    const handleSimAction = async (action: 'balance' | 'export_pdf' | 'export_word' | 'generate_ab') => {
        if (simCart.length === 0) return alert('Selecione questões primeiro!');

        if (action === 'balance') {
            alert('Para análise de equilíbrio, use o chat pedagógico principal. Esta função será migrada em breve.');
        } else if (action === 'export_word') {
            try {
                // 🏭 Usa funções isoladas do SimulationFactory
                const title = generateSimulationTitle('Simulado');
                const contentSummary = generateContentSummary(simCart as SimulationQuestion[]);

                await savePlan(userId, {
                    type: 'simulado',
                    title: title,
                    content: contentSummary,
                    createdAt: new Date().toISOString(),
                }, PlanFolder.SIMULADOS);

                await exportSimulationToDocx(
                    simCart as SimulationQuestion[],
                    simObservations,
                    'Versão Única',
                    settings
                );
            } catch (e: any) {
                alert(`Erro: ${e.message}`);
            }
        } else if (action === 'generate_ab') {
            try {
                // 🏭 Usa funções isoladas do SimulationFactory
                const title = generateSimulationTitle('Simulado_AB');
                const contentSummary = `Geração A/B com ${simCart.length} questões.`;

                await savePlan(userId, {
                    type: 'simulado',
                    title: title,
                    content: contentSummary,
                    createdAt: new Date().toISOString(),
                }, PlanFolder.SIMULADOS);

                await exportSimulationToDocx(
                    simCart as SimulationQuestion[],
                    simObservations,
                    'Versão A',
                    settings
                );

                const shuffled = shuffleQuestions(simCart as SimulationQuestion[]);
                setTimeout(async () => {
                    await exportSimulationToDocx(
                        shuffled,
                        simObservations,
                        'Versão B',
                        settings
                    );
                }, 1000);
            } catch (e: any) {
                alert(`Erro: ${e.message}`);
            }
        }
    };

    return (
        <div className="flex flex-col h-[100dvh] bg-slate-50 relative overflow-hidden">
            {/* Top: Sim History (Placeholder) */}
            <div className="h-20 bg-white border-b border-slate-200 flex items-center px-6 gap-4">
                <div className="flex items-center gap-2 opacity-50 pr-4 border-r border-slate-200">
                    <FileText size={20} className="text-slate-400" />
                    <span className="text-[10px] font-black uppercase text-slate-400 tracking-widest">Recentes</span>
                </div>
                <div className="flex gap-2 overflow-x-auto opacity-50">
                    <span className="text-xs text-slate-400 italic">Histórico de simulados em breve...</span>
                </div>
            </div>

            <div className="flex-1 flex overflow-hidden">
                {/* CENTER: Intelligence & Results */}
                <div className="flex-1 flex flex-col relative">
                    {/* Search Control */}
                    <div className="p-6 bg-white border-b border-slate-200 z-10 shadow-sm">
                        <div className="flex gap-4 mb-4">
                            <button onClick={() => setSimMode('manual')} className={`px-4 py-2 rounded-lg text-xs font-bold uppercase tracking-wide transition-all ${simMode === 'manual' ? 'bg-indigo-600 text-white shadow-md' : 'bg-slate-100 text-slate-500 hover:bg-slate-200'}`}>
                                Busca Manual e BNCC
                            </button>
                            <button onClick={() => setSimMode('mirror')} className={`px-4 py-2 rounded-lg text-xs font-bold uppercase tracking-wide transition-all ${simMode === 'mirror' ? 'bg-indigo-600 text-white shadow-md' : 'bg-slate-100 text-slate-500 hover:bg-slate-200'}`}>
                                Modo Espelho (Via Plano)
                            </button>

                        </div>

                        {/* Area Filters */}
                        {simMode === 'manual' && (
                            <div className="flex flex-wrap gap-3 mb-4 animate-in slide-in-from-top-2">
                                {['Linguagens', 'Matemática', 'Humanas', 'Natureza'].map(area => (
                                    <label key={area} className={`
                                        flex items-center gap-2 px-3 py-1.5 rounded-full border cursor-pointer select-none text-[10px] font-black uppercase tracking-wide transition-all
                                        ${selectedAreas.includes(area)
                                            ? 'bg-indigo-600 border-indigo-600 text-white shadow-sm'
                                            : 'bg-white border-slate-200 text-slate-400 hover:border-indigo-200'
                                        }
                                    `}>
                                        <input
                                            type="checkbox"
                                            className="hidden"
                                            checked={selectedAreas.includes(area)}
                                            onChange={() => toggleArea(area)}
                                        />
                                        {area}
                                    </label>
                                ))}
                            </div>
                        )}

                        <div className="flex gap-2">
                            <div className="relative flex-1">
                                <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                                <input
                                    type="text"
                                    value={simSearchQuery}
                                    onChange={(e) => setSimSearchQuery(e.target.value)}
                                    onKeyDown={(e) => e.key === 'Enter' && handleSimSearch()}
                                    placeholder={simMode === 'mirror' ? "Selecione um plano acima para espelhar..." : "Digite o tema, habilidade ou ano (ex: Equação 1º Grau)..."}
                                    className="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium outline-none focus:ring-2 focus:ring-indigo-100"
                                    disabled={simMode === 'mirror'}
                                />
                            </div>
                            {simMode === 'manual' ? (
                                <button onClick={handleSimSearch} disabled={simLoading} className="px-6 py-3 bg-indigo-600 text-white rounded-xl font-bold shadow-md hover:bg-indigo-700 disabled:opacity-50">
                                    {simLoading ? <Loader2 className="animate-spin" /> : 'Buscar'}
                                </button>
                            ) : (
                                <button onClick={handleMirrorSearch} disabled={simLoading || !selectedTermPlanId} className="px-6 py-3 bg-indigo-600 text-white rounded-xl font-bold shadow-md hover:bg-indigo-700 disabled:opacity-50 flex items-center gap-2">
                                    {simLoading ? <Loader2 className="animate-spin" /> : <><Wand2 size={18} /> Espelhar</>}
                                </button>
                            )}
                        </div>
                    </div>

                    {/* Results Grid */}
                    <div className="flex-1 overflow-y-auto p-6 bg-slate-50/50">
                        {simSearchResults.length === 0 ? (
                            <div className="h-full flex flex-col items-center justify-center opacity-30">
                                <Search size={48} className="mb-4 text-slate-300" />
                                <p className="font-medium text-slate-400">Realize uma busca para ver questões.</p>
                            </div>
                        ) : (
                            <div className="grid grid-cols-1 xl:grid-cols-2 gap-4">
                                {simSearchResults.map((q: any) => {
                                    // Metadata Access
                                    const discipline = q.metadata?.discipline || 'Geral';
                                    const source = 'ENEM/SAEB';
                                    const year = q.metadata?.year || '';
                                    const text = q.metadata?.alternativesIntroduction || q.metadata?.context || 'Visualizar questão completa...';

                                    return (
                                        <div key={q.id} className="bg-white p-4 rounded-xl border border-slate-200 hover:border-indigo-300 transition-all shadow-sm group">
                                            <div className="flex justify-between items-start mb-2">
                                                <div className="flex flex-wrap gap-2">
                                                    <span className="text-[10px] font-black uppercase text-indigo-500 bg-indigo-50 px-2 py-1 rounded">{discipline}</span>
                                                    <span className="text-[10px] font-bold text-slate-400">{year} • {source}</span>
                                                </div>
                                                <button onClick={() => setPreviewQuestion(q as SimulationQuestion)} className="text-slate-300 hover:text-indigo-500 transition-colors">
                                                    <BookOpen size={18} />
                                                </button>
                                            </div>
                                            <div
                                                className="cursor-pointer"
                                                onClick={() => setPreviewQuestion(q as SimulationQuestion)}
                                            >
                                                <p className="text-sm text-slate-700 mb-4 line-clamp-3 leading-relaxed">{text}</p>
                                            </div>
                                            <button
                                                onClick={() => handleAddToCart(q)}
                                                className="w-full py-2 bg-slate-50 hover:bg-slate-100 text-slate-600 hover:text-indigo-600 rounded-lg text-xs font-bold uppercase tracking-wide flex items-center justify-center gap-2 transition-colors border border-transparent hover:border-indigo-200"
                                            >
                                                <CheckCircle2 size={14} /> Adicionar
                                            </button>
                                        </div>
                                    )
                                })}
                            </div>
                        )}
                    </div>

                    {/* Footer Controls */}
                    <div className="p-4 bg-white border-t border-slate-200 flex gap-4 items-center">
                        <textarea
                            value={simObservations}
                            onChange={(e) => setSimObservations(e.target.value)}
                            placeholder="Cabeçalho e Instruções (ex: Escola Profeplan, Valor 10pts...)"
                            className="flex-1 h-14 py-2 px-3 bg-slate-50 rounded-lg text-xs border border-slate-200 resize-none outline-none focus:ring-1 focus:ring-indigo-200 custom-scrollbar"
                        />
                        <div className="flex gap-2">
                            <button onClick={() => handleSimAction('balance')} className="px-3 py-2 bg-amber-50 text-amber-700 hover:bg-amber-100 rounded-lg text-[10px] font-black uppercase tracking-wider flex flex-col items-center gap-1 min-w-[4.5rem] transition-colors">
                                <ArrowUpDown size={14} /> Equilibrar
                            </button>
                            <button onClick={() => handleSimAction('export_word')} className="px-3 py-2 bg-blue-50 text-blue-700 hover:bg-blue-100 rounded-lg text-[10px] font-black uppercase tracking-wider flex flex-col items-center gap-1 min-w-[4.5rem] transition-colors">
                                <Download size={14} /> Word
                            </button>
                            <button onClick={() => handleSimAction('generate_ab')} className="px-3 py-2 bg-indigo-50 text-indigo-700 hover:bg-indigo-100 rounded-lg text-[10px] font-black uppercase tracking-wider flex flex-col items-center gap-1 min-w-[4.5rem] transition-colors" title="Gerar Prova A e B (Embaralhada)">
                                <RefreshCw size={14} /> Versão A/B
                            </button>
                        </div>
                    </div>
                </div>

                {/* RIGHT: Selection Cart */}
                <div className="w-80 border-l border-slate-200 bg-white h-full overflow-hidden flex flex-col shadow-xl z-20">
                    <div className="p-4 border-b border-slate-100 bg-slate-50 flex justify-between items-center">
                        <h3 className="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Minha Seleção</h3>
                        <span className="bg-indigo-100 text-indigo-700 text-[10px] font-bold px-2 py-0.5 rounded-full">{simCart.length} itens</span>
                    </div>
                    <div className="flex-1 overflow-y-auto custom-scrollbar p-2 space-y-2">
                        {simCart.length === 0 ? (
                            <div className="p-6 text-center opacity-40">
                                <FileText size={32} className="mx-auto mb-2 text-slate-300" />
                                <p className="text-xs text-slate-400">Adicione questões para montar o simulado.</p>
                            </div>
                        ) : (
                            simCart.map((q, idx) => (
                                <div key={q.id} className="bg-slate-50 border border-slate-200 p-3 rounded-lg group animate-in slide-in-from-right-2">
                                    <div className="flex justify-between items-start">
                                        <span className="text-[10px] font-bold text-slate-500">#{idx + 1}</span>
                                        <button onClick={() => handleRemoveFromCart(q.id)} className="text-slate-300 hover:text-red-400"><X size={14} /></button>
                                    </div>
                                    <p className="text-xs text-slate-700 mt-1 line-clamp-2">{q.metadata?.alternativesIntroduction || q.metadata?.context}</p>
                                </div>
                            ))
                        )}
                    </div>
                    <div className="p-4 border-t border-slate-100">
                        <div className="text-[10px] font-bold text-slate-400 text-center uppercase tracking-wider">Arraste para reordenar (Em breve)</div>
                    </div>
                </div>
            </div>

            {/* --- MODAL DE PRÉ-VISUALIZAÇÃO --- */}
            {
                previewQuestion && (
                    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm p-4 animate-in fade-in duration-200">
                        <div className="absolute inset-0" onClick={() => setPreviewQuestion(null)}></div>
                        <div className="bg-white rounded-xl shadow-2xl w-full max-w-2xl max-h-[90vh] flex flex-col relative z-10 animate-in zoom-in-95 duration-200 overflow-hidden">
                            <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between bg-slate-50/50">
                                <div className="flex items-center gap-3">
                                    <div className="p-2 bg-indigo-100 text-indigo-600 rounded-lg">
                                        <BookOpen size={18} />
                                    </div>
                                    <div>
                                        <h3 className="text-sm font-bold text-slate-900 flex items-center gap-2">
                                            Questão #{previewQuestion.id}
                                            <span className="text-[10px] bg-slate-200 text-slate-600 px-1.5 py-0.5 rounded-full font-normal">
                                                {previewQuestion.metadata?.year}
                                            </span>
                                        </h3>
                                        <p className="text-xs text-slate-500">{previewQuestion.metadata?.discipline}</p>
                                    </div>
                                </div>
                                <button onClick={() => setPreviewQuestion(null)} className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-full transition-all">
                                    <X size={20} />
                                </button>
                            </div>

                            <div className="p-5 overflow-y-auto custom-scrollbar flex-1 bg-white">
                                {/* Enunciado (Contexto + Comando) */}
                                <div className="mb-6 space-y-4">
                                    <p className="text-slate-800 text-sm leading-relaxed whitespace-pre-line">
                                        {previewQuestion.metadata?.context}
                                    </p>
                                    <p className="text-slate-900 font-medium text-sm">
                                        {previewQuestion.metadata?.alternativesIntroduction}
                                    </p>
                                </div>

                                {/* Alternativas */}
                                <div className="space-y-2">
                                    <h4 className="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-2">Alternativas</h4>
                                    {previewQuestion.metadata?.alternatives?.map((alt) => {
                                        const isCorrect = alt.isCorrect;
                                        return (
                                            <div
                                                key={alt.letter}
                                                className={`flex gap-3 p-3 rounded-lg border text-sm transition-all ${isCorrect
                                                    ? 'bg-emerald-50 border-emerald-200 text-emerald-900 shadow-sm ring-1 ring-emerald-100'
                                                    : 'bg-white border-slate-200 text-slate-600'
                                                    }`}
                                            >
                                                <div className={`
                                                w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold shrink-0
                                                ${isCorrect ? 'bg-emerald-200 text-emerald-800' : 'bg-slate-100 text-slate-500'}
                                            `}>
                                                    {alt.letter}
                                                </div>
                                                <div className="flex-1 pt-0.5">
                                                    {alt.text}
                                                </div>
                                                {isCorrect && <CheckCircle size={18} className="text-emerald-500 shrink-0" />}
                                            </div>
                                        );
                                    })}
                                </div>

                                {/* Metadados Adicionais */}
                                <div className="mt-6 pt-4 border-t border-slate-100 grid grid-cols-2 gap-4 text-xs text-slate-500">
                                    <div>
                                        <span className="font-bold text-slate-700 block mb-1">BNCC</span>
                                        {previewQuestion.metadata?.bncc?.join(', ') || 'N/A'}
                                    </div>
                                    <div>
                                        <span className="font-bold text-slate-700 block mb-1">Tags</span>
                                        {previewQuestion.metadata?.tags?.join(', ') || 'N/A'}
                                    </div>
                                </div>
                            </div>

                            <div className="p-4 border-t border-slate-100 bg-slate-50/50 flex justify-end gap-3 z-20">
                                <button onClick={() => setPreviewQuestion(null)} className="px-4 py-2 text-sm font-bold text-slate-600 hover:text-slate-800 hover:bg-slate-200 rounded-lg transition-colors">
                                    Fechar
                                </button>
                                <button onClick={() => { handleAddToCart(previewQuestion); setPreviewQuestion(null); }} className="px-4 py-2 text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 rounded-lg shadow-sm hover:shadow hover:-translate-y-0.5 transition-all flex items-center gap-2">
                                    <Plus size={16} /> Adicionar
                                </button>
                            </div>
                        </div>
                    </div>
                )
            }
        </div >
    );
};
