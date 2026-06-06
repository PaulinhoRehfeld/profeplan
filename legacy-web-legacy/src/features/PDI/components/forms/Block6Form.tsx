import React from 'react';
import { Block6Atendimento } from '../../../../types/pdi';

export const Block6Form: React.FC<{ block6: Block6Atendimento; setBlock6: (b: Block6Atendimento) => void }> = ({
    block6,
    setBlock6,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 6: Plano de Atendimento</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Frequência de Atendimento</label>
                <input
                    type="text"
                    value={block6.frequencia_atendimento || ''}
                    onChange={(e) => setBlock6({ ...block6, frequencia_atendimento: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Ex: 2x por semana, Diariamente, etc."
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Horários</label>
                <input
                    type="text"
                    value={block6.horarios || ''}
                    onChange={(e) => setBlock6({ ...block6, horarios: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Ex: Terças e Quintas, 14h-15h"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Local</label>
                <input
                    type="text"
                    value={block6.local || ''}
                    onChange={(e) => setBlock6({ ...block6, local: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Local onde ocorrerá o atendimento"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Responsáveis</label>
                <textarea
                    value={block6.responsaveis?.join('\n') || ''}
                    onChange={(e) => setBlock6({ ...block6, responsaveis: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Profissionais responsáveis pelo atendimento (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Tipo de Atendimento</label>
                <textarea
                    value={block6.tipo_atendimento?.join('\n') || ''}
                    onChange={(e) => setBlock6({ ...block6, tipo_atendimento: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Ex: AEE, Apoio pedagógico, Fonoaudiologia, etc. (um por linha)"
                />
            </div>
        </div>
    </>
);
