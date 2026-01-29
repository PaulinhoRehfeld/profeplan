import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import {
    User, FileText, Target, Package, Users as UsersIcon,
    Calendar, Home, MessageSquare, ChevronRight, ChevronLeft,
    Save, CheckCircle, AlertCircle
} from 'lucide-react';
import { PdiDocumentService } from '../../../services/PdiDocumentService';
import {
    Block1Identificacao,
    Block2Diagnostico,
    Block3Objetivos,
    Block4Recursos,
    Block5Equipe,
    Block6Atendimento,
    Block7Familia,
    Block8Observacoes,
    Block1to8Data,
} from '../../../types/pdi';

// Import New Form Components
import { Block1Form } from './forms/Block1Form';
import { Block2Form } from './forms/Block2Form';
import { Block3Form } from './forms/Block3Form';
import { Block4Form } from './forms/Block4Form';
import { Block5Form } from './forms/Block5Form';
import { Block6Form } from './forms/Block6Form';
import { Block7Form } from './forms/Block7Form';
import { Block8Form } from './forms/Block8Form';

interface PDIFormBlocks1to8Props {
    pdiId?: string;
    studentId?: string;
    schoolId?: string;
    period?: string;
}

const PDIFormBlocks1to8: React.FC<PDIFormBlocks1to8Props> = ({
    pdiId,
    studentId,
    schoolId,
    period,
}) => {
    const navigate = useNavigate();
    const { id } = useParams();
    const actualPdiId = pdiId || id;

    const [currentStep, setCurrentStep] = useState(0);
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState(false);

    // Form data for each block
    const [block1, setBlock1] = useState<Block1Identificacao>({} as Block1Identificacao);
    const [block2, setBlock2] = useState<Block2Diagnostico>({} as Block2Diagnostico);
    const [block3, setBlock3] = useState<Block3Objetivos>({} as Block3Objetivos);
    const [block4, setBlock4] = useState<Block4Recursos>({} as Block4Recursos);
    const [block5, setBlock5] = useState<Block5Equipe>({} as Block5Equipe);
    const [block6, setBlock6] = useState<Block6Atendimento>({} as Block6Atendimento);
    const [block7, setBlock7] = useState<Block7Familia>({} as Block7Familia);
    const [block8, setBlock8] = useState<Block8Observacoes>({} as Block8Observacoes);

    const steps = [
        { number: 1, title: 'Identificação', icon: User, fields: ['nome_completo', 'data_nascimento'] },
        { number: 2, title: 'Diagnóstico', icon: FileText, fields: ['necessidades_especificas'] },
        { number: 3, title: 'Objetivos', icon: Target, fields: ['objetivo_geral'] },
        { number: 4, title: 'Recursos', icon: Package, fields: [] },
        { number: 5, title: 'Equipe', icon: UsersIcon, fields: [] },
        { number: 6, title: 'Atendimento', icon: Calendar, fields: [] },
        { number: 7, title: 'Família', icon: Home, fields: [] },
        { number: 8, title: 'Observações', icon: MessageSquare, fields: [] },
    ];

    useEffect(() => {
        if (actualPdiId) {
            loadExistingData();
        }
    }, [actualPdiId]);

    const loadExistingData = async () => {
        if (!actualPdiId) return;
        setLoading(true);
        try {
            const pdi = await PdiDocumentService.getPdiDocument(actualPdiId);
            if (pdi && pdi.block_1_8) {
                setBlock1(pdi.block_1_8.bloco_1_identificacao || {});
                setBlock2(pdi.block_1_8.bloco_2_diagnostico || {});
                setBlock3(pdi.block_1_8.bloco_3_objetivos || {});
                setBlock4(pdi.block_1_8.bloco_4_recursos || {});
                setBlock5(pdi.block_1_8.bloco_5_equipe || {});
                setBlock6(pdi.block_1_8.bloco_6_atendimento || {});
                setBlock7(pdi.block_1_8.bloco_7_familia || {});
                setBlock8(pdi.block_1_8.bloco_8_observacoes || {});
            }
        } catch (err) {
            console.error('Error loading PDI:', err);
            setError('Erro ao carregar dados do PDI');
        } finally {
            setLoading(false);
        }
    };

    const validateStep = (step: number): boolean => {
        switch (step) {
            case 0: // Block 1
                return !!block1.nome_completo && !!block1.data_nascimento;
            case 1: // Block 2
                return true; // Optional fields
            case 2: // Block 3
                return !!block3.objetivo_geral;
            default:
                return true;
        }
    };

    const handleNext = () => {
        if (!validateStep(currentStep)) {
            setError('Por favor, preencha os campos obrigatórios antes de continuar.');
            return;
        }
        setError('');
        if (currentStep < steps.length - 1) {
            setCurrentStep(currentStep + 1);
        }
    };

    const handlePrevious = () => {
        if (currentStep > 0) {
            setCurrentStep(currentStep - 1);
        }
    };

    const handleSave = async () => {
        setSaving(true);
        setError('');

        try {
            const block1to8Data: Block1to8Data = {
                bloco_1_identificacao: block1,
                bloco_2_diagnostico: block2,
                bloco_3_objetivos: block3,
                bloco_4_recursos: block4,
                bloco_5_equipe: block5,
                bloco_6_atendimento: block6,
                bloco_7_familia: block7,
                bloco_8_observacoes: block8,
            };

            if (actualPdiId) {
                // Update existing PDI
                await PdiDocumentService.updateBlock1to8({
                    pdi_id: actualPdiId,
                    block_1_8: block1to8Data,
                });
            } else {
                // Create new PDI
                if (!studentId || !schoolId || !period) {
                    throw new Error('Missing required fields for PDI creation');
                }
                await PdiDocumentService.createPdiDocument({
                    student_id: studentId,
                    school_id: schoolId,
                    period: period,
                    block_1_8: block1to8Data,
                });
            }

            setSuccess(true);
            setTimeout(() => {
                navigate('/pdi');
            }, 1500);
        } catch (err: any) {
            console.error('Error saving PDI:', err);
            setError(err.message || 'Erro ao salvar PDI');
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center min-h-screen bg-slate-50">
                <div className="animate-spin rounded-full h-12 w-12 border-4 border-blue-600 border-t-transparent"></div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-slate-50 p-4 md:p-8">
            <div className="max-w-5xl mx-auto">

                {/* Header */}
                <div className="mb-8">
                    <h1 className="text-3xl font-black text-slate-900 mb-2">
                        Formulário Base PDI - Blocos 1 a 8
                    </h1>
                    <p className="text-slate-600">
                        Preencha as informações institucionais e de diagnóstico do aluno
                    </p>
                </div>

                {/* Progress Steps */}
                <div className="mb-8 overflow-x-auto">
                    <div className="flex items-center gap-2 min-w-max">
                        {steps.map((step, index) => {
                            const Icon = step.icon;
                            const isCompleted = index < currentStep;
                            const isCurrent = index === currentStep;

                            return (
                                <React.Fragment key={step.number}>
                                    <button
                                        onClick={() => setCurrentStep(index)}
                                        className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-all ${isCurrent
                                            ? 'bg-blue-600 text-white shadow-lg'
                                            : isCompleted
                                                ? 'bg-green-100 text-green-700 hover:bg-green-200'
                                                : 'bg-white text-slate-600 hover:bg-slate-100'
                                            }`}
                                    >
                                        <Icon size={18} />
                                        <div className="text-left hidden md:block">
                                            <div className="text-xs font-bold">Bloco {step.number}</div>
                                            <div className="text-xs">{step.title}</div>
                                        </div>
                                        <div className="md:hidden text-xs font-bold">{step.number}</div>
                                    </button>
                                    {index < steps.length - 1 && (
                                        <ChevronRight size={16} className="text-slate-300 shrink-0" />
                                    )}
                                </React.Fragment>
                            );
                        })}
                    </div>
                </div>

                {/* Form Card */}
                <div className="bg-white rounded-2xl shadow-lg border border-slate-200 p-8">

                    {/* Step Content */}
                    <div className="space-y-6">

                        {/* Block 1: Identificação */}
                        {currentStep === 0 && (
                            <Block1Form block1={block1} setBlock1={setBlock1} />
                        )}

                        {/* Block 2: Diagnóstico */}
                        {currentStep === 1 && (
                            <Block2Form block2={block2} setBlock2={setBlock2} />
                        )}

                        {/* Block 3: Objetivos */}
                        {currentStep === 2 && (
                            <Block3Form block3={block3} setBlock3={setBlock3} />
                        )}

                        {/* Block 4: Recursos */}
                        {currentStep === 3 && (
                            <Block4Form block4={block4} setBlock4={setBlock4} />
                        )}

                        {/* Block 5: Equipe */}
                        {currentStep === 4 && (
                            <Block5Form block5={block5} setBlock5={setBlock5} />
                        )}

                        {/* Block 6: Atendimento */}
                        {currentStep === 5 && (
                            <Block6Form block6={block6} setBlock6={setBlock6} />
                        )}

                        {/* Block 7: Família */}
                        {currentStep === 6 && (
                            <Block7Form block7={block7} setBlock7={setBlock7} />
                        )}

                        {/* Block 8: Observações */}
                        {currentStep === 7 && (
                            <Block8Form block8={block8} setBlock8={setBlock8} />
                        )}
                    </div>

                    {/* Error/Success Messages */}
                    {error && (
                        <div className="mt-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center gap-3 text-red-700">
                            <AlertCircle size={20} />
                            <span>{error}</span>
                        </div>
                    )}

                    {success && (
                        <div className="mt-6 p-4 bg-green-50 border border-green-200 rounded-xl flex items-center gap-3 text-green-700">
                            <CheckCircle size={20} />
                            <span>PDI salvo com sucesso! Redirecionando...</span>
                        </div>
                    )}

                    {/* Navigation Buttons */}
                    <div className="mt-8 flex items-center justify-between gap-4">
                        <button
                            onClick={handlePrevious}
                            disabled={currentStep === 0}
                            className="flex items-center gap-2 px-6 py-3 bg-white border-2 border-slate-200 text-slate-700 font-bold rounded-xl hover:border-blue-600 hover:text-blue-600 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
                        >
                            <ChevronLeft size={20} />
                            Anterior
                        </button>

                        <div className="flex items-center gap-4">
                            {currentStep === steps.length - 1 ? (
                                <button
                                    onClick={handleSave}
                                    disabled={saving}
                                    className="flex items-center gap-2 px-8 py-3 bg-green-600 hover:bg-green-700 text-white font-bold rounded-xl shadow-lg disabled:opacity-50 transition-all"
                                >
                                    {saving ? (
                                        <>
                                            <div className="animate-spin rounded-full h-5 w-5 border-2 border-white border-t-transparent"></div>
                                            Salvando...
                                        </>
                                    ) : (
                                        <>
                                            <Save size={20} />
                                            Salvar PDI
                                        </>
                                    )}
                                </button>
                            ) : (
                                <button
                                    onClick={handleNext}
                                    className="flex items-center gap-2 px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-lg transition-all"
                                >
                                    Próximo
                                    <ChevronRight size={20} />
                                </button>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default PDIFormBlocks1to8;
