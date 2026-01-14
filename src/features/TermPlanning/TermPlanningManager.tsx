import React, { useState, useEffect } from 'react';
import { Save, FileText, Calendar, BookOpen, Clock, Target, CheckCircle2, Sparkles } from 'lucide-react';
import { useGlobalPlanning, TermPlan } from '../../contexts/GlobalPlanningContext';
import { saveTermPlan } from './TermPlanningService';
import { exportToDocx } from '../../services/exportService';
import { generateTermPlan } from '../../services/geminiService';

interface TermPlanningManagerProps {
    userId: string;
    settings: any;
    setSidebarContent?: (content: React.ReactNode) => void;
}

const TermPlanningManager: React.FC<TermPlanningManagerProps> = ({ userId, settings, setSidebarContent }) => {
    const { updateCurrentPlan } = useGlobalPlanning();
    const [isSaving, setIsSaving] = useState(false);

    // AI Generation
    const [stateBase, setStateBase] = useState('Minas Gerais');
    const [educationSphere, setEducationSphere] = useState('Estadual');
    const [generatedText, setGeneratedText] = useState('');
    const [isGenerating, setIsGenerating] = useState(false);

    // Form State
    const [period, setPeriod] = useState<number>(1);
    const [regime, setRegime] = useState<'Bimestre' | 'Trimestre'>('Bimestre');
    const [subject, setSubject] = useState('');
    const [grade, setGrade] = useState('');
    const [level, setLevel] = useState<'Ensino Fundamental' | 'Ensino Médio'>('Ensino Médio');
    const [workloadWeekly, setWorkloadWeekly] = useState<number>(2);

    // Reserves
    const [reserves, setReserves] = useState({
        monthlyExam: true,
        bimonthlyExam: true,
        recovery: true
    });

    // Grading
    const [grading, setGrading] = useState({
        vistos: 10,
        trabalhos: 20,
        monthlyExam: 30,
        bimonthlyExam: 40,
        others: 0
    });

    // Calculated
    const totalClasses = workloadWeekly * (regime === 'Bimestre' ? 9 : 12); // Approx: 9 weeks bi, 12 weeks tri

    // Disable sidebar on mount (Full Width Mode)
    useEffect(() => {
        if (setSidebarContent) setSidebarContent(null);
    }, [setSidebarContent]);

    const handleGenerate = async () => {
        if (!subject || !grade) return alert('Preencha a Matéria e a Série antes de gerar.');
        setIsGenerating(true);
        try {
            const text = await generateTermPlan({
                subject,
                grade,
                period,
                regime,
                stateBase,
                educationSphere,
                teacherName: settings.userName || 'Professor(a)',
                totalClasses,
                reserves,
                userId: userId // Pass userId for quota check
            });
            setGeneratedText(text);
        } catch (e) {
            alert('Erro ao gerar planejamento: ' + e);
        } finally {
            setIsGenerating(false);
        }
    };

    const handleSave = async () => {
        if (!subject || !grade) return alert('Preencha a Matéria e a Série.');

        setIsSaving(true);
        const plan: TermPlan = {
            id: `temp_${Date.now()}`,
            created_at: new Date().toISOString(),
            period,
            regime,
            subject,
            grade,
            level,
            workloadWeekly,
            reserves,
            totalClasses,
            gradingGrid: grading,
            stateBase,
            educationSphere,
            generatedText
        };

        try {
            // 1. Update Global Context (Coordinator Agent)
            updateCurrentPlan(plan);

            // 2. Persist Structure (For Planning Tool)
            await saveTermPlan(userId, plan);

            // 3. Persist to Memory/Files (For History & Drive)
            if (generatedText) {
                const { saveGeneratedContent } = await import('../../services/databaseService');
                const title = `Planejamento ${period}º ${regime} - ${subject} (${grade})`;
                await saveGeneratedContent(userId, 'trimestral', title, generatedText);
            }

            alert('✅ Planejamento Salvo e Sincronizado com Sucesso!');
        } catch (e) {
            console.error(e);
            alert('Erro ao salvar.');
        } finally {
            setIsSaving(false);
        }
    };



    const handleExport = async () => {
        const title = `Planejamento_${period}${regime}_${subject}`;
        let content = '';

        if (generatedText) {
            content = generatedText;
        } else {
            const totalPoints = Object.values(grading).reduce((a: number, b: number) => a + b, 0);
            content = `
# PLANEJAMENTO DE ENSINO - ${period}º ${regime.toUpperCase()}

**Disciplina:** ${subject}
**Série:** ${grade} (${level})
**Carga Horária Semanal:** ${workloadWeekly} aulas
**Total Previsto:** ${totalClasses} aulas
**Base:** ${stateBase} (${educationSphere})

## RESERVA DE DATAS
${reserves.monthlyExam ? '- [x] Prova Mensal' : '- [ ] Prova Mensal'}
${reserves.bimonthlyExam ? `- [x] Prova ${regime}` : `- [ ] Prova ${regime}`}
${reserves.recovery ? '- [x] Recuperação' : '- [ ] Recuperação'}

## DISTRIBUIÇÃO DE PONTOS
| Instrumento | Valor |
|-------------|-------|
| Vistos / Participação | ${grading.vistos} |
| Trabalhos / Pesquisas | ${grading.trabalhos} |
| Avaliação Mensal | ${grading.monthlyExam} |
| Avaliação ${regime} | ${grading.bimonthlyExam} |
| Outros | ${grading.others} |
| **TOTAL** | **${totalPoints}** |

***
*Documento gerado automaticamente pelo PROFEPLAN*
            `;
        }

        await exportToDocx(content, title, settings);
    };

    return (
        <div className="max-w-5xl mx-auto p-4 md:p-6 space-y-6 md:space-y-8 animate-in fade-in duration-500 pb-24">

            {/* Header */}
            <div className="text-center space-y-2">
                <h1 className="text-2xl font-black text-slate-800 tracking-tight uppercase italic relative inline-block">
                    Agente Coordenador
                    <div className="absolute -bottom-2 left-0 w-full h-1 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full"></div>
                </h1>
                <p className="text-slate-500 font-medium">Defina o contexto global para o período letivo.</p>
            </div>

            {/* Main Form Card */}
            <div className="bg-white rounded-[2rem] shadow-xl border border-slate-100 p-4 md:p-6 grid grid-cols-1 lg:grid-cols-2 gap-6 relative overflow-hidden">
                <div className="absolute top-0 right-0 w-64 h-64 bg-slate-50 rounded-full -translate-y-1/2 translate-x-1/2 blur-3xl -z-10"></div>

                {/* Left Col: Contexto */}
                <div className="space-y-8">
                    <div className="flex items-center gap-3 text-blue-600 mb-2">
                        <BookOpen className="w-6 h-6" />
                        <h2 className="font-black uppercase tracking-widest text-sm">Contexto do Período</h2>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <label className="text-xs font-bold text-slate-400 uppercase">Regime</label>
                            <div className="flex bg-slate-100 p-1 rounded-xl">
                                {['Bimestre', 'Trimestre'].map((r) => (
                                    <button
                                        key={r}
                                        onClick={() => setRegime(r as any)}
                                        className={`flex-1 py-2 text-xs font-bold uppercase rounded-lg transition-all ${regime === r ? 'bg-white shadow text-blue-600' : 'text-slate-400 hover:text-slate-600'}`}
                                    >
                                        {r}
                                    </button>
                                ))}
                            </div>
                        </div>

                        <div className="space-y-2">
                            <label className="text-xs font-bold text-slate-400 uppercase">Período</label>
                            <div className="flex gap-2">
                                {[1, 2, 3, 4].map((p) => (
                                    <button
                                        key={p}
                                        onClick={() => setPeriod(p)}
                                        className={`w-10 h-10 rounded-xl font-black text-sm transition-all ${period === p ? 'bg-blue-600 text-white shadow-lg shadow-blue-200' : 'bg-slate-50 text-slate-400 hover:bg-slate-100'}`}
                                    >
                                        {p}º
                                    </button>
                                ))}
                            </div>
                        </div>
                    </div>

                    <div className="space-y-2">
                        <label className="text-xs font-bold text-slate-400 uppercase">Disciplina</label>
                        <input
                            type="text" value={subject} onChange={e => setSubject(e.target.value)}
                            className="w-full p-3 bg-slate-50 border-none rounded-xl font-bold text-slate-700 focus:ring-2 focus:ring-blue-100"
                            placeholder="Ex: Filosofia"
                        />
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <label className="text-xs font-bold text-slate-400 uppercase">Série</label>
                            <input
                                type="text" value={grade} onChange={e => setGrade(e.target.value)}
                                className="w-full p-3 bg-slate-50 border-none rounded-xl font-bold text-slate-700 focus:ring-2 focus:ring-blue-100"
                                placeholder="Ex: 3º Ano"
                            />
                        </div>
                        <div className="space-y-2">
                            <label className="text-xs font-bold text-slate-400 uppercase">Nível</label>
                            <select
                                value={level} onChange={e => setLevel(e.target.value as any)}
                                className="w-full p-3 bg-slate-50 border-none rounded-xl font-bold text-slate-700 outline-none"
                            >
                                <option>Ensino Médio</option>
                                <option>Ensino Fundamental</option>
                            </select>
                        </div>
                    </div>
                </div>

                {/* Right Col: Carga e Avaliação */}
                <div className="space-y-8">
                    <div className="flex items-center gap-3 text-purple-600 mb-2">
                        <Target className="w-6 h-6" />
                        <h2 className="font-black uppercase tracking-widest text-sm">Metas e Avaliação</h2>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <label className="text-xs font-bold text-slate-400 uppercase">Aulas Semanais</label>
                            <input
                                type="number" value={workloadWeekly} onChange={e => setWorkloadWeekly(Number(e.target.value))}
                                className="w-full p-3 bg-slate-50 border-none rounded-xl font-mono font-bold text-slate-700"
                            />
                        </div>
                        <div className="space-y-2 opacity-70">
                            <label className="text-xs font-bold text-slate-400 uppercase">Total Período (Est.)</label>
                            <div className="w-full p-3 bg-slate-100 border-none rounded-xl font-mono font-bold text-slate-500">
                                {totalClasses} aulas
                            </div>
                        </div>
                    </div>

                    <div className="space-y-3">
                        <label className="text-xs font-bold text-slate-400 uppercase">Reservas de Calendário</label>
                        <div className="flex flex-col md:flex-row gap-4">
                            {[
                                { k: 'monthlyExam', label: 'Prova Mensal' },
                                { k: 'bimonthlyExam', label: `Prova ${regime}` },
                                { k: 'recovery', label: 'Recuperação' }
                            ].map(({ k, label }) => (
                                <label key={k} className="flex items-center gap-2 cursor-pointer group">
                                    <div className={`w-5 h-5 rounded-md border-2 flex items-center justify-center transition-all ${reserves[k as keyof typeof reserves] ? 'bg-purple-600 border-purple-600' : 'border-slate-300 group-hover:border-purple-300'}`}>
                                        {reserves[k as keyof typeof reserves] && <CheckCircle2 size={12} className="text-white" />}
                                    </div>
                                    <input
                                        type="checkbox" className="hidden"
                                        checked={reserves[k as keyof typeof reserves]}
                                        onChange={() => setReserves(prev => ({ ...prev, [k]: !prev[k as keyof typeof reserves] }))}
                                    />
                                    <span className="text-xs font-bold text-slate-600">{label}</span>
                                </label>
                            ))}
                        </div>
                    </div>

                    <div className="bg-slate-50 rounded-2xl p-5 border border-slate-100">
                        <label className="text-xs font-bold text-slate-400 uppercase mb-4 block">Grade de Distribuição (Total: {Object.values(grading).reduce((a: number, b: number) => a + b, 0)})</label>
                        <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                            {Object.entries(grading).map(([key, val]) => (
                                <div key={key}>
                                    <span className="text-[10px] font-bold uppercase text-slate-400 block mb-1">
                                        {key === 'bimonthlyExam' ? `Prova ${regime}` : key === 'monthlyExam' ? 'Prova Mensal' : key}
                                    </span>
                                    <input
                                        type="number" value={val}
                                        onChange={e => setGrading(prev => ({ ...prev, [key]: Number(e.target.value) }))}
                                        className="w-full p-2 rounded-lg bg-white border border-slate-200 text-center font-bold text-sm"
                                    />
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            </div>

            {/* AI Generation Result */}
            <div className="bg-white rounded-[2rem] shadow-xl border border-indigo-100 p-4 md:p-6 relative overflow-hidden">
                <div className="flex items-center justify-between mb-6">
                    <div className="flex items-center gap-3 text-indigo-600">
                        <Sparkles className="w-6 h-6 animate-pulse" />
                        <h2 className="font-black uppercase tracking-widest text-sm">Agente de Planejamento IA</h2>
                    </div>

                    <button
                        onClick={handleGenerate}
                        disabled={isGenerating}
                        className="px-6 py-3 bg-indigo-600 text-white rounded-xl font-bold text-xs uppercase tracking-widest flex items-center gap-2 hover:bg-indigo-700 transition-all shadow-lg hover:shadow-indigo-200 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        {isGenerating ? <Clock className="animate-spin" size={16} /> : <Sparkles size={16} />}
                        Gerar Planejamento Completo
                    </button>
                </div>

                <div className="relative">
                    {generatedText ? (
                        <textarea
                            value={generatedText}
                            onChange={(e) => setGeneratedText(e.target.value)}
                            className="w-full h-96 p-6 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-medium text-slate-700 focus:ring-2 focus:ring-indigo-100 outline-none resize-y leading-relaxed"
                            placeholder="O planejamento gerado aparecerá aqui..."
                        />
                    ) : (
                        <div className="w-full h-32 bg-slate-50 border border-dashed border-slate-300 rounded-2xl flex flex-col items-center justify-center text-slate-400">
                            <Sparkles className="mb-2 opacity-50" />
                            <p className="text-xs font-bold uppercase tracking-widest">Preencha os dados acima e clique em Gerar</p>
                        </div>
                    )}
                </div>
            </div>

            {/* Actions */}
            <div className="flex flex-col md:flex-row gap-4 justify-end pt-6 md:pt-0">
                <button
                    onClick={handleExport}
                    className="w-full md:w-auto px-8 py-4 bg-white border border-slate-200 text-slate-600 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-slate-50 transition-all shadow-sm"
                >
                    <FileText size={18} /> Gerar Documento Word
                </button>

                <button
                    onClick={handleSave}
                    disabled={isSaving}
                    className="w-full md:w-auto px-10 py-4 bg-gradient-to-br from-blue-600 to-indigo-700 text-white rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 shadow-xl hover:shadow-blue-200 hover:scale-105 active:scale-95 transition-all disabled:opacity-70 disabled:scale-100"
                >
                    {isSaving ? <Clock className="animate-spin" /> : <Save size={18} />}
                    Salvar Planejamento
                </button>
            </div>

        </div>
    );
};

export default TermPlanningManager;
