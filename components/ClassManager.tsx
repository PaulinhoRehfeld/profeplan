import React, { useState, useEffect } from 'react';
import {
    Users, Plus, Trash2, FileText, ChevronRight,
    Upload, Loader2, CheckCircle2, AlertCircle, X, Search, GraduationCap, Download, Cloud,
    Settings, Save, BrainCircuit
} from 'lucide-react';
import { extractTextFromPdf } from '../services/pdfService';
import { parseClassListFromText } from '../services/geminiService';
import { saveClassToLocal, getLocalClasses, getLocalClassDetails, deleteLocalClass, exportClassesToJSON, updateLocalClass } from '../services/localStorageService';
import { updateStudent, getClassDetails } from '../services/supabaseService';
import { Student, Class } from '../types';

const ClassManager: React.FC<{ userId: string }> = ({ userId }) => {
    const [classes, setClasses] = useState<Class[]>([]);
    const [loading, setLoading] = useState(true);
    const [isImporting, setIsImporting] = useState(false);
    const [importStep, setImportStep] = useState<'idle' | 'uploading' | 'parsing' | 'confirming'>('idle');
    const [tempClassData, setTempClassData] = useState<{ className: string, subject: string, students: string[] } | null>(null);
    const [selectedClass, setSelectedClass] = useState<Class | null>(null);
    const [error, setError] = useState('');
    const [searchTerm, setSearchTerm] = useState('');

    // PDI/DUA State
    const [isDrawerOpen, setIsDrawerOpen] = useState(false);
    const [editingStudent, setEditingStudent] = useState<Student | null>(null);
    const [isSavingStart, setIsSavingStart] = useState(false);

    useEffect(() => {
        fetchClasses();
    }, [userId]);

    const fetchClasses = () => {
        setLoading(true);
        // Fallback to local for basic list, but ideally we should sync
        const data = getLocalClasses(userId);
        setClasses(data.map(c => ({
            id: c.id,
            name: c.name,
            subject: c.subject,
            created_at: c.createdAt,
            students: c.students.map((s: any) => ({ ...s, needs_adaptation: s.needs_adaptation ?? false }))
        })));
        setLoading(false);
    };

    const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;

        if (file.type !== 'application/pdf') {
            setError('Por favor, selecione um arquivo PDF.');
            return;
        }

        setImportStep('uploading');
        setError('');

        try {
            const text = await extractTextFromPdf(file);
            setImportStep('parsing');
            const parsedData = await parseClassListFromText(text);
            setTempClassData(parsedData);
            setImportStep('confirming');
        } catch (err: any) {
            console.error(err);
            setError(err.message || 'Erro ao processar PDF.');
            setImportStep('idle');
        }
    };

    const confirmSave = () => {
        if (!tempClassData) return;
        setImportStep('parsing');
        try {
            saveClassToLocal(userId, tempClassData);
            // Note: Ideally we should also save to Supabase here if not already handled by localStorageService logic
            setTempClassData(null);
            setImportStep('idle');
            fetchClasses();
        } catch (err: any) {
            setError('Erro ao salvar localmente.');
            setImportStep('confirming');
        }
    };

    const handleViewClass = async (id: string) => {
        // Try to fetch detailed data from Supabase first if available (for PDI data)
        // If not, fall back to local
        try {
            const { data } = await getClassDetails(id);
            if (data) {
                // Map Supabase structure to UI structure
                setSelectedClass({
                    id: data.id,
                    name: data.name,
                    subject: data.subject,
                    created_at: data.created_at,
                    students: data.students
                });
                return;
            }
        } catch (e) {
            console.log("Fallback to local for class details");
        }

        const data = getLocalClassDetails(id);
        if (data) {
            setSelectedClass({
                id: data.id,
                name: data.name,
                subject: data.subject,
                created_at: data.createdAt,
                students: data.students
            } as any);
        }
    };

    const handleDeleteClass = (id: string) => {
        if (confirm('Tem certeza que deseja excluir esta turma e todos os alunos cadastrados?')) {
            deleteLocalClass(id);
            fetchClasses();
            if (selectedClass?.id === id) setSelectedClass(null);
        }
    };

    const handleExportData = () => {
        const jsonData = exportClassesToJSON(userId);
        const blob = new Blob([jsonData], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `profeplan_turmas_${new Date().toISOString().split('T')[0]}.json`;
        a.click();
        URL.revokeObjectURL(url);
    };

    // PDI Functions
    const openStudentDrawer = (student: Student) => {
        setEditingStudent({ ...student, deficiencies: student.deficiencies || [] });
        setIsDrawerOpen(true);
    };



    const saveStudentPDI = async () => {
        if (!editingStudent || !selectedClass) return;
        setIsSavingStart(true);
        try {
            // 1. Save to Supabase (Best Effort)
            try {
                await updateStudent(editingStudent.id, {
                    needs_adaptation: editingStudent.needs_adaptation,
                    deficiencies: editingStudent.deficiencies,
                    pedagogical_observations: editingStudent.pedagogical_observations
                });
            } catch (err) {
                console.warn("Update Supabase failed, relying on local", err);
            }

            // 2. Update Local State (Selected Class)
            const updatedStudents = selectedClass.students?.map(s =>
                s.id === editingStudent.id ? editingStudent : s
            );

            // 3. PERSIST LOCAL STORAGE (Critical for Data Survival)
            if (updatedStudents) {
                // We need to map UI "Class" back to "LocalClass" structure
                // Assuming selectedClass has all fields. 
                // Note: Types might differ slightly (UI has mapped student structure), so we cast carefully.
                const classToSave: any = {
                    id: selectedClass.id,
                    userId: userId,
                    name: selectedClass.name,
                    subject: selectedClass.subject,
                    createdAt: selectedClass.created_at,
                    students: updatedStudents.map(s => ({
                        id: s.id,
                        classId: selectedClass.id,
                        name: s.name,
                        needs_adaptation: s.needs_adaptation,
                        deficiencies: s.deficiencies,
                        pedagogical_observations: s.pedagogical_observations
                    }))
                };

                updateLocalClass(userId, classToSave);
            }

            setSelectedClass({
                ...selectedClass,
                students: updatedStudents
            });

            // 4. Update Global List (Optimization)
            setIsDrawerOpen(false);

            // Refresh list to ensure consistency
            fetchClasses();

        } catch (error: any) {
            console.error("Erro ao salvar PDI:", error);
            setError("Erro ao salvar perfil: " + error.message);
        } finally {
            setIsSavingStart(false);
        }
    };

    const toggleDeficiency = (tag: string) => {
        if (!editingStudent) return;
        const current = editingStudent.deficiencies || [];
        const updated = current.includes(tag)
            ? current.filter(t => t !== tag)
            : [...current, tag];
        setEditingStudent({ ...editingStudent, deficiencies: updated });
    };

    const AVAILABLE_TAGS = [
        "TDAH", "Autismo", "Dislexia", "Baixa Visão",
        "Deficiência Auditiva", "Superdotação", "Discalculia",
        "Ansiedade", "Mobilidade Reduzida"
    ];

    if (selectedClass) {
        return (
            <div className="space-y-8 animate-in fade-in slide-in-from-right-4 duration-500 relative">
                <div className="flex items-center gap-4">
                    <button
                        onClick={() => setSelectedClass(null)}
                        className="p-3 hover:bg-slate-100 rounded-2xl transition-colors"
                    >
                        <X size={20} />
                    </button>
                    <div>
                        <h2 className="text-2xl font-black text-slate-900 tracking-tight uppercase italic">{selectedClass.name}</h2>
                        <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">{selectedClass.subject} • {selectedClass.students?.length || 0} Alunos</p>
                    </div>
                </div>

                <div className="bg-white border border-slate-100 rounded-[2.5rem] shadow-sm overflow-hidden flex flex-col md:flex-row">
                    <div className="flex-1">
                        <div className="p-8 border-b border-slate-50 bg-slate-50/50 flex items-center justify-between">
                            <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic">Lista de Chamada Digital</h3>
                            <span className="bg-blue-600 text-white text-[10px] font-black px-3 py-1 rounded-full uppercase tracking-widest">Sincronizado</span>
                        </div>
                        <div className="overflow-x-auto">
                            <table className="w-full text-left">
                                <thead>
                                    <tr className="border-b border-slate-50">
                                        <th className="px-10 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">#</th>
                                        <th className="px-10 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Nome do Aluno</th>
                                        <th className="px-10 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest text-right">Ações</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-slate-50">
                                    {selectedClass.students?.map((student, index) => (
                                        <tr key={student.id || index} className={`hover:bg-slate-50 transition-colors group ${student.needs_adaptation ? 'bg-purple-50/30' : ''}`}>
                                            <td className="px-10 py-5 text-sm font-black text-slate-300 italic">{(index + 1).toString().padStart(2, '0')}</td>
                                            <td className="px-10 py-5">
                                                <div className="flex items-center gap-2">
                                                    <span className={`text-sm font-bold ${student.needs_adaptation ? 'text-purple-700' : 'text-slate-700'}`}>
                                                        {student.name}
                                                    </span>
                                                    {student.needs_adaptation && (
                                                        <span className="w-2 h-2 bg-purple-500 rounded-full animate-pulse" title="Necessita Adaptação"></span>
                                                    )}
                                                </div>
                                                {student.deficiencies && student.deficiencies.length > 0 && (
                                                    <div className="flex gap-1 mt-1 flex-wrap">
                                                        {student.deficiencies.map(def => (
                                                            <span key={def} className="text-[9px] px-1.5 py-0.5 bg-slate-100 text-slate-500 rounded uppercase font-bold tracking-wider">{def}</span>
                                                        ))}
                                                    </div>
                                                )}
                                            </td>
                                            <td className="px-10 py-5 text-right">
                                                <button
                                                    onClick={() => openStudentDrawer(student)}
                                                    className="p-2 text-slate-400 hover:text-blue-600 transition-colors relative group/btn"
                                                    title="Perfil Pedagógico"
                                                >
                                                    <Settings size={18} />
                                                    <span className="absolute right-full mr-2 top-1/2 -translate-y-1/2 px-2 py-1 bg-slate-800 text-white text-[9px] font-bold uppercase rounded opacity-0 group-hover/btn:opacity-100 transition-opacity whitespace-nowrap">
                                                        Editar Perfil
                                                    </span>
                                                </button>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>

                    {/* Side Drawer for PDI Editing */}
                    {isDrawerOpen && editingStudent && (
                        <div className="w-full md:w-96 border-l border-slate-100 bg-white md:h-auto overflow-y-auto animate-in slide-in-from-right duration-300 p-8 shadow-2xl relative z-20">
                            <div className="flex items-center justify-between mb-8">
                                <h3 className="text-sm font-black text-slate-900 uppercase tracking-tight">Memória Pedagógica</h3>
                                <button onClick={() => setIsDrawerOpen(false)} className="p-2 hover:bg-slate-50 rounded-lg text-slate-400"><X size={18} /></button>
                            </div>

                            <div className="space-y-8">
                                <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100">
                                    <h4 className="text-lg font-black text-slate-900 mb-1">{editingStudent.name}</h4>
                                    <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Perfil Individual do Aluno</p>
                                </div>

                                {/* Needs Adaptation Switch */}
                                <div className="flex items-center justify-between p-4 bg-purple-50 rounded-2xl border border-purple-100">
                                    <div className="flex items-center gap-3">
                                        <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${editingStudent.needs_adaptation ? 'bg-purple-600 text-white' : 'bg-white text-purple-300'}`}>
                                            <BrainCircuit size={20} />
                                        </div>
                                        <div>
                                            <p className="text-xs font-black text-purple-900 uppercase tracking-tight">Necessita Adaptação?</p>
                                            <p className="text-[9px] font-bold text-purple-400 uppercase tracking-widest">Ativa recursos de IA (PDI/DUA)</p>
                                        </div>
                                    </div>
                                    <button
                                        onClick={() => setEditingStudent({ ...editingStudent, needs_adaptation: !editingStudent.needs_adaptation })}
                                        className={`w-12 h-6 rounded-full transition-colors relative ${editingStudent.needs_adaptation ? 'bg-purple-600' : 'bg-slate-200'}`}
                                    >
                                        <div className={`absolute top-1 left-1 w-4 h-4 bg-white rounded-full transition-transform ${editingStudent.needs_adaptation ? 'translate-x-6' : ''}`}></div>
                                    </button>
                                </div>

                                {/* Tags */}
                                <div>
                                    <label className="text-[9px] font-black text-slate-400 uppercase tracking-[0.3em] mb-3 block">Diagnósticos / Tags</label>
                                    <div className="flex flex-wrap gap-2">
                                        {AVAILABLE_TAGS.map(tag => (
                                            <button
                                                key={tag}
                                                onClick={() => toggleDeficiency(tag)}
                                                className={`px-3 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all ${editingStudent.deficiencies?.includes(tag)
                                                    ? 'bg-slate-900 text-white shadow-lg shadow-slate-200'
                                                    : 'bg-slate-50 text-slate-400 hover:bg-slate-100'
                                                    }`}
                                            >
                                                {tag}
                                            </button>
                                        ))}
                                    </div>
                                </div>

                                {/* Observations */}
                                <div>
                                    <label className="text-[9px] font-black text-slate-400 uppercase tracking-[0.3em] mb-3 block">Observações Pedagógicas</label>
                                    <p className="text-[10px] text-slate-400 mb-2">Detalhe o que funciona melhor para este aluno.</p>
                                    <textarea
                                        value={editingStudent.pedagogical_observations || ''}
                                        onChange={(e) => setEditingStudent({ ...editingStudent, pedagogical_observations: e.target.value })}
                                        placeholder="Ex: Aluno responde bem a estímulos visuais, evitar textos longos sem quebra..."
                                        className="w-full h-32 px-5 py-4 bg-slate-50 border border-slate-100 rounded-2xl text-xs font-medium outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all resize-none"
                                    ></textarea>
                                </div>

                                <button
                                    onClick={saveStudentPDI}
                                    disabled={isSavingStart}
                                    className="w-full py-4 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl shadow-blue-200 hover:bg-blue-700 active:scale-95 transition-all flex items-center justify-center gap-2"
                                >
                                    {isSavingStart ? <Loader2 size={18} className="animate-spin" /> : <Save size={18} />}
                                    Salvar Alterações
                                </button>
                            </div>
                        </div>
                    )}
                </div>
            </div>
        );
    }

    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
                <div>
                    <h2 className="text-2xl font-black text-slate-900 tracking-tight uppercase italic">Minhas Turmas</h2>
                    <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">Gerencie suas salas de aula e listas de alunos</p>
                </div>

                <div className="flex items-center gap-3">
                    <div className="relative">
                        <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                        <input
                            type="text"
                            placeholder="Buscar turma..."
                            className="pl-12 pr-6 py-3 bg-slate-50 border border-slate-100 rounded-2xl text-sm font-bold outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all w-full md:w-64"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </div>

                    {classes.length > 0 && (
                        <button
                            onClick={handleExportData}
                            className="px-6 py-3 bg-green-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest flex items-center gap-2 hover:bg-green-700 transition-all shadow-lg"
                        >
                            <Download size={18} />
                            Exportar
                        </button>
                    )}

                    <label className="cursor-pointer bg-slate-900 text-white px-8 py-3 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center gap-3 hover:bg-blue-600 transition-all shadow-xl shadow-slate-200 active:scale-95">
                        <Upload size={18} />
                        <span>Importar PDF</span>
                        <input type="file" className="hidden" accept="application/pdf" onChange={handleFileUpload} />
                    </label>
                </div>
            </div>

            {error && (
                <div className="p-4 bg-red-50 text-red-600 rounded-2xl text-[10px] font-black uppercase tracking-widest border border-red-100 flex items-center gap-3">
                    <AlertCircle className="w-4 h-4" /> {error}
                    <button onClick={() => setError('')} className="ml-auto"><X size={14} /></button>
                </div>
            )}

            {importStep !== 'idle' && (
                <div className="bg-blue-600 rounded-[2.5rem] p-10 text-white shadow-2xl relative overflow-hidden animate-in zoom-in-95 duration-300">
                    <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 blur-3xl -mr-32 -mt-32"></div>

                    {importStep === 'uploading' || importStep === 'parsing' ? (
                        <div className="flex flex-col items-center text-center py-10">
                            <Loader2 className="w-16 h-16 animate-spin mb-6 text-blue-200" />
                            <h3 className="text-xl font-black uppercase italic tracking-tight">
                                {importStep === 'uploading' ? 'Lendo PDF da Lista...' : 'Gemini processando alunos...'}
                            </h3>
                            <p className="text-blue-200 text-[10px] font-bold uppercase tracking-[0.3em] mt-3">Extraindo inteligência pedagógica</p>
                        </div>
                    ) : (
                        <div className="space-y-6">
                            <div className="flex items-center justify-between">
                                <div>
                                    <h3 className="text-2xl font-black uppercase italic tracking-tight">Turma Encontrada!</h3>
                                    <p className="text-blue-100 text-sm font-bold mt-1">
                                        Encontramos <span className="text-white font-black">{tempClassData?.students.length} alunos</span> na turma <span className="text-white font-black">{tempClassData?.className}</span> ({tempClassData?.subject}).
                                    </p>
                                </div>
                                <div className="flex gap-4">
                                    <button
                                        onClick={() => { setImportStep('idle'); setTempClassData(null); }}
                                        className="px-6 py-3 bg-white/10 hover:bg-white/20 rounded-xl font-black text-[10px] uppercase tracking-widest transition-colors"
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        onClick={confirmSave}
                                        className="px-8 py-3 bg-white text-blue-600 rounded-xl font-black text-[10px] uppercase tracking-widest hover:scale-105 transition-all shadow-lg active:scale-95"
                                    >
                                        Confirmar e Salvar
                                    </button>
                                </div>
                            </div>

                            <div className="bg-white/10 rounded-2xl p-6 max-h-48 overflow-y-auto custom-scrollbar border border-white/10">
                                <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                                    {tempClassData?.students.map((student, i) => (
                                        <div key={i} className="text-[10px] font-bold uppercase tracking-tight text-blue-100 flex items-center gap-2">
                                            <div className="w-1.5 h-1.5 bg-blue-300 rounded-full"></div> {student}
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    )}
                </div>
            )}

            {loading ? (
                <div className="flex flex-col items-center justify-center h-64 text-slate-300">
                    <Loader2 className="w-10 h-10 animate-spin mb-4" />
                    <p className="font-black uppercase tracking-widest text-[10px]">Consultando Turmas Cadastradas...</p>
                </div>
            ) : classes.length === 0 ? (
                <div className="bg-slate-50 border-2 border-dashed border-slate-100 rounded-[2.5rem] p-20 flex flex-col items-center text-center">
                    <div className="w-20 h-20 bg-white rounded-3xl flex items-center justify-center shadow-sm mb-6">
                        <GraduationCap className="text-slate-200" size={40} />
                    </div>
                    <h3 className="text-lg font-black text-slate-900 uppercase italic tracking-tight mb-2">Sua Escola Digital está Vazia</h3>
                    <p className="text-sm font-bold text-slate-400 uppercase tracking-widest max-w-sm">
                        Importe seu arquivo PDF de lista de chamada para começar a personalizar suas aulas.
                    </p>
                </div>
            ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-8">
                    {classes.filter(c => c.name.toLowerCase().includes(searchTerm.toLowerCase())).map((cls) => (
                        <div
                            key={cls.id}
                            className="group bg-white border border-slate-100 rounded-[2.5rem] p-8 shadow-sm hover:shadow-2xl hover:border-blue-100 transition-all duration-500 relative overflow-hidden"
                            onClick={() => handleViewClass(cls.id)}
                        >
                            <div className="absolute top-0 right-0 w-32 h-32 bg-blue-50/50 blur-3xl rounded-full -mr-16 -mt-16 group-hover:bg-blue-100 transition-colors"></div>

                            <div className="flex items-start justify-between mb-6 relative z-10">
                                <div className="w-14 h-14 bg-gradient-to-br from-slate-900 to-slate-800 rounded-2xl flex items-center justify-center text-white shadow-xl shadow-slate-100 group-hover:scale-110 transition-transform">
                                    <Users size={24} />
                                </div>
                                <button
                                    onClick={(e) => { e.stopPropagation(); handleDeleteClass(cls.id); }}
                                    className="p-3 text-slate-300 hover:text-red-500 hover:bg-red-50 rounded-xl transition-colors shrink-0"
                                >
                                    <Trash2 size={18} />
                                </button>
                            </div>

                            <h3 className="font-black text-slate-900 text-xl mb-1 uppercase italic line-clamp-1 tracking-tighter">
                                {cls.name}
                            </h3>
                            <p className="text-[10px] font-black text-blue-600 uppercase tracking-[0.2em] mb-6">{cls.subject || 'Sem Disciplina'}</p>

                            <div className="flex items-center justify-between pt-6 border-t border-slate-50 relative z-10">
                                <div className="flex flex-col">
                                    <p className="text-[9px] font-black text-slate-400 uppercase tracking-widest">Estudantes</p>
                                    <p className="text-lg font-black text-slate-900 italic">{(cls as any).students?.[0]?.count || ((cls as any).students?.length || 0)}</p>
                                </div>
                                <button
                                    className="px-6 py-3 bg-slate-50 text-slate-900 rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-blue-600 hover:text-white transition-all flex items-center gap-2 group/btn"
                                >
                                    Ver Alunos <ChevronRight size={14} className="group-hover/btn:translate-x-1 transition-transform" />
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default ClassManager;
