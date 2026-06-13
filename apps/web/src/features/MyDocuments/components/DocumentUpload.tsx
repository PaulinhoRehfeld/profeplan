import React, { useState, useRef } from 'react';
import { Upload, FileText, CheckCircle2, AlertTriangle, Loader2 } from 'lucide-react';
import { extractTextFromPdf } from '../../../services/pdfService';
import { parseAndAuditPdfText, savePendingDocument } from '../../../services/ai/AiIngestionService';

interface DocumentUploadProps {
    userId: string;
    onUploadSuccess: (docId: string) => void;
    onCancel: () => void;
}

type StepKey = 'idle' | 'extracting' | 'parsing' | 'saving' | 'success' | 'error';

export const DocumentUpload: React.FC<DocumentUploadProps> = ({ userId, onUploadSuccess, onCancel }) => {
    const [category, setCategory] = useState<'course_plan' | 'book' | 'didactic_material'>('course_plan');
    const [file, setFile] = useState<File | null>(null);
    const [step, setStep] = useState<StepKey>('idle');
    const [progressText, setProgressText] = useState('');
    const [errorMessage, setErrorMessage] = useState('');
    const fileInputRef = useRef<HTMLInputElement>(null);

    const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files.length > 0) {
            setFile(e.target.files[0]);
        }
    };

    const handleDragOver = (e: React.DragEvent) => {
        e.preventDefault();
    };

    const handleDrop = (e: React.DragEvent) => {
        e.preventDefault();
        if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
            setFile(e.dataTransfer.files[0]);
        }
    };

    const startIngestion = async () => {
        if (!file) return;
        setStep('extracting');
        setProgressText('Lendo arquivo PDF e extraindo caracteres brutos (OCR)...');

        try {
            // Passo 1: Extrair texto do PDF
            const rawText = await extractTextFromPdf(file);
            if (!rawText || rawText.trim().length === 0) {
                throw new Error("Não foi possível extrair nenhum texto legível deste PDF. Certifique-se de que o arquivo não está corrompido ou protegido por senha.");
            }

            // Passo 2: IA estruturando Markdown e extraindo metadados
            setStep('parsing');
            setProgressText('Processando com a Inteligência Artificial: Estruturando Markdown, extraindo metadados e gerando relatório de curadoria...');
            const parsedResult = await parseAndAuditPdfText(rawText, category);

            // Passo 3: Salvar no Banco
            setStep('saving');
            setProgressText('Salvando documento e catalogando versão...');
            const docName = file.name.replace(/\.[^/.]+$/, ""); // Remove extension
            const doc = await savePendingDocument(userId, docName, file.name, category, parsedResult);

            setStep('success');
            setProgressText('Arquivo importado com sucesso!');
            
            // Redireciona após pequeno delay
            setTimeout(() => {
                onUploadSuccess(doc.id);
            }, 1500);

        } catch (error: any) {
            console.error(error);
            setStep('error');
            setErrorMessage(error.message || 'Erro durante o upload e processamento do PDF.');
        }
    };

    return (
        <div className="bg-slate-900 border border-slate-800 p-8 rounded-[2rem] max-w-xl mx-auto text-slate-100 shadow-2xl backdrop-blur-xl">
            <h3 className="text-lg font-black uppercase tracking-wider text-blue-400 mb-6">Importar Novo Documento</h3>

            {step === 'idle' && (
                <div className="space-y-6">
                    {/* Seletor de Categoria */}
                    <div>
                        <label className="block text-xs font-black uppercase tracking-wider text-slate-400 mb-3">
                            Categoria do Documento
                        </label>
                        <div className="grid grid-cols-3 gap-3">
                            <button
                                type="button"
                                onClick={() => setCategory('course_plan')}
                                className={`p-4 rounded-xl border text-center transition-all ${
                                    category === 'course_plan'
                                        ? 'bg-blue-600/20 border-blue-500 text-blue-300 font-bold'
                                        : 'bg-slate-800/40 border-slate-800 text-slate-400 hover:bg-slate-800'
                                }`}
                            >
                                <span className="block text-xs uppercase tracking-wider">Plano de Curso</span>
                            </button>
                            <button
                                type="button"
                                onClick={() => setCategory('book')}
                                className={`p-4 rounded-xl border text-center transition-all ${
                                    category === 'book'
                                        ? 'bg-blue-600/20 border-blue-500 text-blue-300 font-bold'
                                        : 'bg-slate-800/40 border-slate-800 text-slate-400 hover:bg-slate-800'
                                }`}
                            >
                                <span className="block text-xs uppercase tracking-wider">Livro Apoio</span>
                            </button>
                            <button
                                type="button"
                                onClick={() => setCategory('didactic_material')}
                                className={`p-4 rounded-xl border text-center transition-all ${
                                    category === 'didactic_material'
                                        ? 'bg-blue-600/20 border-blue-500 text-blue-300 font-bold'
                                        : 'bg-slate-800/40 border-slate-800 text-slate-400 hover:bg-slate-800'
                                }`}
                            >
                                <span className="block text-xs uppercase tracking-wider">Material Didático</span>
                            </button>
                        </div>
                    </div>

                    {/* Drag & Drop Area */}
                    <div
                        onDragOver={handleDragOver}
                        onDrop={handleDrop}
                        onClick={() => fileInputRef.current?.click()}
                        className="border-2 border-dashed border-slate-800 rounded-2xl p-8 text-center cursor-pointer hover:border-blue-500/50 hover:bg-slate-800/20 transition-all group"
                    >
                        <input
                            type="file"
                            accept=".pdf"
                            ref={fileInputRef}
                            onChange={handleFileChange}
                            className="hidden"
                        />
                        <Upload className="w-12 h-12 mx-auto text-slate-500 group-hover:text-blue-400 transition-colors mb-4" />
                        {file ? (
                            <div className="space-y-1">
                                <p className="text-sm font-bold text-white">{file.name}</p>
                                <p className="text-xs text-slate-400">{(file.size / 1024 / 1024).toFixed(2)} MB</p>
                            </div>
                        ) : (
                            <div className="space-y-1">
                                <p className="text-sm font-bold text-slate-300">Arraste seu PDF ou clique para selecionar</p>
                                <p className="text-xs text-slate-500">Apenas arquivos .pdf de até 50MB</p>
                            </div>
                        )}
                    </div>

                    {/* Botões de Ação */}
                    <div className="flex justify-end gap-3 pt-4 border-t border-slate-800">
                        <button
                            type="button"
                            onClick={onCancel}
                            className="px-5 py-2 text-xs font-black uppercase tracking-wider text-slate-400 hover:text-white"
                        >
                            Cancelar
                        </button>
                        <button
                            type="button"
                            disabled={!file}
                            onClick={startIngestion}
                            className={`px-6 py-2 rounded-full text-xs font-black uppercase tracking-wider text-white shadow-lg transition-all ${
                                file
                                    ? 'bg-blue-600 hover:bg-blue-500 shadow-blue-600/20'
                                    : 'bg-slate-800 text-slate-500 cursor-not-allowed'
                            }`}
                        >
                            Iniciar Ingestão
                        </button>
                    </div>
                </div>
            )}

            {/* Ingestion States */}
            {(step === 'extracting' || step === 'parsing' || step === 'saving') && (
                <div className="flex flex-col items-center justify-center py-12 space-y-6">
                    <Loader2 className="w-12 h-12 text-blue-500 animate-spin" />
                    <div className="text-center space-y-2 max-w-sm">
                        <h4 className="text-sm font-black uppercase tracking-wider text-white">Processando Documento</h4>
                        <p className="text-xs text-slate-400 leading-relaxed">{progressText}</p>
                    </div>
                </div>
            )}

            {step === 'success' && (
                <div className="flex flex-col items-center justify-center py-12 space-y-4">
                    <CheckCircle2 className="w-16 h-16 text-emerald-500" />
                    <h4 className="text-lg font-black uppercase tracking-wider text-white">Sucesso!</h4>
                    <p className="text-xs text-slate-400">{progressText}</p>
                </div>
            )}

            {step === 'error' && (
                <div className="space-y-6 py-4">
                    <div className="flex items-center gap-3 p-4 bg-red-950/30 border border-red-900/40 rounded-xl">
                        <AlertTriangle className="w-6 h-6 text-red-500 shrink-0" />
                        <div>
                            <h4 className="text-xs font-black uppercase tracking-wider text-red-400">Falha no Processamento</h4>
                            <p className="text-[11px] text-red-500 leading-relaxed">{errorMessage}</p>
                        </div>
                    </div>
                    <div className="flex justify-end gap-3 pt-4 border-t border-slate-800">
                        <button
                            type="button"
                            onClick={() => setStep('idle')}
                            className="px-6 py-2 rounded-full bg-slate-800 hover:bg-slate-700 text-xs font-black uppercase tracking-wider text-white"
                        >
                            Tentar Novamente
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
};
