
import React from 'react';

interface MarkdownRendererProps {
  content: string;
}

export const formatMarkdownToHTML = (text: string, isForExport = false) => {
  let html = text;

  // Limpeza de metadados
  html = html.replace(/\[DADOS DO PROFESSOR:.*?\]/g, '');
  html = html.replace(/\[PREFERÊNCIAS:.*?\]/g, '');
  html = html.replace(/\[AULA ATUAL:.*?\]/g, '');

  // Bold & Italic
  html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
  html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');

  // Tables com estilos específicos para Google Docs
  const tableRegex = /\|(.+)\|[\r\n]+\|([- |]+)\|[\r\n]+((?:\|.+|[\r\n]+)*)/g;
  html = html.replace(tableRegex, (match, header, separator, body) => {
    const headerHtml = `<thead><tr style="background-color: #f1f5f9;">${header.split('|').filter((h: string) => h.trim() !== '').map((h: string) => `<th style="border: 1px solid #94a3b8; padding: 10px; text-align: left; font-family: Arial, sans-serif; font-size: 11pt;">${h.trim()}</th>`).join('')}</tr></thead>`;
    const bodyRows = body.split('\n').filter((row: string) => row.trim().startsWith('|'));
    const bodyHtml = `<tbody>${bodyRows.map((row: string) => `<tr>${row.split('|').filter((cell: string, idx: number, arr: string[]) => idx > 0 && idx < arr.length - 1).map((cell: string) => `<td style="border: 1px solid #cbd5e1; padding: 10px; font-family: Arial, sans-serif; font-size: 10pt;">${cell.trim()}</td>`).join('')}</tr>`).join('')}</tbody>`;
    return `<table style="width: 100%; border-collapse: collapse; margin: 20px 0;">${headerHtml}${bodyHtml}</table>`;
  });

  // Headers com hierarquia visual clara
  html = html.replace(/^### (.*$)/gm, '<h3 style="color: #334155; font-family: Arial, sans-serif; font-size: 14pt; margin-top: 18pt; margin-bottom: 6pt;">$1</h3>');
  html = html.replace(/^## (.*$)/gm, '<h2 style="color: #1e293b; font-family: Arial, sans-serif; font-size: 18pt; border-bottom: 2px solid #3b82f6; padding-bottom: 4pt; margin-top: 24pt; margin-bottom: 12pt;">$1</h2>');
  html = html.replace(/^# (.*$)/gm, '<h1 style="color: #000000; font-family: Arial, sans-serif; font-size: 24pt; text-align: center; margin-bottom: 30pt;">$1</h1>');

  // Lists
  html = html.replace(/^\* (.*$)/gm, '<li style="margin-bottom: 6pt; font-family: Arial, sans-serif; font-size: 11pt;">$1</li>');
  html = html.replace(/^- (.*$)/gm, '<li style="margin-bottom: 6pt; font-family: Arial, sans-serif; font-size: 11pt;">$1</li>');
  
  // Paragraphs
  html = html.replace(/([^\n]+)\n\n/g, '<p style="margin-bottom: 12pt; line-height: 1.6; font-family: Arial, sans-serif; font-size: 11pt;">$1</p>');

  if (isForExport) {
    return `
      <div style="padding: 40px; max-width: 800px; margin: auto;">
        ${html}
      </div>
    `;
  }

  return html;
};

const MarkdownRenderer: React.FC<MarkdownRendererProps> = ({ content }) => {
  return (
    <div 
      className="markdown-content text-slate-800"
      dangerouslySetInnerHTML={{ __html: formatMarkdownToHTML(content) }}
    />
  );
};

export default MarkdownRenderer;
