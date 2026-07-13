import React, { useEffect, useState } from 'react';
import { Database, FileText, ShieldCheck, AlertTriangle } from 'lucide-react';
import { PlanningAuthority } from '../../services/PlanningAuthorityService';

export const KnowledgeManifest: React.FC = () => {
  const [manifest, setManifest] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadManifest();
  }, []);

  const loadManifest = async () => {
    const data = await PlanningAuthority.getKnowledgeManifest();
    setManifest(data);
    setLoading(false);
  };

  // Agrupar por Nível/Ano
  const grouped = manifest.reduce((acc: any, item: any) => {
    const key = item.ano || 'Outros';
    if (!acc[key]) acc[key] = [];
    acc[key].push(item);
    return acc;
  }, {});

  return (
    <div className="bg-slate-50 border border-slate-200 rounded-xl overflow-hidden">
      <div className="bg-slate-100 p-3 border-b border-slate-200 flex items-center justify-between">
        <div className="flex items-center gap-2 text-slate-700">
          <Database size={16} />
          <h3 className="text-xs font-black uppercase tracking-widest">
            Base de Conhecimento Ativa
          </h3>
        </div>
        <div className="flex items-center gap-1 text-[10px] font-bold text-green-600 bg-green-100 px-2 py-0.5 rounded-full">
          <ShieldCheck size={12} />
          <span>GUARDRAILS ON</span>
        </div>
      </div>

      <div className="p-4 max-h-60 overflow-y-auto custom-scrollbar">
        {loading ? (
          <div className="text-center py-4 text-slate-400 text-xs">Carregando índice...</div>
        ) : manifest.length === 0 ? (
          <div className="text-center py-4 text-slate-400 flex flex-col items-center gap-2">
            <AlertTriangle size={24} />
            <span className="text-xs font-medium">
              Nenhum currículo indexado. O Gestor de IA pode recusar planejamentos sem base.
            </span>
          </div>
        ) : (
          <div className="space-y-4">
            {Object.entries(grouped).map(([ano, items]: any) => (
              <div key={ano}>
                <h4 className="text-[10px] font-bold text-slate-400 uppercase mb-2 border-b border-slate-200 pb-1">
                  {ano}
                </h4>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                  {items.map((item: any, idx: number) => (
                    <div
                      key={idx}
                      className="flex items-center gap-2 bg-white p-2 rounded-lg border border-slate-100 shadow-sm"
                    >
                      <FileText size={14} className="text-blue-400" />
                      <div className="flex-1 min-w-0">
                        <p className="text-xs font-bold text-slate-700 truncate">
                          {item.disciplina}
                        </p>
                        <p className="text-[10px] text-slate-400 truncate" title={item.source_file}>
                          {item.source_file}
                        </p>
                      </div>
                      <span className="text-[9px] font-mono bg-slate-100 text-slate-500 px-1 rounded">
                        {item.chunks} chunks
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <div className="bg-slate-50 p-2 border-t border-slate-200 text-[10px] text-slate-400 text-center font-medium">
        Arquivos visualizados pelo Gestor de IA do ProfePlan
      </div>
    </div>
  );
};
