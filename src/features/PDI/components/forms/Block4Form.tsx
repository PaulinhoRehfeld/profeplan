import React from 'react';
import { Block4Recursos } from '../../../../types/pdi';

export const Block4Form: React.FC<{ block4: Block4Recursos; setBlock4: (b: Block4Recursos) => void }> = ({
    block4,
    setBlock4,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 4: Recursos e Materiais</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Recursos Tecnológicos</label>
                <textarea
                    value={block4.recursos_tecnologicos?.join('\n') || ''}
                    onChange={(e) => setBlock4({ ...block4, recursos_tecnologicos: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Ex: Tablet, Software de comunicação alternativa, etc. (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Materiais Adaptados</label>
                <textarea
                    value={block4.materiais_adaptados?.join('\n') || ''}
                    onChange={(e) => setBlock4({ ...block4, materiais_adaptados: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Ex: Livros em braille, Materiais em relevo, etc. (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Mobiliário Específico</label>
                <textarea
                    value={block4.mobiliario_especifico || ''}
                    onChange={(e) => setBlock4({ ...block4, mobiliario_especifico: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Descreva mobiliário especial necessário"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Equipamentos</label>
                <textarea
                    value={block4.equipamentos?.join('\n') || ''}
                    onChange={(e) => setBlock4({ ...block4, equipamentos: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste equipamentos necessários (um por linha)"
                />
            </div>
        </div>
    </>
);
