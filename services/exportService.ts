
import {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
  Table, TableCell, TableRow, WidthType, BorderStyle, Header, Footer, ImageRun
} from "docx";
import saveAs from "file-saver";
import { UserSettings } from "../types";

const parseInlineFormatting = (text: string, options: { isHeading?: boolean; size?: number } = {}) => {
  const { isHeading = false, size = 22 } = options;
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
 * Helper para converter base64 em Buffer de imagem para o DOCX
 */
const base64ToUint8Array = (base64: string) => {
  const binaryString = window.atob(base64.split(',')[1]);
  const len = binaryString.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
};

export const exportToDocx = async (content: string, title: string, settings: UserSettings) => {
  const lines = content.split('\n');
  const docElements: any[] = [];

  // Cabeçalho Oficial do Documento
  const headerChildren: any[] = [];

  if (settings.logoBase64) {
    headerChildren.push(
      new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [
          new ImageRun({
            data: base64ToUint8Array(settings.logoBase64),
            transformation: { width: 80, height: 80 },
          }),
        ],
      })
    );
  }

  if (settings.headerText) {
    settings.headerText.split('\n').forEach(headerLine => {
      headerChildren.push(
        new Paragraph({
          alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: headerLine, bold: true, size: 20, font: "Arial" })],
        })
      );
    });
  }

  // Título do documento no corpo
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
    if (!line) { i++; continue; }

    if (line.startsWith('|')) {
      const tableRows: TableRow[] = [];
      let isFirstRow = true;
      while (i < lines.length && lines[i].trim().startsWith('|')) {
        const rawLine = lines[i].trim();
        if (rawLine.includes('---')) { i++; continue; }
        const cells = rawLine.split('|').filter((_, idx, arr) => idx > 0 && idx < arr.length - 1).map(cell => cell.trim());
        if (cells.length > 0) {
          tableRows.push(new TableRow({
            children: cells.map(cellText => new TableCell({
              children: [new Paragraph({ children: parseInlineFormatting(cellText, { size: 20 }) })],
              padding: { top: 120, bottom: 120, left: 120, right: 120 },
              background: isFirstRow ? { fill: "F1F5F9", color: "F1F5F9" } : undefined,
              borders: {
                top: { style: BorderStyle.SINGLE, size: 1, color: "E2E8F0" },
                bottom: { style: BorderStyle.SINGLE, size: 1, color: "E2E8F0" },
                left: { style: BorderStyle.SINGLE, size: 1, color: "E2E8F0" },
                right: { style: BorderStyle.SINGLE, size: 1, color: "E2E8F0" },
              }
            }))
          }));
          isFirstRow = false;
        }
        i++;
      }
      if (tableRows.length > 0) {
        docElements.push(new Table({ width: { size: 100, type: WidthType.PERCENTAGE }, rows: tableRows, margins: { bottom: 300 } }));
      }
      continue;
    }

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
      docElements.push(new Paragraph({
        children: parseInlineFormatting(line),
        spacing: { after: 120 },
        alignment: AlignmentType.JUSTIFIED
      }));
    }
    i++;
  }

  // Rodapé Oficial
  const footerChildren = [
    new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [
        new TextRun({
          text: settings.footerText || `Documento gerado automaticamente pelo PROFEPLAN v3.0 em ${new Date().toLocaleDateString('pt-BR')}`,
          size: 16,
          color: "666666",
          font: "Arial"
        })
      ],
      spacing: { before: 200 }
    })
  ];

  const doc = new Document({
    sections: [{
      headers: {
        default: new Header({
          children: headerChildren,
        }),
      },
      footers: {
        default: new Footer({
          children: footerChildren,
        }),
      },
      children: docElements,
    }],
  });

  const blob = await Packer.toBlob(doc);
  saveAs(blob, `${title.replace(/\s+/g, '_')}.docx`);
};

import PptxGenJS from "pptxgenjs";

export const exportToPptx = async (content: string, title: string) => {
  const pres = new PptxGenJS();
  pres.layout = 'LAYOUT_16x9';

  // Capa
  const slide = pres.addSlide();
  slide.background = { color: 'FFFFFF' };
  slide.addText(title, { x: 1, y: 2, w: '80%', fontSize: 36, bold: true, color: '000000', align: 'center' });
  slide.addText('Gerado por PROFEPLAN', { x: 1, y: 4, w: '80%', fontSize: 18, color: '666666', align: 'center' });

  // Parsing simples para slides (Markdown headers)
  const slidesContent = content.split(/^## /gm).slice(1); // Ignora texto antes do primeiro ##

  slidesContent.forEach(slideText => {
    const lines = slideText.trim().split('\n');
    const slideTitle = lines[0].trim();
    const slideBody = lines.slice(1).join('\n').trim();

    const slide = pres.addSlide();
    slide.addText(slideTitle, { x: 0.5, y: 0.5, w: '90%', fontSize: 24, bold: true, color: '363636' });

    // Tentativa de limpar markdown
    const cleanBody = slideBody.replace(/\*\*/g, '').replace(/\*/g, '').replace(/\[.*?\]/g, '');

    slide.addText(cleanBody, {
      x: 0.5, y: 1.5, w: '90%', h: '70%',
      fontSize: 18, color: '363636',
      bullet: true,
      valign: 'top'
    });
  });

  await pres.writeFile({ fileName: `${title}.pptx` });
};
