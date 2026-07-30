import React, { useState, useEffect } from 'react';
import {
  Save,
  FileText,
  Calendar,
  BookOpen,
  Clock,
  Target,
  CheckCircle2,
  Sparkles,
  PenTool,
  Book,
  Loader2,
} from 'lucide-react';
import { aiQueue } from '../../services/ai/AiQueue';
import { useGlobalPlanning, TermPlan } from '../../contexts/GlobalPlanningContext';
import { PlanningAuthority } from '../../services/PlanningAuthorityService';
import { saveGeneratedContent } from '../../services/databaseService';
import { saveTermPlan } from './TermPlanningService';
import { exportToDocx } from '../../services/exportService';
import { parseMarkdownToLessons } from '../../utils/markdownParser';
import { FeedbackWidget } from '../../components/Feedback/FeedbackWidget';
import { feedbackService } from '../../services/feedbackService';
import { PnldService } from '../../services/PnldService';
import { PnldBook } from '../../types';
import { Card } from '../../components/ui';

interface TermPlanningManagerProps {
  userId: string;
  settings: any;
  setSidebarContent?: (content: React.ReactNode) => void;
}

const TermPlanningManager: React.FC<TermPlanningManagerProps> = ({
  userId,
  settings,
  setSidebarContent,
}) => {
  const { currentPlan, updateCurrentPlan, refreshTermPlans } = useGlobalPlanning();
  const [isSaving, setIsSaving] = useState(false);

  // AI Generation
  const [stateBase, setStateBase] = useState('Minas Gerais');
  const [educationSphere, setEducationSphere] = useState('Estadual');
  const [generatedText, setGeneratedText] = useState('');
  const [lessons, setLessons] = useState<any[]>([]);
  const [isGenerating, setIsGenerating] = useState(false);
  const [queuePosition, setQueuePosition] = useState(0);

  // Feedback System
  const [showFeedback, setShowFeedback] = useState(false);
  const [isRegenerating, setIsRegenerating] = useState(false);

  // Form State
  const [period, setPeriod] = useState<number>(1);
  const [regime, setRegime] = useState<'Trimestre'>('Trimestre');
  const [subject, setSubject] = useState('');
  const [grade, setGrade] = useState('');
  const [level, setLevel] = useState<'Ensino Fundamental' | 'Ensino Médio'>('Ensino Médio');
  const [workloadWeekly, setWorkloadWeekly] = useState<number>(2);

  // Reserves
  const [reserves, setReserves] = useState({
    monthlyExam: true,
    termExam: true,
    recovery: true,
  });

  // Grading
  const [grading, setGrading] = useState({
    vistos: 5,
    trabalhos: 5,
    monthlyExam: 10,
    termExam: 10,
    others: 0,
  });

  // PNLD Selection States
  const [usePnld, setUsePnld] = useState(false);
  const [selectedPnldBookId, setSelectedPnldBookId] = useState('');
  const [availableBooks, setAvailableBooks] = useState<PnldBook[]>([]);
  const [isLoadingBooks, setIsLoadingBooks] = useState(false);

  // Auto-Filter Logic
  const filteredBooks = availableBooks.filter((book) => {
    const matchesSubject = !subject
      ? true
      : book.discipline?.toLowerCase().includes(subject.toLowerCase()) ||
        book.title.toLowerCase().includes(subject.toLowerCase());

    // Grade Match (Only if grade is filled)
    // Extract number from input grade (e.g. "2º Ano" -> 2)
    const inputGradeNum = grade ? parseInt(grade.replace(/\D/g, '')) : null;
    const bookGradeNum = book.grade ? parseInt(book.grade.replace(/\D/g, '')) : null;

    const matchesGrade = !inputGradeNum ? true : bookGradeNum === inputGradeNum;

    return matchesSubject && matchesGrade;
  });

  useEffect(() => {
    if (period === 3) {
      setGrading({ vistos: 5, trabalhos: 5, monthlyExam: 15, termExam: 15, others: 0 });
    } else {
      setGrading({ vistos: 5, trabalhos: 5, monthlyExam: 10, termExam: 10, others: 0 });
    }
  }, [period]);

  const totalClasses = workloadWeekly * 12;

  useEffect(() => {
    if (setSidebarContent) setSidebarContent(null);
  }, [setSidebarContent]);

  // Hidrata o formulário quando há um TermPlan selecionado na listagem
  useEffect(() => {
    if (!currentPlan) return;

    setPeriod(currentPlan.period);
    setRegime(currentPlan.regime);
    setSubject(currentPlan.subject);
    setGrade(currentPlan.grade);
    setLevel(currentPlan.level);
    setWorkloadWeekly(currentPlan.workloadWeekly);
    setReserves(currentPlan.reserves);
    setGrading(currentPlan.gradingGrid);
    setStateBase(currentPlan.stateBase || 'Minas Gerais');
    setEducationSphere(currentPlan.educationSphere || 'Estadual');
    setGeneratedText(currentPlan.generatedText || '');
    if (currentPlan.lessons && currentPlan.lessons.length) {
      setLessons(currentPlan.lessons);
    }
  }, [currentPlan]);

  useEffect(() => {
    if (usePnld && availableBooks.length === 0) {
      loadBooks();
    }
  }, [usePnld, availableBooks.length]);

  useEffect(() => {
    return aiQueue.subscribe((state) => {
      setQueuePosition(state.position);
    });
  }, []);

  const loadBooks = async () => {
    setIsLoadingBooks(true);
    const books = await PnldService.getAvailableBooks();
    setAvailableBooks(books);
    setIsLoadingBooks(false);
  };

  const handleGenerate = async () => {
    if (!subject || !grade) return alert('Preencha a Matéria e a Série antes de gerar.');
    setIsGenerating(true);
    try {
      const text: any = await PlanningAuthority.executePlanning({
        subject,
        grade,
        period,
        regime,
        stateBase,
        educationSphere,
        teacherName: settings.userName || 'Professor(a)',
        totalClasses,
        reserves,
        userId: userId,
        level,
        pnld_book_id: selectedPnldBookId || undefined,
        gradingGrid: grading, // Pass grading grid to AI
        userSettings: settings, // 🛡️ GUARDRAILS: Preferences pedagógicas
      });
      setGeneratedText(text);
      if (typeof text === 'string') {
        const parsed = parseMarkdownToLessons(text);
        setLessons(parsed);
      }
    } catch (e: any) {
      alert('⛔ BLOQUEIO DO GESTOR DE IA:\n' + e.message);
    } finally {
      setIsGenerating(false);
      setShowFeedback(true);
    }
  };

  const handleFeedbackSubmit = async (feedbackText: string) => {
    setIsRegenerating(true);
    try {
      await feedbackService.saveFeedback({
        userId,
        feature: 'term_planning',
        feedbackText,
        originalContentSummary: `Grade: ${grade}, Subject: ${subject}`,
      });
      const text: any = await PlanningAuthority.executePlanning({
        subject,
        grade,
        period,
        regime,
        stateBase,
        educationSphere,
        teacherName: settings.userName || 'Professor(a)',
        totalClasses,
        reserves,
        userId: userId,
        level,
        feedback: feedbackText,
        pnld_book_id: selectedPnldBookId || undefined,
        gradingGrid: grading, // Pass grading grid to AI
        userSettings: settings, // 🛡️ GUARDRAILS: Preferences pedagógicas
      });
      setGeneratedText(text);
      if (typeof text === 'string') {
        const parsed = parseMarkdownToLessons(text);
        setLessons(parsed);
      }
    } catch (e: any) {
      alert('Erro na regeneração: ' + e.message);
    } finally {
      setIsRegenerating(false);
    }
  };

  const handleSave = async () => {
    if (!subject || !grade) return alert('Preencha a Matéria e a Série.');
    setIsSaving(true);
    const currentLessons = parseMarkdownToLessons(generatedText);
    const plan: TermPlan = {
      id: currentPlan?.id || `temp_${Date.now()}`,
      created_at: currentPlan?.created_at || new Date().toISOString(),
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
      generatedText,
      lessons: currentLessons,
      pnld_book_id: selectedPnldBookId || undefined,
    };
    try {
      updateCurrentPlan(plan);
      await saveTermPlan(plan, userId);
      await refreshTermPlans(userId);
      if (generatedText) {
        const title = `Planejamento ${period}º Trimestre - ${subject} (${grade})`;
        await saveGeneratedContent(userId, 'trimestral', 'TermPlans', title, generatedText);
      }
      alert('✅ Planejamento Salvo! Verifique em "Meus Arquivos > Planejamentos".');
    } catch (e: any) {
      alert(`Erro ao salvar: ${e.message}`);
    } finally {
      setIsSaving(false);
    }
  };

  const handleExport = async () => {
    const title = `Planejamento_${period}${regime}_${subject}`;
    const content = generatedText || `# PLANEJAMENTO - ${subject} - ${grade}`;
    await exportToDocx(content, title, settings);
  };

  return (
    <div className="w-full space-y-6 pb-24 md:space-y-8">
      <div className="space-y-2 border-b border-slate-200 pb-5">
        <h1 className="text-3xl font-semibold tracking-tight text-slate-950">
          Planejamento trimestral
        </h1>
        <p className="max-w-3xl text-base leading-6 text-slate-600">
          Defina o contexto global para o período letivo.
        </p>
      </div>

      <Card className="grid grid-cols-1 gap-8 p-5 sm:p-6 lg:grid-cols-2">
        {/* Left Col */}
        <div className="space-y-8">
          <div className="mb-2 flex items-center gap-3 text-blue-700">
            <BookOpen aria-hidden="true" className="h-6 w-6" />
            <h2 className="font-black uppercase tracking-widest text-sm">Contexto do Período</h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-400 uppercase">Regime</label>
              <div className="flex bg-slate-100 p-1 rounded-xl">
                <button
                  type="button"
                  disabled
                  className="flex-1 rounded-lg bg-white py-2 text-sm font-semibold text-blue-700 disabled:opacity-100"
                >
                  Trimestre
                </button>
              </div>
            </div>
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-400 uppercase">Período</label>
              <div className="flex gap-2">
                {[1, 2, 3].map((p) => (
                  <button
                    type="button"
                    key={p}
                    onClick={() => setPeriod(p)}
                    aria-pressed={period === p}
                    className={`ui-focus-ring min-h-11 min-w-11 rounded-lg text-base font-semibold transition-colors ${period === p ? 'bg-blue-600 text-white' : 'border border-slate-300 bg-white text-slate-700 hover:bg-slate-50'}`}
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
              type="text"
              aria-label="Disciplina"
              value={subject}
              onChange={(e) => setSubject(e.target.value)}
              className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3.5 py-2 text-base text-slate-900"
              placeholder="Ex: Filosofia"
            />
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-400 uppercase">Série</label>
              <input
                type="text"
                aria-label="Série ou ano"
                value={grade}
                onChange={(e) => setGrade(e.target.value)}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3.5 py-2 text-base text-slate-900"
                placeholder="Ex: 3º Ano"
              />
            </div>
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-400 uppercase">Nível</label>
              <select
                aria-label="Etapa de ensino"
                value={level}
                onChange={(e) => setLevel(e.target.value as any)}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3.5 py-2 text-base text-slate-900"
              >
                <option>Ensino Médio</option>
                <option>Ensino Fundamental</option>
              </select>
            </div>
          </div>

          {/* PNLD SELECTION */}
          <div className="bg-indigo-50/50 p-5 rounded-2xl border border-indigo-100 space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2 text-indigo-600">
                <Book className="w-5 h-5" />
                <h3 className="font-black uppercase tracking-widest text-[10px]">
                  Utilizar Livro PNLD?
                </h3>
              </div>
              <button
                type="button"
                role="switch"
                aria-checked={usePnld}
                aria-label="Usar livro do PNLD como referência"
                onClick={() => {
                  setUsePnld(!usePnld);
                  if (usePnld) setSelectedPnldBookId('');
                }}
                className={`w-10 h-5 rounded-full transition-colors relative ${usePnld ? 'bg-indigo-600' : 'bg-slate-300'}`}
              >
                <div
                  className={`absolute top-1 w-3 h-3 bg-white rounded-full transition-all ${usePnld ? 'left-6' : 'left-1'}`}
                />
              </button>
            </div>

            {usePnld && (
              <div className="animate-in fade-in slide-in-from-top-2 duration-300">
                {isLoadingBooks ? (
                  <div className="flex items-center justify-center p-4">
                    <Loader2 size={20} className="animate-spin text-indigo-500" />
                  </div>
                ) : filteredBooks.length === 0 ? (
                  <div className="text-center py-4 bg-slate-50 rounded-xl border border-dashed border-slate-200">
                    <p className="text-[10px] text-slate-400 font-bold uppercase mb-1">
                      Nenhum livro compatível
                    </p>
                    <p className="text-[9px] text-slate-400">
                      Verifique a Disciplina e Série informadas.
                    </p>
                  </div>
                ) : (
                  <div className="flex flex-col gap-2">
                    {filteredBooks.map((book) => (
                      <button
                        type="button"
                        key={book.id}
                        onClick={() => setSelectedPnldBookId(book.title)}
                        aria-pressed={selectedPnldBookId === book.title}
                        className={`w-full p-3 rounded-xl border transition-all flex items-center gap-4 text-left ${selectedPnldBookId === book.title ? 'bg-white border-indigo-500 shadow-md ring-1 ring-indigo-200' : 'bg-white/50 border-slate-200 hover:border-indigo-300 hover:bg-white'}`}
                      >
                        <div className="w-10 h-12 bg-slate-100 rounded-md flex items-center justify-center shrink-0 border border-slate-200 overflow-hidden">
                          {book.cover_url ? (
                            <img
                              src={book.cover_url}
                              alt={book.title}
                              className="w-full h-full object-cover"
                            />
                          ) : (
                            <Book size={18} className="text-slate-300" />
                          )}
                        </div>
                        <div className="flex-1 min-w-0">
                          <span className="text-[10px] font-black text-slate-700 uppercase leading-snug line-clamp-2 block">
                            {book.title}
                          </span>
                          <span className="text-[9px] font-bold text-slate-400 uppercase mt-0.5 block">
                            {book.discipline || 'Didático'}
                          </span>
                        </div>
                        {selectedPnldBookId === book.title && (
                          <div className="text-indigo-600 animate-in zoom-in spin-in-90 duration-300">
                            <CheckCircle2 size={18} />
                          </div>
                        )}
                      </button>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>

        {/* Right Col */}
        <div className="space-y-8">
          <div className="mb-2 flex items-center gap-3 text-purple-700">
            <Target aria-hidden="true" className="h-6 w-6" />
            <h2 className="font-black uppercase tracking-widest text-sm">Metas e Avaliação</h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-400 uppercase">Aulas Semanais</label>
              <input
                type="number"
                aria-label="Aulas semanais"
                value={workloadWeekly}
                onChange={(e) => setWorkloadWeekly(Number(e.target.value))}
                className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white px-3.5 py-2 text-base text-slate-900"
              />
            </div>
            <div className="space-y-2 opacity-70">
              <label className="text-xs font-bold text-slate-400 uppercase">
                Total Período (Est.)
              </label>
              <div className="w-full p-3 bg-slate-100 border-none rounded-xl font-bold text-slate-500">
                {totalClasses} aulas
              </div>
            </div>
          </div>

          <div className="space-y-3">
            <label className="text-xs font-bold text-slate-400 uppercase">Reservas</label>
            <div className="flex flex-col md:flex-row gap-4">
              {[
                { k: 'monthlyExam', label: 'Prova 1' },
                { k: 'termExam', label: 'Prova 2' },
                { k: 'recovery', label: 'Recuperação' },
              ].map(({ k, label }) => (
                <label key={k} className="flex items-center gap-2 cursor-pointer group">
                  <div
                    className={`w-5 h-5 rounded-md border-2 flex items-center justify-center ${reserves[k as keyof typeof reserves] ? 'bg-purple-600 border-purple-600' : 'border-slate-300'}`}
                  >
                    {reserves[k as keyof typeof reserves] && (
                      <CheckCircle2 size={12} className="text-white" />
                    )}
                  </div>
                  <input
                    type="checkbox"
                    className="sr-only"
                    checked={reserves[k as keyof typeof reserves]}
                    onChange={() =>
                      setReserves((prev) => ({ ...prev, [k]: !prev[k as keyof typeof reserves] }))
                    }
                  />
                  <span className="text-xs font-bold text-slate-600">{label}</span>
                </label>
              ))}
            </div>
          </div>

          <div className="bg-slate-50 rounded-2xl p-5 border border-slate-100">
            <label className="text-xs font-bold text-slate-400 uppercase mb-4 block">
              Grade de Pontos
            </label>
            <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
              {Object.entries(grading).map(([key, val]) => {
                // Map English keys to Portuguese labels
                const labelMap: Record<string, string> = {
                  vistos: 'VISTOS',
                  trabalhos: 'TRABALHOS',
                  monthlyExam: 'PROVA 01',
                  termExam: 'PROVA 02',
                  others: 'OUTROS',
                };
                return (
                  <div key={key}>
                    <span className="text-[10px] font-bold uppercase text-slate-400 block mb-1">
                      {labelMap[key] || key}
                    </span>
                    <input
                      type="number"
                      aria-label={`Pontos para ${labelMap[key] || key}`}
                      value={val}
                      onChange={(e) =>
                        setGrading((prev) => ({ ...prev, [key]: Number(e.target.value) }))
                      }
                      className="ui-focus-ring min-h-11 w-full rounded-lg border border-slate-300 bg-white p-2 text-center text-base font-semibold"
                    />
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </Card>

      {/* AI Generation */}
      <Card className="p-5 sm:p-6">
        <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div className="flex items-center gap-3 text-indigo-700">
            <Sparkles aria-hidden="true" className="h-6 w-6" />
            <h2 className="font-black uppercase tracking-widest text-sm">IA de Planejamento</h2>
          </div>
          <button
            type="button"
            onClick={handleGenerate}
            disabled={isGenerating}
            aria-busy={isGenerating || undefined}
            className="ui-focus-ring inline-flex min-h-11 items-center justify-center gap-2 rounded-lg bg-indigo-700 px-5 text-base font-semibold text-white hover:bg-indigo-800 disabled:cursor-not-allowed disabled:opacity-55"
          >
            {isGenerating ? <Clock className="animate-spin" size={16} /> : <Sparkles size={16} />}
            {isGenerating && queuePosition > 0
              ? `Na fila (posição ${queuePosition})...`
              : isGenerating
                ? 'Gerando...'
                : 'Gerar Planejamento'}
          </button>
        </div>
        <div className="relative">
          {generatedText ? (
            <textarea
              aria-label="Conteúdo do planejamento gerado"
              value={generatedText}
              onChange={(e) => setGeneratedText(e.target.value)}
              className="ui-focus-ring h-96 w-full rounded-lg border border-slate-300 bg-white p-4 text-base leading-6 text-slate-900"
            />
          ) : (
            <div className="flex min-h-32 w-full items-center justify-center rounded-lg border border-dashed border-slate-300 bg-slate-50 p-6 text-center text-base text-slate-600">
              Preencha os dados e gere o plano.
            </div>
          )}
        </div>
      </Card>

      {/* Actions */}
      <div className="flex flex-col-reverse gap-3 sm:flex-row sm:justify-end">
        <button
          type="button"
          onClick={handleExport}
          className="ui-focus-ring min-h-11 rounded-lg border border-slate-300 bg-white px-5 text-base font-semibold text-slate-800 hover:bg-slate-50"
        >
          Word
        </button>
        <button
          type="button"
          onClick={handleSave}
          disabled={isSaving}
          aria-busy={isSaving || undefined}
          className="ui-focus-ring min-h-11 rounded-lg bg-indigo-700 px-6 text-base font-semibold text-white hover:bg-indigo-800 disabled:cursor-not-allowed disabled:opacity-55"
        >
          {isSaving ? 'Salvando...' : 'Salvar planejamento'}
        </button>
      </div>

      <FeedbackWidget
        isVisible={showFeedback}
        onClose={() => setShowFeedback(false)}
        onSubmitFeedback={handleFeedbackSubmit}
        isRegenerating={isRegenerating}
      />
    </div>
  );
};

export default TermPlanningManager;
