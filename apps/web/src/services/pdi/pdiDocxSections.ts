import { PdiDocument } from '../../types';

/**
 * HELPER FUNCTIONS FOR DOCX EXPORT
 * Consolidated from PdiExportService
 */

type DocxModule = {
  Document: new (...args: unknown[]) => unknown;
  Packer: { toBlob: (doc: unknown) => Promise<Blob> };
  Paragraph: new (options: Record<string, unknown>) => unknown;
  TextRun: new (options: Record<string, unknown>) => unknown;
  HeadingLevel: Record<string, unknown>;
  AlignmentType: Record<string, unknown>;
};

function createBlock1Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
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
        new TextRun({ text: data.nome_completo || '' }),
      ],
      spacing: { after: 100 },
    }),
    new Paragraph({
      children: [
        new TextRun({ text: 'Data de Nascimento: ', bold: true }),
        new TextRun({ text: data.data_nascimento || '' }),
      ],
      spacing: { after: 100 },
    }),
    new Paragraph({
      children: [
        new TextRun({ text: 'Código INEP: ', bold: true }),
        new TextRun({ text: data.codigo_inep || 'Não informado' }),
      ],
      spacing: { after: 100 },
    }),
    new Paragraph({
      children: [
        new TextRun({ text: 'Série: ', bold: true }),
        new TextRun({ text: data.serie || '' }),
      ],
      spacing: { after: 100 },
    }),
    new Paragraph({
      children: [
        new TextRun({ text: 'Turma: ', bold: true }),
        new TextRun({ text: data.turma || '' }),
      ],
      spacing: { after: 100 },
    }),
    new Paragraph({
      children: [
        new TextRun({ text: 'Diagnóstico Clínico: ', bold: true }),
        new TextRun({ text: data.diagnostico_clinico || '' }),
      ],
      spacing: { after: 100 },
    }),
    new Paragraph({ text: '', spacing: { after: 200 } }),
  ];
}

function createBlock2Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
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
    ...(data.necessidades_especificas?.map(
      (n: string) => new Paragraph({ text: `• ${n}`, spacing: { after: 50 } })
    ) || []),
    new Paragraph({
      text: 'Potencialidades:',
      bold: true,
      spacing: { before: 200, after: 100 },
    }),
    ...(data.potencialidades?.map(
      (p: string) => new Paragraph({ text: `• ${p}`, spacing: { after: 50 } })
    ) || []),
    new Paragraph({ text: '', spacing: { after: 200 } }),
  ];
}

function createBlock3Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
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
        new TextRun({ text: data.objetivo_geral || '' }),
      ],
      spacing: { after: 200 },
    }),
    new Paragraph({ text: '', spacing: { after: 200 } }),
  ];
}

function createBlock4Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
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
    ...(data.recursos_tecnologicos?.map(
      (r: string) => new Paragraph({ text: `• ${r}`, spacing: { after: 50 } })
    ) || []),
    new Paragraph({ text: '', spacing: { after: 200 } }),
  ];
}

function createBlock5Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
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
    ...(data.professores?.map(
      (p: string) => new Paragraph({ text: `• ${p}`, spacing: { after: 50 } })
    ) || []),
    new Paragraph({ text: '', spacing: { after: 200 } }),
  ];
}

function createBlock6Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
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
        new TextRun({ text: data.frequencia_atendimento || '' }),
      ],
      spacing: { after: 100 },
    }),
    new Paragraph({ text: '', spacing: { after: 200 } }),
  ];
}

function createBlock7Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
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
        new TextRun({ text: data.responsavel_principal || '' }),
      ],
      spacing: { after: 100 },
    }),
    new Paragraph({ text: '', spacing: { after: 200 } }),
  ];
}

function createBlock8Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
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

function createBlock9Summary(pdi: PdiDocument, docx: DocxModule): unknown[] {
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

function createBlock10Summary(pdi: PdiDocument, docx: DocxModule): unknown[] {
  const { Paragraph, HeadingLevel } = docx;
  const avaliacoes = pdi.block_10_entries || [];
  const mediaGeral =
    avaliacoes.length > 0
      ? (
          avaliacoes.reduce((sum: number, av) => {
            const entry = av as { professor_nota_alcancada?: number; professor_valor?: number };
            return (
              sum +
              ((entry.professor_nota_alcancada as number) / (entry.professor_valor as number)) * 100
            );
          }, 0) / avaliacoes.length
        ).toFixed(1)
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

function createBlock11Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
  const { Paragraph, HeadingLevel } = docx;
  const reportText = pdi.final_report || '';

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

function createSignatureSection(docx: DocxModule): unknown[] {
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

export type { DocxModule };
export {
  createBlock1Section,
  createBlock2Section,
  createBlock3Section,
  createBlock4Section,
  createBlock5Section,
  createBlock6Section,
  createBlock7Section,
  createBlock8Section,
  createBlock9Summary,
  createBlock10Summary,
  createBlock11Section,
  createSignatureSection,
};
