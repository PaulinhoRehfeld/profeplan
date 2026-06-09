import React from 'react';
import { useRouteError, useNavigate } from 'react-router-dom';
import { ShieldAlert, RefreshCw, Home } from 'lucide-react';

export const AppErrorPage: React.FC = () => {
  const error = useRouteError() as any;
  const navigate = useNavigate();

  console.error("🚨 [AppErrorPage] Caught an error:", error);

  const handleReset = () => {
    localStorage.removeItem('profeplan_settings');
    window.location.href = '/?force_reset=true';
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 dark:bg-gray-900 p-6 text-center">
      <div className="bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-xl max-w-md w-full border border-red-100 dark:border-red-900/30">
        <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-red-100 dark:bg-red-900/30 mb-6">
          <ShieldAlert className="h-8 w-8 text-red-600 dark:text-red-400" />
        </div>
        
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
          Oops! Algo deu errado.
        </h1>
        
        <p className="text-gray-500 dark:text-gray-400 mb-6">
          A aplicação encontrou um erro inesperado ao tentar renderizar esta tela.
        </p>

        {error && (
          <div className="bg-red-50 dark:bg-red-900/10 p-4 rounded-lg text-left overflow-auto mb-6 text-sm font-mono text-red-800 dark:text-red-300 max-h-32">
            {error.statusText || error.message || "Erro desconhecido"}
          </div>
        )}

        <div className="flex flex-col space-y-3">
          <button
            onClick={() => window.location.reload()}
            className="w-full flex items-center justify-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2.5 rounded-xl font-medium transition-colors"
          >
            <RefreshCw className="w-5 h-5" />
            Tentar Novamente
          </button>
          
          <button
            onClick={() => navigate('/')}
            className="w-full flex items-center justify-center gap-2 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-200 px-4 py-2.5 rounded-xl font-medium transition-colors"
          >
            <Home className="w-5 h-5" />
            Voltar para Início
          </button>
          
          <button
            onClick={handleReset}
            className="w-full mt-4 text-xs text-red-500 hover:text-red-600 dark:text-red-400 dark:hover:text-red-300 transition-colors"
          >
            Modo de Segurança (Limpar Cache)
          </button>
        </div>
      </div>
    </div>
  );
};
