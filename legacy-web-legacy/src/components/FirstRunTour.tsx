import React, { useEffect, useState } from 'react';
import { X, ArrowRight, Check } from 'lucide-react';

const STORAGE_KEY = 'profeplan_first_run_done_v1';

interface FirstRunTourProps {
  activeModeLabel: string;
}

const steps = [
  {
    id: 'sidebar',
    title: 'Menu principal do PROFEPLAN',
    body: 'Aqui você acessa Planejamento, Avaliação, PDI, Meus Arquivos e Minhas Turmas. Pense como o “mapa” do seu workspace.',
  },
  {
    id: 'assistant',
    title: 'Assistente pedagógico + FREEDAY',
    body: 'Na área central você conversa com o assistente, gera planos, materiais e avaliações. A FREEDAY está sempre disponível no canto da tela.',
  },
  {
    id: 'planning',
    title: 'Planejamento Trimestral e Planos de Aula',
    body: 'Nos modos de Planejamento você organiza o trimestre e usa o wizard de Plano de Aula para estruturar cada encontro.',
  },
  {
    id: 'pdi',
    title: 'Inclusão & PDI',
    body: 'Na área de PDI você acompanha alunos com necessidades específicas, gera e valida adaptações com apoio da FREEDAY.',
  },
];

export const FirstRunTour: React.FC<FirstRunTourProps> = ({ activeModeLabel }) => {
  const [visible, setVisible] = useState(false);
  const [stepIndex, setStepIndex] = useState(0);

  useEffect(() => {
    const alreadyDone = localStorage.getItem(STORAGE_KEY);
    if (!alreadyDone) {
      // pequena espera para evitar conflito com carregamento inicial
      const t = setTimeout(() => setVisible(true), 800);
      return () => clearTimeout(t);
    }
  }, []);

  if (!visible) return null;

  const step = steps[stepIndex];
  const isLast = stepIndex === steps.length - 1;

  const finish = () => {
    localStorage.setItem(STORAGE_KEY, '1');
    setVisible(false);
  };

  return (
    <div
      className="fixed inset-0 z-[2200] pointer-events-none"
      aria-label="Tour de primeiro uso do PROFEPLAN"
    >
      {/* Backdrop clicável para pular */}
      <div
        className="absolute inset-0 bg-slate-900/40 backdrop-blur-sm pointer-events-auto"
        onClick={finish}
      />

      {/* Cartão flutuante principal */}
      <div className="absolute bottom-6 left-1/2 -translate-x-1/2 w-full max-w-xl px-4 pointer-events-auto">
        <div className="bg-white rounded-3xl shadow-2xl border border-slate-100 p-5 md:p-6 flex flex-col md:flex-row gap-4 items-start">
          <div className="flex-1">
            <p className="text-[10px] font-black uppercase tracking-[0.3em] text-slate-400 mb-1">
              Passo {stepIndex + 1} de {steps.length}
            </p>
            <h2 className="text-sm md:text-base font-black text-slate-900 mb-1">
              {step.title}
            </h2>
            <p className="text-xs md:text-sm text-slate-600 leading-relaxed">
              {step.body}
            </p>
            <p className="text-[10px] text-slate-400 font-bold uppercase tracking-[0.2em] mt-3">
              Modo atual: {activeModeLabel}
            </p>
          </div>
          <div className="flex flex-col items-stretch gap-2 md:w-40">
            <button
              type="button"
              onClick={() => {
                if (isLast) {
                  finish();
                } else {
                  setStepIndex((prev) => Math.min(prev + 1, steps.length - 1));
                }
              }}
              className="inline-flex items-center justify-center gap-2 px-4 py-2 rounded-full bg-indigo-600 text-white text-[11px] font-black uppercase tracking-[0.2em] hover:bg-indigo-700 transition-colors"
            >
              {isLast ? (
                <>
                  <Check size={14} />
                  Concluir tour
                </>
              ) : (
                <>
                  Próximo
                  <ArrowRight size={14} />
                </>
              )}
            </button>
            <button
              type="button"
              onClick={finish}
              className="inline-flex items-center justify-center gap-1 px-4 py-1.5 rounded-full bg-slate-100 text-slate-500 text-[10px] font-black uppercase tracking-[0.2em] hover:bg-slate-200 transition-colors"
            >
              Pular tour
            </button>
          </div>
          <button
            type="button"
            onClick={finish}
            className="absolute top-3 right-3 p-1.5 rounded-full bg-slate-100 text-slate-400 hover:bg-slate-200 hover:text-slate-700 transition-colors"
            aria-label="Fechar tour"
          >
            <X size={14} />
          </button>
        </div>
      </div>
    </div>
  );
};

