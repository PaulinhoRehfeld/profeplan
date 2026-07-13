import React from 'react';
import { Activity } from 'lucide-react';
import { ChecklistGrid } from '../components/ChecklistGrid';

interface SectionProps {
  onSave: () => void;
}

const PSYCHOMOTOR_ITEMS = [
  { key: 'body_schema', label: 'Esquema corporal (Conhece as partes e funções do corpo?)' },
  { key: 'body_awareness', label: 'Consciência corporal' },
  { key: 'body_expression', label: 'Expressão corporal' },
  { key: 'body_image', label: 'Imagem corporal' },
  { key: 'hypertonic_tone', label: 'Tônus Hipertônico' },
  { key: 'hypotonic_tone', label: 'Tônus Hipotônico' },
  { key: 'gross_motor_coordination', label: 'Coordenação motora ampla' },
  { key: 'fine_motor_coordination', label: 'Coordenação motora fina' },
  { key: 'dynamic_balance', label: 'Equilíbrio dinâmico' },
  { key: 'static_balance', label: 'Equilíbrio estático' },
  { key: 'laterality', label: 'Lateralidade' },
  { key: 'gustatory_perception', label: 'Percepção gustativa' },
  { key: 'olfactory_perception', label: 'Percepção olfativa' },
  { key: 'tactile_perception', label: 'Percepção tátil' },
  { key: 'visual_perception', label: 'Percepção visual' },
  { key: 'posture', label: 'Postura' },
];

export const Section4Psychomotor: React.FC<SectionProps> = ({ onSave }) => {
  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex items-center gap-3 border-b border-slate-100 pb-4">
        <div className="w-10 h-10 bg-teal-50 rounded-full flex items-center justify-center text-teal-600">
          <Activity className="w-5 h-5" />
        </div>
        <div>
          <h2 className="text-xl font-bold text-slate-900">VI. Aspectos Psicomotores</h2>
          <p className="text-sm text-slate-500">Developmento Motor e Físico</p>
        </div>
      </div>

      <ChecklistGrid sectionKey="psychomotor" items={PSYCHOMOTOR_ITEMS} onSave={onSave} />
    </div>
  );
};
