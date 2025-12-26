import React, { useState, useEffect } from 'react';
import { 
  Folder, FileText, HardDrive, Search, Download, Trash2, 
  Cloud, UserCheck, Edit3, ChevronLeft, Save, 
  Loader2, AlertCircle, CheckCircle2, FileEdit
} from 'lucide-react';
import { UserSettings } from '../types';
import { getGeneratedContents, updateGeneratedContent, deleteGeneratedContent } from '../services/databaseService';
import { exportToDocx } from '../services/exportService';
import MarkdownRenderer from './MarkdownRenderer';

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

  const fetchData = async () => {
    setLoading(true);
    try {
      const data = await getGeneratedContents(userId);
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
    { id: 'plano', name: 'PLANOS', icon: Folder },
    { id: 'aula', name: 'AULAS', icon: Folder },
    { id: 'avaliacao', name: 'AVALIAÇÕES', icon: Folder },
    { id: 'documento', name: 'OUTROS', icon: Folder },
  ];

  const getFilteredFiles = () => {
    if (!activeFolder) return allContents.slice(0, 10); // Mostra recentes se nada selecionado
    return allContents.filter(f => f.type === activeFolder);
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
      await fetchData();
      setEditingFile(prev => prev ? { ...prev, title: editTitle, content: editContent } : null);
    } catch (err) {
      setFeedback({ type: 'error', message: 'Falha na sincronização cloud.' });
    } finally {
      setSaveLoading(false);
      setTimeout(() => setFeedback(null), 3000);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Excluir permanentemente este documento da sua nuvem?")) return;
    try {
      await deleteGeneratedContent(id);
      await fetchData();
      if (editingFile?.id === id) setEditingFile(null);
    } catch (err) {
      alert("Erro ao excluir arquivo.");
    }
  };

  const handleExport = async (file: ContentFile) => {
    const contentToExport = editingFile?.id === file.id ? editContent : file.content;
    const titleToExport = editingFile?.id === file.id ? editTitle : file.title;
    await exportToDocx(contentToExport, titleToExport, settings);
  };

  if (editingFile) {
    return (
      <div className="space-y-6 animate-in slide-in-from-right-4 duration-500">
        <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-6 rounded-[2rem] border border-slate-100 shadow-sm">
          <div className="flex items-center gap-4">
            <button 
              onClick={() => setEditingFile(null)}
              className="p-3 bg-slate-50 text-slate-500 hover:text-blue-600 rounded-2xl transition-all"
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
          <div className={`p-4 rounded-2xl border flex items-center gap-3 animate-in fade-in slide-in-from-top-2 ${
            feedback.type === 'success' ? 'bg-emerald-50 border-emerald-100 text-emerald-700' : 'bg-red-50 border-red-100 text-red-700'
          }`}>
            {feedback.type === 'success' ? <CheckCircle2 size={18} /> : <AlertCircle size={18} />}
            <p className="text-xs font-bold">{feedback.message}</p>
          </div>
        )}

        <div className="grid grid-cols-1 xl:grid-cols-2 gap-8 h-[calc(100vh-320px)]">
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
    <div className="space-y-10 animate-in fade-in duration-700 pb-20">
      {/* Header Dashboard */}
      <div className="bg-slate-950 p-12 rounded-[3.5rem] text-white flex flex-col md:flex-row justify-between items-center gap-8 shadow-3xl relative overflow-hidden group">
        <div className="absolute top-[-20%] left-[-10%] w-96 h-96 bg-blue-600/20 blur-[100px] rounded-full group-hover:scale-110 transition-transform duration-1000"></div>
        <div className="z-10 text-center md:text-left">
          <h1 className="text-5xl font-black tracking-tighter italic mb-3">Workspace Digital</h1>
          <div className="flex items-center justify-center md:justify-start gap-2 text-slate-400 font-bold text-xs uppercase tracking-[0.2em]">
            <UserCheck size={16} className="text-blue-500" /> Professor: {userEmail}
          </div>
        </div>
        <div className="bg-white/5 backdrop-blur-2xl border border-white/10 p-8 rounded-[3rem] flex items-center gap-6 shadow-inner z-10 hover:bg-white/10 transition-all">
          <div className="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-[1.5rem] flex items-center justify-center shadow-2xl shadow-blue-500/20">
            <HardDrive className="text-white" size={32} />
          </div>
          <div>
            <p className="text-[10px] uppercase font-black text-slate-400 tracking-widest mb-1">Status do Servidor</p>
            <p className="text-2xl font-black italic tracking-tight text-emerald-400 flex items-center gap-2">
              SINCRONIZADO <CheckCircle2 size={20} />
            </p>
          </div>
        </div>
      </div>

      {/* Folders Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-6">
        {folders.map((folder) => {
          const count = allContents.filter(f => f.type === folder.id).length;
          const isActive = activeFolder === folder.id;
          return (
            <button
              key={folder.id}
              onClick={() => setActiveFolder(isActive ? null : folder.id)}
              className={`group p-10 rounded-[3rem] border-2 transition-all text-left relative overflow-hidden ${
                isActive 
                  ? 'bg-blue-600 border-blue-400 text-white shadow-2xl shadow-blue-600/40 -translate-y-2' 
                  : 'bg-white border-slate-100 hover:border-blue-200 hover:shadow-xl'
              }`}
            >
              <div className={`w-16 h-16 rounded-2xl flex items-center justify-center mb-6 transition-all ${
                isActive ? 'bg-white/20 scale-110' : 'bg-slate-50 text-slate-400 group-hover:bg-blue-50 group-hover:text-blue-600'
              }`}>
                <folder.icon className="w-8 h-8" />
              </div>
              <p className="font-black text-xl tracking-tighter uppercase italic">{folder.name}</p>
              <div className="flex items-center justify-between mt-2">
                <p className={`text-[10px] font-bold uppercase tracking-widest ${isActive ? 'text-blue-100' : 'text-slate-400'}`}>
                  {count} {count === 1 ? 'doc' : 'docs'}
                </p>
                {isActive && <CheckCircle2 size={16} className="text-white animate-pulse" />}
              </div>
            </button>
          );
        })}
      </div>

      {/* Files List Area */}
      <div className="bg-white rounded-[4rem] border border-slate-200 shadow-2xl overflow-hidden">
        <div className="p-10 border-b border-slate-50 bg-slate-50/30 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-white rounded-2xl border border-slate-100 shadow-sm">
               <FileText size={20} className="text-blue-600" />
            </div>
            <h2 className="font-black text-slate-900 uppercase tracking-[0.2em] text-xs">
              {activeFolder ? folders.find(f => f.id === activeFolder)?.name : 'Histórico de Produção'}
            </h2>
          </div>
          <div className="bg-slate-200/50 px-4 py-2 rounded-full text-[10px] font-black text-slate-500">
            {getFilteredFiles().length} REGISTROS
          </div>
        </div>
        
        {loading ? (
          <div className="p-32 flex flex-col items-center justify-center gap-6 text-center">
            <div className="relative">
              <Loader2 className="w-16 h-16 text-blue-600 animate-spin" />
              <div className="absolute inset-0 flex items-center justify-center">
                <div className="w-2 h-2 bg-blue-600 rounded-full animate-ping"></div>
              </div>
            </div>
            <p className="text-[11px] font-black uppercase text-slate-400 tracking-[0.5em] animate-pulse">Consultando Banco Supabase...</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead>
                <tr className="bg-slate-50/80 text-[11px] font-black text-slate-400 uppercase tracking-[0.2em]">
                  <th className="px-12 py-8">Documento Pedagógico</th>
                  <th className="px-12 py-8">Status / Data</th>
                  <th className="px-12 py-8 text-right">Ações Rápidas</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50">
                {getFilteredFiles().map(file => (
                  <tr key={file.id} className="group hover:bg-slate-50/50 transition-all cursor-default">
                    <td className="px-12 py-8">
                      <div className="flex items-center gap-5">
                        <div className="w-12 h-12 bg-white border border-slate-100 rounded-2xl flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all shadow-sm">
                          <FileText size={22} />
                        </div>
                        <div>
                          <p className="font-black text-slate-900 text-base tracking-tight mb-0.5 group-hover:text-blue-600 transition-colors">{file.title}</p>
                          <div className="flex items-center gap-2">
                             <span className="text-[9px] font-black uppercase tracking-widest text-slate-400 px-2 py-0.5 bg-slate-100 rounded-md">DOCX</span>
                             <span className="text-[9px] font-black uppercase tracking-widest text-emerald-500">Cloud Sync OK</span>
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-12 py-8">
                      <div className="flex flex-col">
                        <span className="text-xs font-black text-slate-600 uppercase italic">
                          {new Date(file.created_at).toLocaleDateString('pt-BR')}
                        </span>
                        <span className="text-[10px] font-bold text-slate-400">
                          Horário: {new Date(file.created_at).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}
                        </span>
                      </div>
                    </td>
                    <td className="px-12 py-8 text-right">
                      <div className="flex items-center justify-end gap-3 opacity-0 group-hover:opacity-100 transition-opacity">
                        <button 
                          onClick={() => handleEdit(file)}
                          className="p-3.5 bg-blue-50 text-blue-600 hover:bg-blue-600 hover:text-white rounded-2xl transition-all shadow-sm"
                          title="Abrir Editor"
                        >
                          <Edit3 size={18} />
                        </button>
                        <button 
                          onClick={() => handleExport(file)}
                          className="p-3.5 bg-emerald-50 text-emerald-600 hover:bg-emerald-600 hover:text-white rounded-2xl transition-all shadow-sm"
                          title="Baixar para Word"
                        >
                          <Download size={18} />
                        </button>
                        <button 
                          onClick={() => handleDelete(file.id)}
                          className="p-3.5 bg-red-50 text-red-400 hover:bg-red-500 hover:text-white rounded-2xl transition-all shadow-sm"
                          title="Excluir Permanentemente"
                        >
                          <Trash2 size={18} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
                
                {getFilteredFiles().length === 0 && (
                  <tr>
                    <td colSpan={3} className="p-48 text-center">
                      <div className="flex flex-col items-center gap-6 opacity-20">
                        <HardDrive className="w-24 h-24" />
                        <p className="font-black text-base uppercase tracking-[0.3em] italic">Workspace Vazio</p>
                      </div>
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default DriveExplorer;