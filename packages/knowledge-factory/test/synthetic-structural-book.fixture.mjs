const encoder = new TextEncoder();

export const GOLDEN_SAMPLE_FILENAME = 'HORIZONTES_PNLD26_SOCIOLOGIA_VU_MP.pdf';

function byteLength(value) {
  return encoder.encode(value).length;
}

function escapePdfString(value) {
  return value.replaceAll('\\', '\\\\').replaceAll('(', '\\(').replaceAll(')', '\\)');
}

function text(textValue, x, y, size = 13) {
  return { kind: 'text', text: textValue, x, y, size };
}

function image(x, y, width, height) {
  return { kind: 'image', x, y, width, height };
}

function streamForPage(blocks) {
  return blocks
    .map((block) => {
      if (block.kind === 'image') {
        return `q\n${block.width} 0 0 ${block.height} ${block.x} ${block.y} cm\n/Im1 Do\nQ`;
      }
      return (
        `BT\n/F1 ${block.size} Tf\n1 0 0 1 ${block.x} ${block.y} Tm\n` +
        `(${escapePdfString(block.text)}) Tj\nET`
      );
    })
    .join('\n');
}

export function buildStructuralGoldenSamplePdf() {
  const pages = [
    [
      text('COLECAO HORIZONTES', 72, 710, 22),
      text('SOCIOLOGIA', 72, 670, 18),
      text('MANUAL DO PROFESSOR', 72, 630, 16),
    ],
    [
      text('Horizontes - Sociologia', 72, 720, 20),
      text('Volume unico', 72, 680),
      text('Manual do Professor', 72, 650),
    ],
    [
      text('Ficha catalografica sintetica', 72, 720, 18),
      text('ISBN sintetico 000-0-00-000000-0', 72, 680),
      text('Primeira edicao', 72, 650),
    ],
    [
      text('Apresentacao', 72, 720, 18),
      text('Esta obra sintetica serve apenas para provar cartografia estrutural.', 72, 680),
    ],
    [
      text('Conheca seu livro', 72, 720, 18),
      text('Texto principal', 72, 680),
      text('Atividade guiada', 72, 650),
      text('Imagem comentada', 72, 620),
    ],
    [
      text('Mapa curricular', 72, 720, 18),
      text('Habilidade sintetica SYN-CHS-001', 72, 680),
    ],
    [
      text('Sumario', 72, 740, 20),
      text('Introducao ........ 10', 72, 700),
      text('Por que estudamos a vida coletiva? ........ 10', 92, 675),
      text('A convivencia e suas regras ........ 11', 92, 650),
      text('Atividade guiada ........ 12', 92, 625),
      text('Unidade 1 - Cultura e cotidiano ........ 13', 72, 590),
      text('Capitulo 1 - Olhares sobre a cultura ........ 14', 92, 565),
      text('Orientacoes ao Professor ........ 17', 72, 530),
    ],
    [text('Sumario - continuacao', 72, 740, 18), text('Referencias ........ 18', 72, 700)],
    [text('Antes de comecar', 72, 720, 18), text('Pagina de transicao sintetica.', 72, 680)],
    [text('Abertura geral', 72, 720, 18), text('Preparacao para o corpo principal.', 72, 680)],
    [
      text('Introducao', 72, 740, 20),
      text('Por que estudamos a vida coletiva?', 72, 700, 16),
      text(
        'A vida coletiva pode ser investigada por perguntas sobre regras, convivencia e mudanca.',
        72,
        660
      ),
    ],
    [
      text('A convivencia e suas regras', 72, 740, 18),
      text('Normas orientam comportamentos, mas podem variar entre grupos e contextos.', 72, 700),
      image(72, 520, 220, 120),
      text('Legenda: imagem sintetica de formas diferentes de convivencia.', 72, 490, 11),
    ],
    [
      text('Atividade guiada', 72, 740, 18),
      text(
        'Compare duas situacoes ficticias e identifique regras sociais presentes em cada uma.',
        72,
        700
      ),
    ],
    [text('Unidade 1 - Cultura e cotidiano', 72, 720, 22), text('Abertura da unidade.', 72, 680)],
    [
      text('Capitulo 1 - Olhares sobre a cultura', 72, 720, 20),
      text('Conceitos iniciais do capitulo sintetico.', 72, 680),
    ],
    [
      text('Texto do capitulo', 72, 720, 18),
      text('Conteudo sintetico destinado somente ao teste.', 72, 680),
    ],
    [
      text('Galeria de atividades', 72, 720, 18),
      text('Atividades sinteticas de encerramento.', 72, 680),
    ],
    [
      text('Orientacoes ao Professor', 72, 740, 20),
      text('Atividade guiada - orientacao', 72, 700, 16),
      text(
        'Espera-se que o estudante compare regras e justifique sua leitura com evidencias.',
        72,
        660
      ),
    ],
    [text('Referencias', 72, 720, 20), text('Referencia sintetica A. Referencia sintetica B.', 72, 680)],
  ];

  const objects = [];
  const pageObjectNumbers = pages.map((_, index) => 4 + index * 2);
  const imageObjectNumber = 4 + pages.length * 2;
  const imageHex = 'FF000000FF000000FFFFFFFF>';
  objects[1] =
    '<< /Type /Catalog /Pages 2 0 R ' +
    '/PageLabels << /Nums [0 << /P (Capa) >> 1 << /S /D /St 1 >>] >> >>';
  objects[2] = `<< /Type /Pages /Kids [${pageObjectNumbers.map((number) => `${number} 0 R`).join(' ')}] /Count ${pages.length} >>`;
  objects[3] = '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>';

  for (const [index, blocks] of pages.entries()) {
    const pageObjectNumber = pageObjectNumbers[index];
    const contentObjectNumber = pageObjectNumber + 1;
    const stream = streamForPage(blocks);
    const hasImage = blocks.some((block) => block.kind === 'image');
    const resources = hasImage
      ? `<< /Font << /F1 3 0 R >> /XObject << /Im1 ${imageObjectNumber} 0 R >> >>`
      : '<< /Font << /F1 3 0 R >> >>';
    objects[pageObjectNumber] =
      `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] ` +
      `/Resources ${resources} /Contents ${contentObjectNumber} 0 R >>`;
    objects[contentObjectNumber] = `<< /Length ${byteLength(stream)} >>\nstream\n${stream}\nendstream`;
  }

  objects[imageObjectNumber] =
    `<< /Type /XObject /Subtype /Image /Width 2 /Height 2 /ColorSpace /DeviceRGB ` +
    `/BitsPerComponent 8 /Filter /ASCIIHexDecode /Length ${byteLength(imageHex)} >>\n` +
    `stream\n${imageHex}\nendstream`;

  let pdf = '%PDF-1.4\n% ProfePlan structural golden sample\n';
  const offsets = [0];
  const maxObjectNumber = objects.length - 1;

  for (let objectNumber = 1; objectNumber <= maxObjectNumber; objectNumber += 1) {
    offsets[objectNumber] = byteLength(pdf);
    pdf += `${objectNumber} 0 obj\n${objects[objectNumber]}\nendobj\n`;
  }

  const xrefOffset = byteLength(pdf);
  pdf += `xref\n0 ${maxObjectNumber + 1}\n`;
  pdf += '0000000000 65535 f \n';
  for (let objectNumber = 1; objectNumber <= maxObjectNumber; objectNumber += 1) {
    pdf += `${String(offsets[objectNumber]).padStart(10, '0')} 00000 n \n`;
  }
  pdf += `trailer\n<< /Size ${maxObjectNumber + 1} /Root 1 0 R >>\n`;
  pdf += `startxref\n${xrefOffset}\n%%EOF\n`;

  return encoder.encode(pdf);
}

export function verifiedGoldenSampleArtifact() {
  const body = buildStructuralGoldenSamplePdf();
  const sha256 = 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
  return {
    artifact: {
      artifactId: 'artifact-structural-golden-sample',
      sha256,
      sizeBytes: body.byteLength,
    },
    mediaType: 'application/pdf',
    expiresAt: '2026-08-18T21:00:00.000Z',
    sha256,
    body,
  };
}
