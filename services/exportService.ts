
import { Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType } from "docx";
import saveAs from "file-saver";

/**
 * Exporta o conteúdo pedagógico para um arquivo Word formatado.
 * @param content O conteúdo em Markdown/Texto
 * @param title O título do documento
 */
export const exportToDocx = async (content: string, title: string) => {
  // Limpa o conteúdo de metadados internos do sistema
  const cleanContent = content
    .replace(/\[DADOS DO PROFESSOR:.*?\]/g, '')
    .replace(/\[PREFERÊNCIAS:.*?\]/g, '')
    .replace(/\[AULA ATUAL:.*?\]/g, '')
    .trim();

  // Divide o conteúdo em linhas para criar parágrafos separados
  const lines = cleanContent.split('\n');
  const docParagraphs = lines.map(line => {
    const trimmed = line.trim();
    
    if (!trimmed) return new Paragraph({ text: "" });

    // Tratamento básico de títulos Markdown para hierarquia do Word
    if (trimmed.startsWith('# ')) {
      return new Paragraph({
        text: trimmed.replace('# ', ''),
        heading: HeadingLevel.HEADING_1,
        spacing: { before: 400, after: 200 }
      });
    }
    if (trimmed.startsWith('## ')) {
      return new Paragraph({
        text: trimmed.replace('## ', ''),
        heading: HeadingLevel.HEADING_2,
        spacing: { before: 300, after: 150 }
      });
    }
    if (trimmed.startsWith('### ')) {
      return new Paragraph({
        text: trimmed.replace('### ', ''),
        heading: HeadingLevel.HEADING_3,
        spacing: { before: 200, after: 100 }
      });
    }

    // Parágrafos comuns
    return new Paragraph({
      children: [
        new TextRun({
          text: trimmed,
          size: 22, // 11pt
          font: "Arial"
        })
      ],
      spacing: { after: 120 },
      alignment: AlignmentType.JUSTIFIED
    });
  });

  const doc = new Document({
    sections: [{
      properties: {},
      children: [
        new Paragraph({
          text: title,
          heading: HeadingLevel.TITLE,
          alignment: AlignmentType.CENTER,
          spacing: { after: 400 }
        }),
        ...docParagraphs
      ],
    }],
  });

  const blob = await Packer.toBlob(doc);
  saveAs(blob, `${title.replace(/\s+/g, '_')}.docx`);
};
