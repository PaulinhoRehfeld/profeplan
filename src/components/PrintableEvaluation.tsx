import React from 'react';
import type { Assessment } from '../types';
import A4PrintSheet from './A4PrintSheet';

interface PrintableEvaluationProps {
  assessment: Assessment;
  schoolName: string;
  logoBase64?: string;
}

const PrintableEvaluation: React.FC<PrintableEvaluationProps> = ({
  assessment,
  schoolName,
  logoBase64
}) => {
  return (
    <A4PrintSheet title={assessment.title}>
      <div id="section-to-print">
        {/* CABEÇALHO ESCOLAR COMPLETO */}
        <div className="assessment-header">
          <div className="header-top">
            {logoBase64 && <img src={logoBase64} alt="Logo" className="school-logo" />}
            <div className="school-info">
              <h1>{schoolName}</h1>
              <h2>AVALIAÇÃO DE {assessment.subject.toUpperCase()}</h2>
            </div>
          </div>

          <div className="header-grid">
            <div className="header-item full">
              <strong>Aluno(a):</strong> ____________________________________________________________________
            </div>
            <div className="header-item">
              <strong>Turma:</strong> {assessment.className || '_________'}
            </div>
            <div className="header-item">
              <strong>Data:</strong> ____/____/________
            </div>
            <div className="header-item">
              <strong>Período:</strong> {assessment.academicPeriod || '_________'}
            </div>
            <div className="header-item">
              <strong>Valor:</strong> {assessment.totalPoints} pts
            </div>
          </div>
        </div>

        {/* INSTRUÇÕES */}
        <div className="assessment-instructions">
          <strong>INSTRUÇÕES:</strong> Leia cada questão com atenção antes de responder.
          Use caneta azul ou preta. Não é permitido o uso de corretivos ou consultas não autorizadas.
        </div>

        {/* QUESTÕES */}
        <div className="questions-container">
          {assessment.questions.map((question, index) => (
            <div key={question.id} className="assessment-question question-block">
              <p className="q-text">
                <strong>Questão {index + 1}</strong> {question.difficulty && <span className="difficulty-tag">[{question.difficulty}]</span>}
                <br />
                {question.question}
              </p>

              {question.type === 'objective' && question.options && (
                <div className="q-options">
                  {question.options.map((opt, i) => (
                    <div key={i} className="opt-item">{opt}</div>
                  ))}
                </div>
              )}

              {question.type === 'dissertative' && (
                <div className="answer-lines">
                  {[...Array(6)].map((_, i) => (
                    <div key={i} className="line" />
                  ))}
                </div>
              )}
            </div>
          ))}
        </div>
      </div>

      <style>{`
        #section-to-print {
          font-family: 'Times New Roman', serif;
          background: white;
          color: black;
          font-size: 11pt;
          line-height: 1.4;
          width: 100%;
        }

        /* === CABEÇALHO === */
        .assessment-header {
          border: 2px solid black;
          padding: 3mm;
          margin-bottom: 5mm;
        }

        .header-top {
          display: flex;
          align-items: center;
          gap: 15px;
          border-bottom: 1px solid black;
          padding-bottom: 3mm;
          margin-bottom: 3mm;
        }

        .school-logo {
          max-height: 50px;
          max-width: 150px;
        }

        .school-info h1 {
          margin: 0;
          font-size: 14pt;
          font-weight: bold;
          text-transform: uppercase;
        }

        .school-info h2 {
          margin: 2px 0 0 0;
          font-size: 11pt;
          font-weight: bold;
          color: #333;
        }

        .header-grid {
          display: grid;
          grid-template-columns: 2fr 1fr;
          gap: 2mm 5mm;
        }

        .header-item {
          font-size: 10pt;
        }

        .header-item.full {
          grid-column: span 2;
        }

        /* === INSTRUÇÕES === */
        .assessment-instructions {
          font-size: 9pt;
          border: 1px dashed black;
          padding: 2mm;
          margin-bottom: 6mm;
          font-style: italic;
        }

        /* === QUESTÕES === */
        .assessment-question {
          margin-bottom: 8mm;
        }

        .q-text {
          font-size: 11pt;
          margin: 0 0 3mm 0;
          text-align: justify;
        }

        .difficulty-tag {
          font-size: 8pt;
          color: #666;
          margin-left: 5px;
        }

        .q-options {
          display: flex;
          flex-direction: column;
          gap: 1.5mm;
          padding-left: 5mm;
        }

        .opt-item {
          font-size: 10.5pt;
        }

        .answer-lines {
          margin-top: 3mm;
          border: 1px solid #eee;
          padding: 2mm;
        }

        .line {
          border-bottom: 1px solid #ccc;
          height: 8mm;
          margin-bottom: 1mm;
        }

        @media screen {
          #section-to-print {
            /* No screen, let A4PrintSheet handle the container style */
          }
        }

        @media print {
          * {
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
          }
        }
      `}</style>
    </A4PrintSheet>
  );
};

export default PrintableEvaluation;

