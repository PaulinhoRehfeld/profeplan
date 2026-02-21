import React from 'react';
import { MessageSquare } from 'lucide-react';
import { ChecklistGrid } from '../components/ChecklistGrid';

interface SectionProps {
    onSave: () => void;
}

const COMMUNICATION_ITEMS = [
    { key: 'verbal_expression', label: 'Expressão Verbal (Clareza, vocabulário)' },
    { key: 'non_verbal_expression', label: 'Expressão Não-Verbal (Gestos, expressões)' },
    { key: 'understanding_verbal', label: 'Compreensão Verbal' },
    { key: 'interaction_intent', label: 'Intenção Comunicativa (Iniciativa)' },
];

export const Section6Communication: React.FC<SectionProps> = ({ onSave }) => {
    return (
        <div className="space-y-8 animate-in fade-in duration-500">
            <div className="flex items-center gap-3 border-b border-slate-100 pb-4">
                <div className="w-10 h-10 bg-orange-50 rounded-full flex items-center justify-center text-orange-600">
                    <MessageSquare className="w-5 h-5" />
                </div>
                <div>
                    <h2 className="text-xl font-bold text-slate-900">VIII. Comunicação e Linguagem</h2>
                    <p className="text-sm text-slate-500">Avaliação das Habilidades Comunicativas</p>
                </div>
            </div>

            <ChecklistGrid
                sectionKey="communication"
                items={COMMUNICATION_ITEMS}
                onSave={onSave}
            />
        </div>
    );
};
