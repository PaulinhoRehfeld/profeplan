// import { saveAs } from 'file-saver'; // Removed unused import for performance
// Note: In a real environment with npm access, we would import { Document, Packer, Paragraph, TextRun } from "docx";
// Since we cannot run npm install here, we will use a robust HTML-to-Word export strategy
// which is native and works without heavy dependencies for this specific task.

export const buildInclusionDocHtml = (
  originalLesson: { title: string, content: string },
  adaptations: { studentName: string, content: string }[],
  includeOriginal: boolean = true
) => {
  // Create Semantic HTML structure for the Word Doc
  let htmlContent = `
        <html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'>
        <head>
            <meta charset="utf-8">
            <title>${originalLesson.title}</title>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.5; }
                .page-break { page-break-before: always; }
                h1 { color: #2E3A59; font-size: 24px; border-bottom: 2px solid #2E3A59; padding-bottom: 10px; }
                h2 { color: #0F766E; font-size: 18px; margin-top: 20px; }
                .adaptation-card { border: 1px solid #ddd; padding: 20px; background: #f9f9f9; }
                .header { text-align: center; color: #666; font-size: 12px; margin-bottom: 30px; }
            </style>
        </head>
        <body>
            <!-- Capa / Aula Original (Opcional) -->
            <div class="header">PROFEPLAN - DOCUMENTO DE INCLUSÃO</div>
    `;

  if (includeOriginal) {
    htmlContent += `
            <h1>Aula Original: ${originalLesson.title}</h1>
            <div>${originalLesson.content.replace(/\n/g, '<br/>')}</div>
            <div class="page-break"></div>
        `;
  } else {
    htmlContent += `
            <div style="text-align: center; margin-bottom: 40px;">
                <h1>Adaptações Curriculares</h1>
                <p><strong>Referência:</strong> ${originalLesson.title}</p>
            </div>
        `;
  }

  // Append each student's adaptation with a page break
  adaptations.forEach((adapt, index) => {
    // If it's the first item and we skipped original, we don't strictly need a page break before it, 
    // but usually consistency is good. 
    // If includeOriginal is FALSE, the first item is at the top (after header).
    if (includeOriginal || index > 0) {
      htmlContent += `<div class="page-break"></div>`;
    }

    htmlContent += `
            <div class="header">PROFEPLAN - PDI INDIVIDUAL</div>
            <h1>Adaptação para: ${adapt.studentName}</h1>
            <div class="adaptation-card">
                ${adapt.content.replace(/\n/g, '<br/>').replace(/## (.*)/g, '<h2>$1</h2>')}
            </div>
        `;
  });

  htmlContent += `</body></html>`;
  return htmlContent;
};

export const generateInclusionDoc = async (
  originalLesson: { title: string, content: string },
  adaptations: { studentName: string, content: string }[],
  includeOriginal: boolean = true
) => {
  const htmlContent = buildInclusionDocHtml(originalLesson, adaptations, includeOriginal);

  // Create Blob
  const blob = new Blob(['\ufeff', htmlContent], {
    type: 'application/msword'
  });

  // Save
  const filename = `KIT_INCLUSAO_${originalLesson.title.substring(0, 20)}.doc`;

  // Simple save implementation without file-saver dependency
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

export const generatePdiReportDoc = (studentName: string, period: string, reportContent: string) => {
  const htmlContent = `
        <html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'>
        <head>
            <meta charset="utf-8">
            <style>
                body { font-family: 'Times New Roman', serif; line-height: 1.5; }
                h1 { text-align: center; font-size: 18px; text-transform: uppercase; }
                .meta { margin: 20px 0; border: 1px solid #000; padding: 10px; }
            </style>
        </head>
        <body>
            <h1>Relatório de Desenvolvimento Individual</h1>
            <div class="meta">
                <strong>Estudante:</strong> ${studentName}<br>
                <strong>Período:</strong> ${period}
            </div>
            <div>
                ${reportContent.replace(/\n/g, '<br/>').replace(/\*\*(.*?)\*\*/g, '<b>$1</b>')}
            </div>
        </body>
        </html>
    `;

  const blob = new Blob(['\ufeff', htmlContent], { type: 'application/msword' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `RELATORIO_PDI_${studentName}_${period}.doc`;
  a.click();
};

// --- General Export Functions (Restored) ---

const markdownToHtml = (text: string) => {
  let html = text
    // Headers
    .replace(/^### (.*$)/gim, '<h3>$1</h3>')
    .replace(/^## (.*$)/gim, '<h2>$1</h2>')
    .replace(/^# (.*$)/gim, '<h1>$1</h1>')
    // Bold
    .replace(/\*\*(.*?)\*\*/gim, '<b>$1</b>')
    // Lists (Simple implementation)
    .replace(/^\s*-\s+(.*$)/gim, '<ul><li>$1</li></ul>')
    .replace(/<\/ul>\s*<ul>/gim, '') // Merge adjacent lists
    // Line breaks
    .replace(/\n/g, '<br/>');

  return html;
};

export const exportToDocx = async (content: string, title: string, settings: any) => {
  // Convert Markdown to HTML for Word
  const encodedContent = markdownToHtml(content);

  const htmlContent = `
        <html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'>
        <head>
            <meta charset="utf-8">
            <title>${title}</title>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.5; color: #000; }
                h1 { color: #2E3A59; font-size: 24px; border-bottom: 2px solid #2E3A59; margin-bottom: 15px; }
                h2 { color: #2E3A59; font-size: 18px; margin-top: 20px; font-weight: bold; }
                h3 { color: #4B5563; font-size: 14px; margin-top: 15px; font-weight: bold; }
                b { font-weight: bold; }
                ul { margin-left: 20px; }
                li { margin-bottom: 5px; }
            </style>
        </head>
        <body>
            <h1>${title}</h1>
            <p><strong>Professor(a):</strong> ${settings?.teacherName || settings?.userName || 'Professor(a)'}</p>
            <p><strong>Escola:</strong> ${settings?.schoolName || 'Instituição de Ensino'}</p>
            <hr/>
            <div style="margin-top: 20px;">${encodedContent}</div>
        </body>
        </html>
    `;

  const blob = new Blob(['\ufeff', htmlContent], { type: 'application/msword' });

  // Simple save implementation
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = `${title}.doc`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

export const exportToPptx = async (data: any) => {
  console.warn("PPTX export requires a specialized library (pptxgenjs). Placeholder for now.");
  alert("Exportação PPTX não implementada nesta versão sem dependências externas.");
};

// --- Assessment Export (Restored) ---
export const exportAssessmentToDocx = async (assessment: any, settings: any) => {
  let contentHtml = `
        <div style="font-family: Arial, sans-serif;">
            <div style="text-align: center; margin-bottom: 20px;">
                <h1 style="text-transform: uppercase; font-size: 18px;">${assessment.title}</h1>
                <p><strong>Professor(a):</strong> ${settings?.userName || '__________'}</p>
                <p><strong>Turma:</strong> __________ <strong>Data:</strong> ___/___/___</p>
                <p><strong>Aluno(a):</strong> __________________________________________________</p>
            </div>
            <hr/>
    `;

  assessment.questions.forEach((q: any, index: number) => {
    contentHtml += `<div style="margin-bottom: 20px;">`;
    contentHtml += `<p><strong>${index + 1}.</strong> ${q.question}</p>`;

    if (q.type === 'objective' && q.options) {
      contentHtml += `<ul style="list-style-type: none; padding-left: 0;">`;
      q.options.forEach((opt: string) => {
        contentHtml += `<li style="margin-bottom: 5px;">( ) ${opt}</li>`;
      });
      contentHtml += `</ul>`;
    } else if (q.type === 'dissertative') {
      contentHtml += `<div style="border: 1px solid #ccc; height: 100px; margin-top: 10px;"></div>`;
    }
    contentHtml += `</div>`;
  });

  contentHtml += `</div>`;

  // Reuse the HTML export logic
  const blob = new Blob(['\ufeff', htmlWrapper(assessment.title, contentHtml)], { type: 'application/msword' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = `AVALIACAO_${assessment.title.substring(0, 20)}.doc`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

// Helper for generic HTML wrapping
const htmlWrapper = (title: string, body: string) => `
    <html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'>
    <head>
        <meta charset="utf-8">
        <title>${title}</title>
    </head>
    <body>${body}</body>
    </html>
`;

export const exportSimuladoToDocx = async (questions: any[], headerText: string, versionTitle: string, settings: any) => {
  // 1. Build Header
  let contentHtml = `
        <div style="font-family: Arial, sans-serif;">
            <div style="text-align: center; margin-bottom: 30px; border-bottom: 2px solid #000; padding-bottom: 15px;">
                <h1 style="text-transform: uppercase; font-size: 16px; margin: 0;">${settings?.userName || 'PROFEPLAN'} - SIMULADO</h1>
                <p style="white-space: pre-wrap; font-size: 12px; margin-top: 10px;">${headerText || 'Instruções Gerais: Leia com atenção.'}</p>
                <p style="font-size: 12px; margin-top: 5px;"><strong>Versão:</strong> ${versionTitle} | <strong>Data:</strong> ${new Date().toLocaleDateString('pt-BR')}</p>
            </div>
    `;

  // 2. Questions Body (Attempting 2 Columns)
  // Note: 'column-count' works in some Word importers (MHT), but simple tables are safer for strict layout if column-count fails.
  // However, users asked for "Estilo ENEM" which implies continuous text in columns.
  // We will try CSS columns for the wrapper.
  contentHtml += `<div style="column-count: 2; column-gap: 40px; text-align: justify;">`;

  questions.forEach((q, index) => {
    // Construct Enunciado (Context + Command)
    const context = q.metadata?.context || '';
    const command = q.metadata?.alternativesIntroduction || ''; // Some questions might call it 'text' or 'question', adjusting based on types.ts
    // Fallback if metadata is missing (legacy questions)
    const questionText = (context || command) ?
      `${context ? `<div class="context">${context.replace(/\n/g, '<br/>')}</div>` : ''} 
         ${command ? `<div class="command" style="margin-top: 10px; font-weight: bold;">${command.replace(/\n/g, '<br/>')}</div>` : ''}`
      : q.content?.replace(/\n/g, '<br/>') || 'Texto da questão indisponível.';

    // Construct Alternatives
    let alternativesHtml = '';
    if (q.metadata?.alternatives && Array.isArray(q.metadata.alternatives)) {
      alternativesHtml = '<ul style="list-style-type: none; padding-left: 0; margin-top: 10px;">';
      q.metadata.alternatives.forEach((alt: any) => {
        const letter = alt.letter || '?';
        const text = alt.text || '';
        alternativesHtml += `<li style="margin-bottom: 5px;"><strong>${letter})</strong> ${text}</li>`;
      });
      alternativesHtml += '</ul>';
    }

    contentHtml += `
            <div style="break-inside: avoid; margin-bottom: 25px; font-size: 11px;">
                <p style="margin-bottom: 5px;"><strong>QUESTÃO ${index + 1}</strong> <span style="font-size: 9px; color: #666;">(${q.metadata?.year || q.metadata?.ano || 'BANCO'} | ${q.metadata?.discipline || q.metadata?.disciplina || 'GERAL'})</span></p>
                <div style="margin-bottom: 10px;">${questionText}</div>
                ${alternativesHtml}
            </div>
        `;
  });

  contentHtml += `</div>`; // End Columns

  // 3. Gabarito Page
  contentHtml += `<br clear="all" style="page-break-before: always" />`; // Force Page Break
  contentHtml += `
        <div style="text-align: center; margin-top: 50px;">
            <h2>GABARITO OFICIAL - ${versionTitle.toUpperCase()}</h2>
            <table border="1" cellpadding="5" cellspacing="0" style="margin: 0 auto; border-collapse: collapse; width: 60%;">
                <thead>
                    <tr style="background-color: #eee;">
                        <th>Questão</th>
                        <th>Gabarito</th>
                    </tr>
                </thead>
                <tbody>
    `;

  questions.forEach((q, index) => {
    contentHtml += `
            <tr>
                <td style="text-align: center;">${index + 1}</td>
                <td style="text-align: center; font-weight: bold;">${q.metadata?.gabarito || '-'}</td>
            </tr>
        `;
  });

  contentHtml += `
                </tbody>
            </table>
        </div>
        </div>
    `;

  // 4. Save
  const blob = new Blob(['\ufeff', htmlWrapper(`Simulado - ${versionTitle}`, contentHtml)], { type: 'application/msword' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = `SIMULADO_${versionTitle}_${new Date().toISOString().slice(0, 10)}.doc`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
