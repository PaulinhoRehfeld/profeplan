import React, { useState, useEffect } from 'react';
import {
    Plus, Loader2, AlertCircle, X, Search, GraduationCap, Download, Upload
} from 'lucide-react';
import { saveClassToLocal, getLocalClasses, getLocalClassDetails, deleteLocalClass, exportClassesToJSON, updateLocalClass } from '../services/localStorageService';
import { updateStudent, getClassDetails, deleteClass } from '../services/supabaseService';
import { Student, Class } from '../types';

// Import SubComponents
import ClassList from './ClassManager/ClassList';
import ClassDetail from './ClassManager/ClassDetail';
import CreateClassModal from './ClassManager/CreateClassModal';
import ImportProcess from './ClassManager/ImportProcess';

const ClassManager: React.FC<{ userId: string; userProfile?: any }> = ({ userId, userProfile }) => {
    const [classes, setClasses] = useState<Class[]>([]);
    const [loading, setLoading] = useState(true);

    // Processing State
    const [importingFile, setImportingFile] = useState<File | null>(null);

    // Filter/Search State
    const [searchTerm, setSearchTerm] = useState('');

    // Selection/Navigation State
    const [selectedClass, setSelectedClass] = useState<Class | null>(null);
    const [isManualCreateOpen, setIsManualCreateOpen] = useState(false);

    const [error, setError] = useState('');

    useEffect(() => {
        fetchClasses();
    }, [userId, userProfile?.active_school_id]);

    const fetchClasses = async () => {
        setLoading(true);
        try {
            // 1. Try fetching from Supabase
            const { getClasses } = await import('../services/supabaseService');

            // Para professores com múltiplas escolas, filtrar por escola ativa
            const schoolId = userProfile?.active_school_id;
            console.log('[ClassManager] Fetching classes for school:', schoolId);

            const { data, error } = await getClasses(userId, schoolId);

            if (error) throw error;

            const remoteClasses = (data || []).map((c: any) => ({
                id: c.id,
                name: c.name,
                subject: c.subject,
                created_at: c.created_at,
                students: Array.isArray(c.students) ? c.students.map((s: any) => ({
                    ...s,
                    name: s?.name && typeof s.name === 'object' ? s.name.name || 'Sem Nome' : s?.name || 'Sem Nome'
                })) : []
            }));

            // Se Supabase retornou vazio (pode ser RLS bloqueando por sessão expirada),
            // usa o localStorage como fallback para não perder dados importados.
            if (remoteClasses.length === 0) {
                const localData = getLocalClasses(userId);
                if (localData.length > 0) {
                    console.warn('[ClassManager] Supabase returned 0 classes. Showing local backup.');
                    setClasses(localData.map(c => ({
                        id: c.id,
                        name: c.name,
                        subject: c.subject,
                        created_at: c.createdAt,
                        students: Array.isArray(c.students) ? c.students.map((s: any) => ({
                            ...s,
                            name: s?.name && typeof s.name === 'object' ? s.name.name || 'Sem Nome' : s?.name || 'Sem Nome',
                            needs_adaptation: s.needs_adaptation ?? false
                        })) : []
                    })));
                    return;
                }
            }

            setClasses(remoteClasses as any);
        } catch (err) {
            console.warn("Supabase fetch failed, falling back to local:", err);
            // Fallback to local
            const data = getLocalClasses(userId);
            setClasses(data.map(c => ({
                id: c.id,
                name: c.name,
                subject: c.subject,
                created_at: c.createdAt,
                students: Array.isArray(c.students) ? c.students.map((s: any) => ({
                    ...s,
                    name: s?.name && typeof s.name === 'object' ? s.name.name || 'Sem Nome' : s?.name || 'Sem Nome',
                    needs_adaptation: s.needs_adaptation ?? false
                })) : []
            })));
        } finally {
            setLoading(false);
        }
    };

    const handleSaveNewClass = async (data: { name: string, subject: string, students: string[] }) => {
        // Salva local primeiro — backup garantido independente do Supabase
        saveClassToLocal(userId, {
            className: data.name,
            subject: data.subject,
            students: data.students
        });

        try {
            const { saveClassStructure } = await import('../services/supabaseService');
            await saveClassStructure(userId, {
                className: data.name,
                subject: data.subject,
                students: data.students,
                schoolId: userProfile?.active_school_id || userProfile?.school_id
            });
        } catch (err: any) {
            const is401 = err?.status === 401 || err?.message?.includes('401') || err?.message?.includes('row-level security');
            console.warn('[ClassManager] Supabase save failed on createClass. Saved locally.', err?.message);
            if (!is401) throw err;
        }

        fetchClasses();
    };

    const handleImportComplete = async (parsedData: { className: string, subject: string, students: string[] }) => {
        // Sempre salva local primeiro — garante que o dado não se perde mesmo com sessão expirada
        saveClassToLocal(userId, parsedData);

        // Tenta sincronizar com Supabase; falha silenciosa (401/RLS) não deve bloquear o usuário
        try {
            const { saveClassStructure } = await import('../services/supabaseService');
            await saveClassStructure(userId, {
                className: parsedData.className,
                subject: parsedData.subject,
                students: parsedData.students,
                schoolId: userProfile?.active_school_id || userProfile?.school_id
            });
        } catch (err: any) {
            const is401 = err?.status === 401 || err?.message?.includes('401') || err?.message?.includes('row-level security');
            console.warn('[ClassManager] Supabase save failed (session issue?). Saved locally.', err?.message);
            if (is401) {
                // Sessão expirada: dado está no localStorage, será sincronizado após o login
                setError('Turma salva localmente. Faça login novamente para sincronizar com o servidor.');
            } else {
                throw err; // Erro inesperado — repassa para o ImportProcess mostrar
            }
        }

        setImportingFile(null);
        fetchClasses();
    };

    const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;
        setImportingFile(file);
        e.target.value = '';
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
                    students: Array.isArray(data.students) ? data.students.map((s: any) => ({
                        ...s,
                        name: s?.name && typeof s.name === 'object' ? s.name.name || 'Sem Nome' : s?.name || 'Sem Nome'
                    })) : []
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
                students: Array.isArray(data.students) ? data.students.map((s: any) => ({
                    ...s,
                    name: s?.name && typeof s.name === 'object' ? s.name.name || 'Sem Nome' : s?.name || 'Sem Nome'
                })) : []
            } as any);
        }
    };

    const handleDeleteClass = async (id: string) => {
        if (!confirm('Tem certeza que deseja excluir esta turma e todos os alunos cadastrados?')) return;

        try {
            const { error } = await deleteClass(id);
            if (error) throw error;

            // Mantém o cache local em sincronia
            deleteLocalClass(id, userId);

            if (selectedClass?.id === id) setSelectedClass(null);

            await fetchClasses();
        } catch (err) {
            console.error('[ClassManager] Error deleting class:', err);
            setError('Erro ao excluir turma. Tente novamente.');
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

    const handleUpdateStudent = async (updatedStudent: Student) => {
        if (!selectedClass) return;

        // 1. Save to Supabase (Best Effort)
        try {
            await updateStudent(updatedStudent.id, {
                needs_adaptation: updatedStudent.needs_adaptation,
                deficiencies: updatedStudent.deficiencies,
                pedagogical_observations: updatedStudent.pedagogical_observations
            });
        } catch (err) {
            console.warn("Update Supabase failed, relying on local", err);
        }

        // 2. Update Local State (Selected Class)
        const updatedStudents = selectedClass.students?.map(s =>
            s.id === updatedStudent.id ? updatedStudent : s
        );

        // 3. PERSIST LOCAL STORAGE (Critical for Data Survival)
                if (updatedStudents) {
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
                            student_code: s.student_code,
                            call_number: s.call_number,
                            needs_adaptation: s.needs_adaptation,
                            deficiencies: s.deficiencies,
                            pedagogical_observations: s.pedagogical_observations
                        }))
                    };

                    updateLocalClass(userId, classToSave);
                }

        // Update selected class state
        setSelectedClass({
            ...selectedClass,
            students: updatedStudents
        });

        // Refresh list
        fetchClasses();
    };

    // --- RENDER ---

    // 1. Detailed View
    if (selectedClass) {
        return (
            <ClassDetail
                selectedClass={selectedClass}
                onClose={() => setSelectedClass(null)}
                onUpdateStudent={handleUpdateStudent}
            />
        );
    }

    // 2. Main List View
    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            {/* Header / Controls */}
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
                <div>
                    <h2 className="text-2xl font-black text-slate-900 tracking-tight uppercase italic">Minhas Turmas</h2>
                    <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">Gerencie suas salas de aula e listas de alunos</p>
                </div>

                <div className="flex items-center gap-3 flex-wrap">
                    <button
                        onClick={() => setIsManualCreateOpen(true)}
                        className="bg-blue-600 text-white px-6 py-3 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center gap-2 hover:bg-blue-700 transition-all shadow-xl shadow-blue-200 active:scale-95"
                    >
                        <Plus size={18} /> Criar Turma
                    </button>

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
                            className="px-6 py-3 bg-green-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest flex items-center gap-2 hover:bg-green-700 transition-all shadow-lg hidden md:flex"
                        >
                            <Download size={18} />
                            Exportar
                        </button>
                    )}

                    <label className="cursor-pointer bg-slate-900 text-white px-6 py-3 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center gap-3 hover:bg-slate-800 transition-all shadow-xl shadow-slate-200 active:scale-95">
                        <Upload size={18} />
                        <span className="hidden sm:inline">Importar PDF</span>
                        <input type="file" className="hidden" accept="application/pdf" onChange={handleFileUpload} />
                    </label>
                </div>
            </div>

            {/* ERROR BANNER */}
            {error && (
                <div className="p-4 bg-red-50 text-red-600 rounded-2xl text-[10px] font-black uppercase tracking-widest border border-red-100 flex items-center gap-3">
                    <AlertCircle className="w-4 h-4" /> {error}
                    <button onClick={() => setError('')} className="ml-auto"><X size={14} /></button>
                </div>
            )}

            {/* IMPORT PROCESS VIEW */}
            {importingFile && (
                <ImportProcess
                    file={importingFile}
                    onCancel={() => setImportingFile(null)}
                    onComplete={handleImportComplete}
                />
            )}

            {/* LOADING STATE */}
            {loading ? (
                <div className="flex flex-col items-center justify-center h-64 text-slate-300">
                    <Loader2 className="w-10 h-10 animate-spin mb-4" />
                    <p className="font-black uppercase tracking-widest text-[10px]">Consultando Turmas Cadastradas...</p>
                </div>
            ) : classes.length === 0 && !importingFile ? (
                /* EMPTY STATE */
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
                /* CLASS GRID */
                !importingFile && (
                    <ClassList
                        classes={classes}
                        loading={loading}
                        searchTerm={searchTerm}
                        onSelectClass={handleViewClass}
                        onDeleteClass={handleDeleteClass}
                    />
                )
            )}

            {/* MODALS */}
            {isManualCreateOpen && (
                <CreateClassModal
                    activeSchoolId={(userProfile as any)?.active_school_id || ''}
                    onClose={() => setIsManualCreateOpen(false)}
                    onSave={handleSaveNewClass}
                />
            )}
        </div >
    );
};

export default ClassManager;
