import React, { useState, useEffect } from 'react';
import {
    FileText, Loader2, CheckCircle2, AlertCircle, X, Target, Printer, Save, GraduationCap
} from 'lucide-react';
import { generateAssessmentWithContext } from '../../services/geminiService';
import { getLocalClasses, getLessonsByClass } from '../../services/localStorageService';
import { exportAssessmentToDocx } from '../../services/exportService';
import PrintableEvaluation from '../../components/PrintableEvaluation';
import type { Assessment } from '../../types';
import { saveAssessment } from './AssessmentService'; // New Service
import { searchQuestions } from '../../services/questionService';
import { EnemQuestion } from '../../types';

interface AssessmentManagerProps {
    userId: string;
    settings?: any;
    setSidebarContent?: (content: React.ReactNode) => void;
}

const AssessmentManager: React.FC<AssessmentManagerProps> = ({ userId, settings, setSidebarContent }) => {
    const [classes, setClasses] = useState<any[]>([]);
    const [selectedClassId, setSelectedClassId] = useState('');
    const [academicPeriod, setAcademicPeriod] = useState('1º Bimestre');
    const [additionalTopics, setAdditionalTopics] = useState('');
    const [difficulty, setDifficulty] = useState<'Fácil' | 'Médio' | 'Difícil'>('Médio');
    const [objectiveCount, setObjectiveCount] = useState(5);
    const [dissertativeCount, setDissertativeCount] = useState(2);
    const [numEnem, setNumEnem] = useState(3);
    const [assessmentValue, setAssessmentValue] = useState(10);

    const [availableLessons, setAvailableLessons] = useState<any[]>([]);
    const [selectedLessonIds, setSelectedLessonIds] = useState<string[]>([]);

    const [isGenerating, setIsGenerating] = useState(false);
    const [generatedAssessment, setGeneratedAssessment] = useState<Assessment | null>(null);
    const [error, setError] = useState('');
    const [showPrintView, setShowPrintView] = useState(false);
    const [isSaving, setIsSaving] = useState(false);

    useEffect(() => {
        if (!userId) return;

        const fetchClasses = async () => {
            try {
                console.log(`[Assessment] Buscando turmas para o usuário: ${userId}`);
                // 1. Try fetching from Supabase (Cloud) - Priority
                const { getClasses } = await import('../../services/supabaseService');
                const { data, error } = await getClasses(userId);

                if (error) throw error;

                if (data && data.length > 0) {
                    console.log(`[Assessment] ${data.length} turmas encontradas no Supabase.`);
                    setClasses(data.map((c: any) => ({
                        id: c.id,
                        name: c.name,
                        subject: c.subject,
                        // Fix for student count: Handle both list and count object
                        students: Array.isArray(c.students)
                            ? c.students
                            : Array(c.students?.[0]?.count || 0).fill({})
                    })));
                } else {
                    console.warn("[Assessment] Nenhuma turma encontrada no Supabase, tentando local...");
                    throw new Error("No data from cloud");
                }
            } catch (err) {
                console.warn("[Assessment] Supabase fetch error, fallback to local:", err);
                // 2. Fallback to LocalStorage
                const data = getLocalClasses(userId);
                console.log(`[Assessment] ${data.length} turmas encontradas no LocalStorage.`);
                setClasses(data);
            }
        };

        fetchClasses();
    }, [userId]);

    /* --- SMART LESSON FILTERING --- */
    useEffect(() => {
        const fetchAndFilterLessons = async () => {
            if (!selectedClassId) {
                setAvailableLessons([]);
                return;
            }

            const selectedClass = classes.find(c => c.id === selectedClassId);
            if (!selectedClass) return;

            let allLessons: any[] = [];

            // 1. Fetch ALL lessons (Cloud Priority)
            try {
                const { getLessons } = await import('../../services/supabaseService');
                const { data } = await getLessons(userId);
                if (data) allLessons = data;
            } catch (error) {
                console.warn("Using local lessons fallback");
                const { getLocalLessons } = await import('../../services/localStorageService');
                allLessons = getLocalLessons(userId);
            }

            // 2. Smart Filter Logic
            const filtered = allLessons.filter(lesson => {
                // A. Direct Link (if exists)
                if (lesson.class_id === selectedClassId) return true;

                // B. Content/Context Match (The "Smart" Part)
                const textToSearch = (lesson.topic + ' ' + lesson.content).toLowerCase();
                const className = selectedClass.name.toLowerCase();
                const subject = selectedClass.subject.toLowerCase();

                // Grade Detection (1º, 2º, 3º or 100, 200, 300 series)
                const isFirstYear = className.includes('1º') || className.includes('1ano') || /\b10\d\b/.test(className);
                const isSecondYear = className.includes('2º') || className.includes('2ano') || /\b20\d\b/.test(className);
                const isThirdYear = className.includes('3º') || className.includes('3ano') || /\b30\d\b/.test(className);

                let gradeMatch = false;
                if (isFirstYear && (textToSearch.includes('1º') || textToSearch.includes('1ano') || textToSearch.includes('1 ano'))) gradeMatch = true;
                if (isSecondYear && (textToSearch.includes('2º') || textToSearch.includes('2ano') || textToSearch.includes('2 ano'))) gradeMatch = true;
                if (isThirdYear && (textToSearch.includes('3º') || textToSearch.includes('3ano') || textToSearch.includes('3 ano'))) gradeMatch = true;

                // Subject Match
                const subjectMatch = textToSearch.includes(subject);

                // Permissive: If matches grade AND subject, it's a strong candidate. 
                // We also include if it JUST matches the Subject closely to be helpful.
                return gradeMatch || subjectMatch;
            });

            // 3. Fallback: If smart filter finds nothing, show recent lessons (Safety Net)
            setAvailableLessons(filtered.length > 0 ? filtered : allLessons.slice(0, 15));
            setSelectedLessonIds([]);
        };

        fetchAndFilterLessons();
    }, [selectedClassId, classes, userId]);

    /* SIDEBAR EFFECT */
    useEffect(() => {
        if (!setSidebarContent) return;

        if (generatedAssessment && !showPrintView) {
            setSidebarContent(
                <div className="space-y-6 animate-in slide-in-from-right-4 duration-500">
                    <div className="bg-gradient-to-br from-indigo-50 to-purple-50 border border-indigo-100 rounded-[2.5rem] p-6 shadow-lg">
                        <h3 className="text-[10px] font-black text-indigo-400 uppercase tracking-[0.2em] mb-6 italic">
                            Centro de Comando
                        </h3>

                        <div className="space-y-3">
                            <button
                                onClick={handlePrint}
                                className="w-full bg-indigo-600 text-white px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-indigo-700 transition-all shadow-lg hover:shadow-indigo-200 active:scale-95 group"
                            >
                                <Printer size={18} className="group-hover:rotate-12 transition-transform" />
                                Imprimir Prova
                            </button>

                            <button
                                onClick={handleExportWord}
                                className="w-full bg-white text-indigo-700 px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-indigo-50 border border-indigo-100 transition-all shadow-sm active:scale-95 group"
                            >
                                <FileText size={18} className="group-hover:-translate-y-0.5 transition-transform" />
                                Exportar Word
                            </button>

                            <button
                                onClick={handleSave}
                                disabled={isSaving}
                                className="w-full bg-purple-600 text-white px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-purple-700 transition-all shadow-lg hover:shadow-purple-200 active:scale-95 group disabled:opacity-50"
                            >
                                {isSaving ? <Loader2 className="animate-spin" /> : <Save size={18} className="group-hover:scale-110 transition-transform" />}
                                {isSaving ? 'Salvando...' : 'Salvar Avaliação'}
                            </button>
                        </div>
                    </div>

                    <div className="bg-slate-900 rounded-[2.5rem] p-6 shadow-xl text-white relative overflow-hidden group">
                        <div className="absolute top-0 right-0 w-32 h-32 bg-purple-500/10 blur-3xl group-hover:bg-purple-500/20 transition-all"></div>

                        <h3 className="text-[9px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4 flex items-center gap-2">
                            <Target size={12} className="text-purple-400" /> Métricas
                        </h3>

                        <div className="grid grid-cols-2 gap-4">
                            <div className="bg-white/5 p-3 rounded-2xl border border-white/10">
                                <p className="text-[9px] text-slate-400 uppercase tracking-widest mb-1">Questões</p>
                                <p className="text-xl font-black">{generatedAssessment.questions.length}</p>
                            </div>
                            <div className="bg-white/5 p-3 rounded-2xl border border-white/10">
                                <p className="text-[9px] text-slate-400 uppercase tracking-widest mb-1">Pontos</p>
                                <p className="text-xl font-black text-purple-400">{generatedAssessment.totalPoints}</p>
                            </div>
                            <div className="bg-white/5 p-3 rounded-2xl border border-white/10 col-span-2 flex justify-between items-center px-4">
                                <span className="text-[9px] text-slate-400 uppercase tracking-widest">Objetivas</span>
                                <span className="font-bold text-green-400">{generatedAssessment.questions.filter(q => q.type === 'objective').length}</span>
                            </div>
                            <div className="bg-white/5 p-3 rounded-2xl border border-white/10 col-span-2 flex justify-between items-center px-4">
                                <span className="text-[9px] text-slate-400 uppercase tracking-widest">Dissertativas</span>
                                <span className="font-bold text-purple-400">{generatedAssessment.questions.filter(q => q.type === 'dissertative').length}</span>
                            </div>
                        </div>
                    </div>
                </div>
            );
        } else {
            setSidebarContent(null);
        }

        return () => {
            setSidebarContent(null);
        };
    }, [generatedAssessment, showPrintView, setSidebarContent, isSaving]);


    const handleGenerate = async () => {
        if (!selectedClassId) {
            setError('Selecione uma turma primeiro.');
            return;
        }

        setIsGenerating(true);
        setError('');

        try {
            const selectedClass = classes.find(c => c.id === selectedClassId);
            if (!selectedClass) throw new Error('Turma não encontrada');

            const selectedLessons = availableLessons.filter(l => selectedLessonIds.includes(l.id));

            // 1. Gera as questões contextuais (Objetivas e Dissertativas) via IA
            // Passamos 0 no numEnem para a IA não gerar questões fake
            const result = await generateAssessmentWithContext(
                selectedClass.name,
                selectedClass.subject,
                selectedLessons,
                additionalTopics,
                academicPeriod,
                objectiveCount,
                dissertativeCount,
                0, // 0 ENEM via IA
                difficulty
            );

            let finalQuestions = [...result.questions];

            // 2. Busca questões REAIS do ENEM no Banco de Dados
            if (numEnem > 0) {
                // Constrói query de busca baseada no contexto
                const topics = selectedLessons.map(l => l.topic).join(' ');
                const searchQuery = `${selectedClass.subject} ${additionalTopics} ${topics}`.trim();

                try {
                    console.log("🔍 Buscando questões ENEM reais para:", searchQuery);
                    const enemResults = await searchQuestions(searchQuery);

                    // Pega as top N questões
                    const selectedEnem = enemResults.slice(0, numEnem);

                    // Mapeia para o formato de AssessmentQuestion
                    const mappedEnemQuestions = selectedEnem.map(q => {
                        const meta = q.metadata;
                        // Combina contexto e enunciado
                        const fullQuestionText = [meta.context, meta.alternativesIntroduction]
                            .filter(Boolean)
                            .join('\n\n');

                        return {
                            id: `enem_${q.id}`,
                            type: 'objective',
                            question: `[Questão ENEM ${meta.year || ''}] ${fullQuestionText}`,
                            options: meta.alternatives.map((alt: any) => `${alt.letter}) ${alt.text}`),
                            correctAnswer: meta.alternatives.find((a: any) => a.isCorrect)?.letter || 'A',
                            maxPoints: 1.0, // Valor padrão, pode ser ajustado
                            difficulty: difficulty,
                            rubric: null
                        };
                    });

                    finalQuestions = [...finalQuestions, ...mappedEnemQuestions];

                } catch (enemError) {
                    console.error("Erro ao buscar questões ENEM reais:", enemError);
                    alert("Aviso: Não foi possível buscar questões do banco ENEM. A prova foi gerada apenas com as questões contextuais.");
                }
            }

            const assessment: Assessment = {
                id: `assessment_${Date.now()}`,
                title: result.title,
                questions: finalQuestions,
                classId: selectedClassId,
                className: selectedClass.name,
                subject: selectedClass.subject,
                createdAt: new Date().toISOString(),
                totalPoints: assessmentValue,
                academicPeriod,
                difficulty,
                numEnem
            };

            setGeneratedAssessment(assessment);
        } catch (err: any) {
            setError(err.message || 'Erro ao gerar avaliação.');
        } finally {
            setIsGenerating(false);
        }
    };

    const handlePrint = () => {
        if (!generatedAssessment) return;
        setShowPrintView(true);
    };

    const handleSave = async () => {
        if (!generatedAssessment) return;
        setIsSaving(true);

        try {
            // Usa o novo Service Local-First
            await saveAssessment(userId, generatedAssessment);
            alert('✅ Avaliação salva com sucesso!');
        } catch (error: any) {
            console.error('Erro ao salvar:', error);
            alert('⚠️ ' + error.message);
        } finally {
            setIsSaving(false);
        }
    };

    const handleExportWord = async () => {
        if (!generatedAssessment) return;
        try {
            await exportAssessmentToDocx(generatedAssessment, settings);
        } catch (error) {
            console.error('Erro ao exportar Word:', error);
            alert('Erro ao exportar para Word.');
        }
    };

    if (showPrintView && generatedAssessment) {
        return (
            <>
                <button
                    onClick={() => setShowPrintView(false)}
                    className="no-print fixed top-10 left-10 z-[200] px-6 py-3 bg-white text-slate-900 rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl hover:bg-slate-100 transition-all"
                >
                    ← Voltar para Edição
                </button>
                <PrintableEvaluation
                    assessment={generatedAssessment}
                    schoolName={settings?.institution || 'Sua Escola'}
                    logoBase64={settings?.logoBase64}
                />
            </>
        );
    }

    if (generatedAssessment) {
        return (
            <div className="flex w-full animate-in fade-in slide-in-from-right-4 duration-500">
                <div className="w-full max-w-5xl mx-auto space-y-8">
                    <div className="flex items-center justify-between">
                        <div>
                            <h2 className="text-3xl font-black text-slate-900 tracking-tight uppercase italic">{generatedAssessment.title}</h2>
                            <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">
                                {generatedAssessment.className} • {generatedAssessment.subject}
                            </p>
                        </div>
                        <button
                            onClick={() => { setGeneratedAssessment(null); if (setSidebarContent) setSidebarContent(null); }}
                            className="p-3 hover:bg-slate-100 rounded-2xl transition-colors"
                        >
                            <X size={20} />
                        </button>
                    </div>

                    <div className="space-y-6">
                        {generatedAssessment.questions.map((q, index) => (
                            <div key={q.id} className="bg-white border border-slate-100 rounded-[2.5rem] p-10 shadow-sm transition-all hover:shadow-md">
                                <div className="flex items-start gap-6">
                                    <div className="w-14 h-14 bg-gradient-to-br from-blue-600 to-indigo-700 rounded-2xl flex items-center justify-center text-white font-black text-xl shrink-0 shadow-lg shadow-blue-100">
                                        {index + 1}
                                    </div>
                                    <div className="flex-1">
                                        <div className="flex items-center gap-3 mb-5">
                                            <span className={`px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest ${q.type === 'objective' ? 'bg-green-100 text-green-700' : 'bg-purple-100 text-purple-700'
                                                }`}>
                                                {q.type === 'objective' ? 'Objetiva' : 'Dissertativa'}
                                            </span>
                                            <span className="text-xs font-bold text-slate-400">{q.maxPoints} pontos</span>
                                        </div>
                                        <p className="text-base font-medium text-slate-900 mb-6 leading-relaxed">{q.question}</p>

                                        {q.type === 'objective' && q.options && (
                                            <div className="space-y-3">
                                                {q.options.map((opt, i) => (
                                                    <div
                                                        key={i}
                                                        className={`p-4 rounded-xl border-2 transition-all ${opt.startsWith(q.correctAnswer || '')
                                                            ? 'border-green-200 bg-green-50 font-bold text-green-800'
                                                            : 'border-transparent bg-slate-50 text-slate-600 hover:border-slate-100'
                                                            }`}
                                                    >
                                                        <span className="text-sm">{opt}</span>
                                                    </div>
                                                ))}
                                            </div>
                                        )}

                                        {q.type === 'dissertative' && q.rubric && (
                                            <div className="p-6 bg-indigo-50 border border-indigo-100 rounded-2xl">
                                                <p className="text-[10px] font-black text-indigo-600 uppercase tracking-widest mb-3">Rubrica de Correção</p>
                                                <p className="text-xs text-indigo-900 leading-relaxed font-medium">{q.rubric}</p>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>

                    {/* MOBILE ACTION BAR (Visible when Sidebar is hidden on small screens) */}
                    <div className="lg:hidden grid grid-cols-1 gap-3 pt-4 pb-10">
                        <button
                            onClick={handleSave}
                            disabled={isSaving}
                            className="w-full bg-purple-600 text-white px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 active:scale-95 transition-all shadow-lg disabled:opacity-50"
                        >
                            {isSaving ? <Loader2 className="animate-spin" /> : <Save size={18} />}
                            {isSaving ? 'Salvando...' : 'Salvar Avaliação'}
                        </button>

                        <div className="grid grid-cols-2 gap-3">
                            <button
                                onClick={handlePrint}
                                className="w-full bg-indigo-100 text-indigo-700 px-4 py-3 rounded-xl font-black text-[10px] uppercase tracking-widest flex items-center justify-center gap-2 active:scale-95 transition-all"
                            >
                                <Printer size={16} /> Imprimir
                            </button>
                            <button
                                onClick={handleExportWord}
                                className="w-full bg-blue-100 text-blue-700 px-4 py-3 rounded-xl font-black text-[10px] uppercase tracking-widest flex items-center justify-center gap-2 active:scale-95 transition-all"
                            >
                                <FileText size={16} /> Baixar Word
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div>
                <h2 className="text-2xl font-black text-slate-900 tracking-tight uppercase italic">Criar Avaliação Contextualizada</h2>
                <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">Ciclo de Feedback Fechado • Baseado no histórico de aulas</p>
            </div>

            {error && (
                <div className="p-4 bg-red-50 text-red-600 rounded-2xl text-[10px] font-black uppercase tracking-widest border border-red-100 flex items-center gap-3">
                    <AlertCircle className="w-4 h-4" /> {error}
                    <button onClick={() => setError('')} className="ml-auto"><X size={14} /></button>
                </div>
            )}

            <div className="bg-white border border-slate-100 rounded-[2.5rem] p-10 shadow-sm space-y-8">
                {/* 1. Seleção de Turma */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div>
                        <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
                            <Target size={14} className="inline mr-2" />
                            Selecione a Turma
                        </label>
                        <select
                            value={selectedClassId}
                            onChange={(e) => setSelectedClassId(e.target.value)}
                            className="w-full px-6 py-4 bg-slate-50 border border-slate-100 rounded-2xl text-sm font-bold outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all appearance-none"
                        >
                            <option value="">Escolha uma turma...</option>
                            {classes.map((cls) => (
                                <option key={cls.id} value={cls.id}>
                                    {cls.name} - {cls.subject} ({cls.students.length} alunos)
                                </option>
                            ))}
                        </select>
                        {classes.length === 0 && (
                            <p className="text-xs text-amber-600 mt-2 font-bold">
                                ⚠️ Nenhuma turma cadastrada. Vá em "Minhas Turmas" para importar alunos.
                            </p>
                        )}
                    </div>

                    <div>
                        <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
                            Período Letivo
                        </label>
                        <select
                            value={academicPeriod}
                            onChange={(e) => setAcademicPeriod(e.target.value)}
                            className="w-full px-6 py-4 bg-slate-50 border border-slate-100 rounded-2xl text-sm font-bold outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all appearance-none"
                        >
                            <option value="1º Bimestre">1º Bimestre</option>
                            <option value="2º Bimestre">2º Bimestre</option>
                            <option value="3º Bimestre">3º Bimestre</option>
                            <option value="4º Bimestre">4º Bimestre</option>
                            <option value="1º Trimestre">1º Trimestre</option>
                            <option value="2º Trimestre">2º Trimestre</option>
                            <option value="3º Trimestre">3º Trimestre</option>
                        </select>
                    </div>
                </div>

                {/* 2. Seleção de Aulas */}
                {selectedClassId && (
                    <div className="animate-in fade-in slide-in-from-top-4 duration-300">
                        <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3 text-blue-600">
                            Aulas Ministradas (Filtro de Conteúdo)
                        </label>
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 max-h-48 overflow-y-auto p-4 bg-slate-50 rounded-2xl border border-slate-100">
                            {availableLessons.length > 0 ? (
                                availableLessons.map((lesson) => (
                                    <label
                                        key={lesson.id}
                                        className={`flex items-start gap-3 p-3 rounded-xl border transition-all cursor-pointer ${selectedLessonIds.includes(lesson.id)
                                            ? 'bg-blue-600 border-blue-600 text-white shadow-md'
                                            : 'bg-white border-slate-100 text-slate-600 hover:border-blue-200'
                                            }`}
                                    >
                                        <input
                                            type="checkbox"
                                            className="hidden"
                                            checked={selectedLessonIds.includes(lesson.id)}
                                            onChange={() => {
                                                setSelectedLessonIds(prev =>
                                                    prev.includes(lesson.id)
                                                        ? prev.filter(id => id !== lesson.id)
                                                        : [...prev, lesson.id]
                                                );
                                            }}
                                        />
                                        <div className="pt-0.5">
                                            {selectedLessonIds.includes(lesson.id) ? (
                                                <CheckCircle2 size={16} />
                                            ) : (
                                                <div className="w-4 h-4 rounded-full border-2 border-slate-200" />
                                            )}
                                        </div>
                                        <div className="flex-1">
                                            <p className="text-[11px] font-black leading-tight uppercase line-clamp-1">
                                                {lesson.topic}
                                            </p>
                                            <p className={`text-[9px] font-bold opacity-70 mt-0.5`}>
                                                {new Date(lesson.created_at).toLocaleDateString('pt-BR')}
                                            </p>
                                        </div>
                                    </label>
                                ))
                            ) : (
                                <p className="col-span-full py-4 text-center text-[10px] font-bold text-slate-400 uppercase italic">
                                    Nenhuma aula encontrada para esta turma no Supabase.
                                </p>
                            )}
                        </div>
                    </div>
                )}

                <div>
                    <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
                        Assuntos Específicos Adicionais
                    </label>
                    <textarea
                        value={additionalTopics}
                        onChange={(e) => setAdditionalTopics(e.target.value)}
                        placeholder="Ex: Impactos da Revolução Industrial no Brasil, Questões de atualidades..."
                        className="w-full px-6 py-4 bg-slate-50 border border-slate-100 rounded-2xl text-sm font-bold outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all min-h-[100px] resize-none"
                    />
                </div>

                {/* 3. Configuração da Prova */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div className="bg-emerald-50 p-4 rounded-2xl border border-emerald-100">
                        <label className="block text-[10px] font-black text-emerald-700 uppercase tracking-widest mb-3">
                            Questões ENEM (Banco de Dados)
                        </label>
                        <input
                            type="number"
                            min="0" max="10"
                            value={numEnem}
                            onChange={(e) => setNumEnem(parseInt(e.target.value) || 0)}
                            className="w-full px-4 py-3 bg-white border border-emerald-200 rounded-xl text-sm font-bold outline-none focus:ring-2 focus:ring-emerald-200"
                        />
                        <p className="text-[9px] text-emerald-600 mt-2 font-medium leading-tight">Busca questões reais do INEP baseadas nos temas das aulas.</p>
                    </div>

                    <div className="bg-blue-50 p-4 rounded-2xl border border-blue-100">
                        <label className="block text-[10px] font-black text-blue-700 uppercase tracking-widest mb-3">
                            Objetivas Contextuais (IA)
                        </label>
                        <input
                            type="number"
                            min="0" max="20"
                            value={objectiveCount}
                            onChange={(e) => setObjectiveCount(parseInt(e.target.value) || 0)}
                            className="w-full px-4 py-3 bg-white border border-blue-200 rounded-xl text-sm font-bold outline-none focus:ring-2 focus:ring-blue-200"
                        />
                        <p className="text-[9px] text-blue-600 mt-2 font-medium leading-tight">Questões inéditas criadas pela IA com base no contexto da turma.</p>
                    </div>

                    <div className="bg-purple-50 p-4 rounded-2xl border border-purple-100">
                        <label className="block text-[10px] font-black text-purple-700 uppercase tracking-widest mb-3">
                            Subjetivas / Dissertativas (IA)
                        </label>
                        <input
                            type="number"
                            min="0" max="10"
                            value={dissertativeCount}
                            onChange={(e) => setDissertativeCount(parseInt(e.target.value) || 0)}
                            className="w-full px-4 py-3 bg-white border border-purple-200 rounded-xl text-sm font-bold outline-none focus:ring-2 focus:ring-purple-200"
                        />
                        <p className="text-[9px] text-purple-600 mt-2 font-medium leading-tight">Questões abertas para avaliar argumentação e escrita.</p>
                    </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-4">
                    <div>
                        <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
                            Dificuldade Geral
                        </label>
                        <select
                            value={difficulty}
                            onChange={(e) => setDifficulty(e.target.value as any)}
                            className="w-full px-4 py-3 bg-slate-50 border border-slate-100 rounded-xl text-sm font-bold outline-none appearance-none"
                        >
                            <option value="Fácil">Fácil</option>
                            <option value="Médio">Médio</option>
                            <option value="Difícil">Difícil</option>
                        </select>
                    </div>
                    <div>
                        <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
                            Valor Total da Avaliação
                        </label>
                        <input
                            type="number"
                            min="0" max="100"
                            value={assessmentValue}
                            onChange={(e) => setAssessmentValue(parseInt(e.target.value) || 10)}
                            className="w-full px-4 py-3 bg-slate-50 border border-slate-100 rounded-xl text-sm font-bold outline-none"
                        />
                    </div>
                </div>

                <div className="pt-4">
                    <button
                        onClick={handleGenerate}
                        disabled={isGenerating || !selectedClassId}
                        className="w-full bg-gradient-to-r from-blue-600 to-indigo-700 text-white px-10 py-5 rounded-[2rem] font-black text-sm uppercase tracking-widest hover:scale-[1.02] active:scale-95 transition-all shadow-2xl shadow-blue-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 group"
                    >
                        {isGenerating ? (
                            <>
                                <Loader2 className="w-6 h-6 animate-spin" />
                                <span className="animate-pulse">Gemini Construindo Avaliação...</span>
                            </>
                        ) : (
                            <>
                                <GraduationCap size={24} className="group-hover:rotate-12 transition-transform" />
                                Montar Prova Contextualizada
                            </>
                        )}
                    </button>
                    <p className="text-center text-[9px] font-bold text-slate-400 uppercase tracking-tighter mt-4">
                        O Gemini analisará as aulas selecionadas e gerará questões híbridas (v1.5 Flash)
                    </p>
                </div>
            </div>
        </div>
    );
};

export default AssessmentManager;
