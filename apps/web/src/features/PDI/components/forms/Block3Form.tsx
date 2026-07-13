import React from 'react';
import { Block3Objetivos } from '../../../../types/pdi';

export const Block3Form: React.FC<{
  block3: Block3Objetivos;
  setBlock3: (b: Block3Objetivos) => void;
}> = ({ block3, setBlock3 }) => (
  <>
    <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 3: Objetivos do PDI</h2>

    <div className="space-y-6">
      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">
          Objetivo Geral <span className="text-red-600">*</span>
        </label>
        <textarea
          value={block3.objetivo_geral || ''}
          onChange={(e) => setBlock3({ ...block3, objetivo_geral: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
          placeholder="Descreva o objetivo geral do PDI para este estudante"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">Objetivos Específicos</label>
        <textarea
          value={block3.objetivos_especificos?.join('\n') || ''}
          onChange={(e) =>
            setBlock3({
              ...block3,
              objetivos_especificos: e.target.value.split('\n').filter(Boolean),
            })
          }
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
          placeholder="Liste os objetivos específicos (um por linha)"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">Metas de Curto Prazo</label>
        <textarea
          value={block3.metas_curto_prazo?.join('\n') || ''}
          onChange={(e) =>
            setBlock3({ ...block3, metas_curto_prazo: e.target.value.split('\n').filter(Boolean) })
          }
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
          placeholder="Metas para o bimestre/trimestre atual (uma por linha)"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">Metas de Longo Prazo</label>
        <textarea
          value={block3.metas_longo_prazo?.join('\n') || ''}
          onChange={(e) =>
            setBlock3({ ...block3, metas_longo_prazo: e.target.value.split('\n').filter(Boolean) })
          }
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
          placeholder="Metas para o ano letivo/próximos períodos (uma por linha)"
        />
      </div>
    </div>
  </>
);
