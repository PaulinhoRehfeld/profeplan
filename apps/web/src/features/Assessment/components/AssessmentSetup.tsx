import React, { useState, useEffect } from 'react';
import { Target, CheckCircle2, AlertCircle, X, Loader2, GraduationCap } from 'lucide-react';
import { getLocalClasses } from '../../../services/localStorageService';
import { searchQuestions } from '../../../services/questionService';
import { generateAssessmentWithContext } from '../../../services/ai/AiAssessmentService';
import { Assessment } from '../../../types';
import { aiQueue } from '../../../services/ai/AiQueue';

interface AssessmentSetupProps {
  userId: string;
  onAssessmentGenerated: (assessment: Assessment) => void;
}

const AssessmentSetup: React.FC<AssessmentSetupProps> = ({ userId, onAssessmentGenerated }) => {
  // Basic Form State
  const [classes, setClasses] = useState<any[]>([]);
  const [selectedClassId, setSelectedClassId] = useState('');
  const [academicPeriod, setAcademicPeriod] = useState('1º Trimestre');
  const [additionalTopics, setAdditionalTopics] = useState('');
  const [difficulty, setDifficulty] = useState<'Fácil' | 'Médio' | 'Difícil'>('Médio');
  const [objectiveCount, setObjectiveCount] = useState(5);
  const [dissertativeCount, setDissertativeCount] = useState(2);
  const [numEnem, setNumEnem] = useState(3);
  const [assessmentValue, setAssessmentValue] = useState(10);

  // Filtered Lessons State
  const [availableLessons, setAvailableLessons] = useState<any[]>([]);
  const [selectedLessonIds, setSelectedLessonIds] = useState<string[]>([]);

  // Status State
  const [isGenerating, setIsGenerating] = useState(false);
  const [queuePosition, setQueuePosition] = useState(0);
  const [error, setError] = useState('');

  useEffect(() => {
    return aiQueue.subscribe((state) => {
      setQueuePosition(state.position);
    });
  }, []);

  // Fetch Classes on Mount
  useEffect(() => {
    if (!userId) return;

    const fetchClasses = async () => {
      try {
        // 1. Try fetching from Supabase (Cloud) - Priority
        const { getClasses } = await import('../../../services/supabaseService');
        const { data, error } = await getClasses(userId);

        if (error) throw error;

        if (data && data.length > 0) {
          setClasses(
            data.map((c: any) => ({
              id: c.id,
              name: c.name,
              subject: c.subject,
              students: Array.isArray(c.students)
                ? c.students
                : Array(c.students?.[0]?.count || 0).fill({}),
            }))
          );
        } else {
          throw new Error('No data from cloud');
        }
      } catch (err) {
        // 2. Fallback to LocalStorage
        const data = getLocalClasses(userId);
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

      const selectedClass = classes.find((c) => c.id === selectedClassId);
      if (!selectedClass) return;

      let allLessons: any[] = [];

      // 1. Fetch ALL lessons (Cloud Priority)
      try {
        const { getLessons } = await import('../../../services/supabaseService');
        const { data } = await getLessons(userId);
        if (data) allLessons = data;
      } catch (error) {
        const { getLocalLessons } = await import('../../../services/localStorageService');
        allLessons = getLocalLessons(userId);
      }

      // 2. Smart Filter Logic
      const filtered = allLessons.filter((lesson) => {
        if (lesson.class_id === selectedClassId) return true;

        const textToSearch = (lesson.topic + ' ' + lesson.content).toLowerCase();
        const className = selectedClass.name.toLowerCase();
        const subject = selectedClass.subject.toLowerCase();

        const isFirstYear =
          className.includes('1º') || className.includes('1ano') || /\b10\d\b/.test(className);
        const isSecondYear =
          className.includes('2º') || className.includes('2ano') || /\b20\d\b/.test(className);
        const isThirdYear =
          className.includes('3º') || className.includes('3ano') || /\b30\d\b/.test(className);

        let gradeMatch = false;
        if (
          isFirstYear &&
          (textToSearch.includes('1º') ||
            textToSearch.includes('1ano') ||
            textToSearch.includes('1 ano'))
        )
          gradeMatch = true;
        if (
          isSecondYear &&
          (textToSearch.includes('2º') ||
            textToSearch.includes('2ano') ||
            textToSearch.includes('2 ano'))
        )
          gradeMatch = true;
        if (
          isThirdYear &&
          (textToSearch.includes('3º') ||
            textToSearch.includes('3ano') ||
            textToSearch.includes('3 ano'))
        )
          gradeMatch = true;

        const subjectMatch = textToSearch.includes(subject);
        return gradeMatch || subjectMatch;
      });

      // 3. Fallback: If smart filter finds nothing, show recent lessons (Safety Net)
      setAvailableLessons(filtered.length > 0 ? filtered : allLessons.slice(0, 15));
      setSelectedLessonIds([]);
    };

    fetchAndFilterLessons();
  }, [selectedClassId, classes, userId]);

  const handleGenerate = async () => {
    if (!selectedClassId) {
      setError('Selecione uma turma primeiro.');
      return;
    }

    setIsGenerating(true);
    setError('');

    try {
      const selectedClass = classes.find((c) => c.id === selectedClassId);
      if (!selectedClass) throw new Error('Turma não encontrada');

      const selectedLessons = availableLessons.filter((l) => selectedLessonIds.includes(l.id));

      // 1. Gera as questões contextuais (Objetivas e Dissertativas) via IA
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
        const topics = selectedLessons.map((l) => l.topic).join(' ');
        const searchQuery = `${selectedClass.subject} ${additionalTopics} ${topics}`.trim();

        try {
          const enemResults = await searchQuestions(searchQuery);
          const selectedEnem = enemResults.slice(0, numEnem);

          const mappedEnemQuestions = selectedEnem.map((q) => {
            const meta = q.metadata;
            const fullQuestionText = [meta.context, meta.alternativesIntroduction]
              .filter(Boolean)
              .join('\n\n');

            return {
              id: `enem_${q.id}`,
              type: 'objective',
              question: `[Questão ENEM ${meta.year || ''}] ${fullQuestionText}`,
              options: meta.alternatives.map((alt: any) => `${alt.letter}) ${alt.text}`),
              correctAnswer: meta.alternatives.find((a: any) => a.isCorrect)?.letter || 'A',
              maxPoints: 1.0,
              difficulty: difficulty,
              rubric: null,
            };
          });

          finalQuestions = [...finalQuestions, ...mappedEnemQuestions];
        } catch (enemError) {
          console.error('Erro ao buscar questões ENEM reais:', enemError);
          alert(
            'Aviso: Não foi possível buscar questões do banco ENEM. A prova foi gerada apenas com as questões contextuais.'
          );
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
        numEnem,
      } as Assessment; // Cast due to potential minor type mismatch in 'numEnem' if not in type def yet

      onAssessmentGenerated(assessment);
    } catch (err: any) {
      setError(err.message || 'Erro ao gerar avaliação.');
    } finally {
      setIsGenerating(false);
    }
  };

  return (
    <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
      <div>
        <h2 className="text-2xl font-black text-slate-900 tracking-tight uppercase italic">
          Criar Avaliação Contextualizada
        </h2>
        <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">
          Ciclo de Feedback Fechado • Baseado no histórico de aulas
        </p>
      </div>

      {error && (
        <div className="p-4 bg-red-50 text-red-600 rounded-2xl text-[10px] font-black uppercase tracking-widest border border-red-100 flex items-center gap-3">
          <AlertCircle className="w-4 h-4" /> {error}
          <button onClick={() => setError('')} className="ml-auto">
            <X size={14} />
          </button>
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
              <option value="1º Trimestre (P1)">1º Trimestre (Prova 1)</option>
              <option value="1º Trimestre (P2)">1º Trimestre (Prova 2)</option>
              <option value="2º Trimestre (P1)">2º Trimestre (Prova 1)</option>
              <option value="2º Trimestre (P2)">2º Trimestre (Prova 2)</option>
              <option value="3º Trimestre (P1)">3º Trimestre (Prova 1)</option>
              <option value="3º Trimestre (P2)">3º Trimestre (Prova 2)</option>
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
                    className={`flex items-start gap-3 p-3 rounded-xl border transition-all cursor-pointer ${
                      selectedLessonIds.includes(lesson.id)
                        ? 'bg-blue-600 border-blue-600 text-white shadow-md'
                        : 'bg-white border-slate-100 text-slate-600 hover:border-blue-200'
                    }`}
                  >
                    <input
                      type="checkbox"
                      className="hidden"
                      checked={selectedLessonIds.includes(lesson.id)}
                      onChange={() => {
                        setSelectedLessonIds((prev) =>
                          prev.includes(lesson.id)
                            ? prev.filter((id) => id !== lesson.id)
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
              min="0"
              max="10"
              value={numEnem}
              onChange={(e) => setNumEnem(parseInt(e.target.value) || 0)}
              className="w-full px-4 py-3 bg-white border border-emerald-200 rounded-xl text-sm font-bold outline-none focus:ring-2 focus:ring-emerald-200"
            />
            <p className="text-[9px] text-emerald-600 mt-2 font-medium leading-tight">
              Busca questões reais do INEP baseadas nos temas das aulas.
            </p>
          </div>

          <div className="bg-blue-50 p-4 rounded-2xl border border-blue-100">
            <label className="block text-[10px] font-black text-blue-700 uppercase tracking-widest mb-3">
              Objetivas Contextuais (IA)
            </label>
            <input
              type="number"
              min="0"
              max="20"
              value={objectiveCount}
              onChange={(e) => setObjectiveCount(parseInt(e.target.value) || 0)}
              className="w-full px-4 py-3 bg-white border border-blue-200 rounded-xl text-sm font-bold outline-none focus:ring-2 focus:ring-blue-200"
            />
            <p className="text-[9px] text-blue-600 mt-2 font-medium leading-tight">
              Questões inéditas criadas pela IA com base no contexto da turma.
            </p>
          </div>

          <div className="bg-purple-50 p-4 rounded-2xl border border-purple-100">
            <label className="block text-[10px] font-black text-purple-700 uppercase tracking-widest mb-3">
              Subjetivas / Dissertativas (IA)
            </label>
            <input
              type="number"
              min="0"
              max="10"
              value={dissertativeCount}
              onChange={(e) => setDissertativeCount(parseInt(e.target.value) || 0)}
              className="w-full px-4 py-3 bg-white border border-purple-200 rounded-xl text-sm font-bold outline-none focus:ring-2 focus:ring-purple-200"
            />
            <p className="text-[9px] text-purple-600 mt-2 font-medium leading-tight">
              Questões abertas para avaliar argumentação e escrita.
            </p>
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
              min="0"
              max="100"
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
                <span className="animate-pulse">
                  {queuePosition > 0
                    ? `Na fila (posição ${queuePosition})...`
                    : 'Construindo Avaliação...'}
                </span>
              </>
            ) : (
              <>
                <GraduationCap size={24} className="group-hover:rotate-12 transition-transform" />
                <Target size={18} />
                Montar Prova Contextualizada
              </>
            )}
          </button>
          <p className="text-center text-[9px] font-bold text-slate-400 uppercase tracking-tighter mt-4">
            A IA analisará as aulas selecionadas e gerará questões híbridas
          </p>
        </div>
      </div>
    </div>
  );
};

export default AssessmentSetup;
