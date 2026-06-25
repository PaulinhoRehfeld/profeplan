import React, { useState, useEffect } from 'react';
import { Plus, Trash2, LibraryBig, CheckCircle2, AlertCircle, RefreshCw, GitCompare, FileText } from 'lucide-react';
import { supabase } from '../../services/supabaseClient';
import { DocumentUpload } from './components/DocumentUpload';
import { MarkdownReview } from './components/MarkdownReview';
import { VersionCompare } from './components/VersionCompare';

interface MyDocumentsManagerProps {
    userId: string;
    setSidebarContent?: (node: React.ReactNode) => void;
}

type ViewState = 'list' | 'upload' | 'review' | 'compare';

export const MyDocumentsManager: React.FC<MyDocumentsManagerProps> = ({ userId }) => {
    const [view, setView] = useState<ViewState>('list');
    const [documents, setDocuments] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedDocId, setSelectedDocId] = useState<string>('');
    const [compareDocs, setCompareDocs] = useState<{ doc1Id: string; doc2Id: string }>({ doc1Id: '', doc2Id: '' });

    const fetchDocuments = async () => {
        setLoading(true);
        // Resolve auth.uid() real para coincidir com a política RLS.
        // session.id pode ser ghost UUID em cache; auth.getUser() retorna o JWT atual.
        const { data: { user: authUser } } = await supabase.auth.getUser();
        const authUid = authUser?.id ?? userId;
        const { data, error } = await supabase
            .from('teacher_documents')
            .select('*')
            .eq('user_id', authUid)
            .order('created_at', { ascending: false });

        if (!error && data) {
            setDocuments(data);
        }
        setLoading(false);
    };

    useEffect(() => {
        if (userId) {
            fetchDocuments();
        }
    }, [userId]);

    const handleDelete = async (docId: string) => {
        const confirm = window.confirm("Deseja realmente excluir este documento? Todos os chunks e dados de RAG correspondentes serão removidos.");
        if (confirm) {
            const { error } = await supabase
                .from('teacher_documents')
                .delete()
                .eq('id', docId);

            if (!error) {
                fetchDocuments();
            } else {
                alert("Erro ao excluir documento.");
            }
        }
    };

    // Agrupa documentos por 'filename' (nome original do arquivo) para simplificar a visualização de versões
    const groupedDocs = documents.reduce((acc: Record<string, any[]>, doc) => {
        if (!acc[doc.filename]) {
            acc[doc.filename] = [];
        }
        acc[doc.filename].push(doc);
        return acc;
    }, {});

    const renderList = () => {
        if (loading) {
            return (
                <div className="flex items-center justify-center p-20 text-slate-400">
                    <RefreshCw className="animate-spin mr-2 w-5 h-5 text-blue-500" />
                    <span>Carregando seus documentos...</span>
                </div>
            );
        }

        if (Object.keys(groupedDocs).length === 0) {
            return (
                <div className="text-center p-12 bg-slate-900 border border-slate-800 rounded-3xl max-w-lg mx-auto space-y-6">
                    <LibraryBig className="w-16 h-16 text-slate-700 mx-auto" />
                    <div className="space-y-1">
                        <h4 className="text-lg font-black text-white uppercase tracking-wider">Sua Base de Conhecimento está vazia</h4>
                        <p className="text-xs text-slate-400 leading-relaxed">
                            Envie Planos de Curso, Livros Didáticos ou Materiais Complementares para que os agentes de inteligência respondam alinhados à sua grade de aulas.
                        </p>
                    </div>
                    <button
                        onClick={() => setView('upload')}
                        className="px-6 py-2.5 bg-blue-600 hover:bg-blue-500 rounded-full text-xs font-black uppercase tracking-wider text-white shadow-lg shadow-blue-600/10 transition-all"
                    >
                        Adicionar Primeiro Documento
                    </button>
                </div>
            );
        }

        return (
            <div className="space-y-6">
                <div className="flex justify-between items-center mb-6">
                    <div>
                        <span className="text-[10px] font-black text-blue-500 uppercase tracking-widest">Painel de Contexto</span>
                        <h2 className="text-2xl font-black text-white">Meus Documentos</h2>
                    </div>
                    <button
                        onClick={() => setView('upload')}
                        className="px-5 py-2.5 bg-blue-600 hover:bg-blue-500 rounded-full text-xs font-black uppercase tracking-wider text-white flex items-center gap-1.5 shadow-lg shadow-blue-600/20 transition-all"
                    >
                        <Plus className="w-4 h-4" />
                        Adicionar Documento
                    </button>
                </div>

                <div className="grid grid-cols-1 gap-4">
                    {Object.entries(groupedDocs).map(([filename, versions]: [string, any[]]) => {
                        // A versão mais recente é a primeira no array devido ao order('created_at', desc)
                        const latestDoc = versions[0];
                        const hasMultipleVersions = versions.length > 1;

                        return (
                            <div key={filename} className="bg-slate-900/60 border border-slate-850 hover:border-slate-800 p-6 rounded-3xl flex flex-col md:flex-row md:items-center justify-between gap-4 transition-all">
                                <div className="space-y-2">
                                    <div className="flex items-center gap-2">
                                        <span className={`px-2 py-0.5 rounded text-[9px] font-black uppercase tracking-wider ${
                                            latestDoc.category === 'course_plan'
                                                ? 'bg-blue-900/30 text-blue-300 border border-blue-800/30'
                                                : latestDoc.category === 'book'
                                                ? 'bg-amber-900/30 text-amber-300 border border-amber-800/30'
                                                : 'bg-indigo-900/30 text-indigo-300 border border-indigo-800/30'
                                        }`}>
                                            {latestDoc.category === 'course_plan' ? 'Plano de Curso' : latestDoc.category === 'book' ? 'Livro Didático' : 'Material Didático'}
                                        </span>
                                        <span className="text-[10px] text-slate-500">Versão mais recente: V{latestDoc.version}</span>
                                    </div>
                                    <h4 className="text-base font-black text-white leading-tight">{latestDoc.title}</h4>
                                    <div className="flex items-center gap-4 text-xs text-slate-400">
                                        <span>{latestDoc.metadata?.subject || 'Sem matéria'}</span>
                                        <span>•</span>
                                        <span>{latestDoc.metadata?.year || 'Sem ano'}</span>
                                        {latestDoc.extraction_score && (
                                            <>
                                                <span>•</span>
                                                <span className={latestDoc.extraction_score >= 80 ? 'text-emerald-400' : 'text-amber-400'}>
                                                    Confiança: {latestDoc.extraction_score}%
                                                </span>
                                            </>
                                        )}
                                    </div>
                                </div>

                                <div className="flex items-center gap-3 self-end md:self-center">
                                    {/* Link de Homologação / Visualizar Pendente */}
                                    {latestDoc.status === 'pending' ? (
                                        <button
                                            onClick={() => {
                                                setSelectedDocId(latestDoc.id);
                                                setView('review');
                                            }}
                                            className="px-4 py-2 bg-amber-600 hover:bg-amber-500 rounded-xl text-xs font-bold text-white flex items-center gap-1.5 transition-colors"
                                        >
                                            <AlertCircle className="w-3.5 h-3.5" />
                                            Revisar Ingestão
                                        </button>
                                    ) : (
                                        <div className="flex items-center gap-1.5 text-xs text-emerald-400 font-bold bg-emerald-950/20 border border-emerald-900/20 px-3 py-2 rounded-xl">
                                            <CheckCircle2 className="w-4 h-4" />
                                            Ingerido
                                        </div>
                                    )}

                                    {/* Comparação de Versões */}
                                    {hasMultipleVersions && (
                                        <button
                                            onClick={() => {
                                                setCompareDocs({ doc1Id: versions[1].id, doc2Id: versions[0].id });
                                                setView('compare');
                                            }}
                                            className="px-3 py-2 bg-slate-800 hover:bg-slate-700 rounded-xl text-xs font-bold text-slate-300 flex items-center gap-1 transition-colors"
                                        >
                                            <GitCompare className="w-3.5 h-3.5" />
                                            Comparar V{versions[1].version} vs V{versions[0].version}
                                        </button>
                                    )}

                                    <button
                                        onClick={() => handleDelete(latestDoc.id)}
                                        className="p-2 text-slate-500 hover:text-red-400 hover:bg-red-500/10 rounded-xl transition-all"
                                        title="Excluir Documento"
                                    >
                                        <Trash2 className="w-4 h-4" />
                                    </button>
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>
        );
    };

    return (
        <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar bg-slate-950 text-slate-100 min-h-screen">
            {view === 'list' && renderList()}

            {view === 'upload' && (
                <DocumentUpload
                    userId={userId}
                    onUploadSuccess={(docId) => {
                        setSelectedDocId(docId);
                        setView('review');
                    }}
                    onCancel={() => setView('list')}
                />
            )}

            {view === 'review' && (
                <MarkdownReview
                    documentId={selectedDocId}
                    userId={userId}
                    onApproved={() => {
                        setView('list');
                        fetchDocuments();
                    }}
                    onReprocess={() => {
                        setView('list');
                        fetchDocuments();
                    }}
                />
            )}

            {view === 'compare' && (
                <VersionCompare
                    doc1Id={compareDocs.doc1Id}
                    doc2Id={compareDocs.doc2Id}
                    onBack={() => setView('list')}
                />
            )}
        </div>
    );
};

export default MyDocumentsManager;
