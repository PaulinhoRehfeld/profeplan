import React, { useState, useEffect } from 'react';
import { Columns, GitCompare, Sparkles, Loader2, ArrowLeft } from 'lucide-react';
import { supabase } from '../../../services/supabaseClient';
import { createSimpleCompletion } from '../../../services/ai/AiCore';

interface VersionCompareProps {
    doc1Id: string;
    doc2Id: string;
    onBack: () => void;
}

export const VersionCompare: React.FC<VersionCompareProps> = ({ doc1Id, doc2Id, onBack }) => {
    const [doc1, setDoc1] = useState<any>(null);
    const [doc2, setDoc2] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    const [aiReport, setAiReport] = useState('');
    const [generatingAi, setGeneratingAi] = useState(false);

    useEffect(() => {
        const fetchDocs = async () => {
            setLoading(true);
            const { data: d1 } = await supabase.from('teacher_documents').select('*').eq('id', doc1Id).single();
            const { data: d2 } = await supabase.from('teacher_documents').select('*').eq('id', doc2Id).single();
            setDoc1(d1);
            setDoc2(d2);
            setLoading(false);
        };
        fetchDocs();
    }, [doc1Id, doc2Id]);

    const generateAiComparison = async () => {
        if (!doc1 || !doc2) return;
        setGeneratingAi(true);
        setAiReport('');

        const prompt = `
Você é um auditor de currículos escolares. Compare as duas versões a seguir do mesmo documento curricular e gere um relatório detalhado em formato Markdown listando:
1. O que foi adicionado na Versão 2 (ex: novas habilidades, novos capítulos, carga horária alterada).
2. O que foi removido.
3. Diferenças sutis em conteúdos e competências.

Versão 1 (${doc1.title} - V${doc1.version}):
---
${doc1.content_md?.substring(0, 15000)}
---

Versão 2 (${doc2.title} - V${doc2.version}):
---
${doc2.content_md?.substring(0, 15000)}
---

Gere uma resposta curta, objetiva, e bem formatada em Markdown de fácil leitura para professores.
`;

        try {
            const report = await createSimpleCompletion(prompt, "Você é um assistente analítico pedagógico.", 0.2);
            setAiReport(report);
        } catch (e) {
            console.error(e);
            setAiReport("Falha ao gerar relatório comparativo da IA.");
        } finally {
            setGeneratingAi(false);
        }
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center p-20 bg-slate-900 border border-slate-800 text-slate-400 rounded-3xl">
                <Loader2 className="animate-spin mr-2 w-6 h-6 text-blue-500" />
                <span className="text-sm font-medium">Carregando comparação de versões...</span>
            </div>
        );
    }

    if (!doc1 || !doc2) {
        return (
            <div className="p-8 text-center bg-slate-900 text-slate-400 border border-slate-800 rounded-3xl">
                Erro ao carregar documentos selecionados.
            </div>
        );
    }

    return (
        <div className="bg-slate-900 border border-slate-800 rounded-[2rem] p-8 space-y-6 text-slate-200 shadow-2xl">
            <div className="flex items-center justify-between border-b border-slate-800 pb-4">
                <button
                    onClick={onBack}
                    className="text-xs font-black uppercase tracking-wider text-slate-400 hover:text-white flex items-center gap-1.5 transition-colors"
                >
                    <ArrowLeft className="w-4 h-4" />
                    Voltar
                </button>
                <div className="flex items-center gap-2">
                    <GitCompare className="w-5 h-5 text-blue-500" />
                    <span className="text-sm font-black uppercase tracking-wider text-white">Comparar Versões</span>
                </div>
            </div>

            {/* Painel do Relatório da IA */}
            <div className="bg-slate-950/50 border border-slate-850 p-6 rounded-2xl space-y-4">
                <div className="flex items-center justify-between">
                    <div className="space-y-0.5">
                        <h4 className="text-xs font-black uppercase tracking-wider text-white">Relatório de Modificações (IA)</h4>
                        <p className="text-[10px] text-slate-500">Compare as mudanças curriculares entre as duas versões</p>
                    </div>
                    <button
                        onClick={generateAiComparison}
                        disabled={generatingAi}
                        className="bg-blue-600 hover:bg-blue-500 disabled:bg-slate-850 text-white px-4 py-2 rounded-full text-xs font-bold flex items-center gap-1.5 transition-all shadow-md shadow-blue-600/10"
                    >
                        {generatingAi ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Sparkles className="w-3.5 h-3.5 text-amber-300" />}
                        Análise Curricular por IA
                    </button>
                </div>

                {aiReport && (
                    <div className="bg-slate-950 p-4 border border-slate-850 rounded-xl text-xs text-slate-300 leading-relaxed whitespace-pre-wrap max-h-60 overflow-y-auto">
                        {aiReport}
                    </div>
                )}
            </div>

            {/* Colunas Lado a Lado */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Versão Antiga */}
                <div className="border border-slate-850 bg-slate-950/20 p-6 rounded-2xl space-y-4">
                    <div className="border-b border-slate-850 pb-2 flex justify-between items-center">
                        <h4 className="text-sm font-black text-white">{doc1.title}</h4>
                        <span className="px-2 py-0.5 bg-slate-800 text-[10px] font-bold text-slate-400 rounded">
                            Versão {doc1.version}
                        </span>
                    </div>
                    <div className="text-[11px] text-slate-400 bg-slate-950/40 p-4 rounded-xl space-y-1">
                        <span className="block font-bold text-slate-500">Metadados da Versão</span>
                        <p>Disciplina: {doc1.metadata?.subject || 'N/A'}</p>
                        <p>Ano Escolar: {doc1.metadata?.year || 'N/A'}</p>
                        <p>Habilidades: {doc1.metadata?.skills?.join(', ') || 'Nenhuma'}</p>
                    </div>
                    <div className="h-80 overflow-y-auto p-4 bg-slate-950 rounded-xl font-mono text-[10px] text-slate-400 whitespace-pre-wrap leading-relaxed">
                        {doc1.content_md}
                    </div>
                </div>

                {/* Versão Nova */}
                <div className="border border-slate-850 bg-slate-950/20 p-6 rounded-2xl space-y-4">
                    <div className="border-b border-slate-850 pb-2 flex justify-between items-center">
                        <h4 className="text-sm font-black text-white">{doc2.title}</h4>
                        <span className="px-2 py-0.5 bg-blue-900/40 text-[10px] font-bold text-blue-300 rounded">
                            Versão {doc2.version}
                        </span>
                    </div>
                    <div className="text-[11px] text-slate-400 bg-slate-950/40 p-4 rounded-xl space-y-1">
                        <span className="block font-bold text-slate-500">Metadados da Versão</span>
                        <p>Disciplina: {doc2.metadata?.subject || 'N/A'}</p>
                        <p>Ano Escolar: {doc2.metadata?.year || 'N/A'}</p>
                        <p>Habilidades: {doc2.metadata?.skills?.join(', ') || 'Nenhuma'}</p>
                    </div>
                    <div className="h-80 overflow-y-auto p-4 bg-slate-950 rounded-xl font-mono text-[10px] text-slate-400 whitespace-pre-wrap leading-relaxed">
                        {doc2.content_md}
                    </div>
                </div>
            </div>
        </div>
    );
};
