import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { Save, AlertCircle, BookOpen, GraduationCap } from 'lucide-react';
import { supabase } from '../../services/supabaseClient';
import { TeacherEvaluationSchema, pdiTeacherEvaluationForm, AutonomyLevel, ComprehensionLevel } from '../../types/pdi-schema';

interface StudentAssessmentFormProps {
    studentId: string;
    studentName: string;
    teacherId: string;
    pdiCycleId?: string; // If we already know the cycle
    onSuccess?: () => void;
}

export const StudentAssessmentForm: React.FC<StudentAssessmentFormProps> = ({
    studentId,
    studentName,
    teacherId,
    pdiCycleId,
    onSuccess
}) => {
    const [loading, setLoading] = useState(false);

    // Default values could potentially be fetched if editing
    const { register, handleSubmit, formState: { errors } } = useForm<pdiTeacherEvaluationForm>({
        resolver: zodResolver(TeacherEvaluationSchema),
        defaultValues: {
            period: 1,
            subject: '',
            autonomy_level: AutonomyLevel.POUCO_SUPORTE,
            comprehension_level: ComprehensionLevel.MEDIA
        }
    });

    const onSubmit = async (formData: pdiTeacherEvaluationForm) => {
        setLoading(true);
        try {
            // 1. Ensure PDI Cycle exists for this year
            let targetCycleId = pdiCycleId;

            if (!targetCycleId) {
                const currentYear = new Date().getFullYear();

                // Try to find existing
                const { data: existingCycle } = await supabase
                    .from('pdi_cycles')
                    .select('id')
                    .eq('student_id', studentId)
                    .eq('year', currentYear)
                    .single();

                if (existingCycle) {
                    targetCycleId = existingCycle.id;
                } else {
                    // Create new if not exists (Teacher triggering creation or just linking?) 
                    // Usually Manager creates, but we can allow auto-create for fluidity or throw error.
                    // Let's safe-create.
                    const { data: newCycle, error: createError } = await (supabase as any)
                        .from('pdi_cycles')
                        .insert({
                            student_id: studentId,
                            year: currentYear,
                            status: 'IN_PROGRESS'
                        })
                        .select()
                        .single();

                    if (createError) throw new Error("Erro ao iniciar ciclo PDI: " + createError.message);
                    targetCycleId = newCycle.id;
                }
            }

            // 2. Save Evaluation
            const { error: evalError } = await (supabase as any)
                .from('pdi_teacher_evaluations')
                .upsert({
                    pdi_cycle_id: targetCycleId,
                    teacher_id: teacherId,
                    subject: formData.subject,
                    period: formData.period,
                    autonomy_level: formData.autonomy_level,
                    comprehension_level: formData.comprehension_level,
                    pedagogical_diagnosis: formData.pedagogical_diagnosis
                }, {
                    onConflict: 'pdi_cycle_id, teacher_id, subject, period'
                });

            if (evalError) throw evalError;

            alert("✅ Avaliação registrada com sucesso!");
            if (onSuccess) onSuccess();

        } catch (err: any) {
            console.error("Submission Error:", err);
            alert(`Erro ao salvar avaliação: ${err.message}`);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6">
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-100">
                <div className="bg-orange-100 p-2 rounded-lg text-orange-600">
                    <GraduationCap size={20} />
                </div>
                <div>
                    <h3 className="font-black text-slate-800 text-lg">Avaliação Trimestral</h3>
                    <p className="text-xs text-slate-500 font-bold">Professor regente: {studentName}</p>
                </div>
            </div>

            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">

                {/* ROW 1: Context */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label className="text-xs font-bold uppercase text-slate-400 mb-1 block">Disciplina</label>
                        <input
                            {...register("subject")}
                            className="w-full p-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-bold focus:ring-2 focus:ring-orange-500 outline-none transition-all"
                            placeholder="Ex: Matemática"
                        />
                        {errors.subject && <span className="text-red-500 text-xs">{errors.subject.message}</span>}
                    </div>

                    <div>
                        <label className="text-xs font-bold uppercase text-slate-400 mb-1 block">Período (MG)</label>
                        <select
                            {...register("period", { valueAsNumber: true })}
                            className="w-full p-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-bold focus:ring-2 focus:ring-orange-500 outline-none transition-all"
                        >
                            <option value={1}>1º Trimestre</option>
                            <option value={2}>2º Trimestre</option>
                            <option value={3}>3º Trimestre</option>
                        </select>
                    </div>
                </div>

                {/* ROW 2: Quantitative Stats */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label className="text-xs font-bold uppercase text-slate-400 mb-1 block">Nível de Autonomia</label>
                        <select
                            {...register("autonomy_level")}
                            className="w-full p-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-bold focus:ring-2 focus:ring-orange-500 outline-none transition-all"
                        >
                            <option value={AutonomyLevel.MUITO_SUPORTE}>Necessita muito suporte</option>
                            <option value={AutonomyLevel.POUCO_SUPORTE}>Necessita pouco suporte</option>
                            <option value={AutonomyLevel.AUTONOMO}>Autônomo</option>
                            <option value={AutonomyLevel.NAO_OBSERVADO}>Não observado</option>
                        </select>
                    </div>

                    <div>
                        <label className="text-xs font-bold uppercase text-slate-400 mb-1 block">Compreensão</label>
                        <select
                            {...register("comprehension_level")}
                            className="w-full p-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-bold focus:ring-2 focus:ring-orange-500 outline-none transition-all"
                        >
                            <option value={ComprehensionLevel.ALTA}>Alta</option>
                            <option value={ComprehensionLevel.MEDIA}>Média</option>
                            <option value={ComprehensionLevel.BAIXA}>Baixa</option>
                            <option value={ComprehensionLevel.NENHUMA}>Nenhuma</option>
                        </select>
                    </div>
                </div>

                {/* ROW 3: Quality Text */}
                <div>
                    <label className="text-xs font-bold uppercase text-slate-400 mb-1 block flex justify-between">
                        <span>Diagnóstico Pedagógico</span>
                        <span className="text-[10px] bg-slate-100 px-2 py-0.5 rounded text-slate-500">Item X do PDI</span>
                    </label>
                    <textarea
                        {...register("pedagogical_diagnosis")}
                        className="w-full p-4 bg-slate-50 border border-slate-200 rounded-xl text-sm leading-relaxed focus:ring-2 focus:ring-orange-500 outline-none transition-all min-h-[120px]"
                        placeholder="Descreva o desempenho do aluno nas atividades adaptadas, seus avanços e desafios..."
                    />
                    {errors.pedagogical_diagnosis && <span className="text-red-500 text-xs">{errors.pedagogical_diagnosis.message}</span>}
                </div>

                {/* SUBMIT */}
                <button
                    disabled={loading}
                    type="submit"
                    className="w-full py-4 bg-orange-600 hover:bg-orange-700 text-white rounded-xl font-bold uppercase tracking-widest shadow-lg shadow-orange-200 transition-all active:scale-95 flex items-center justify-center gap-2 group disabled:opacity-50"
                >
                    {loading ? 'Salvando...' : (
                        <>
                            <Save size={18} className="group-hover:scale-110 transition-transform" />
                            Registrar Avaliação
                        </>
                    )}
                </button>

            </form>
        </div>
    );
};
