import React, { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { Save, AlertCircle, BrainCircuit, User, Activity } from 'lucide-react';
import { PDI_SCHEMA, PDIProfileData } from '../../../types/pdi-schema';
import { PDICheckboxGroup } from './PDICheckboxGroup';
import { getStudentById, updateStudent } from '../../../services/studentService';
import { getSchoolStudentById, findSchoolStudentBySchoolAndName, createSchoolStudent, updateSchoolStudentPdiData } from '../../../services/schoolStudentService';
import { getClassById } from '../../../services/classService';
import { SchoolService } from '../../../services/SchoolService';

interface StudentPDIProfileProps {
    studentId: string;
    onClose: () => void;
}

export const StudentPDIProfile: React.FC<StudentPDIProfileProps> = ({ studentId, onClose }) => {
    const [activeTab, setActiveTab] = useState<'info' | 'clinical' | 'pedagogical'>('info');
    const [loading, setLoading] = useState(false);
    const [studentName, setStudentName] = useState('');
    const [schoolStudentId, setSchoolStudentId] = useState<string | null>(null);

    const { register, handleSubmit, reset, watch, setValue, formState: { errors } } = useForm<PDIProfileData & { deficiencies: string[] }>({
        resolver: zodResolver(PDI_SCHEMA) as any,
        defaultValues: {
            psychomotor: {},
            cognitive: {},
            deficiencies: []
        }
    });

    useEffect(() => {
        const loadStudentData = async () => {
            setLoading(true);
            try {
                // 1. Fetch ALL Student Data to ensure we have DOB etc.
                const student = await getStudentById(studentId);

                if (!student) {
                    alert('Aluno não encontrado na base de dados (students).');
                    if (onClose) onClose();
                    return;
                }

                setStudentName(student.name);
                setValue('student_data.name', student.name);

                let finalSSId = student.school_student_id || null;

                // Self-healing: If missing school_student_id but we have school context
                if (!finalSSId && student.current_school_id) {
                    console.log('Attempting to auto-heal missing school_student_id...');
                    const existingSS = await findSchoolStudentBySchoolAndName(student.current_school_id, student.name);

                    if (existingSS) {
                        finalSSId = existingSS.id;
                    } else {
                        const newSS = await createSchoolStudent(student.current_school_id, student.name);
                        if (newSS) finalSSId = newSS.id;
                    }

                    if (finalSSId) {
                        await updateStudent(studentId, { school_student_id: finalSSId });
                    }
                }

                if (finalSSId) {
                    setSchoolStudentId(finalSSId);
                    const ssData = await getSchoolStudentById(finalSSId);

                    if (ssData?.pdi_data) {
                        reset(ssData.pdi_data as PDIProfileData);
                        setValue('student_data.name', student.name);
                        const deficiencies = (ssData.pdi_data as PDIProfileData & { deficiencies?: string[] })?.deficiencies;
                        if (deficiencies) {
                            setValue('deficiencies', deficiencies);
                        }
                    }
                } else {
                    console.warn('Could not resolve school_student_id even after self-healing.');
                }

                // 2. Hydrate Relations (Class/School)
                let className = '';
                let schoolYear = '';
                let schoolName = '';
                let shift = '';

                if (student.class_id) {
                    const classData = await getClassById(student.class_id);
                    if (classData) {
                        className = classData.name;
                        schoolYear = classData.year?.toString() || '';
                        shift = classData.shift || '';
                    }
                }

                if (student.current_school_id) {
                    const schoolData = await SchoolService.getSchoolById(student.current_school_id);
                    if (schoolData) schoolName = schoolData.name;
                }

                setValue('student_data.class_name', className);
                setValue('student_data.school_year', schoolYear);
                setValue('student_data.shift', shift);
                setValue('institutional.school_name', schoolName);

                // 3. Hydrate Age/DOB from Student Record if explicit
                // Try common column names: dob, birth_date, data_nascimento
                const dob = (student as any).dob || (student as any).birth_date || (student as any).data_nascimento;
                if (dob) {
                    setValue('student_data.dob', dob);
                    // Calculate Age
                    const birthDate = new Date(dob);
                    const today = new Date();
                    let age = today.getFullYear() - birthDate.getFullYear();
                    const m = today.getMonth() - birthDate.getMonth();
                    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                        age--;
                    }
                    if (!isNaN(age)) setValue('student_data.age', age);
                }

            } catch (err: any) {
                console.error("Error loading PDI data:", err);
                alert(`Erro ao carregar dados: ${err.message || JSON.stringify(err)}`);
            } finally {
                setLoading(false);
            }
        };

        if (studentId) loadStudentData();
    }, [studentId, reset, setValue]);

    const onError = (errors: any) => {
        console.error("Validation Errors:", errors);
        const formatErrors = (errObj: any, prefix = ''): string[] => {
            return Object.keys(errObj).reduce((acc: string[], key) => {
                const err = errObj[key];
                if (err.message) return [...acc, `${prefix}${key}: ${err.message}`];
                if (typeof err === 'object') return [...acc, ...formatErrors(err, `${prefix}${key}.`)];
                return acc;
            }, []);
        };
        const missingFields = formatErrors(errors).join("\n");
        alert(`Não foi possível salvar.\nVerifique:\n${missingFields}`);
    };

    const onSubmit = async (formData: PDIProfileData & { deficiencies: string[] }) => {
        setLoading(true);
        console.log("Saving PDI Data:", formData);

        if (!schoolStudentId) {
            alert("Erro: ID de vínculo escolar (school_student_id) não encontrado. Não é possível salvar o PDI.");
            setLoading(false);
            return;
        }

        try {
            // Update 'school_students' table where PDI data lives
            // We use 'pdi_data' JSON column. we prefer NOT to touch 'deficiencies' array column directly if it doesn't exist or is read-only.
            const result = await updateSchoolStudentPdiData(schoolStudentId, {
                ...formData,
                deficiencies: formData.deficiencies
            });

            if (!result.success) throw new Error(result.error || 'Erro ao salvar PDI');

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
        <div className="flex flex-col h-full bg-slate-50">
            {/* HEADER */}
            <div className="bg-white border-b border-indigo-100 p-6 flex justify-between items-center shadow-sm z-10">
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
                        onClick={handleSubmit(onSubmit as any, onError)}
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
                                <p className="font-bold text-sm">Dados Cadastrais</p>
                                <p className="text-xs mt-1">Estes dados são identificados automaticamente do cadastro do aluno.</p>
                            </div>
                        </div>

                        {/* Identification Fields */}
                        <div className="space-y-4">
                            <label className="block">
                                <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Nome do Aluno</span>
                                <input
                                    className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm bg-slate-100 text-slate-600 font-bold"
                                    {...register('student_data.name')}
                                    readOnly
                                />
                            </label>

                            <div className="grid grid-cols-2 gap-4">
                                <label className="block">
                                    <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Escola</span>
                                    <input
                                        className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm bg-slate-100 text-slate-600"
                                        {...register('institutional.school_name')}
                                        placeholder="Nome da Escola"
                                    />
                                </label>
                                <label className="block">
                                    <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Ano Escolar</span>
                                    <input
                                        className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm bg-slate-100 text-slate-600"
                                        {...register('student_data.school_year')}
                                        placeholder="Ex: 5º Ano"
                                    />
                                </label>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <label className="block">
                                    <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Turma</span>
                                    <input
                                        className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm bg-slate-100 text-slate-600"
                                        {...register('student_data.class_name')}
                                        placeholder="Turma"
                                    />
                                </label>
                                <label className="block">
                                    <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Idade</span>
                                    <input
                                        type="number"
                                        className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm"
                                        {...register('student_data.age', { setValueAs: (v) => v === "" ? undefined : Number(v) })}
                                        placeholder="Idade"
                                    />
                                </label>
                            </div>
                        </div>

                        <div className="space-y-4 pt-4 border-t border-slate-100">
                            <PDICheckboxGroup
                                label="Principais Diagnósticos (Tags)"
                                options={[
                                    "TDAH",
                                    "Autismo",
                                    "Dislexia",
                                    "TOD",
                                    "Defi. Intelectual",
                                    "Altas Habilidades",
                                    "Outro"
                                ]}
                                selected={watch('deficiencies') || []}
                                onChange={(newVal) => setValue('deficiencies', newVal)}
                            />
                            <p className="text-[10px] text-slate-400">Selecione as tags para identificação rápida na lista.</p>
                        </div>

                        <div className="space-y-4 pt-8 border-t border-slate-200">
                            <h3 className="font-black text-slate-700 uppercase tracking-widest text-sm">Histórico de Escolarização</h3>
                            <textarea
                                className="w-full p-4 rounded-xl border border-slate-200 text-sm min-h-[120px]"
                                placeholder="Descreva brevemente o histórico escolar do aluno..."
                                {...register('clinical_health.medical_updates')}
                            ></textarea>
                        </div>
                    </div>
                )}

                {/* TAB 2: CLINICAL */}
                {activeTab === 'clinical' && (
                    <div className="max-w-3xl mx-auto animate-in slide-in-from-right-4 fade-in duration-300 space-y-8">
                        <div className="bg-purple-50 border border-purple-100 p-4 rounded-xl flex gap-3 text-purple-700">
                            <Activity className="shrink-0" />
                            <div>
                                <p className="font-bold text-sm">Aspectos Clínicos</p>
                                <p className="text-xs mt-1">Informações de saúde e terapias.</p>
                            </div>
                        </div>

                        <div className="space-y-6">
                            <label className="block">
                                <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Diagnóstico (CID)</span>
                                <input
                                    className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm"
                                    {...register('clinical_health.diagnosis_cid')}
                                    placeholder="Ex: F84.0"
                                />
                            </label>

                            <label className="block">
                                <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Medicação em Uso</span>
                                <textarea
                                    className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm"
                                    {...register('clinical_health.medication')}
                                    placeholder="Descreva..."
                                />
                            </label>

                            <label className="block">
                                <span className="text-xs font-bold uppercase text-slate-400 tracking-wider">Terapias / Acompanhamentos</span>
                                <textarea
                                    className="w-full mt-2 p-3 rounded-xl border border-slate-200 text-sm"
                                    {...register('clinical_health.therapies')}
                                    placeholder="Fonoaudiologia, Psicologia..."
                                />
                            </label>
                        </div>
                    </div>
                )}

                {/* TAB 3: PEDAGOGICAL (Checklists) */}
                {activeTab === 'pedagogical' && (
                    <div className="max-w-4xl mx-auto animate-in slide-in-from-right-8 fade-in duration-300 space-y-12 pb-20">
                        {/* Psychomotor Section */}
                        <div className="space-y-6">
                            <div className="flex items-center gap-3 mb-6">
                                <div className="w-8 h-8 rounded-lg bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold">1</div>
                                <h3 className="text-lg font-black text-slate-800 tracking-tight">Aspectos Psicomotores</h3>
                            </div>

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                                <div className="space-y-4 col-span-2">
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        {[
                                            { key: 'body_schema', label: 'Esquema Corporal' },
                                            { key: 'gross_motor_coordination', label: 'Coordenação Ampla' },
                                            { key: 'fine_motor_coordination', label: 'Coordenação Fina' },
                                            { key: 'dynamic_balance', label: 'Equilíbrio Dinâmico' },
                                            { key: 'attention_sustained', label: 'Atenção Sustentada', section: 'cognitive' },
                                            { key: 'memory_short_term', label: 'Memória Curto Prazo', section: 'cognitive' },
                                            { key: 'orders_simple', label: 'Compreensão Ordens Simples', section: 'cognitive' },
                                            { key: 'interaction_intent', label: 'Intenção Comunicativa', section: 'communication' }
                                        ].map((item) => (
                                            <label key={item.key} className="block bg-slate-50 p-3 rounded-xl border border-slate-100">
                                                <span className="text-[10px] font-bold uppercase text-slate-400 tracking-wider block mb-2">{item.label}</span>
                                                <select
                                                    className="w-full text-xs font-bold text-slate-700 bg-white p-2 rounded-lg border border-slate-200"
                                                    {...register(`${item.section || 'psychomotor'}.${item.key}` as any)}
                                                >
                                                    <option value="">Não Avaliado</option>
                                                    <option value="APRESENTA">Apresenta</option>
                                                    <option value="COM_AJUDA">Com Ajuda</option>
                                                    <option value="NAO_APRESENTA">Não Apresenta</option>
                                                    <option value="NAO_OBSERVADO">Não Observado</option>
                                                </select>
                                            </label>
                                        ))}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                )}
            </form>
        </div>
    );
};
