import React, { useState, useEffect } from 'react';
import { supabase } from '../../../services/supabaseClient';
import { BrainCircuit, BookOpen, GraduationCap, FileText, CheckCircle2, Save, Printer } from 'lucide-react';

interface PDIConsolidatorProps {
    studentId: string;
    studentName: string;
    onClose?: () => void;
}

export const PDIConsolidator: React.FC<PDIConsolidatorProps> = ({ studentId, studentName, onClose }) => {
    const [loading, setLoading] = useState(false);
    const [generating, setGenerating] = useState(false);

    // DATA STATE
    const [profileData, setProfileData] = useState<any>(null);
    const [evaluations, setEvaluations] = useState<any[]>([]);
    const [adaptationCount, setAdaptationCount] = useState(0);
    const [finalReport, setFinalReport] = useState('');
    const [pdiCycleId, setPdiCycleId] = useState<string | null>(null);

    useEffect(() => {
        loadConsolidatedData();
    }, [studentId]);

    const loadConsolidatedData = async () => {
        setLoading(true);
        try {
            // 0. Resolve IDs (App ID vs PDI ID)
            const { data: studentMap, error: mapError } = await supabase
                .from('students')
                .select('school_student_id')
                .eq('id', studentId)
                .single();

            if (mapError) console.warn("Could not resolve PDI ID:", mapError);
            const pdiId = studentMap?.school_student_id;

            // 1. Fetch Profile (JSONB)
            let pdiData = {};
            if (pdiId) {
                const { data: student } = await supabase
                    .from('school_students')
                    .select('pdi_data')
                    .eq('id', pdiId) // Use PDI ID
                    .maybeSingle(); // Use maybeSingle to avoid crash
                pdiData = student?.pdi_data || {};
            }
            setProfileData(pdiData);

            // 2. Fetch Cycle (Current Year)
            const currentYear = new Date().getFullYear();
            const { data: cycle } = await supabase
                .from('pdi_cycles')
                .select('id, final_report')
                .eq('student_id', studentId)
                .eq('year', currentYear)
                .single();

            if (cycle) {
                setPdiCycleId(cycle.id);
                setFinalReport(cycle.final_report || '');

                // 3. Fetch Evaluations linked to this cycle
                const { data: evals } = await supabase
                    .from('pdi_teacher_evaluations')
                    .select('*')
                    .eq('pdi_cycle_id', cycle.id);
                setEvaluations(evals || []);
            } else {
                // If no cycle, maybe fetch evaluations by student linkage? 
                // For now, if no cycle, we assume no evaluations linked (or we create cycle on fly).
                // Let's create on fly if missing to allow consolidation
                const { data: newCycle } = await supabase
                    .from('pdi_cycles')
                    .insert({ student_id: studentId, year: currentYear })
                    .select()
                    .single();
                if (newCycle) setPdiCycleId(newCycle.id);
            }

            // 4. Count Adaptations (Mock check on logs or pdi_records)
            // Assuming we track this somewhere. For now, we count specific logs for this student
            // We'll use a count query on pdi_teacher_evaluations for now as proxy or real logs if table exists
            // We used `pdi_records` in schema.
            const { count } = await supabase
                .from('pdi_records')
                .select('*', { count: 'exact', head: true })
                .eq('student_id', studentId);
            setAdaptationCount(count || 0);

        } catch (err) {
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const handleGenerateReport = async () => {
        setGenerating(true);
        try {
            const report = await generateFinalPDIReport({
                studentName,
                profileData,
                evaluations,
                adaptationCount
            });
            setFinalReport(report);
        } catch (err: any) {
            alert("Erro ao gerar relatório: " + err.message);
        } finally {
            setGenerating(false);
        }
    };

    const handleSave = async () => {
        if (!pdiCycleId) return;
        setLoading(true);
        try {
            const { error } = await supabase
                .from('pdi_cycles')
                .update({
                    final_report: finalReport,
                    status: 'COMPLETED'
                })
                .eq('id', pdiCycleId);

            if (error) throw error;
            alert("✅ Relatório Final salvo e PDI concluído!");
            if (onClose) onClose();
        } catch (err) {
            console.error(err);
            alert("Erro ao salvar.");
        } finally {
            setLoading(false);
        }
    };

    const generateFinalPDIReport = async ({ studentName, profileData, evaluations, adaptationCount }: any) => {
        return `Relatório Final para ${studentName} com ${adaptationCount} adaptações.`;
    };

    if (loading && !profileData) return <div className="p-10 text-center">Carregando dados consolidados...</div>;

    return (
        <div className="bg-white min-h-[600px] flex flex-col h-full rounded-2xl shadow-xl overflow-hidden">
            {/* HEADER */}
            <div className="bg-gradient-to-r from-slate-900 to-slate-800 p-6 text-white flex justify-between items-center">
                <div>
                    <h2 className="text-xl font-black uppercase tracking-tight flex items-center gap-3">
                        <BrainCircuit className="text-emerald-400" />
                        Consolidação do PDI
                    </h2>
                    <p className="text-emerald-200/60 text-xs font-bold uppercase tracking-widest mt-1">Item XI - Relatório Final (IA Generator)</p>
                </div>
                <div className="flex gap-2">
                    <button onClick={onClose} className="px-4 py-2 text-xs font-bold uppercase text-slate-400 hover:text-white transition-colors">Fechar</button>
                    <button className="px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg text-white font-bold flex items-center gap-2 text-xs uppercase tracking-wider">
                        <Printer size={14} /> Imprimir PDF
                    </button>
                </div>
            </div>

            <div className="flex-1 overflow-y-auto bg-slate-50 p-8 flex flex-col lg:flex-row gap-8">

                {/* LEFT: SOURCES */}
                <div className="w-full lg:w-1/3 space-y-6">
                    <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm">
                        <h3 className="text-xs font-black uppercase text-slate-400 tracking-wider mb-4 border-b border-slate-100 pb-2">Fontes de Dados</h3>

                        <div className="space-y-4">
                            {/* Profile Status */}
                            <div className="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
                                <div className="flex items-center gap-3">
                                    <div className={`p-2 rounded-lg ${profileData?.psychomotor ? 'bg-emerald-100 text-emerald-600' : 'bg-red-100 text-red-600'}`}>
                                        <BookOpen size={16} />
                                    </div>
                                    <div>
                                        <p className="text-sm font-bold text-slate-700">Perfil Clínico</p>
                                        <p className="text-xs text-slate-400">{profileData?.psychomotor ? 'Preenchido' : 'Pendente'}</p>
                                    </div>
                                </div>
                                {profileData?.psychomotor && <CheckCircle2 size={16} className="text-emerald-500" />}
                            </div>

                            {/* Evaluations */}
                            <div className="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
                                <div className="flex items-center gap-3">
                                    <div className={`p-2 rounded-lg ${evaluations.length > 0 ? 'bg-blue-100 text-blue-600' : 'bg-orange-100 text-orange-600'}`}>
                                        <GraduationCap size={16} />
                                    </div>
                                    <div>
                                        <p className="text-sm font-bold text-slate-700">Avaliações Docentes</p>
                                        <p className="text-xs text-slate-400">{evaluations.length} Professores registraram</p>
                                    </div>
                                </div>
                                <span className="text-xs font-bold bg-white border border-slate-200 px-2 py-1 rounded text-slate-600">{evaluations.length}</span>
                            </div>

                            {/* Adaptation Logs */}
                            <div className="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
                                <div className="flex items-center gap-3">
                                    <div className="p-2 rounded-lg bg-indigo-100 text-indigo-600">
                                        <FileText size={16} />
                                    </div>
                                    <div>
                                        <p className="text-sm font-bold text-slate-700">Aulas Adaptadas</p>
                                        <p className="text-xs text-slate-400">Item IX (Automático)</p>
                                    </div>
                                </div>
                                <span className="text-xs font-bold bg-white border border-slate-200 px-2 py-1 rounded text-slate-600">{adaptationCount}</span>
                            </div>
                        </div>
                    </div>

                    <div className="bg-blue-50 border border-blue-100 p-4 rounded-xl text-blue-800 text-xs leading-relaxed">
                        <p className="font-bold mb-2 flex items-center gap-2"><BrainCircuit size={14} /> Como funciona a IA?</p>
                        O Gerador analisa o Perfil Clínico + Avaliações dos Professores e redige um texto técnico coeso para o campo "Relatório Final", pronto para assinatura.
                    </div>
                </div>

                {/* RIGHT: EDITOR */}
                <div className="w-full lg:w-2/3 flex flex-col h-full">
                    <div className="bg-white rounded-xl border border-slate-200 shadow-sm flex flex-col h-full overflow-hidden">
                        <div className="p-4 bg-slate-50 border-b border-slate-200 flex justify-between items-center">
                            <h3 className="font-bold text-slate-700 text-sm">Editor do Relatório Final</h3>
                            <button
                                onClick={handleGenerateReport}
                                disabled={generating}
                                className="px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-bold uppercase tracking-wider flex items-center gap-2 disabled:opacity-50 transition-all hover:scale-105"
                            >
                                {generating ? (
                                    <span className="animate-pulse">Escrevendo...</span>
                                ) : (
                                    <>
                                        <BrainCircuit size={16} /> Gerar com IA
                                    </>
                                )}
                            </button>
                        </div>

                        <textarea
                            value={finalReport}
                            onChange={(e) => setFinalReport(e.target.value)}
                            className="flex-1 p-6 text-sm leading-relaxed text-slate-700 outline-none resize-none font-medium"
                            placeholder="O relatório final aparecerá aqui após a geração, ou você pode escrever manualmente..."
                        />

                        <div className="p-4 border-t border-slate-100 bg-slate-50 flex justify-end">
                            <button
                                onClick={handleSave}
                                disabled={loading}
                                className="px-8 py-3 bg-slate-900 hover:bg-slate-800 text-white rounded-xl font-bold uppercase tracking-widest text-xs flex items-center gap-2 transition-all hover:scale-[1.02]"
                            >
                                <Save size={16} /> Salvar Documento Oficial
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};
