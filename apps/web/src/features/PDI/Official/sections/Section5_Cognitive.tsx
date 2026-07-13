import React from 'react';
import { Brain } from 'lucide-react';
import { ChecklistGrid } from '../components/ChecklistGrid';

interface SectionProps {
  onSave: () => void;
}

const COGNITIVE_ITEMS = [
  { key: 'memory_short_term', label: 'Memória de Curto Prazo' },
  { key: 'memory_long_term', label: 'Memória de Longo Prazo' },
  { key: 'memory_auditory', label: 'Memória Auditiva' },
  { key: 'memory_visual', label: 'Memória Visual' },
  { key: 'perception_auditory', label: 'Percepção Auditiva' },
  { key: 'perception_body', label: 'Percepção Corporal' },
  { key: 'perception_spatial', label: 'Percepção Espacial' },
  { key: 'perception_tactile', label: 'Percepção Tátil' },
  { key: 'perception_temporal', label: 'Percepção Temporal' },
  { key: 'perception_visual_cognitive', label: 'Percepção Visual (Cognitiva)' },
  { key: 'attention_alert', label: 'Atenção Alerta' },
  { key: 'attention_alternating', label: 'Atenção Alternada' },
  { key: 'attention_selective', label: 'Atenção Seletiva' },
  { key: 'attention_sustained', label: 'Atenção Sustentada' },
  { key: 'logic_abductive', label: 'Raciocínio Lógico Abdutivo' },
  { key: 'logic_deductive', label: 'Raciocínio Lógico Dedutivo' },
  { key: 'logic_intuitive', label: 'Raciocínio Lógico Intuitivo' },
  { key: 'thought_analytical', label: 'Pensamento Analítico' },
  { key: 'thought_creative', label: 'Pensamento Criativo' },
  { key: 'thought_critical', label: 'Pensamento Crítico' },
  { key: 'thought_synthesis', label: 'Pensamento de Síntese' },
  { key: 'thought_questioning', label: 'Pensamento Questionador' },
  { key: 'thought_systemic', label: 'Pensamento Sistêmico' },
  { key: 'orders_simple', label: 'Compreensão de Ordens Simples' },
  { key: 'orders_complex', label: 'Compreensão de Ordens Complexas' },
];

export const Section5Cognitive: React.FC<SectionProps> = ({ onSave }) => {
  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex items-center gap-3 border-b border-slate-100 pb-4">
        <div className="w-10 h-10 bg-purple-50 rounded-full flex items-center justify-center text-purple-600">
          <Brain className="w-5 h-5" />
        </div>
        <div>
          <h2 className="text-xl font-bold text-slate-900">VII. Aspectos Pedagógicos/Cognitivos</h2>
          <p className="text-sm text-slate-500">Avaliação do Desenvolvimento Cognitivo</p>
        </div>
      </div>

      <ChecklistGrid sectionKey="cognitive" items={COGNITIVE_ITEMS} onSave={onSave} />
    </div>
  );
};
