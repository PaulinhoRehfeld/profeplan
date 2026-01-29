import React from 'react';
import { Block5Equipe } from '../../../../types/pdi';

export const Block5Form: React.FC<{ block5: Block5Equipe; setBlock5: (b: Block5Equipe) => void }> = ({
    block5,
    setBlock5,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 5: Equipe Multidisciplinar</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Professores Envolvidos</label>
                <textarea
                    value={block5.professores?.join('\n') || ''}
                    onChange={(e) => setBlock5({ ...block5, professores: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste os professores envolvidos (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Apoio Escolar</label>
                <textarea
                    value={block5.apoio_escolar || ''}
                    onChange={(e) => setBlock5({ ...block5, apoio_escolar: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Descreva o sistema de apoio escolar (monitor, estagiário, etc.)"
                />
            </div>

            <p className="text-sm text-slate-600 italic">
                Nota: Para adicionar detalhes da equipe multidisciplinar (psicólogos, fonoaudiólogos, etc.),
                você poderá editá-los posteriormente na visualização completa do PDI.
            </p>
        </div>
    </>
);
