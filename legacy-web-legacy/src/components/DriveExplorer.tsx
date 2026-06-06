import React, { useState, useEffect } from 'react';
import {
  Folder, FileText, HardDrive, Search, Download, Trash2,
  Cloud, UserCheck, Edit3, ChevronLeft, Save,
  Loader2, AlertCircle, CheckCircle2, FileEdit, Calendar, Target, Book, Play
} from 'lucide-react';
import { UserSettings } from '../types';
import { getGeneratedContents, updateGeneratedContent, deleteGeneratedContent } from '../services/databaseService';
import { exportToDocx } from '../services/exportService';
import MarkdownRenderer from './MarkdownRenderer';
import { useToast } from '../contexts/ToastContext';
import { withRetry } from '../services/retryService';

interface DriveExplorerProps {
  userId: string;
  userEmail: string;
  settings: UserSettings;
}

interface ContentFile {
  id: string;
  title: string;
  type: string;
  content: string;
  created_at: string;
}

const DriveExplorer: React.FC<DriveExplorerProps> = ({ userId, userEmail, settings }) => {
  const [activeFolder, setActiveFolder] = useState<string | null>(null);
  const [allContents, setAllContents] = useState<ContentFile[]>([]);
  const [loading, setLoading] = useState(true);
  const [editingFile, setEditingFile] = useState<ContentFile | null>(null);
  const [editTitle, setEditTitle] = useState('');
  const [editContent, setEditContent] = useState('');
  const [saveLoading, setSaveLoading] = useState(false);
  const [feedback, setFeedback] = useState<{ type: 'success' | 'error', message: string } | null>(null);
  const { showToast } = useToast();
  const [searchTerm, setSearchTerm] = useState('');
  const [sortDesc, setSortDesc] = useState(true);

  const fetchData = async () => {
    setLoading(true);
    try {
      const data = await withRetry(() => getGeneratedContents(userId));
      setAllContents(data);
    } catch (err) {
      console.error("Erro ao carregar dados:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [userId]);

  const folders = [
    { id: 'trimestral', name: 'TRIMESTRAIS', icon: Calendar },
    { id: 'plano', name: 'PLANOS DE AULA', icon: Folder },
    { id: 'material', name: 'MATERIAIS ALUNOS', icon: Book },
    { id: 'exercicio', name: 'ATIVIDADES', icon: FileText },
    { id: 'simulado', name: 'SIMULADOS', icon: Target },
    { id: 'avaliacao', name: 'AVALIAÇÕES', icon: CheckCircle2 },
    { id: 'apresentacao', name: 'APRESENTAÇÕES', icon: Play },
    { id: 'documento', name: 'OUTROS', icon: HardDrive },
  ];

  const getFilteredFiles = () => {
    let base = activeFolder ? allContents.filter(f => f.type === activeFolder) : allContents;
    if (searchTerm.trim()) {
      const term = searchTerm.toLowerCase();
      base = base.filter(f => f.title.toLowerCase().includes(term));
    }
    base = [...base].sort((a, b) => {
      const da = new Date(a.created_at).getTime();
      const db = new Date(b.created_at).getTime();
      return sortDesc ? db - da : da - db;
    });
    if (!activeFolder && !searchTerm) {
      return base.slice(0, 10);
    }
    return base;
  };

  const handleEdit = (file: ContentFile) => {
    setEditingFile(file);
    setEditTitle(file.title);
    setEditContent(file.content);
    setFeedback(null);
  };

  const handleSave = async () => {
    if (!editingFile) return;
    setSaveLoading(true);
    setFeedback(null);
    try {
      await updateGeneratedContent(editingFile.id, {
        title: editTitle,
        content: editContent
      });
      setFeedback({ type: 'success', message: 'Conteúdo atualizado no Supabase!' });
      showToast('success', 'Conteúdo atualizado no Supabase!');
      await fetchData();
      setEditingFile(prev => prev ? { ...prev, title: editTitle, content: editContent } : null);
    } catch (err) {
      setFeedback({ type: 'error', message: 'Falha na sincronização cloud.' });
      showToast('error', 'Falha na sincronização cloud.');
    } finally {
      setSaveLoading(false);
      setTimeout(() => setFeedback(null), 3000);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Excluir permanentemente este documento da sua nuvem?")) return;
    try {
      await withRetry(() => deleteGeneratedContent(id));
      await fetchData();
      if (editingFile?.id === id) setEditingFile(null);
    } catch (err) {
      showToast('error', 'Erro ao excluir arquivo.');
    }
  };

  const handleExport = async (file: ContentFile) => {
    const contentToExport = editingFile?.id === file.id ? editContent : file.content;
    const titleToExport = editingFile?.id === file.id ? editTitle : file.title;
    await withRetry(() => exportToDocx(contentToExport, titleToExport, settings), { retries: 1 });
  };

  const recentFiles = [...allContents]
    .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
    .slice(0, 5);

  if (editingFile) {
    return (
      <div className="space-y-6 animate-in slide-in-from-right-4 duration-500">
        <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-6 rounded-[2rem] border border-slate-100 shadow-sm">
          <div className="flex items-center gap-4">
            <button
              onClick={() => setEditingFile(null)}
              className="p-3 bg-slate-50 text-slate-500 hover:text-blue-600 rounded-2xl transition-all"
              aria-label="Voltar para a lista de arquivos"
            >
              <ChevronLeft size={20} />
            </button>
            <div>
              <h3 className="font-black text-slate-900 uppercase text-xs tracking-widest italic">Editor Pedagógico</h3>
              <p className="text-[10px] font-bold text-slate-400 uppercase">Ajuste o conteúdo gerado pela IA</p>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={() => handleExport(editingFile)}
              className="px-5 py-3 bg-emerald-50 text-emerald-700 rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-emerald-100 transition-all flex items-center gap-2 border border-emerald-100"
            >
              <Download size={14} /> Baixar Word
            </button>
            <button
              onClick={handleSave}
              disabled={saveLoading}
              className="px-6 py-3 bg-blue-600 text-white rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-blue-700 transition-all shadow-lg shadow-blue-600/20 flex items-center gap-2 disabled:opacity-50"
            >
              {saveLoading ? <Loader2 size={14} className="animate-spin" /> : <Save size={14} />}
              {saveLoading ? 'Sincronizando...' : 'Salvar na Nuvem'}
            </button>
          </div>
        </header>

        {feedback && (
          <div className={`p-4 rounded-2xl border flex items-center gap-3 animate-in fade-in slide-in-from-top-2 ${feedback.type === 'success' ? 'bg-emerald-50 border-emerald-100 text-emerald-700' : 'bg-red-50 border-red-100 text-red-700'
            } `}>
            {feedback.type === 'success' ? <CheckCircle2 size={18} /> : <AlertCircle size={18} />}
            <p className="text-xs font-bold">{feedback.message}</p>
          </div>
        )}

        <div className="grid grid-cols-1 xl:grid-cols-2 gap-8 h-[calc(100dvh-320px)]">
          {/* Editor Area */}
          <div className="flex flex-col gap-4 bg-white p-6 rounded-[2.5rem] border border-slate-200 shadow-sm overflow-hidden">
            <input
              type="text"
              value={editTitle}
              onChange={(e) => setEditTitle(e.target.value)}
              className="w-full px-5 py-4 bg-slate-50 border border-slate-100 rounded-2xl text-sm font-black text-slate-800 outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all italic"
              placeholder="Título do documento..."
            />
            <textarea
              value={editContent}
              onChange={(e) => setEditContent(e.target.value)}
              className="flex-1 w-full p-6 bg-slate-50 border border-slate-100 rounded-[2rem] text-sm font-medium outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all resize-none font-mono leading-relaxed"
              placeholder="Corpo do texto pedagógico..."
            />
          </div>

          {/* Preview Area */}
          <div className="bg-white p-10 rounded-[2.5rem] border border-slate-200 shadow-sm overflow-y-auto custom-scrollbar relative">
            <div className="sticky top-0 right-0 float-right z-10">
              <span className="bg-blue-50 text-blue-600 px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest border border-blue-100 shadow-sm">
                Visualização Final
              </span>
            </div>
            <MarkdownRenderer content={editContent} />
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6 animate-in fade-in duration-700 pb-20 h-[calc(100dvh-100px)] flex flex-col">

      <div className="flex flex-row gap-4 lg:gap-6 flex-1 overflow-hidden px-2 md:px-0 pb-4 md:pb-0">
        {/* Left Sidebar - Folders (Vertical Always, Slim on Mobile) */}
        <div className="w-16 lg:w-72 flex flex-col gap-3 shrink-0 overflow-y-auto custom-scrollbar pb-2 lg:pb-0 border-r lg:border-r-0 border-slate-100 pr-2 lg:pr-0">
          <h3 className="hidden lg:block text-xs font-black text-slate-400 uppercase tracking-widest ml-4 mb-1">Pastas</h3>
          {folders.map((folder) => {
            const count = allContents.filter(f => f.type === folder.id).length;
            const isActive = activeFolder === folder.id;

            return (
              <button
                key={folder.id}
                onClick={() => setActiveFolder(isActive ? null : folder.id)}
                className={`w-full p-2 lg:p-4 rounded-xl lg:rounded-[1.5rem] border transition-all text-left flex flex-col lg:flex-row items-center lg:items-center justify-center lg:justify-start gap-1 lg:gap-4 group relative overflow-hidden ${isActive
                  ? 'bg-blue-600 border-blue-500 text-white shadow-lg shadow-blue-600/30'
                  : 'bg-white border-transparent hover:bg-white hover:border-slate-200 hover:shadow-md text-slate-500'
                  }`}
              >
                <div className={`w-8 h-8 lg:w-10 lg:h-10 rounded-lg lg:rounded-xl flex items-center justify-center transition-all shrink-0 ${isActive ? 'bg-white/20 text-white' : 'bg-slate-50 text-slate-400 group-hover:bg-blue-50 group-hover:text-blue-600'
                  }`}>
                  <folder.icon size={18} />
                </div>

                <div className="hidden lg:block flex-1 whitespace-nowrap">
                  <p className={`font-black text-sm uppercase tracking-tight ${isActive ? 'text-white' : 'text-slate-700'}`}>
                    {folder.name}
                  </p>
                  <p className={`text-[10px] font-bold ${isActive ? 'text-blue-200' : 'text-slate-400'}`}>
                    {count} {count === 1 ? 'arquivo' : 'arquivos'}
                  </p>
                </div>

                {isActive && (
                  <div className="hidden lg:block absolute right-4 w-2 h-2 bg-white rounded-full animate-pulse shadow-[0_0_10px_rgba(255,255,255,0.8)]"></div>
                )}
              </button>
            );
          })}
        </div>

        {/* Right Content - Files List */}
        <div className="flex-1 bg-white rounded-[2.5rem] border border-slate-200 shadow-xl overflow-hidden flex flex-col">
          <div className="p-6 border-b border-slate-50 bg-slate-50/50 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4 shrink-0">
          <div className="flex items-center gap-3">
              <div className="p-2.5 bg-white rounded-xl border border-slate-100 shadow-sm">
                <FileText size={18} className="text-blue-600" />
              </div>
              <div>
                <h2 className="font-black text-slate-900 uppercase tracking-[0.15em] text-xs">
                  {activeFolder ? folders.find(f => f.id === activeFolder)?.name : 'Todos os Arquivos'}
                </h2>
                <p className="text-[10px] text-slate-400 font-bold mt-1">
                  {getFilteredFiles().length} documentos
                </p>
              </div>
            </div>
            <div className="flex flex-col md:flex-row md:items-center gap-3 md:gap-4 w-full md:w-auto">
              <div className="relative">
                <Search className="absolute left-2 top-1/2 -translate-y-1/2 text-slate-400" size={14} />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Buscar por título..."
                  className="pl-7 pr-3 py-2 rounded-full border border-slate-200 bg-white text-[11px] text-slate-600 focus:ring-2 focus:ring-blue-100 outline-none"
                />
              </div>
              <button
                type="button"
                onClick={() => setSortDesc(prev => !prev)}
                className="px-3 py-2 rounded-full bg-white border border-slate-200 text-[10px] font-black uppercase tracking-[0.15em] text-slate-500 hover:bg-slate-100 transition-colors"
              >
                {sortDesc ? 'Mais recentes' : 'Mais antigos'}
              </button>
            </div>

            {/* Últimas produções do professor */}
            {recentFiles.length > 0 && (
              <div className="w-full md:w-auto">
                <p className="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 mb-1">
                  Últimas produções
                </p>
                <div className="flex gap-2 overflow-x-auto pb-1">
                  {recentFiles.map((file) => (
                    <button
                      key={file.id}
                      type="button"
                      onClick={() => handleEdit(file)}
                      className="min-w-[140px] max-w-[180px] px-3 py-2 rounded-2xl bg-white border border-slate-200 hover:border-blue-300 hover:bg-blue-50 text-left transition-all"
                    >
                      <p className="text-[10px] font-black uppercase tracking-[0.16em] text-slate-500 mb-1 line-clamp-1">
                        {folders.find(f => f.id === file.type)?.name || 'OUTRO'}
                      </p>
                      <p className="text-[11px] font-bold text-slate-800 line-clamp-2">
                        {file.title}
                      </p>
                      <p className="text-[9px] text-slate-400 mt-1">
                        {new Date(file.created_at).toLocaleDateString('pt-BR')}
                      </p>
                    </button>
                  ))}
                </div>
              </div>
            )}
          </div>

          <div className="flex-1 overflow-y-auto custom-scrollbar p-0">
          {loading ? (
              <table className="w-full text-left border-collapse">
                <tbody className="divide-y divide-slate-50">
                  {Array.from({ length: 6 }).map((_, idx) => (
                    <tr key={`skeleton-row-${idx}`} className="animate-pulse">
                      <td className="px-4 md:px-8 py-6 w-full">
                        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                          <div className="flex items-center gap-4">
                            <div className="w-10 h-10 bg-slate-100 rounded-xl" />
                            <div className="space-y-2">
                              <div className="h-4 w-40 bg-slate-100 rounded-md" />
                              <div className="flex items-center gap-2">
                                <div className="h-3 w-16 bg-slate-100 rounded-full" />
                                <div className="h-3 w-24 bg-slate-100 rounded-full" />
                              </div>
                            </div>
                          </div>
                          <div className="flex items-center gap-2">
                            <div className="w-9 h-9 bg-slate-100 rounded-xl" />
                            <div className="w-9 h-9 bg-slate-100 rounded-xl" />
                            <div className="w-9 h-9 bg-slate-100 rounded-xl" />
                          </div>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <table className="w-full text-left border-collapse">
                <tbody className="divide-y divide-slate-50">
                  {getFilteredFiles().map(file => (
                    <tr key={file.id} className="group hover:bg-slate-50 transition-all cursor-default">
                      <td className="px-4 md:px-8 py-6 w-full">
                        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                          <div className="flex items-center gap-4">
                            <div className="w-10 h-10 bg-white border border-slate-100 rounded-xl flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all shadow-sm">
                              {file.type === 'plano' ? <Folder size={18} /> :
                                file.type === 'trimestral' ? <Calendar size={18} /> :
                                  file.type === 'enem' ? <Target size={18} /> :
                                    <FileText size={18} />}
                            </div>
                            <div>
                              <p className="font-bold text-slate-800 text-sm mb-1 group-hover:text-blue-700 transition-colors line-clamp-1">
                                {file.title}
                              </p>
                              <div className="flex items-center gap-3 text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                                <span>{new Date(file.created_at).toLocaleDateString('pt-BR')}</span>
                                <span className="w-1 h-1 bg-slate-300 rounded-full"></span>
                                <span>{folders.find(f => f.id === file.type)?.name || 'OUTRO'}</span>
                              </div>
                            </div>
                          </div>

                          <div className="flex items-center gap-2 transition-all">
                            <button
                              onClick={() => handleEdit(file)}
                              className="p-2.5 bg-white border border-slate-200 text-slate-500 hover:bg-blue-600 hover:border-blue-600 hover:text-white rounded-xl transition-all shadow-sm"
                              title="Editar"
                              aria-label="Editar documento"
                            >
                              <Edit3 size={16} />
                            </button>
                            <button
                              onClick={() => handleExport(file)}
                              className="p-2.5 bg-white border border-slate-200 text-slate-500 hover:bg-emerald-500 hover:border-emerald-500 hover:text-white rounded-xl transition-all shadow-sm"
                              title="Baixar"
                              aria-label="Baixar documento em Word"
                            >
                              <Download size={16} />
                            </button>
                            <button
                              onClick={() => handleDelete(file.id)}
                              className="p-2.5 bg-white border border-slate-200 text-slate-500 hover:bg-red-500 hover:border-red-500 hover:text-white rounded-xl transition-all shadow-sm"
                              title="Excluir"
                              aria-label="Excluir documento"
                            >
                              <Trash2 size={16} />
                            </button>
                          </div>
                        </div>
                      </td>
                    </tr>
                  ))}

                  {getFilteredFiles().length === 0 && (
                    <tr>
                      <td className="p-20 text-center">
                        <div className="flex flex-col items-center gap-4 opacity-30">
                          <div className="w-16 h-16 bg-slate-100 rounded-2xl flex items-center justify-center">
                            <Folder className="w-8 h-8 text-slate-400" />
                          </div>
                          <p className="font-black text-xs uppercase tracking-[0.2em] text-slate-400">Nenhum arquivo encontrado</p>
                        </div>
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default DriveExplorer;