import React, { useState } from 'react';
import { Loader2, Upload, Database } from 'lucide-react';
import { ingestFiles, clearExistingSource } from '../../../services/ingestionService';

export const RagIngestionWidget: React.FC = () => {
  const [isUpdatingDb, setIsUpdatingDb] = useState(false);
  const [updateProgress, setUpdateProgress] = useState(0);
  const [updateStatus, setUpdateStatus] = useState('');
  const fileInputRef = React.useRef<HTMLInputElement>(null);

  const handleFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    if (
      !confirm(
        `Deseja processar ${files.length} arquivos para o Banco de Dados?\nIsso pode levar alguns minutos.`
      )
    ) {
      if (fileInputRef.current) fileInputRef.current.value = '';
      return;
    }

    setIsUpdatingDb(true);
    setUpdateProgress(0);
    setUpdateStatus('Iniciando...');

    try {
      const fileArray = Array.from(files) as File[];
      const filenames = fileArray.map((f) => f.name);

      // 1. Limpar versões antigas
      setUpdateStatus('Limpando versões anteriores...');
      await clearExistingSource(filenames);

      // 2. Ingerir
      await ingestFiles(fileArray, (current, total, msg) => {
        setUpdateProgress((current / total) * 100);
        setUpdateStatus(msg);
      });

      alert('Banco de Dados Atualizado com Sucesso!');
    } catch (error: any) {
      console.error(error);
      alert('Falha na atualização: ' + error.message);
    } finally {
      setIsUpdatingDb(false);
      setUpdateStatus('');
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const triggerFileInput = () => {
    fileInputRef.current?.click();
  };

  return (
    <div className="mb-8 bg-indigo-50 border border-indigo-100 rounded-xl p-6 flex flex-col md:flex-row items-center justify-between gap-4">
      <div>
        <h3 className="font-bold text-indigo-900 flex items-center gap-2">
          <Database size={20} />
          Atualização de Currículo (RAG)
        </h3>
        <p className="text-sm text-indigo-700 mt-1">
          Carregue novos arquivos Markdown (.md) para atualizar o conhecimento da IA. O sistema
          detecta automaticamente mudanças nos arquivos.
        </p>
      </div>

      <div className="flex flex-col items-end gap-2">
        <input
          type="file"
          multiple
          accept=".md"
          ref={fileInputRef}
          className="hidden"
          onChange={handleFileSelect}
        />
        <button
          onClick={triggerFileInput}
          disabled={isUpdatingDb}
          className="flex items-center gap-2 px-5 py-2.5 bg-indigo-600 text-white rounded-lg font-bold shadow-md hover:bg-indigo-700 disabled:opacity-50 transition"
        >
          {isUpdatingDb ? <Loader2 className="animate-spin" size={20} /> : <Upload size={20} />}
          {isUpdatingDb ? 'Processando...' : 'Atualizar Banco de Dados'}
        </button>
        {isUpdatingDb && (
          <div className="w-full max-w-[200px]">
            <div className="h-2 bg-indigo-200 rounded-full overflow-hidden">
              <div
                className="h-full bg-indigo-600 transition-all duration-300"
                style={{ width: `${updateProgress}%` }}
              ></div>
            </div>
            <p className="text-[10px] text-indigo-600 text-right mt-1 font-mono">{updateStatus}</p>
          </div>
        )}
      </div>
    </div>
  );
};
