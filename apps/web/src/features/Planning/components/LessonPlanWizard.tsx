import React, { useState } from 'react';
import { ArrowLeft, ArrowRight, Check, Loader2 } from 'lucide-react';

interface LessonPlanWizardProps {
  isOpen: boolean;
  onClose: () => void;
  onGenerate: (prompt: string) => Promise<void>;
  defaultSubject?: string;
  defaultGrade?: string;
  defaultLessonTitle?: string;
}

export const LessonPlanWizard: React.FC<LessonPlanWizardProps> = ({
  isOpen,
  onClose,
  onGenerate,
  defaultSubject = '',
  defaultGrade = '',
  defaultLessonTitle = '',
}) => {
  const [step, setStep] = useState(1);
  const [subject, setSubject] = useState(defaultSubject);
  const [grade, setGrade] = useState(defaultGrade);
  const [topic, setTopic] = useState(defaultLessonTitle);
  const [objectives, setObjectives] = useState('');
  const [activities, setActivities] = useState('');
  const [assessment, setAssessment] = useState('');
  const [isGenerating, setIsGenerating] = useState(false);

  // Quando abrir, aplicar presets por etapa/disciplina
  React.useEffect(() => {
    if (!isOpen) return;

    const normalizedSubject = (defaultSubject || '').toLowerCase();
    const normalizedGrade = (defaultGrade || '').toLowerCase();

    let etapa: 'EFI' | 'EFII' | 'EM' | 'OUTRO' = 'OUTRO';
    if (
      normalizedGrade.includes('1º') ||
      normalizedGrade.includes('2º') ||
      normalizedGrade.includes('3º') ||
      normalizedGrade.includes('4º') ||
      normalizedGrade.includes('5º')
    ) {
      etapa = 'EFI';
    } else if (
      normalizedGrade.includes('6º') ||
      normalizedGrade.includes('7º') ||
      normalizedGrade.includes('8º') ||
      normalizedGrade.includes('9º')
    ) {
      etapa = 'EFII';
    } else if (normalizedGrade.includes('em') || normalizedGrade.includes('ensino médio')) {
      etapa = 'EM';
    }

    let area: 'LINGUAGENS' | 'MATEMATICA' | 'HUMANAS' | 'NATUREZA' | 'OUTRA' = 'OUTRA';
    if (normalizedSubject.match(/portugu[eê]s|linguagens|red[aç][aã]o|ingl[eê]s|espanhol|arte/)) {
      area = 'LINGUAGENS';
    } else if (normalizedSubject.includes('matem')) {
      area = 'MATEMATICA';
    } else if (normalizedSubject.match(/hist[oó]ria|geografia|filosofia|sociologia|humanas/)) {
      area = 'HUMANAS';
    } else if (normalizedSubject.match(/ci[eê]ncias|f[ií]sica|qu[ií]mica|biologia|natureza/)) {
      area = 'NATUREZA';
    }

    // Só aplica preset se os campos ainda estiverem vazios
    if (!objectives && !activities && !assessment) {
      if (area === 'MATEMATICA') {
        setObjectives(
          '- Desenvolver o raciocínio lógico dos estudantes.\n' +
            '- Relacionar o conteúdo com situações do cotidiano (problemas contextualizados).\n' +
            (etapa === 'EFI'
              ? '- Explorar a compreensão de quantidades, operações básicas e noção de grandezas.'
              : etapa === 'EFII'
                ? '- Consolidar procedimentos de resolução de problemas com diferentes representações (tabelas, gráficos, equações).'
                : '- Preparar para avaliações externas (ENEM/SAEB) com foco em interpretação de problemas e argumentação matemática.')
        );
        setActivities(
          '- Resolução guiada de problemas em dupla ou grupo pequeno.\n' +
            '- Uso de exemplos próximos da realidade dos estudantes (preços, medidas, tempo, trajetos).\n' +
            (etapa === 'EFI'
              ? '- Atividades manipulativas (cartas numéricas, material dourado, jogos simples).'
              : '- Discussão coletiva de diferentes estratégias de resolução, com registro no quadro.')
        );
        setAssessment(
          '- Observação da participação durante a resolução de problemas.\n' +
            '- 2–3 questões escritas de dificuldade progressiva, com espaço para explicar o raciocínio.\n' +
            '- Registro rápido pelo professor sobre quais alunos precisam de reforço no conteúdo.'
        );
      } else if (area === 'LINGUAGENS') {
        setObjectives(
          '- Desenvolver a compreensão leitora a partir de textos significativos para a turma.\n' +
            '- Ampliar o repertório de gêneros textuais trabalhados em sala.\n' +
            (etapa === 'EM'
              ? '- Estimular a produção de textos autorais com foco em argumentação.'
              : '- Incentivar a oralidade e a escuta ativa em momentos de partilha.')
        );
        setActivities(
          '- Leitura compartilhada ou em grupos de um texto (literário ou não literário) conectado ao tema da unidade.\n' +
            '- Roda de conversa para ativar conhecimentos prévios sobre o tema.\n' +
            '- Atividade de registro (escrito ou multimodal) em que os estudantes expressem compreensão e opinião sobre o texto.'
        );
        setAssessment(
          '- Avaliação formativa por meio da participação na leitura e discussão.\n' +
            '- Coleta de alguns registros escritos para feedback qualitativo (não apenas nota).\n' +
            '- Anotações do professor sobre avanços em fluência, compreensão e produção.'
        );
      } else if (area === 'HUMANAS') {
        setObjectives(
          '- Contextualizar o conteúdo histórico/geográfico com a realidade dos estudantes.\n' +
            '- Desenvolver habilidades de análise crítica de fontes e pontos de vista.\n' +
            '- Relacionar o tema a questões atuais (cidadania, direitos, diversidade).'
        );
        setActivities(
          '- Exploração de imagens, mapas, documentos ou relatos relacionados ao tema da aula.\n' +
            '- Perguntas-problema para orientar a investigação em grupo.\n' +
            '- Socialização das conclusões em forma de cartazes, mapas mentais ou apresentações curtas.'
        );
        setAssessment(
          '- Observação das contribuições nas discussões em grupo.\n' +
            '- Pequeno registro escrito ou gráfico (linha do tempo, esquema, mapa mental) para sintetizar o que foi aprendido.\n' +
            '- Comentários do professor destacando avanços na argumentação e respeito à diversidade de opiniões.'
        );
      } else if (area === 'NATUREZA') {
        setObjectives(
          '- Estimular a curiosidade científica dos estudantes a partir de situações do cotidiano.\n' +
            '- Desenvolver habilidades de observação, registro e explicação de fenômenos naturais.\n' +
            (etapa === 'EM'
              ? '- Articular conceitos de Física/Química/Biologia com resolução de problemas e experimentos guiados.'
              : '- Introduzir vocabulário científico de forma gradual e significativa.')
        );
        setActivities(
          '- Proposição de uma pergunta disparadora sobre um fenômeno (ex.: estados físicos da água, fontes de energia, corpo humano).\n' +
            '- Experimento simples, demonstração ou observação guiada, com registro em tabela ou desenho.\n' +
            '- Discussão coletiva relacionando a experiência aos conceitos científicos da aula.'
        );
        setAssessment(
          '- Verificação dos registros (desenhos, tabelas, frases) produzidos durante o experimento.\n' +
            '- Perguntas orais ou escritas de checagem de compreensão dos conceitos-chave.\n' +
            '- Anotações do professor sobre dificuldades comuns para planejar retomadas.'
        );
      }
    }
  }, [isOpen, defaultSubject, defaultGrade, objectives, activities, assessment]);

  if (!isOpen) return null;

  const canNext =
    (step === 1 && subject.trim() && grade.trim() && topic.trim()) ||
    (step === 2 && objectives.trim()) ||
    (step === 3 && activities.trim()) ||
    step === 4;

  const handleNext = () => {
    if (!canNext) return;
    if (step < 4) setStep((prev) => prev + 1);
  };

  const handlePrev = () => {
    if (step > 1) setStep((prev) => prev - 1);
  };

  const handleFinish = async () => {
    if (isGenerating) return;
    setIsGenerating(true);

    const prompt = `[AÇÃO: PLANO DE AULA DETALHADO]
Crie um plano de aula completo para o tema: "${topic}".

[Contexto]
- Etapa / Série: ${grade || 'Não informado'}
- Disciplina: ${subject || 'Não informada'}

[Objetivos de Aprendizagem]
${objectives || 'Professor não especificou objetivos; proponha objetivos alinhados à BNCC/CRMG.'}

[Atividades e Metodologias]
${activities || 'Sugira atividades adequadas ao tema e à etapa.'}

[Forma de Avaliação]
${assessment || 'Sugira formas de avaliação formativa e somativa para este plano.'}

Respeite o formato padrão de planos do PROFEPLAN.`;

    try {
      await onGenerate(prompt);
      onClose();
    } finally {
      setIsGenerating(false);
    }
  };

  const renderStep = () => {
    if (step === 1) {
      return (
        <>
          <h2 className="text-sm font-black text-slate-900 uppercase tracking-[0.2em] mb-3">
            Passo 1 · Contexto da Aula
          </h2>
          <div className="space-y-3">
            <input
              className="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm focus:ring-2 focus:ring-indigo-100 outline-none"
              placeholder="Disciplina (ex.: Matemática, História...)"
              value={subject}
              onChange={(e) => setSubject(e.target.value)}
            />
            <input
              className="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm focus:ring-2 focus:ring-indigo-100 outline-none"
              placeholder="Série / Ano (ex.: 8º ano EF, 1ª série EM...)"
              value={grade}
              onChange={(e) => setGrade(e.target.value)}
            />
            <input
              className="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm focus:ring-2 focus:ring-indigo-100 outline-none"
              placeholder="Tema da aula (ex.: Equações do 1º grau, Revolução Francesa...)"
              value={topic}
              onChange={(e) => setTopic(e.target.value)}
            />
          </div>
        </>
      );
    }

    if (step === 2) {
      return (
        <>
          <h2 className="text-sm font-black text-slate-900 uppercase tracking-[0.2em] mb-3">
            Passo 2 · Objetivos
          </h2>
          <textarea
            className="w-full h-32 px-4 py-3 rounded-2xl border border-slate-200 text-sm focus:ring-2 focus:ring-indigo-100 outline-none resize-none"
            placeholder="Liste os principais objetivos de aprendizagem para esta aula..."
            value={objectives}
            onChange={(e) => setObjectives(e.target.value)}
          />
        </>
      );
    }

    if (step === 3) {
      return (
        <>
          <h2 className="text-sm font-black text-slate-900 uppercase tracking-[0.2em] mb-3">
            Passo 3 · Atividades & Metodologias
          </h2>
          <textarea
            className="w-full h-32 px-4 py-3 rounded-2xl border border-slate-200 text-sm focus:ring-2 focus:ring-indigo-100 outline-none resize-none"
            placeholder="Descreva atividades, metodologias ativas, momentos da aula..."
            value={activities}
            onChange={(e) => setActivities(e.target.value)}
          />
        </>
      );
    }

    return (
      <>
        <h2 className="text-sm font-black text-slate-900 uppercase tracking-[0.2em] mb-3">
          Passo 4 · Avaliação
        </h2>
        <textarea
          className="w-full h-32 px-4 py-3 rounded-2xl border border-slate-200 text-sm focus:ring-2 focus:ring-indigo-100 outline-none resize-none"
          placeholder="Como você pretende avaliar a aprendizagem nesta aula?"
          value={assessment}
          onChange={(e) => setAssessment(e.target.value)}
        />
      </>
    );
  };

  return (
    <div
      className="fixed inset-0 z-[2000] bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4"
      role="dialog"
      aria-modal="true"
      aria-labelledby="lesson-plan-wizard-title"
    >
      <div className="w-full max-w-xl bg-white rounded-[2rem] shadow-2xl border border-slate-100 flex flex-col">
        <div className="px-5 py-3 border-b border-slate-100 flex items-center justify-between">
          <span
            id="lesson-plan-wizard-title"
            className="text-[10px] font-black uppercase tracking-[0.3em] text-slate-400"
          >
            Wizard · Novo Plano de Aula
          </span>
          <button
            type="button"
            onClick={onClose}
            className="text-slate-400 hover:text-slate-700 text-xs font-bold uppercase tracking-wide"
            aria-label="Fechar wizard de plano de aula"
          >
            Fechar
          </button>
        </div>

        <div className="px-5 py-4 space-y-4">
          <div className="flex items-center gap-2 text-[10px] font-black uppercase tracking-[0.3em] text-slate-400">
            <span
              className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${
                step >= 1 ? 'bg-indigo-600 text-white' : 'bg-slate-200 text-slate-500'
              }`}
            >
              1
            </span>
            <span
              className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${
                step >= 2 ? 'bg-indigo-600 text-white' : 'bg-slate-200 text-slate-500'
              }`}
            >
              2
            </span>
            <span
              className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${
                step >= 3 ? 'bg-indigo-600 text-white' : 'bg-slate-200 text-slate-500'
              }`}
            >
              3
            </span>
            <span
              className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${
                step >= 4 ? 'bg-indigo-600 text-white' : 'bg-slate-200 text-slate-500'
              }`}
            >
              4
            </span>
          </div>

          {renderStep()}
        </div>

        <div className="px-5 py-3 border-t border-slate-100 flex items-center justify-between bg-slate-50/60 rounded-b-[2rem]">
          <button
            type="button"
            onClick={handlePrev}
            disabled={step === 1}
            className="inline-flex items-center gap-1 text-[11px] font-black uppercase tracking-[0.2em] text-slate-500 disabled:opacity-40"
          >
            <ArrowLeft size={14} />
            Voltar
          </button>

          {step < 4 ? (
            <button
              type="button"
              onClick={handleNext}
              disabled={!canNext}
              className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-indigo-600 text-white text-[11px] font-black uppercase tracking-[0.2em] disabled:opacity-40"
            >
              Próximo
              <ArrowRight size={14} />
            </button>
          ) : (
            <button
              type="button"
              onClick={handleFinish}
              disabled={isGenerating}
              className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-emerald-600 text-white text-[11px] font-black uppercase tracking-[0.2em] disabled:opacity-40"
            >
              {isGenerating ? (
                <>
                  <Loader2 size={14} className="animate-spin" />
                  Gerando Plano...
                </>
              ) : (
                <>
                  <Check size={14} />
                  Gerar Plano
                </>
              )}
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
