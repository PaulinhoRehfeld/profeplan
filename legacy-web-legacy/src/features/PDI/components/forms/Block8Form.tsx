import React from 'react';
import { Block8Observacoes } from '../../../../types/pdi';

export const Block8Form: React.FC<{ block8: Block8Observacoes; setBlock8: (b: Block8Observacoes) => void }> = ({
    block8,
    setBlock8,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 8: Observações Gerais</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Observações Gerais</label>
                <textarea
                    value={block8.observacoes_gerais || ''}
                    onChange={(e) => setBlock8({ ...block8, observacoes_gerais: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Informações adicionais relevantes sobre o aluno"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Histórico Escolar</label>
                <textarea
                    value={block8.historico_escolar || ''}
                    onChange={(e) => setBlock8({ ...block8, historico_escolar: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Resumo do histórico escolar relevante"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Transferências</label>
                <textarea
                    value={block8.transferencias || ''}
                    onChange={(e) => setBlock8({ ...block8, transferencias: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Informações sobre transferências anteriores"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Outras Informações</label>
                <textarea
                    value={block8.outras_informacoes || ''}
                    onChange={(e) => setBlock8({ ...block8, outras_informacoes: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Quaisquer outras informações importantes"
                />
            </div>
        </div>
    </>
);
