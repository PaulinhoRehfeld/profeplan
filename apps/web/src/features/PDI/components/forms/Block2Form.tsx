import React from 'react';
import { Block2Diagnostico } from '../../../../types/pdi';

export const Block2Form: React.FC<{ block2: Block2Diagnostico; setBlock2: (b: Block2Diagnostico) => void }> = ({
    block2,
    setBlock2,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 2: Diagnóstico Pedagógico</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Necessidades Específicas</label>
                <textarea
                    value={block2.necessidades_especificas?.join('\n') || ''}
                    onChange={(e) => setBlock2({ ...block2, necessidades_especificas: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste as necessidades específicas do aluno (uma por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Potencialidades</label>
                <textarea
                    value={block2.potencialidades?.join('\n') || ''}
                    onChange={(e) => setBlock2({ ...block2, potencialidades: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste as potencialidades do aluno (uma por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Desafios</label>
                <textarea
                    value={block2.desafios?.join('\n') || ''}
                    onChange={(e) => setBlock2({ ...block2, desafios: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste os principais desafios (uma por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Medicamentos em Uso</label>
                <textarea
                    value={block2.medicamentos_uso || ''}
                    onChange={(e) => setBlock2({ ...block2, medicamentos_uso: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Descreva medicamentos em uso e posologia"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Restrições de Atividades</label>
                <textarea
                    value={block2.restricoes_atividades || ''}
                    onChange={(e) => setBlock2({ ...block2, restricoes_atividades: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Há alguma restrição para atividades físicas ou outras?"
                />
            </div>
        </div>
    </>
);
