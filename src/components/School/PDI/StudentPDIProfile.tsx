import React, { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { Save, CheckCircle2, AlertCircle, ArrowRight, BrainCircuit, User, Activity } from 'lucide-react';
import { supabase } from '../../../services/supabaseClient';
import { PDI_SCHEMA, PDIProfileData } from '../../../types/pdi-schema';
import { PDICheckboxGroup } from './PDICheckboxGroup';
import { toast } from 'sonner'; // Assuming generic toast or simple console for now if not installed

interface StudentPDIProfileProps {
    studentId: string;
    onClose?: () => void;
}

export const StudentPDIProfile: React.FC<StudentPDIProfileProps> = ({ studentId, onClose }) => {
    const [activeTab, setActiveTab] = useState<'info' | 'clinical' | 'pedagogical'>('info');
    const [loading, setLoading] = useState(false);
    const [studentName, setStudentName] = useState('');

    const { register, handleSubmit, reset, watch, formState: { errors } } = useForm<PDIProfileData>({
        resolver: zodResolver(PDI_SCHEMA),
        defaultValues: {
            psychomotor: {},
            cognitive: {}
        }
    });

    useEffect(() => {
        const loadStudentData = async () => {
            setLoading(true);
            try {
                // Fetch Student Name and existing PDI Data
                const { data, error } = await supabase
                    .from('school_students')
                    .select('name, pdi_data')
                    .eq('id', studentId)
                    .single();

                if (error) throw error;

                if (data) {
                    setStudentName(data.name);
                    if (data.pdi_data) {
                        // Merge existing PDI data into form
                        // We assume pdi_data has the structure { psychomotor: ..., cognitive: ... }
                        // and potentially other fields like "history", "medication" which are not in Zod yet but handled via standard inputs in Tab 1
                        reset(data.pdi_data);
                    }
                }
            } catch (err) {
                console.error("Error loading PDI data:", err);
                alert("Erro ao carregar dados do aluno.");
            } finally {
                setLoading(false);
            }
        };

        if (studentId) loadStudentData();
    }, [studentId, reset]);

    const onSubmit = async (formData: PDIProfileData) => {
        setLoading(true);
        console.log("Saving PDI Data:", formData);

        try {
            // Update the JSONB column
            const { error } = await supabase
                .from('school_students')
                .update({
                    pdi_data: formData
                })
                .eq('id', studentId);

            if (error) throw error;

            alert("✅ PDI salvo com sucesso!");
            if (onClose) onClose();

        } catch (err: any) {
            console.error("Save error:", err);
            alert(`Erro ao salvar: ${err.message}`);
        } finally {
            setLoading(false);
        }
    };

    if (loading && !studentName) return <div className="p-10 text-center">Carregando perfil...</div>;

    return (
        <div className="bg-white min-h-[500px] flex flex-col h-full">
            {/* HEADER */}
            <div className="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <div>
                    <h2 className="text-xl font-black text-slate-800 tracking-tight flex items-center gap-2">
                        <BrainCircuit className="text-indigo-600" />
                        PDI Digital: {studentName}
                    </h2>
                    <p className="text-xs text-slate-500 font-bold uppercase tracking-wider mt-1">Preenchimento Oficial • Modelo SEE/MG</p>
                </div>
                <div className="flex gap-2">
                    <button onClick={onClose} className="px-4 py-2 text-sm text-slate-400 font-bold hover:text-slate-600">Fechar</button>
                    <button
                        onClick={handleSubmit(onSubmit)}
                        className="px-6 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg font-bold shadow-lg shadow-indigo-200 flex items-center gap-2 transition-all active:scale-95"
                    >
                        <Save size={18} />
                        Salvar PDI
                    </button>
                </div>
            </div>

            {/* TABS */}
            <div className="flex border-b border-slate-200 px-6 gap-6">
                <button
                    onClick={() => setActiveTab('info')}
                    className={`py-4 text-xs font-black uppercase tracking-widest border-b-2 transition-colors flex items-center gap-2 ${activeTab === 'info' ? 'border-indigo-600 text-indigo-600' : 'border-transparent text-slate-400 hover:text-slate-600'}`}
                >
                    <User size={16} /> 1. Dados & Histórico
                </button>
                <button
                    onClick={() => setActiveTab('clinical')}
                    className={`py-4 text-xs font-black uppercase tracking-widest border-b-2 transition-colors flex items-center gap-2 ${activeTab === 'clinical' ? 'border-indigo-600 text-indigo-600' : 'border-transparent text-slate-400 hover:text-slate-600'}`}
                >
                    <Activity size={16} /> 2. Aspectos Clínicos
                </button>
                <button
                    onClick={() => setActiveTab('pedagogical')}
                    className={`py-4 text-xs font-black uppercase tracking-widest border-b-2 transition-colors flex items-center gap-2 ${activeTab === 'pedagogical' ? 'border-indigo-600 text-indigo-600' : 'border-transparent text-slate-400 hover:text-slate-600'}`}
                >
                    <BrainCircuit size={16} /> 3. Pedagógico (Checklist)
                </button>
            </div>

            {/* FORM CONTENT */}
            <form className="flex-1 overflow-y-auto p-8 bg-slate-50/30 custom-scrollbar">

                {/* TAB 1: INFO (Placeholder for Sections I-V) */}
                {activeTab === 'info' && (
                    <div className="max-w-3xl mx-auto animate-in slide-in-from-left-4 fade-in duration-300 space-y-8">
                        <div className="bg-blue-50 border border-blue-100 p-4 rounded-xl flex gap-3 text-blue-700">
                            <AlertCircle className="shrink-0" />
                            <div>
                                <p className="font-bold text-sm">Dados Cadastrais (Em Desenvolvimento)</p>
                                <p className="text-xs mt-1">Nesta etapa, futuramente, exibiremos os dados importados do SIMADE/DED.</p>
                            </div>
                        </div>

                        {/* Generic Fields to store in JSONB freely for now */}
                        <div className="space-y-4">
                            <label className="block">
                                <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Histórico de Escolarização</span>
                                <textarea
                                    className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm focus:ring-2 focus:ring-indigo-500 outline-none min-h-[100px]"
                                    placeholder="Descreva a trajetória escolar do aluno..."
                                    {...register('history' as any)}
                                />
                            </label>

                            <label className="block">
                                <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Laudo Médico (CID)</span>
                                <input
                                    type="text"
                                    className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm focus:ring-2 focus:ring-indigo-500 outline-none"
                                    placeholder="Ex: F84.0 - Autismo Infantil"
                                    {...register('cid' as any)}
                                />
                            </label>
                        </div>
                    </div>
                )}

                {/* TAB 2: CLINICAL / PSYCHOMOTOR */}
                {activeTab === 'clinical' && (
                    <div className="max-w-4xl mx-auto animate-in slide-in-from-right-4 fade-in duration-300">
                        <div className="mb-8">
                            <h3 className="text-lg font-black text-slate-800 mb-2">Seção VI: Aspectos Psicomotores</h3>
                            <p className="text-slate-500 text-sm">Avalie o desenvolvimento motor conforme observação clínica ou laudo.</p>
                        </div>

                        <PDICheckboxGroup sectionKey="psychomotor" register={register} data={watch()} />

                        <div className="flex justify-end mt-8">
                            <button
                                type="button"
                                onClick={() => setActiveTab('pedagogical')}
                                className="flex items-center gap-2 text-indigo-600 font-bold text-sm hover:underline"
                            >
                                Próximo: Pedagógico <ArrowRight size={16} />
                            </button>
                        </div>
                    </div>
                )}

                {/* TAB 3: PEDAGOGICAL / COGNITIVE */}
                {activeTab === 'pedagogical' && (
                    <div className="max-w-4xl mx-auto animate-in slide-in-from-right-4 fade-in duration-300">
                        <div className="mb-8">
                            <h3 className="text-lg font-black text-slate-800 mb-2">Seção VII: Aspectos Cognitivos</h3>
                            <p className="text-slate-500 text-sm">Avalie as funções cognitivas e estilo de aprendizagem.</p>
                        </div>

                        <PDICheckboxGroup sectionKey="cognitive" register={register} data={watch()} />

                        <div className="mt-10 p-6 bg-emerald-50 border border-emerald-100 rounded-xl text-center">
                            <CheckCircle2 className="w-10 h-10 text-emerald-500 mx-auto mb-3" />
                            <h4 className="font-black text-emerald-800 text-sm uppercase tracking-wide">Preenchimento Concluído</h4>
                            <p className="text-emerald-600 text-xs mt-1 mb-4">Clique em Salvar para registrar as alterações no prontuário do aluno.</p>
                            <button
                                onClick={handleSubmit(onSubmit)}
                                className="px-8 py-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl font-bold shadow-lg shadow-emerald-200 transition-all active:scale-95 w-full md:w-auto"
                            >
                                Salvar PDI Agora
                            </button>
                        </div>
                    </div>
                )}
            </form>
        </div>
    );
};
