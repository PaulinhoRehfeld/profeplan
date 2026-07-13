import React, { useState } from 'react';
import { searchQuestions } from '../../services/questionService';
import { EnemQuestion } from '../../types';
import { Search, X, CheckCircle } from 'lucide-react';

export function QuestionSearchWidget() {
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [results, setResults] = useState<EnemQuestion[]>([]);
  const [previewQuestion, setPreviewQuestion] = useState<EnemQuestion | null>(null);

  const handleSearch = async () => {
    if (!query.trim()) return;
    setLoading(true);
    try {
      const data = await searchQuestions(query);
      setResults(data);
    } catch (error) {
      console.error(error);
      alert('Erro ao buscar questões.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full max-w-4xl mx-auto p-4">
      {/* Search Bar Compacta */}
      <div className="flex gap-2 mb-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
          <input
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
            placeholder="Ex: Citologia com gráficos, Era Vargas..."
            className="w-full pl-9 pr-4 h-10 rounded-lg border border-gray-300 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>
        <button
          onClick={handleSearch}
          disabled={loading}
          className="px-4 h-10 bg-blue-600 text-white rounded-lg text-sm font-medium hover:bg-blue-700 disabled:opacity-50"
        >
          {loading ? 'Buscando...' : 'Buscar'}
        </button>
      </div>

      {/* Lista de Resultados Compacta */}
      <div className="space-y-3 max-h-[500px] overflow-y-auto pr-2">
        {results.map((q) => {
          // O metadata agora é garantido pelo service
          const meta = q.metadata;

          return (
            <div
              key={q.id}
              onClick={() => setPreviewQuestion(q)}
              className="group border border-gray-200 rounded-lg p-3 hover:border-blue-400 hover:shadow-sm cursor-pointer transition-all bg-white"
            >
              <div className="flex justify-between items-start mb-2">
                <div className="flex gap-2">
                  <span className="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded-md font-medium border border-gray-200">
                    {meta?.year || 'N/A'}
                  </span>
                  <span className="px-2 py-0.5 bg-blue-50 text-blue-700 text-xs rounded-md font-medium border border-blue-100">
                    {meta?.discipline || 'Geral'}
                  </span>
                </div>
                <span className="text-xs text-green-600 font-medium opacity-0 group-hover:opacity-100 transition-opacity">
                  Clique para ver detalhes
                </span>
              </div>

              {/* Preview do texto (truncado) */}
              <p className="text-sm text-gray-600 line-clamp-2 leading-relaxed">
                {meta?.context || meta?.alternativesIntroduction || 'Sem texto de prévia...'}
              </p>
            </div>
          );
        })}
      </div>

      {/* MODAL DE DETALHES */}
      {previewQuestion && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm p-4">
          <div className="bg-white w-full max-w-2xl max-h-[90vh] rounded-xl shadow-2xl flex flex-col overflow-hidden">
            {/* Header */}
            <div className="px-5 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
              <h3 className="font-semibold text-gray-800">
                Questão {(previewQuestion.metadata as any)?.id_original || previewQuestion.id}
              </h3>
              <button
                onClick={() => setPreviewQuestion(null)}
                className="p-1 hover:bg-gray-200 rounded-full text-gray-500"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            {/* Conteúdo Scrollável */}
            <div className="p-6 overflow-y-auto flex-1">
              {(() => {
                const meta = previewQuestion.metadata;
                if (!meta) return <div>Erro: Metadata ausente</div>;

                return (
                  <>
                    {/* Contexto */}
                    {meta.context && (
                      <div className="mb-6 text-gray-800 text-sm whitespace-pre-line leading-relaxed border-l-4 border-blue-100 pl-4">
                        {meta.context}
                      </div>
                    )}

                    {/* Imagens do Enunciado */}
                    {(meta as any).files && (meta as any).files.length > 0 && (
                      <div className="mb-6 flex flex-wrap gap-4 justify-center bg-gray-50 p-4 rounded-lg border border-gray-100">
                        {(meta as any).files.map((file: string, idx: number) => (
                          <img
                            key={idx}
                            src={file}
                            alt="Apoio"
                            className="max-h-48 rounded object-contain"
                          />
                        ))}
                      </div>
                    )}

                    {/* Pergunta */}
                    {meta.alternativesIntroduction && (
                      <p className="mb-4 font-semibold text-gray-900 text-sm">
                        {meta.alternativesIntroduction}
                      </p>
                    )}

                    {/* Alternativas */}
                    <div className="space-y-2.5">
                      {meta.alternatives?.map((alt: any, idx: number) => (
                        <div
                          key={idx}
                          className={`flex gap-3 p-3 rounded-lg border text-sm transition-colors ${
                            alt.isCorrect
                              ? 'bg-green-50 border-green-200 ring-1 ring-green-100'
                              : 'bg-white border-gray-200 hover:bg-gray-50'
                          }`}
                        >
                          <span
                            className={`font-bold w-6 shrink-0 ${alt.isCorrect ? 'text-green-700' : 'text-gray-400'}`}
                          >
                            {alt.letter})
                          </span>

                          <div className="flex-1">
                            {alt.text && (
                              <span className={alt.isCorrect ? 'text-green-900' : 'text-gray-700'}>
                                {alt.text}
                              </span>
                            )}
                            {alt.file && (
                              <img
                                src={alt.file}
                                alt={`Alternativa ${alt.letter}`}
                                className="mt-2 h-24 border rounded bg-white p-1"
                              />
                            )}
                          </div>

                          {alt.isCorrect && (
                            <CheckCircle className="h-5 w-5 text-green-600 shrink-0" />
                          )}
                        </div>
                      ))}
                    </div>
                  </>
                );
              })()}
            </div>

            {/* Footer */}
            <div className="p-4 border-t border-gray-100 bg-gray-50 flex justify-end gap-3">
              <button
                onClick={() => setPreviewQuestion(null)}
                className="px-4 py-2 text-sm font-medium text-gray-600 hover:text-gray-800"
              >
                Cancelar
              </button>
              <button
                className="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 shadow-sm"
                onClick={() => alert('Função de adicionar será implementada no próximo passo!')}
              >
                Adicionar à Prova
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
