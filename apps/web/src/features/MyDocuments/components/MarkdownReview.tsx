import React, { useState } from 'react';
import { Check, RefreshCw, AlertTriangle, AlertCircle, FileText, Settings, Loader2 } from 'lucide-react';
import { approveDocumentAndIngest } from '../../../services/ai/AiIngestionService';
import { supabase } from '../../../services/supabaseClient';

interface MarkdownReviewProps {
    documentId: string;
    userId: string;
    onApproved: () => void;
    onReprocess: () => void;
}

export const MarkdownReview: React.FC<MarkdownReviewProps> = ({ documentId, userId, onApproved, onReprocess }) => {
    const [doc, setDoc] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    const [ingesting, setIngesting] = useState(false);
    const [ingestionProgressText, setIngestionProgressText] = useState('');
    const [isEditing, setIsEditing] = useState(false);
    const [contentMd, setContentMd] = useState('');

    React.useEffect(() => {
        const fetchDoc = async () => {
            setLoading(true);
            const { data, error } = await supabase
                .from('teacher_documents')
                .select('*')
                .eq('id', documentId)
                .single();

            if (data && !error) {
                setDoc(data);
                setContentMd(data.content_md || '');
            }
            setLoading(false);
        };

        if (documentId) {
            fetchDoc();
        }
    }, [documentId]);

    const handleApprove = async () => {
        setIngesting(true);
        try {
            // Se editou o markdown, atualiza no banco antes
            if (isEditing) {
                await supabase
                    .from('teacher_documents')
                    .update({ content_md: contentMd })
                    .eq('id', documentId);
            }

            await approveDocumentAndIngest(documentId, userId, (progressMsg) => {
                setIngestionProgressText(progressMsg);
            });

            onApproved();
        } catch (e) {
            console.error(e);
            alert("Falha ao homologar documento e gerar embeddings.");
        } finally {
            setIngesting(false);
        }
    };

    const handleReprocess = async () => {
        const confirm = window.confirm("Deseja realmente reprocessar este documento? O registro atual será removido para re-envio.");
        if (confirm) {
            try {
                await supabase
                    .from('teacher_documents')
                    .delete()
                    .eq('id', documentId);
                onReprocess();
            } catch (e) {
                console.error(e);
            }
        }
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center p-20 bg-slate-900 border border-slate-800 text-slate-400 rounded-3xl">
                <Loader2 className="animate-spin mr-2 w-6 h-6 text-blue-500" />
                <span className="text-sm font-medium">Carregando dados da revisão...</span>
            </div>
        );
    }

    if (!doc) {
        return (
            <div className="p-8 text-center bg-slate-900 text-slate-400 border border-slate-800 rounded-3xl">
                Documento não localizado.
            </div>
        );
    }

    const metadata = doc.metadata || {};
    const score = doc.extraction_score || 0;
    const isScoreLow = score < 80;

    return (
        <div className="bg-slate-900 border border-slate-800 rounded-[2rem] p-8 space-y-8 text-slate-200 max-w-5xl mx-auto shadow-2xl relative">
            {ingesting && (
                <div className="absolute inset-0 bg-slate-950/80 backdrop-blur-md rounded-[2rem] flex flex-col items-center justify-center z-50 space-y-4">
                    <Loader2 className="w-12 h-12 text-blue-500 animate-spin" />
                    <h4 className="text-sm font-black uppercase tracking-wider text-white">Homologando Documento</h4>
                    <p className="text-xs text-slate-400">{ingestionProgressText}</p>
                </div>
            )}

            <div className="flex items-center justify-between border-b border-slate-800 pb-4">
                <div>
                    <span className="text-[10px] font-black text-blue-500 uppercase tracking-widest">
                        Revisão de Conteúdo - V{doc.version}
                    </span>
                    <h3 className="text-xl font-black text-white">{doc.title}</h3>
                </div>
                <div className="flex items-center gap-3">
                    <span className="text-xs text-slate-500">{doc.filename}</span>
                </div>
            </div>

            {/* Alerta de Confiança de Extração */}
            {isScoreLow ? (
                <div className="flex gap-4 p-5 bg-amber-950/20 border border-amber-900/30 rounded-2xl">
                    <AlertTriangle className="w-6 h-6 text-amber-500 shrink-0 mt-0.5" />
                    <div className="space-y-1">
                        <h4 className="text-xs font-black uppercase tracking-wider text-amber-400">
                            Score de Confiança Baixo ({score}%)
                        </h4>
                        <p className="text-[11px] text-amber-500/80 leading-relaxed">
                            A extração por IA identificou que algumas partes do PDF original (tabelas, caracteres especiais ou formatação) podem ter sido comprometidas. Recomendamos revisar e ajustar o Markdown abaixo antes de aprovar.
                        </p>
                    </div>
                </div>
            ) : (
                <div className="flex gap-4 p-5 bg-emerald-950/10 border border-emerald-900/20 rounded-2xl">
                    <AlertCircle className="w-6 h-6 text-emerald-500 shrink-0 mt-0.5" />
                    <div className="space-y-1">
                        <h4 className="text-xs font-black uppercase tracking-wider text-emerald-400">
                            Excelente Qualidade de Extração ({score}%)
                        </h4>
                        <p className="text-[11px] text-emerald-500/80 leading-relaxed">
                            Os algoritmos de parser confirmaram alta fidelidade de extração em relação ao PDF original.
                        </p>
                    </div>
                </div>
            )}

            {/* Grid Superior: Metadados Extraídos & Relatório de Curadoria */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Metadados */}
                <div className="bg-slate-950/40 border border-slate-850 p-6 rounded-2xl space-y-4">
                    <h4 className="text-xs font-black uppercase tracking-wider text-slate-400 border-b border-slate-850 pb-2">
                        Metadados Identificados
                    </h4>
                    <div className="grid grid-cols-2 gap-4 text-xs">
                        <div>
                            <span className="block text-slate-500 font-bold">Disciplina</span>
                            <span className="text-slate-300">{metadata.subject || 'Não extraído'}</span>
                        </div>
                        <div>
                            <span className="block text-slate-500 font-bold">Ano Escolar</span>
                            <span className="text-slate-300">{metadata.year || 'Não extraído'}</span>
                        </div>
                        <div>
                            <span className="block text-slate-500 font-bold">Carga Horária</span>
                            <span className="text-slate-300">{metadata.workload ? `${metadata.workload} horas` : 'N/A'}</span>
                        </div>
                    </div>
                    {metadata.skills && metadata.skills.length > 0 && (
                        <div className="text-xs space-y-1">
                            <span className="block text-slate-500 font-bold">Habilidades BNCC</span>
                            <div className="flex flex-wrap gap-1">
                                {metadata.skills.map((s: string) => (
                                    <span key={s} className="px-2 py-0.5 bg-slate-800 text-blue-300 rounded text-[10px] font-bold">
                                        {s}
                                    </span>
                                ))}
                            </div>
                        </div>
                    )}
                </div>

                {/* Relatório de Curadoria */}
                <div className="bg-slate-950/40 border border-slate-850 p-6 rounded-2xl space-y-2">
                    <h4 className="text-xs font-black uppercase tracking-wider text-slate-400 border-b border-slate-850 pb-2">
                        Relatório de Curadoria Pedagógica (IA)
                    </h4>
                    <div className="text-xs text-slate-400 overflow-y-auto max-h-40 leading-relaxed whitespace-pre-wrap">
                        {doc.curation_report || 'Nenhum problema encontrado no relatório de curadoria.'}
                    </div>
                </div>
            </div>

            {/* Painel do Markdown */}
            <div className="space-y-3">
                <div className="flex items-center justify-between">
                    <h4 className="text-xs font-black uppercase tracking-wider text-slate-400">
                        Markdown Estruturado do Documento
                    </h4>
                    <button
                        type="button"
                        onClick={() => setIsEditing(!isEditing)}
                        className="text-xs font-bold text-blue-400 hover:text-blue-300 flex items-center gap-1"
                    >
                        <Settings className="w-3.5 h-3.5" />
                        {isEditing ? 'Visualizar' : 'Editar Markdown'}
                    </button>
                </div>

                {isEditing ? (
                    <textarea
                        value={contentMd}
                        onChange={(e) => setContentMd(e.target.value)}
                        className="w-full h-80 bg-slate-950 text-slate-300 font-mono text-xs p-4 rounded-2xl border border-slate-800 focus:border-blue-500 focus:outline-none"
                    />
                ) : (
                    <div className="w-full h-80 bg-slate-950 text-slate-300 text-xs p-4 rounded-2xl border border-slate-850 overflow-y-auto whitespace-pre-wrap leading-relaxed">
                        {contentMd}
                    </div>
                )}
            </div>

            {/* Botões Finais */}
            <div className="flex justify-end gap-3 pt-6 border-t border-slate-800">
                <button
                    type="button"
                    onClick={handleReprocess}
                    className="px-6 py-2.5 rounded-full border border-slate-800 hover:bg-slate-800 text-xs font-black uppercase tracking-wider text-slate-400 hover:text-white flex items-center gap-2 transition-colors"
                >
                    <RefreshCw className="w-3.5 h-3.5" />
                    Reprocessar PDF
                </button>
                <button
                    type="button"
                    onClick={handleApprove}
                    className="px-6 py-2.5 rounded-full bg-blue-600 hover:bg-blue-500 text-xs font-black uppercase tracking-wider text-white flex items-center gap-2 shadow-lg shadow-blue-600/20 transition-all"
                >
                    <Check className="w-4 h-4" />
                    Homologar e Ingerir no RAG
                </button>
            </div>
        </div>
    );
};
