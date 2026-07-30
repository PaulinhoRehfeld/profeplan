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
  const [isLoadingClasses, setIsLoadingClasses] = useState(true);
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
      setIsLoadingClasses(true);
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
      } finally {
        setIsLoadingClasses(false);
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
        difficulty,
        undefined,
        userId
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
    <div className="mx-auto max-w-5xl space-y-6 px-4 py-6 md:px-8 md:py-8">
      <div>
        <h1 className="text-2xl font-bold tracking-tight text-slate-950 md:text-3xl">
          Monte sua avaliação
        </h1>
        <p className="mt-2 max-w-2xl text-sm leading-6 text-slate-600">
          Selecione a turma e os conteúdos trabalhados. Depois, defina como as questões serão
          distribuídas.
        </p>
      </div>

      {error && (
        <div
          role="alert"
          className="flex items-center gap-3 rounded-xl border border-red-200 bg-red-50 p-4 text-sm font-medium text-red-800"
        >
          <AlertCircle className="w-4 h-4" /> {error}
          <button
            type="button"
            onClick={() => setError('')}
            aria-label="Fechar mensagem de erro"
            className="ui-focus-ring ml-auto rounded-md p-1 hover:bg-red-100"
          >
            <X size={14} />
          </button>
        </div>
      )}

      <div className="space-y-8 rounded-2xl border border-slate-200 bg-white p-4 shadow-sm md:p-8">
        {/* 1. Seleção de Turma */}
        <section aria-labelledby="assessment-context" className="space-y-5">
          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-blue-700">Etapa 1</p>
            <h2 id="assessment-context" className="mt-1 text-lg font-semibold text-slate-950">
              Turma e período
            </h2>
          </div>
          <div className="grid grid-cols-1 gap-5 md:grid-cols-2">
            <div>
              <label
                htmlFor="assessment-class"
                className="mb-2 block text-sm font-medium text-slate-700"
              >
                <Target size={14} className="inline mr-2" />
                Selecione a Turma
              </label>
              <select
                id="assessment-class"
                value={selectedClassId}
                onChange={(e) => setSelectedClassId(e.target.value)}
                disabled={isLoadingClasses}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3 text-sm text-slate-900 disabled:cursor-wait disabled:bg-slate-100"
              >
                <option value="">
                  {isLoadingClasses ? 'Carregando turmas...' : 'Escolha uma turma...'}
                </option>
                {classes.map((cls) => (
                  <option key={cls.id} value={cls.id}>
                    {cls.name} - {cls.subject} ({cls.students.length} alunos)
                  </option>
                ))}
              </select>
              {!isLoadingClasses && classes.length === 0 && (
                <p className="mt-2 text-sm text-amber-700">
                  Nenhuma turma cadastrada. Acesse “Minhas turmas” para importar alunos.
                </p>
              )}
            </div>

            <div>
              <label
                htmlFor="assessment-period"
                className="mb-2 block text-sm font-medium text-slate-700"
              >
                Período Letivo
              </label>
              <select
                id="assessment-period"
                value={academicPeriod}
                onChange={(e) => setAcademicPeriod(e.target.value)}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3 text-sm text-slate-900"
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
        </section>

        {/* 2. Seleção de Aulas */}
        {selectedClassId && (
          <section aria-labelledby="assessment-lessons" className="space-y-4">
            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-blue-700">Etapa 2</p>
              <h2 id="assessment-lessons" className="mt-1 text-lg font-semibold text-slate-950">
                Conteúdos da avaliação
              </h2>
              <p className="mt-1 text-sm text-slate-600">
                Marque as aulas que devem orientar a criação das questões.
              </p>
            </div>
            <div className="grid max-h-64 grid-cols-1 gap-2 overflow-y-auto rounded-xl border border-slate-200 bg-slate-50 p-3 sm:grid-cols-2">
              {availableLessons.length > 0 ? (
                availableLessons.map((lesson) => (
                  <label
                    key={lesson.id}
                    className={`flex min-h-12 cursor-pointer items-start gap-3 rounded-lg border p-3 transition-colors ${
                      selectedLessonIds.includes(lesson.id)
                        ? 'border-blue-500 bg-blue-50 text-blue-950'
                        : 'border-slate-200 bg-white text-slate-700 hover:border-blue-300'
                    }`}
                  >
                    <input
                      type="checkbox"
                      className="sr-only"
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
                        <CheckCircle2 size={16} className="text-blue-600" />
                      ) : (
                        <div className="w-4 h-4 rounded-full border-2 border-slate-200" />
                      )}
                    </div>
                    <div className="flex-1">
                      <p className="line-clamp-2 text-sm font-medium leading-tight">
                        {lesson.topic}
                      </p>
                      <p className="mt-1 text-xs text-slate-500">
                        {new Date(lesson.created_at).toLocaleDateString('pt-BR')}
                      </p>
                    </div>
                  </label>
                ))
              ) : (
                <p className="col-span-full py-6 text-center text-sm text-slate-500">
                  Nenhuma aula encontrada para esta turma.
                </p>
              )}
            </div>
          </section>
        )}

        <div>
          <label
            htmlFor="assessment-topics"
            className="mb-2 block text-sm font-medium text-slate-700"
          >
            Outros conteúdos ou orientações
          </label>
          <textarea
            id="assessment-topics"
            value={additionalTopics}
            onChange={(e) => setAdditionalTopics(e.target.value)}
            placeholder="Ex: Impactos da Revolução Industrial no Brasil, Questões de atualidades..."
            className="ui-focus-ring min-h-24 w-full resize-y rounded-lg border border-slate-300 bg-white px-3 py-3 text-sm text-slate-900"
          />
        </div>

        {/* 3. Configuração da Prova */}
        <section aria-labelledby="assessment-format" className="space-y-5">
          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-blue-700">Etapa 3</p>
            <h2 id="assessment-format" className="mt-1 text-lg font-semibold text-slate-950">
              Formato da avaliação
            </h2>
          </div>
          <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
            <div className="rounded-xl border border-slate-200 bg-slate-50 p-4">
              <label
                htmlFor="assessment-enem"
                className="mb-2 block text-sm font-medium text-slate-700"
              >
                Questões ENEM (Banco de Dados)
              </label>
              <input
                id="assessment-enem"
                type="number"
                min="0"
                max="10"
                value={numEnem}
                onChange={(e) => setNumEnem(parseInt(e.target.value) || 0)}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3 text-sm"
              />
              <p className="mt-2 text-xs leading-5 text-slate-600">
                Busca questões reais do INEP baseadas nos temas das aulas.
              </p>
            </div>

            <div className="rounded-xl border border-slate-200 bg-slate-50 p-4">
              <label
                htmlFor="assessment-objective"
                className="mb-2 block text-sm font-medium text-slate-700"
              >
                Objetivas Contextuais (IA)
              </label>
              <input
                id="assessment-objective"
                type="number"
                min="0"
                max="20"
                value={objectiveCount}
                onChange={(e) => setObjectiveCount(parseInt(e.target.value) || 0)}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3 text-sm"
              />
              <p className="mt-2 text-xs leading-5 text-slate-600">
                Questões inéditas criadas pela IA com base no contexto da turma.
              </p>
            </div>

            <div className="rounded-xl border border-slate-200 bg-slate-50 p-4">
              <label
                htmlFor="assessment-dissertative"
                className="mb-2 block text-sm font-medium text-slate-700"
              >
                Subjetivas / Dissertativas (IA)
              </label>
              <input
                id="assessment-dissertative"
                type="number"
                min="0"
                max="10"
                value={dissertativeCount}
                onChange={(e) => setDissertativeCount(parseInt(e.target.value) || 0)}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3 text-sm"
              />
              <p className="mt-2 text-xs leading-5 text-slate-600">
                Questões abertas para avaliar argumentação e escrita.
              </p>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-4">
            <div>
              <label
                htmlFor="assessment-difficulty"
                className="mb-2 block text-sm font-medium text-slate-700"
              >
                Dificuldade Geral
              </label>
              <select
                id="assessment-difficulty"
                value={difficulty}
                onChange={(e) => setDifficulty(e.target.value as any)}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3 text-sm"
              >
                <option value="Fácil">Fácil</option>
                <option value="Médio">Médio</option>
                <option value="Difícil">Difícil</option>
              </select>
            </div>
            <div>
              <label
                htmlFor="assessment-value"
                className="mb-2 block text-sm font-medium text-slate-700"
              >
                Valor Total da Avaliação
              </label>
              <input
                id="assessment-value"
                type="number"
                min="0"
                max="100"
                value={assessmentValue}
                onChange={(e) => setAssessmentValue(parseInt(e.target.value) || 10)}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3 text-sm"
              />
            </div>
          </div>
        </section>

        <div className="pt-4">
          <button
            type="button"
            onClick={handleGenerate}
            disabled={isGenerating || !selectedClassId}
            aria-busy={isGenerating}
            className="ui-focus-ring flex min-h-12 w-full items-center justify-center gap-3 rounded-lg bg-blue-600 px-6 text-base font-semibold text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:opacity-50"
          >
            {isGenerating ? (
              <>
                <Loader2 className="w-6 h-6 animate-spin" />
                <span aria-live="polite">
                  {queuePosition > 0
                    ? `Na fila (posição ${queuePosition})...`
                    : 'Construindo Avaliação...'}
                </span>
              </>
            ) : (
              <>
                <GraduationCap size={22} />
                <Target size={18} />
                Montar Prova Contextualizada
              </>
            )}
          </button>
          <p className="mt-3 text-center text-sm text-slate-500">
            A IA analisará as aulas selecionadas para criar as questões.
          </p>
        </div>
      </div>
    </div>
  );
};

export default AssessmentSetup;
