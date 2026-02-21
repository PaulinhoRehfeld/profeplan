import React from 'react';
import { Block7Familia } from '../../../../types/pdi';

export const Block7Form: React.FC<{ block7: Block7Familia; setBlock7: (b: Block7Familia) => void }> = ({
    block7,
    setBlock7,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 7: Participação da Família</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Responsável Principal</label>
                <input
                    type="text"
                    value={block7.responsavel_principal || ''}
                    onChange={(e) => setBlock7({ ...block7, responsavel_principal: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Nome do responsável principal"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Contato do Responsável</label>
                <input
                    type="text"
                    value={block7.contato_responsavel || ''}
                    onChange={(e) => setBlock7({ ...block7, contato_responsavel: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Telefone e/ou email"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Participação da Família</label>
                <textarea
                    value={block7.participacao_familia || ''}
                    onChange={(e) => setBlock7({ ...block7, participacao_familia: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Descreva como a família participa do processo educacional do aluno"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Orientações para a Família</label>
                <textarea
                    value={block7.orientacoes_familia || ''}
                    onChange={(e) => setBlock7({ ...block7, orientacoes_familia: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Orientações específicas que devem ser passadas à família"
                />
            </div>
        </div>
    </>
);
