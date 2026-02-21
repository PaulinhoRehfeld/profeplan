
import React from 'react';

interface MarkdownRendererProps {
  content: string;
}

export const formatMarkdownToHTML = (text: string, isForExport = false) => {
  let html = text;

  // Limpeza de metadados internos
  html = html.replace(/\[PROFESSOR:.*?\]/g, '');
  html = html.replace(/\[INSTITUIÇÃO:.*?\]/g, '');
  html = html.replace(/\[REDE:.*?\]/g, '');
  html = html.replace(/\[DISCIPLINA:.*?\]/g, '');
  html = html.replace(/\[SÉRIE:.*?\]/g, '');
  html = html.replace(/\[METODOLOGIA:.*?\]/g, '');

  // Bold & Italic
  html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
  html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');

  // Tables - Design Profissional e Responsivo
  const tableRegex = /\|(.+)\|[\r\n]+\|([- |]+)\|[\r\n]+((?:\|.+|[\r\n]+)*)/g;
  html = html.replace(tableRegex, (match, header, separator, body) => {
    const headerHtml = `<thead><tr class="bg-slate-50 border-b border-slate-200">${header.split('|').filter((h: string) => h.trim() !== '').map((h: string) => `<th class="px-4 py-3 text-left text-[11px] font-black uppercase tracking-wider text-slate-500 border-r border-slate-200 last:border-0">${h.trim()}</th>`).join('')}</tr></thead>`;
    
    const bodyRows = body.split('\n').filter((row: string) => row.trim().startsWith('|'));
    const bodyHtml = `<tbody>${bodyRows.map((row: string) => `<tr class="border-b border-slate-100 last:border-0 hover:bg-slate-50/50 transition-colors">${row.split('|').filter((cell: string, idx: number, arr: string[]) => idx > 0 && idx < arr.length - 1).map((cell: string) => `<td class="px-4 py-3 text-sm text-slate-700 border-r border-slate-100 last:border-0 font-medium">${cell.trim()}</td>`).join('')}</tr>`).join('')}</tbody>`;
    
    return `<div class="overflow-x-auto my-6 rounded-2xl border border-slate-200 bg-white"><table class="w-full border-collapse">${headerHtml}${bodyHtml}</table></div>`;
  });

  // Headers com Identidade Visual PROFEPLAN
  html = html.replace(/^### (.*$)/gm, '<h3 class="text-base font-black text-slate-800 uppercase tracking-widest mb-3 mt-6 flex items-center gap-2 after:content-[\'\'] after:flex-1 after:h-px after:bg-slate-100">$1</h3>');
  html = html.replace(/^## (.*$)/gm, '<h2 class="text-xl font-black text-slate-900 italic uppercase tracking-tighter mb-4 mt-8 border-l-4 border-blue-600 pl-4">$1</h2>');
  html = html.replace(/^# (.*$)/gm, '<h1 class="text-3xl font-black text-slate-950 tracking-tighter text-center mb-10 py-6 border-y border-slate-100 bg-slate-50/50 rounded-3xl">$1</h1>');

  // Lists - Elegantes
  html = html.replace(/^\* (.*$)/gm, '<li class="flex items-start gap-3 mb-2 text-slate-700 font-medium before:content-[\'•\'] before:text-blue-500 before:font-bold">$1</li>');
  html = html.replace(/^- (.*$)/gm, '<li class="flex items-start gap-3 mb-2 text-slate-700 font-medium before:content-[\'→\'] before:text-blue-500 before:font-bold">$1</li>');
  
  // Parágrafos e Espaçamento
  html = html.replace(/([^\n]+)\n\n/g, '<p class="mb-5 leading-relaxed text-slate-700 font-medium">$1</p>');

  if (isForExport) {
    // Versão limpa para exportação DOCX (estilo Word básico)
    return html;
  }

  return html;
};

const MarkdownRenderer: React.FC<MarkdownRendererProps> = ({ content }) => {
  return (
    <div 
      className="markdown-content prose prose-slate max-w-none"
      dangerouslySetInnerHTML={{ __html: formatMarkdownToHTML(content) }}
    />
  );
};

export default MarkdownRenderer;
