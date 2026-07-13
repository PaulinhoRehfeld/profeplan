import React from 'react';
import { X, Copy, ExternalLink, HelpCircle } from 'lucide-react';
import MarkdownRenderer from './MarkdownRenderer';

interface CanvaExportModalProps {
  isOpen: boolean;
  onClose: () => void;
  data: string;
}

const CanvaExportModal: React.FC<CanvaExportModalProps> = ({ isOpen, onClose, data }) => {
  if (!isOpen) return null;

  const handleCopy = () => {
    navigator.clipboard.writeText(data);
    alert("Tabela copiada! Agora cole no 'Criar em Lote' do Canva.");
  };

  return (
    <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-4xl max-h-[90vh] flex flex-col overflow-hidden animate-in zoom-in-95 duration-200">
        {/* Header */}
        <div className="p-6 border-b border-slate-100 flex items-center justify-between bg-gradient-to-r from-purple-50 to-indigo-50">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-purple-600 rounded-xl flex items-center justify-center text-white shadow-lg shadow-purple-200">
              <span className="font-black text-xs">Cn</span>
            </div>
            <div>
              <h2 className="text-lg font-black text-slate-900 tracking-tight">
                Exportação para Canva
              </h2>
              <p className="text-xs text-slate-500 font-bold uppercase tracking-widest">
                Bulk Create Data
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 hover:bg-white/50 rounded-full transition-colors"
          >
            <X size={20} className="text-slate-400 hover:text-slate-600" />
          </button>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto p-8 bg-slate-50/50">
          {/* Help Card */}
          <div className="mb-8 p-6 bg-blue-50 border border-blue-100 rounded-2xl flex gap-6">
            <div className="shrink-0 p-3 bg-blue-100 text-blue-600 rounded-xl h-fit">
              <HelpCircle size={24} />
            </div>
            <div className="space-y-2">
              <h3 className="font-black text-blue-900 text-sm uppercase tracking-wide">
                Como criar slides em segundos:
              </h3>
              <ol className="list-decimal list-inside text-sm text-blue-800 space-y-1 font-medium">
                <li>
                  Abra um template de apresentação no <strong>Canva</strong>.
                </li>
                <li>
                  No menu lateral, vá em <strong>Apps</strong> e busque por{' '}
                  <strong>"Criar em Lote" (Bulk Create)</strong>.
                </li>
                <li>
                  Selecione <strong>"Inserir dados manualmente"</strong>.
                </li>
                <li>
                  Limpe a tabela de exemplo e <strong>COLE</strong> os dados abaixo (clique no botão
                  copiar).
                </li>
                <li>
                  Conecte os dados aos elementos do slide (clique direito no elemento -&gt; Conectar
                  dados).
                </li>
              </ol>
            </div>
          </div>

          <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm relative group">
            <button
              onClick={handleCopy}
              className="absolute top-4 right-4 flex items-center gap-2 px-4 py-2 bg-slate-900 text-white rounded-xl text-xs font-bold uppercase tracking-wide shadow-lg hover:scale-105 active:scale-95 transition-all z-10"
            >
              <Copy size={14} /> Copiar Tabela
            </button>
            <div className="prose prose-sm max-w-none prose-slate">
              <MarkdownRenderer content={data} />
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="p-6 border-t border-slate-100 bg-white flex justify-end gap-3">
          <a
            href="https://www.canva.com/education/"
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2 px-6 py-3 text-slate-500 hover:text-purple-600 font-bold text-xs uppercase tracking-widest transition-colors"
          >
            <ExternalLink size={16} /> Abrir Canva
          </a>
          <button
            onClick={handleCopy}
            className="flex items-center gap-3 px-8 py-3 bg-purple-600 hover:bg-purple-700 text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl shadow-purple-200 transition-all hover:-translate-y-0.5"
          >
            <Copy size={18} /> Copiar Dados
          </button>
        </div>
      </div>
    </div>
  );
};

export default CanvaExportModal;
