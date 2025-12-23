
import { 
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType, 
  Table, TableCell, TableRow, WidthType, BorderStyle 
} from "docx";
import saveAs from "file-saver";

/**
 * Transforma texto com markdown ** em um array de TextRuns para o docx.
 * Suporta detecção de negritos no meio de frases.
 */
const parseInlineFormatting = (text: string, options: { isHeading?: boolean; size?: number } = {}) => {
  const { isHeading = false, size = 22 } = options;
  
  // Limpa o texto de marcações de metadados se houver
  const cleanText = text.replace(/\[.*?\]/g, '').trim();

  if (isHeading) {
    return [new TextRun({
      text: cleanText.replace(/\*\*|__/g, ""),
      size: size,
      font: "Arial",
      bold: true
    })];
  }

  const parts = cleanText.split(/(\*\*.*?\*\*)/g);
  
  return parts.map(part => {
    if (part.startsWith('**') && part.endsWith('**')) {
      return new TextRun({
        text: part.slice(2, -2),
        bold: true,
        size: size,
        font: "Arial"
      });
    }
    return new TextRun({
      text: part,
      size: size,
      font: "Arial"
    });
  });
};

/**
 * Exporta o conteúdo pedagógico para um arquivo Word (.docx) com suporte a tabelas e negritos.
 */
export const exportToDocx = async (content: string, title: string) => {
  const lines = content.split('\n');
  const docElements: any[] = [];

  // Título do documento
  docElements.push(
    new Paragraph({
      text: "PROFEPLAN - PLANEJAMENTO PEDAGÓGICO",
      heading: HeadingLevel.TITLE,
      alignment: AlignmentType.CENTER,
      spacing: { after: 400 }
    })
  );

  let i = 0;
  while (i < lines.length) {
    const line = lines[i].trim();

    if (!line) {
      i++;
      continue;
    }

    // --- LÓGICA DE DETECÇÃO DE TABELA ---
    if (line.startsWith('|')) {
      const tableRows: TableRow[] = [];
      let isFirstRow = true;

      while (i < lines.length && lines[i].trim().startsWith('|')) {
        const rawLine = lines[i].trim();
        
        // Ignora a linha de separação do markdown (ex: | :--- | :--- |)
        if (rawLine.includes('---')) {
          i++;
          continue;
        }

        // Extrai as células (ignora o primeiro e último pipe se houver)
        const cells = rawLine
          .split('|')
          .filter((_, index, array) => index > 0 && index < array.length - 1)
          .map(cell => cell.trim());

        if (cells.length > 0) {
          tableRows.push(
            new TableRow({
              children: cells.map(cellText => 
                new TableCell({
                  children: [new Paragraph({ 
                    children: parseInlineFormatting(cellText, { size: 20 }) 
                  })],
                  padding: { top: 120, bottom: 120, left: 120, right: 120 },
                  background: isFirstRow ? { fill: "F1F5F9", color: "F1F5F9" } : undefined,
                  borders: {
                    top: { style: BorderStyle.SINGLE, size: 1, color: "E2E8F0" },
                    bottom: { style: BorderStyle.SINGLE, size: 1, color: "E2E8F0" },
                    left: { style: BorderStyle.SINGLE, size: 1, color: "E2E8F0" },
                    right: { style: BorderStyle.SINGLE, size: 1, color: "E2E8F0" },
                  }
                })
              ),
            })
          );
          isFirstRow = false;
        }
        i++;
      }

      if (tableRows.length > 0) {
        docElements.push(
          new Table({
            width: { size: 100, type: WidthType.PERCENTAGE },
            rows: tableRows,
            margins: { bottom: 300 },
          })
        );
      }
      continue;
    }

    // --- LÓGICA DE CABEÇALHOS ---
    if (line.startsWith('# ')) {
      docElements.push(new Paragraph({
        children: parseInlineFormatting(line.replace('# ', ''), { isHeading: true, size: 28 }),
        heading: HeadingLevel.HEADING_1,
        spacing: { before: 400, after: 200 }
      }));
    } else if (line.startsWith('## ')) {
      docElements.push(new Paragraph({
        children: parseInlineFormatting(line.replace('## ', ''), { isHeading: true, size: 26 }),
        heading: HeadingLevel.HEADING_2,
        spacing: { before: 300, after: 150 }
      }));
    } else if (line.startsWith('### ')) {
      docElements.push(new Paragraph({
        children: parseInlineFormatting(line.replace('### ', ''), { isHeading: true, size: 24 }),
        heading: HeadingLevel.HEADING_3,
        spacing: { before: 200, after: 100 }
      }));
    } else {
      // --- PARÁGRAFO COMUM COM SUPORTE A NEGRITO ---
      docElements.push(new Paragraph({
        children: parseInlineFormatting(line),
        spacing: { after: 120 },
        alignment: AlignmentType.JUSTIFIED
      }));
    }
    i++;
  }

  // Rodapé com data
  docElements.push(
    new Paragraph({
      children: [
        new TextRun({
          text: `Gerado automaticamente pelo sistema PROFEPLAN v3.0 em ${new Date().toLocaleDateString('pt-BR')}`,
          italics: true,
          size: 16,
          color: "666666"
        })
      ],
      alignment: AlignmentType.RIGHT,
      spacing: { before: 600 }
    })
  );

  const doc = new Document({
    sections: [{
      properties: {},
      children: docElements,
    }],
  });

  const blob = await Packer.toBlob(doc);
  saveAs(blob, `${title.replace(/\s+/g, '_')}.docx`);
};
