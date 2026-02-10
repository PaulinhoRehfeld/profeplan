import React, { useEffect, useState } from 'react';
import {
    FileText, Download, Eye, Printer, CheckCircle,
    User, TrendingUp, Award, Calendar, Loader
} from 'lucide-react';
import { PdiDocumentService } from '../../../services/pdi/PdiDocumentService';
import { PdiDocument } from '../../../types/pdi';
import PDIViewBlocks1to8 from './PDIViewBlocks1to8';
import PDIBlock9Viewer from './PDIBlock9Viewer';
import PDIBlock10Viewer from './PDIBlock10Viewer';
import PDIBlock11Editor from './PDIBlock11Editor';

interface PDICompilerProps {
    pdiId: string;
    userId: string;
    userRole: string;
}

/**
 * PDI Compiler - Complete View & Export
 * Shows all 11 blocks in a single scrollable document
 * Allows export to official DOCX format
 */
const PDICompiler: React.FC<PDICompilerProps> = ({ pdiId, userId, userRole }) => {
    const [pdi, setPdi] = useState<PdiDocument | null>(null);
    const [loading, setLoading] = useState(true);
    const [exporting, setExporting] = useState(false);
    const [activeTab, setActiveTab] = useState<'view' | 'print'>('view');

    useEffect(() => {
        loadPdi();
    }, [pdiId]);

    const loadPdi = async () => {
        setLoading(true);
        try {
            const { data, error } = await PdiDocumentService.getPdiDocument(pdiId);
            if (error) throw error;
            setPdi(data);
        } catch (error) {
            console.error('Error loading PDI:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleExportDocx = async () => {
        if (!pdi) return;

        setExporting(true);
        try {
            // Import dynamically to avoid bundle bloat
            const { exportPdiToDocx } = await import('../../../services/pdi/PdiDocumentService');
            await exportPdiToDocx(pdi);
        } catch (error: any) {
            console.error('Error exporting to DOCX:', error);
            alert(error.message || 'Erro ao exportar PDI para DOCX');
        } finally {
            setExporting(false);
        }
    };

    const handlePrint = () => {
        window.print();
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center min-h-screen">
                <div className="animate-spin rounded-full h-12 w-12 border-4 border-blue-600 border-t-transparent"></div>
            </div>
        );
    }

    if (!pdi) {
        return (
            <div className="flex items-center justify-center min-h-screen">
                <div className="text-center">
                    <h2 className="text-2xl font-bold text-slate-900 mb-2">PDI não encontrado</h2>
                    <p className="text-slate-600">Verifique se o ID está correto.</p>
                </div>
            </div>
        );
    }

    const studentName = pdi.student_name || 'Estudante';
    const completeness = PdiDocumentService.calculateCompleteness(pdi);

    return (
        <div className="min-h-screen bg-slate-50">

            {/* Fixed Header */}
            <div className="sticky top-0 z-50 bg-white border-b border-slate-200 shadow-sm print:hidden">
                <div className="max-w-7xl mx-auto px-4 py-4">
                    <div className="flex items-center justify-between">
                        <div>
                            <h1 className="text-2xl font-black text-slate-900">
                                PDI Completo - {studentName}
                            </h1>
                            <p className="text-sm text-slate-600">
                                Ano: {pdi.year} | Status: <strong>{pdi.status}</strong>
                            </p>
                        </div>
                        <div className="flex items-center gap-3">
                            {/* Completeness Badge */}
                            <div className="flex items-center gap-2 px-4 py-2 bg-blue-100 rounded-xl">
                                <CheckCircle size={18} className="text-blue-600" />
                                <span className="font-bold text-blue-900">
                                    {completeness.overall_percentage}% Completo
                                </span>
                            </div>

                            {/* Export Buttons */}
                            <button
                                onClick={handlePrint}
                                className="flex items-center gap-2 px-4 py-2 bg-slate-200 hover:bg-slate-300 text-slate-700 font-semibold rounded-xl transition-colors"
                            >
                                <Printer size={18} />
                                Imprimir
                            </button>
                            <button
                                onClick={handleExportDocx}
                                disabled={exporting || completeness.overall_percentage < 100}
                                className="flex items-center gap-2 px-6 py-2 bg-green-600 hover:bg-green-700 text-white font-bold rounded-xl shadow-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all"
                            >
                                {exporting ? (
                                    <>
                                        <Loader size={18} className="animate-spin" />
                                        Exportando...
                                    </>
                                ) : (
                                    <>
                                        <Download size={18} />
                                        Exportar DOCX Oficial
                                    </>
                                )}
                            </button>
                        </div>
                    </div>

                    {/* Completeness Progress Bar */}
                    <div className="mt-4">
                        <div className="flex items-center justify-between text-xs font-semibold text-slate-600 mb-2">
                            <span>Progresso de Preenchimento</span>
                            <span>{completeness.overall_percentage}%</span>
                        </div>
                        <div className="w-full h-2 bg-slate-200 rounded-full overflow-hidden">
                            <div
                                className="h-full bg-gradient-to-r from-blue-500 to-green-500 transition-all duration-500"
                                style={{ width: `${completeness.overall_percentage}%` }}
                            ></div>
                        </div>
                        <div className="grid grid-cols-11 gap-2 mt-2">
                            {completeness.blocks_status.map((block) => (
                                <div
                                    key={block.block_name}
                                    className={`text-xs text-center py-1 rounded ${block.is_complete
                                        ? 'bg-green-100 text-green-700'
                                        : block.completion_percentage > 0
                                            ? 'bg-yellow-100 text-yellow-700'
                                            : 'bg-slate-100 text-slate-400'
                                        }`}
                                    title={`${block.block_name}: ${block.completion_percentage}%`}
                                >
                                    B{block.block_name.replace('block_', '')}
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            </div>

            {/* Main Content */}
            <div className="max-w-7xl mx-auto px-4 py-8 space-y-12">

                {/* Cover Page (Print Only) */}
                <div className="hidden print:block page-break-after">
                    <div className="text-center space-y-6 py-20">
                        <div className="w-32 h-32 bg-blue-600 rounded-full flex items-center justify-center mx-auto">
                            <FileText size={64} className="text-white" />
                        </div>
                        <h1 className="text-5xl font-black text-slate-900">
                            PLANO DE DESENVOLVIMENTO INDIVIDUAL
                        </h1>
                        <h2 className="text-3xl font-bold text-slate-700">
                            {studentName}
                        </h2>
                        <p className="text-xl text-slate-600">
                            Ano: {pdi.year}
                        </p>
                        <p className="text-lg text-slate-500">
                            {new Date().toLocaleDateString('pt-BR', {
                                year: 'numeric',
                                month: 'long',
                                day: 'numeric'
                            })}
                        </p>
                    </div>
                </div>

                {/* Blocks 1-8: Institutional Data */}
                <section className="page-break-before">
                    <div className="flex items-center gap-3 mb-6">
                        <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
                            <User size={20} className="text-blue-600" />
                        </div>
                        <h2 className="text-3xl font-black text-slate-900">
                            Blocos 1-8: Dados Institucionais e Diagnóstico
                        </h2>
                    </div>
                    <PDIViewBlocks1to8 pdiId={pdiId} />
                </section>

                {/* Block 9: Curriculum Adaptations */}
                <section className="page-break-before">
                    <div className="flex items-center gap-3 mb-6">
                        <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center">
                            <FileText size={20} className="text-purple-600" />
                        </div>
                        <h2 className="text-3xl font-black text-slate-900">
                            Bloco 9: Adaptações Curriculares
                        </h2>
                    </div>
                    <PDIBlock9Viewer pdiId={pdiId} />
                </section>

                {/* Block 10: Evaluations */}
                <section className="page-break-before">
                    <div className="flex items-center gap-3 mb-6">
                        <div className="w-10 h-10 bg-indigo-100 rounded-xl flex items-center justify-center">
                            <TrendingUp size={20} className="text-indigo-600" />
                        </div>
                        <h2 className="text-3xl font-black text-slate-900">
                            Bloco 10: Avaliações e Acompanhamento
                        </h2>
                    </div>
                    <PDIBlock10Viewer pdiId={pdiId} />
                </section>

                {/* Block 11: Final Report */}
                <section className="page-break-before">
                    <div className="flex items-center gap-3 mb-6">
                        <div className="w-10 h-10 bg-emerald-100 rounded-xl flex items-center justify-center">
                            <Award size={20} className="text-emerald-600" />
                        </div>
                        <h2 className="text-3xl font-black text-slate-900">
                            Bloco 11: Relatório Final
                        </h2>
                    </div>
                    <PDIBlock11Editor
                        pdiId={pdiId}
                        studentName={studentName}
                        userId={userId}
                        userRole={userRole}
                    />
                </section>

                {/* Signature Section (Print Only) */}
                <section className="hidden print:block page-break-before">
                    <div className="mt-20 space-y-16">
                        <div>
                            <div className="border-t-2 border-slate-900 w-96 mx-auto"></div>
                            <p className="text-center mt-2 font-bold text-slate-700">
                                Coordenador Pedagógico / Gestor Escolar
                            </p>
                            <p className="text-center text-sm text-slate-500">
                                Data: _____ / _____ / _____
                            </p>
                        </div>
                        <div>
                            <div className="border-t-2 border-slate-900 w-96 mx-auto"></div>
                            <p className="text-center mt-2 font-bold text-slate-700">
                                Professor Responsável
                            </p>
                            <p className="text-center text-sm text-slate-500">
                                Data: _____ / _____ / _____
                            </p>
                        </div>
                        <div>
                            <div className="border-t-2 border-slate-900 w-96 mx-auto"></div>
                            <p className="text-center mt-2 font-bold text-slate-700">
                                Responsável Legal do Estudante
                            </p>
                            <p className="text-center text-sm text-slate-500">
                                Data: _____ / _____ / _____
                            </p>
                        </div>
                    </div>
                </section>
            </div>

            {/* Print Styles */}
            <style jsx>{`
                @media print {
                    body {
                        print-color-adjust: exact;
                        -webkit-print-color-adjust: exact;
                    }
                    .page-break-before {
                        page-break-before: always;
                    }
                    .page-break-after {
                        page-break-after: always;
                    }
                    .print\\:hidden {
                        display: none !important;
                    }
                    .print\\:block {
                        display: block !important;
                    }
                }
            `}</style>
        </div>
    );
};

export default PDICompiler;
