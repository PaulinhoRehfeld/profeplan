/**
 * PDI Export Service
 * Handles export of PDI to official DOCX format
 * 
 * REQUIREMENTS:
 * Install the docx library:
 * npm install docx file-saver
 * npm install --save-dev @types/file-saver
 */


import type { Document, Paragraph, TextRun, HeadingLevel, AlignmentType, BorderStyle } from 'docx';
import { PdiDocument } from '../types/pdi';

/**
 * Export PDI to official DOCX format
 * Following SEE-MG official template structure
 */
export const exportPdiToDocx = async (pdi: PdiDocument): Promise<void> => {
    try {
        const docx = await import('docx');
        const fileSaver = await import('file-saver');
        const saveAs = fileSaver.saveAs;

        const { Document, Paragraph, HeadingLevel, AlignmentType, Packer } = docx;

        const studentName = pdi.block_1_8?.bloco_1_identificacao?.nome_completo || 'Estudante';

        // Create document
        const doc = new Document({
            sections: [
                {
                    properties: {},
                    children: [
                        // Cover Page
                        new Paragraph({
                            text: 'PLANO DE DESENVOLVIMENTO INDIVIDUAL - PDI',
                            heading: HeadingLevel.TITLE,
                            alignment: AlignmentType.CENTER,
                            spacing: { after: 400 },
                        }),
                        new Paragraph({
                            text: studentName,
                            heading: HeadingLevel.HEADING_1,
                            alignment: AlignmentType.CENTER,
                            spacing: { after: 200 },
                        }),
                        new Paragraph({
                            text: `Período: ${pdi.period}`,
                            alignment: AlignmentType.CENTER,
                            spacing: { after: 200 },
                        }),
                        new Paragraph({
                            text: `Data de Emissão: ${new Date().toLocaleDateString('pt-BR')}`,
                            alignment: AlignmentType.CENTER,
                            spacing: { after: 800 },
                        }),

                        // Block 1: Identification
                        ...createBlock1Section(pdi, docx),

                        // Block 2: Diagnosis
                        ...createBlock2Section(pdi, docx),

                        // Block 3: Objectives
                        ...createBlock3Section(pdi, docx),

                        // Block 4: Resources
                        ...createBlock4Section(pdi, docx),

                        // Block 5: Team
                        ...createBlock5Section(pdi, docx),

                        // Block 6: Service Plan
                        ...createBlock6Section(pdi, docx),

                        // Block 7: Family
                        ...createBlock7Section(pdi, docx),

                        // Block 8: Observations
                        ...createBlock8Section(pdi, docx),

                        // Block 9: Adaptations Summary
                        ...createBlock9Summary(pdi, docx),

                        // Block 10: Evaluations Summary
                        ...createBlock10Summary(pdi, docx),

                        // Block 11: Final Report
                        ...createBlock11Section(pdi, docx),

                        // Signatures
                        ...createSignatureSection(docx),
                    ],
                },
            ],
        });

        // Generate and download
        const blob = await Packer.toBlob(doc);
        saveAs(blob, `PDI_${studentName.replace(/ /g, '_')}_${pdi.period.replace(/ /g, '_')}.docx`);

    } catch (error) {
        console.error('Error exporting PDI to DOCX:', error);
        throw new Error('Erro ao exportar PDI para DOCX. Verifique se a biblioteca "docx" está instalada.');
    }
};

// ============================================================================
// HELPER FUNCTIONS TO CREATE SECTIONS
// ============================================================================

function createBlock1Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, TextRun, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_1_identificacao;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 1: IDENTIFICAÇÃO DO ESTUDANTE',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Nome Completo: ', bold: true }),
                new TextRun(data.nome_completo || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Data de Nascimento: ', bold: true }),
                new TextRun(data.data_nascimento || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Código INEP: ', bold: true }),
                new TextRun(data.codigo_inep || 'Não informado'),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Série: ', bold: true }),
                new TextRun(data.serie || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Turma: ', bold: true }),
                new TextRun(data.turma || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Diagnóstico Clínico: ', bold: true }),
                new TextRun(data.diagnostico_clinico || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock2Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_2_diagnostico;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 2: DIAGNÓSTICO PEDAGÓGICO',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: 'Necessidades Específicas:',
            bold: true,
            spacing: { after: 100 },
        }),
        ...(data.necessidades_especificas?.map((n: string) =>
            new Paragraph({ text: `• ${n}`, spacing: { after: 50 } })
        ) || []),
        new Paragraph({
            text: 'Potencialidades:',
            bold: true,
            spacing: { before: 200, after: 100 },
        }),
        ...(data.potencialidades?.map((p: string) =>
            new Paragraph({ text: `• ${p}`, spacing: { after: 50 } })
        ) || []),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock3Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, TextRun, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_3_objetivos;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 3: OBJETIVOS DO PDI',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Objetivo Geral: ', bold: true }),
                new TextRun(data.objetivo_geral || ''),
            ],
            spacing: { after: 200 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock4Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_4_recursos;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 4: RECURSOS E MATERIAIS',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: 'Recursos Tecnológicos:',
            bold: true,
            spacing: { after: 100 },
        }),
        ...(data.recursos_tecnologicos?.map((r: string) =>
            new Paragraph({ text: `• ${r}`, spacing: { after: 50 } })
        ) || []),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock5Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_5_equipe;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 5: EQUIPE MULTIDISCIPLINAR',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: 'Professores Envolvidos:',
            bold: true,
            spacing: { after: 100 },
        }),
        ...(data.professores?.map((p: string) =>
            new Paragraph({ text: `• ${p}`, spacing: { after: 50 } })
        ) || []),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock6Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, TextRun, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_6_atendimento;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 6: PLANO DE ATENDIMENTO',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Frequência: ', bold: true }),
                new TextRun(data.frequencia_atendimento || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock7Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, TextRun, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_7_familia;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 7: PARTICIPAÇÃO DA FAMÍLIA',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Responsável: ', bold: true }),
                new TextRun(data.responsavel_principal || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock8Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_8_observacoes;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 8: OBSERVAÇÕES GERAIS',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: data.observacoes_gerais || '',
            spacing: { after: 200 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock9Summary(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, HeadingLevel } = docx;
    const total = pdi.block_9_content?.length || 0;

    return [
        new Paragraph({
            text: 'BLOCO 9: RESUMO DE ADAPTAÇÕES CURRICULARES',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: `Total de adaptações realizadas: ${total}`,
            bold: true,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: '(Detalhamento completo disponível no sistema digital)',
            italics: true,
            spacing: { after: 200 },
        }),
    ];
}

function createBlock10Summary(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, HeadingLevel } = docx;
    const avaliacoes = pdi.block_10_entries || [];
    const mediaGeral = avaliacoes.length > 0
        ? (avaliacoes.reduce((sum: number, av: any) =>
            sum + ((av.professor_nota_alcancada / av.professor_valor) * 100), 0
        ) / avaliacoes.length).toFixed(1)
        : 'N/A';

    return [
        new Paragraph({
            text: 'BLOCO 10: RESUMO DE AVALIAÇÕES',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: `Total de avaliações: ${avaliacoes.length}`,
            bold: true,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: `Média geral de aproveitamento: ${mediaGeral}%`,
            bold: true,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: '(Detalhamento completo disponível no sistema digital)',
            italics: true,
            spacing: { after: 200 },
        }),
    ];
}

function createBlock11Section(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, HeadingLevel } = docx;
    const reportText = pdi.block_11_supervisor_edit || pdi.block_11_ai_generated || '';

    return [
        new Paragraph({
            text: 'BLOCO 11: RELATÓRIO FINAL',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: reportText,
            spacing: { after: 400 },
        }),
    ];
}

function createSignatureSection(docx: any): any[] {
    const { Paragraph, HeadingLevel, AlignmentType } = docx;
    return [
        new Paragraph({ text: '', spacing: { before: 800, after: 200 } }),
        new Paragraph({
            text: 'ASSINATURAS',
            heading: HeadingLevel.HEADING_2,
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
        }),
        new Paragraph({
            text: '_'.repeat(60),
            alignment: AlignmentType.CENTER,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: 'Coordenador Pedagógico / Gestor Escolar',
            alignment: AlignmentType.CENTER,
            spacing: { after: 50 },
        }),
        new Paragraph({
            text: `Data: ______/______/______`,
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
        }),
        new Paragraph({
            text: '_'.repeat(60),
            alignment: AlignmentType.CENTER,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: 'Professor Responsável',
            alignment: AlignmentType.CENTER,
            spacing: { after: 50 },
        }),
        new Paragraph({
            text: `Data: ______/______/______`,
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
        }),
        new Paragraph({
            text: '_'.repeat(60),
            alignment: AlignmentType.CENTER,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: 'Responsável Legal do Estudante',
            alignment: AlignmentType.CENTER,
            spacing: { after: 50 },
        }),
        new Paragraph({
            text: `Data: ______/______/______`,
            alignment: AlignmentType.CENTER,
        }),
    ];
}
