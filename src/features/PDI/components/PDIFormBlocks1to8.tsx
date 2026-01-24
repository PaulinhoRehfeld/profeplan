import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import {
    User, FileText, Target, Package, Users as UsersIcon,
    Calendar, Home, MessageSquare, ChevronRight, ChevronLeft,
    Save, CheckCircle, AlertCircle
} from 'lucide-react';
import { PdiDocumentService } from '../../../services/PdiDocumentService';
import { ProfileService } from '../../../services/ProfileService';
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

// ============================================================================
// FORM COMPONENTS FOR EACH BLOCK
// ============================================================================

const Block1Form: React.FC<{ block1: Block1Identificacao; setBlock1: (b: Block1Identificacao) => void }> = ({
    block1,
    setBlock1,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 1: Identificação do Aluno</h2>

        <div className="grid md:grid-cols-2 gap-6">
            <div className="md:col-span-2">
                <label className="block text-sm font-bold text-slate-700 mb-2">
                    Nome Completo <span className="text-red-600">*</span>
                </label>
                <input
                    type="text"
                    value={block1.nome_completo || ''}
                    onChange={(e) => setBlock1({ ...block1, nome_completo: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Nome completo do estudante"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">
                    Data de Nascimento <span className="text-red-600">*</span>
                </label>
                <input
                    type="date"
                    value={block1.data_nascimento || ''}
                    onChange={(e) => setBlock1({ ...block1, data_nascimento: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Código INEP</label>
                <input
                    type="text"
                    value={block1.codigo_inep || ''}
                    onChange={(e) => setBlock1({ ...block1, codigo_inep: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Código INEP do aluno"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Série</label>
                <input
                    type="text"
                    value={block1.serie || ''}
                    onChange={(e) => setBlock1({ ...block1, serie: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Ex: 5º Ano EF"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Turma</label>
                <input
                    type="text"
                    value={block1.turma || ''}
                    onChange={(e) => setBlock1({ ...block1, turma: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Ex: Turma A"
                />
            </div>

            <div className="md:col-span-2">
                <label className="block text-sm font-bold text-slate-700 mb-2">Diagnóstico Clínico</label>
                <textarea
                    value={block1.diagnostico_clinico || ''}
                    onChange={(e) => setBlock1({ ...block1, diagnostico_clinico: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Descreva o diagnóstico clínico do aluno (ex: TEA Nível 1, TDAH, etc.)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Laudo Médico</label>
                <input
                    type="text"
                    value={block1.laudo_medico || ''}
                    onChange={(e) => setBlock1({ ...block1, laudo_medico: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Número/referência do laudo"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Data do Laudo</label>
                <input
                    type="date"
                    value={block1.data_laudo || ''}
                    onChange={(e) => setBlock1({ ...block1, data_laudo: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
            </div>
        </div>
    </>
);

const Block2Form: React.FC<{ block2: Block2Diagnostico; setBlock2: (b: Block2Diagnostico) => void }> = ({
    block2,
    setBlock2,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 2: Diagnóstico Pedagógico</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Necessidades Específicas</label>
                <textarea
                    value={block2.necessidades_especificas?.join('\n') || ''}
                    onChange={(e) => setBlock2({ ...block2, necessidades_especificas: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste as necessidades específicas do aluno (uma por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Potencialidades</label>
                <textarea
                    value={block2.potencialidades?.join('\n') || ''}
                    onChange={(e) => setBlock2({ ...block2, potencialidades: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste as potencialidades do aluno (uma por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Desafios</label>
                <textarea
                    value={block2.desafios?.join('\n') || ''}
                    onChange={(e) => setBlock2({ ...block2, desafios: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste os principais desafios (uma por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Medicamentos em Uso</label>
                <textarea
                    value={block2.medicamentos_uso || ''}
                    onChange={(e) => setBlock2({ ...block2, medicamentos_uso: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Descreva medicamentos em uso e posologia"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Restrições de Atividades</label>
                <textarea
                    value={block2.restricoes_atividades || ''}
                    onChange={(e) => setBlock2({ ...block2, restricoes_atividades: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Há alguma restrição para atividades físicas ou outras?"
                />
            </div>
        </div>
    </>
);

const Block3Form: React.FC<{ block3: Block3Objetivos; setBlock3: (b: Block3Objetivos) => void }> = ({
    block3,
    setBlock3,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 3: Objetivos do PDI</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">
                    Objetivo Geral <span className="text-red-600">*</span>
                </label>
                <textarea
                    value={block3.objetivo_geral || ''}
                    onChange={(e) => setBlock3({ ...block3, objetivo_geral: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Descreva o objetivo geral do PDI para este estudante"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Objetivos Específicos</label>
                <textarea
                    value={block3.objetivos_especificos?.join('\n') || ''}
                    onChange={(e) => setBlock3({ ...block3, objetivos_especificos: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste os objetivos específicos (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Metas de Curto Prazo</label>
                <textarea
                    value={block3.metas_curto_prazo?.join('\n') || ''}
                    onChange={(e) => setBlock3({ ...block3, metas_curto_prazo: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Metas para o bimestre/trimestre atual (uma por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Metas de Longo Prazo</label>
                <textarea
                    value={block3.metas_longo_prazo?.join('\n') || ''}
                    onChange={(e) => setBlock3({ ...block3, metas_longo_prazo: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Metas para o ano letivo/próximos períodos (uma por linha)"
                />
            </div>
        </div>
    </>
);

const Block4Form: React.FC<{ block4: Block4Recursos; setBlock4: (b: Block4Recursos) => void }> = ({
    block4,
    setBlock4,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 4: Recursos e Materiais</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Recursos Tecnológicos</label>
                <textarea
                    value={block4.recursos_tecnologicos?.join('\n') || ''}
                    onChange={(e) => setBlock4({ ...block4, recursos_tecnologicos: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Ex: Tablet, Software de comunicação alternativa, etc. (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Materiais Adaptados</label>
                <textarea
                    value={block4.materiais_adaptados?.join('\n') || ''}
                    onChange={(e) => setBlock4({ ...block4, materiais_adaptados: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Ex: Livros em braille, Materiais em relevo, etc. (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Mobiliário Específico</label>
                <textarea
                    value={block4.mobiliario_especifico || ''}
                    onChange={(e) => setBlock4({ ...block4, mobiliario_especifico: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Descreva mobiliário especial necessário"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Equipamentos</label>
                <textarea
                    value={block4.equipamentos?.join('\n') || ''}
                    onChange={(e) => setBlock4({ ...block4, equipamentos: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste equipamentos necessários (um por linha)"
                />
            </div>
        </div>
    </>
);

const Block5Form: React.FC<{ block5: Block5Equipe; setBlock5: (b: Block5Equipe) => void }> = ({
    block5,
    setBlock5,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 5: Equipe Multidisciplinar</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Professores Envolvidos</label>
                <textarea
                    value={block5.professores?.join('\n') || ''}
                    onChange={(e) => setBlock5({ ...block5, professores: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Liste os professores envolvidos (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Apoio Escolar</label>
                <textarea
                    value={block5.apoio_escolar || ''}
                    onChange={(e) => setBlock5({ ...block5, apoio_escolar: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Descreva o sistema de apoio escolar (monitor, estagiário, etc.)"
                />
            </div>

            <p className="text-sm text-slate-600 italic">
                Nota: Para adicionar detalhes da equipe multidisciplinar (psicólogos, fonoaudiólogos, etc.),
                você poderá editá-los posteriormente na visualização completa do PDI.
            </p>
        </div>
    </>
);

const Block6Form: React.FC<{ block6: Block6Atendimento; setBlock6: (b: Block6Atendimento) => void }> = ({
    block6,
    setBlock6,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 6: Plano de Atendimento</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Frequência de Atendimento</label>
                <input
                    type="text"
                    value={block6.frequencia_atendimento || ''}
                    onChange={(e) => setBlock6({ ...block6, frequencia_atendimento: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Ex: 2x por semana, Diariamente, etc."
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Horários</label>
                <input
                    type="text"
                    value={block6.horarios || ''}
                    onChange={(e) => setBlock6({ ...block6, horarios: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Ex: Terças e Quintas, 14h-15h"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Local</label>
                <input
                    type="text"
                    value={block6.local || ''}
                    onChange={(e) => setBlock6({ ...block6, local: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Local onde ocorrerá o atendimento"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Responsáveis</label>
                <textarea
                    value={block6.responsaveis?.join('\n') || ''}
                    onChange={(e) => setBlock6({ ...block6, responsaveis: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Profissionais responsáveis pelo atendimento (um por linha)"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Tipo de Atendimento</label>
                <textarea
                    value={block6.tipo_atendimento?.join('\n') || ''}
                    onChange={(e) => setBlock6({ ...block6, tipo_atendimento: e.target.value.split('\n').filter(Boolean) })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Ex: AEE, Apoio pedagógico, Fonoaudiologia, etc. (um por linha)"
                />
            </div>
        </div>
    </>
);

const Block7Form: React.FC<{ block7: Block7Familia; setBlock7: (b: Block7Familia) => void }> = ({
    block7,
    setBlock7,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 7: Participação da Família</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Responsável Principal</label>
                <input
                    type="text"
                    value={block7.responsavel_principal || ''}
                    onChange={(e) => setBlock7({ ...block7, responsavel_principal: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Nome do responsável principal"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Contato do Responsável</label>
                <input
                    type="text"
                    value={block7.contato_responsavel || ''}
                    onChange={(e) => setBlock7({ ...block7, contato_responsavel: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Telefone e/ou email"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Participação da Família</label>
                <textarea
                    value={block7.participacao_familia || ''}
                    onChange={(e) => setBlock7({ ...block7, participacao_familia: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Descreva como a família participa do processo educacional do aluno"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Orientações para a Família</label>
                <textarea
                    value={block7.orientacoes_familia || ''}
                    onChange={(e) => setBlock7({ ...block7, orientacoes_familia: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Orientações específicas que devem ser passadas à família"
                />
            </div>
        </div>
    </>
);

const Block8Form: React.FC<{ block8: Block8Observacoes; setBlock8: (b: Block8Observacoes) => void }> = ({
    block8,
    setBlock8,
}) => (
    <>
        <h2 className="text-2xl font-black text-slate-900 mb-6">Bloco 8: Observações Gerais</h2>

        <div className="space-y-6">
            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Observações Gerais</label>
                <textarea
                    value={block8.observacoes_gerais || ''}
                    onChange={(e) => setBlock8({ ...block8, observacoes_gerais: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Informações adicionais relevantes sobre o aluno"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Histórico Escolar</label>
                <textarea
                    value={block8.historico_escolar || ''}
                    onChange={(e) => setBlock8({ ...block8, historico_escolar: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Resumo do histórico escolar relevante"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Transferências</label>
                <textarea
                    value={block8.transferencias || ''}
                    onChange={(e) => setBlock8({ ...block8, transferencias: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-24 resize-none"
                    placeholder="Informações sobre transferências anteriores"
                />
            </div>

            <div>
                <label className="block text-sm font-bold text-slate-700 mb-2">Outras Informações</label>
                <textarea
                    value={block8.outras_informacoes || ''}
                    onChange={(e) => setBlock8({ ...block8, outras_informacoes: e.target.value })}
                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 h-32 resize-none"
                    placeholder="Qualquer outra informação relevante"
                />
            </div>

            <div className="p-4 bg-blue-50 border border-blue-200 rounded-xl">
                <p className="text-sm text-blue-900">
                    <strong>✓ Parabéns!</strong> Você está prestes a concluir o formulário base do PDI.
                    Clique em "Salvar PDI" para finalizar. Os próximos blocos (9, 10 e 11) serão preenchidos
                    automaticamente conforme o trabalho pedagógico for realizado.
                </p>
            </div>
        </div>
    </>
);

export default PDIFormBlocks1to8;
