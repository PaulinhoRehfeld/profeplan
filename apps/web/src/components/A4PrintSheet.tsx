import React, { useEffect } from 'react';

interface A4PrintSheetProps {
  children: React.ReactNode;
  title?: string;
}

const A4PrintSheet: React.FC<A4PrintSheetProps> = ({ children, title }) => {
  const handlePrint = () => {
    window.print();
  };

  useEffect(() => {
    // Ao montar, garantir que o corpo permite scroll para que o navegador pegue todo o conteúdo
    const originalOverflow = document.body.style.overflow;
    document.body.style.overflow = 'visible';

    return () => {
      document.body.style.overflow = originalOverflow;
    };
  }, []);

  return (
    <div className="print-overlay">
      {/* Botões de Controle - Não aparecem na impressão */}
      <div className="print-controls no-print">
        <button onClick={handlePrint} className="btn-print">
          🖨️ Confirmar e Imprimir PDF
        </button>
        <p className="print-hint">
          Certifique-se de que o layout esteja como 'Retrato' e margens como 'Padrão'.
        </p>
      </div>

      {/* A Folha A4 */}
      <div className="a4-page">{children}</div>

      <style>{`
        /* Estilo para Visualização no Navegador (Tela) */
        .print-overlay {
          background-color: #525659;
          min-height: 100vh;
          padding: 40px 20px;
          display: flex;
          flex-direction: column;
          align-items: center;
        }

        .print-controls {
          margin-bottom: 20px;
          text-align: center;
          position: sticky;
          top: 20px;
          z-index: 100;
        }

        .btn-print {
          background: #2563eb;
          color: white;
          padding: 12px 24px;
          border-radius: 8px;
          border: none;
          font-weight: bold;
          cursor: pointer;
          box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .print-hint {
          color: #e5e7eb;
          font-size: 0.8rem;
          margin-top: 8px;
        }

        .a4-page {
          background: white;
          width: 210mm;
          min-height: 297mm;
          padding: 20mm;
          margin: 0 auto;
          box-shadow: 0 0 10px rgba(0,0,0,0.5);
          box-sizing: border-box;
          position: relative;
        }

        /* O SEGREDO: Configurações de Impressão */
        @media print {
          /* 1. Esconde tudo que não for a folha */
          body * {
            visibility: hidden;
          }
          
          .a4-page, .a4-page * {
            visibility: visible;
          }

          /* 2. Reseta o posicionamento para o topo da folha real */
          .a4-page {
            position: absolute;
            left: 0;
            top: 0;
            width: 210mm;
            margin: 0;
            padding: 15mm; /* Margem interna da impressão */
            box-shadow: none;
            height: auto !important;
          }

          /* 3. Força o navegador a permitir múltiplas páginas */
          html, body {
            height: auto !important;
            overflow: visible !important;
            background: white;
          }

          /* 4. Remove cabeçalhos e rodapés do sistema (URL, data) */
          @page {
            size: A4 portrait;
            margin: 0;
          }

          /* 5. Classe para não quebrar uma questão ao meio entre duas páginas */
          .question-block {
            page-break-inside: avoid;
            break-inside: avoid;
            margin-bottom: 15px;
          }

          .no-print {
            display: none !important;
          }
        }
      `}</style>
    </div>
  );
};

export default A4PrintSheet;
