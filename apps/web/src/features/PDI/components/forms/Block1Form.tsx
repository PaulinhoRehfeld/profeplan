import React from 'react';
import { Block1Identificacao } from '../../../../types/pdi';

export const Block1Form: React.FC<{
  block1: Block1Identificacao;
  setBlock1: (b: Block1Identificacao) => void;
}> = ({ block1, setBlock1 }) => (
  <>
    <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 1: Identificação do Aluno</h2>

    <div className="grid md:grid-cols-2 gap-6">
      <div className="md:col-span-2">
        <label className="block text-sm font-bold text-slate-700 mb-2">
          Nome Completo <span className="text-red-600">*</span>
        </label>
        <input
          type="text"
          value={block1.nome_completo || ''}
          onChange={(e) => setBlock1({ ...block1, nome_completo: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Nome completo do estudante"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">
          Data de Nascimento <span className="text-red-600">*</span>
        </label>
        <input
          type="date"
          value={block1.data_nascimento || ''}
          onChange={(e) => setBlock1({ ...block1, data_nascimento: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">Código INEP</label>
        <input
          type="text"
          value={block1.codigo_inep || ''}
          onChange={(e) => setBlock1({ ...block1, codigo_inep: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Código INEP do aluno"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">Série</label>
        <input
          type="text"
          value={block1.serie || ''}
          onChange={(e) => setBlock1({ ...block1, serie: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Ex: 5º Ano EF"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">Turma</label>
        <input
          type="text"
          value={block1.turma || ''}
          onChange={(e) => setBlock1({ ...block1, turma: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Ex: Turma A"
        />
      </div>

      <div className="md:col-span-2">
        <label className="block text-sm font-bold text-slate-700 mb-2">Diagnóstico Clínico</label>
        <textarea
          value={block1.diagnostico_clinico || ''}
          onChange={(e) => setBlock1({ ...block1, diagnostico_clinico: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
          placeholder="Descreva o diagnóstico clínico do aluno (ex: TEA Nível 1, TDAH, etc.)"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">Laudo Médico</label>
        <input
          type="text"
          value={block1.laudo_medico || ''}
          onChange={(e) => setBlock1({ ...block1, laudo_medico: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Número/referência do laudo"
        />
      </div>

      <div>
        <label className="block text-sm font-bold text-slate-700 mb-2">Data do Laudo</label>
        <input
          type="date"
          value={block1.data_laudo || ''}
          onChange={(e) => setBlock1({ ...block1, data_laudo: e.target.value })}
          className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
      </div>
    </div>
  </>
);
