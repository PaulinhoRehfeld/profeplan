import { saveAs } from 'file-saver';
// Note: In a real environment with npm access, we would import { Document, Packer, Paragraph, TextRun } from "docx";
// Since we cannot run npm install here, we will use a robust HTML-to-Word export strategy
// which is native and works without heavy dependencies for this specific task.

export const buildInclusionDocHtml = (
  originalLesson: { title: string, content: string },
  adaptations: { studentName: string, content: string }[]
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
            <!-- Capa / Aula Original -->
            <div class="header">PROFEPLAN - DOCUMENTO DE INCLUSÃO</div>
            <h1>Aula Original: ${originalLesson.title}</h1>
            <div>${originalLesson.content.replace(/\n/g, '<br/>')}</div>
    `;

  // Append each student's adaptation with a page break
  adaptations.forEach(adapt => {
    htmlContent += `
            <div class="page-break"></div>
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
  adaptations: { studentName: string, content: string }[]
) => {
  const htmlContent = buildInclusionDocHtml(originalLesson, adaptations);

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

export const exportToDocx = async (content: string, title: string, settings: any) => {
  const htmlContent = `
        <html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'>
        <head>
            <meta charset="utf-8">
            <title>${title}</title>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.5; }
                h1 { color: #2E3A59; }
            </style>
        </head>
        <body>
            <h1>${title}</h1>
            <p><strong>Autor:</strong> ${settings?.userName || 'Professor'}</p>
            <hr/>
            <div>${content.replace(/\n/g, '<br/>')}</div>
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
    contentHtml += `
            <div style="break-inside: avoid; margin-bottom: 25px; font-size: 11px;">
                <p style="margin-bottom: 5px;"><strong>QUESTÃO ${index + 1}</strong> <span style="font-size: 9px; color: #666;">(${q.metadata?.ano || 'BANCO'} | ${q.metadata?.disciplina?.substring(0, 3).toUpperCase() || ''})</span></p>
                <div style="margin-bottom: 10px;">${q.content.replace(/\n/g, '<br/>')}</div>
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
