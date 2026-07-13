import React, { useState } from 'react';
import { Camera, Loader2, CheckCircle2, AlertCircle, X, Upload } from 'lucide-react';
import { gradeWrittenAnswer } from '../services/ai/AiAssessmentService';
import type { GradingResult } from '../types';

interface DissertativeGraderProps {
  questionText: string;
  rubric: string;
  maxPoints: number;
  onClose: () => void;
}

const DissertativeGrader: React.FC<DissertativeGraderProps> = ({
  questionText,
  rubric,
  maxPoints,
  onClose,
}) => {
  const [imageBase64, setImageBase64] = useState('');
  const [isGrading, setIsGrading] = useState(false);
  const [result, setResult] = useState<GradingResult | null>(null);
  const [error, setError] = useState('');

  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (!file.type.startsWith('image/')) {
      setError('Por favor, selecione uma imagem.');
      return;
    }

    const reader = new FileReader();
    reader.onload = (event) => {
      setImageBase64(event.target?.result as string);
      setError('');
    };
    reader.readAsDataURL(file);
  };

  const handleGrade = async () => {
    if (!imageBase64) {
      setError('Envie uma foto da resposta primeiro.');
      return;
    }

    setIsGrading(true);
    setError('');

    try {
      const gradingResult = await gradeWrittenAnswer(questionText, rubric, imageBase64);
      setResult({
        questionId: '', // Pode ser preenchido se necessário
        ...gradingResult,
      });
    } catch (err: any) {
      setError(err.message || 'Erro ao corrigir resposta.');
    } finally {
      setIsGrading(false);
    }
  };

  if (result) {
    return (
      <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-6">
        <div className="bg-white rounded-[2.5rem] p-10 max-w-2xl w-full shadow-2xl space-y-6 animate-in zoom-in-95 duration-300">
          <div className="flex items-center justify-between">
            <h3 className="text-xl font-black text-slate-900 uppercase italic tracking-tight">
              Correção IA Concluída
            </h3>
            <button
              onClick={onClose}
              className="p-2 hover:bg-slate-100 rounded-xl transition-colors"
            >
              <X size={20} />
            </button>
          </div>

          <div className="bg-gradient-to-br from-green-50 to-emerald-50 border border-green-100 rounded-2xl p-8 text-center">
            <CheckCircle2 className="w-16 h-16 text-green-600 mx-auto mb-4" />
            <p className="text-4xl font-black text-green-900 mb-2">
              {result.score.toFixed(1)}
              <span className="text-2xl text-green-600">/{result.maxScore}</span>
            </p>
            <p className="text-[10px] font-black text-green-600 uppercase tracking-widest">
              Pontuação Atribuída pelo Gemini
            </p>
          </div>

          <div>
            <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
              Texto Extraído (OCR)
            </p>
            <div className="p-4 bg-slate-50 border border-slate-100 rounded-xl">
              <p className="text-sm text-slate-700 italic leading-relaxed">
                {result.studentAnswer}
              </p>
            </div>
          </div>

          <div>
            <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
              Feedback Pedagógico
            </p>
            <div className="p-4 bg-blue-50 border border-blue-100 rounded-xl">
              <p className="text-sm text-blue-900 leading-relaxed">{result.feedback}</p>
            </div>
          </div>

          <button
            onClick={onClose}
            className="w-full bg-slate-900 text-white px-8 py-4 rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-blue-600 transition-all"
          >
            Fechar
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-6">
      <div className="bg-white rounded-[2.5rem] p-10 max-w-2xl w-full shadow-2xl space-y-6 animate-in zoom-in-95 duration-300">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-xl font-black text-slate-900 uppercase italic tracking-tight">
              Corretor IA de Dissertativas
            </h3>
            <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">
              Gemini Vision • OCR + Análise Pedagógica
            </p>
          </div>
          <button onClick={onClose} className="p-2 hover:bg-slate-100 rounded-xl transition-colors">
            <X size={20} />
          </button>
        </div>

        {error && (
          <div className="p-4 bg-red-50 text-red-600 rounded-2xl text-[10px] font-black uppercase tracking-widest border border-red-100 flex items-center gap-3">
            <AlertCircle className="w-4 h-4" /> {error}
            <button onClick={() => setError('')} className="ml-auto">
              <X size={14} />
            </button>
          </div>
        )}

        <div>
          <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
            Questão
          </p>
          <div className="p-4 bg-slate-50 border border-slate-100 rounded-xl">
            <p className="text-sm text-slate-700 leading-relaxed">{questionText}</p>
          </div>
        </div>

        <div>
          <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
            Rubrica de Correção
          </p>
          <div className="p-4 bg-blue-50 border border-blue-100 rounded-xl">
            <p className="text-xs text-blue-900 leading-relaxed">{rubric}</p>
          </div>
        </div>

        <div>
          <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
            <Camera size={14} className="inline mr-2" />
            Foto da Resposta Escrita
          </label>
          {imageBase64 ? (
            <div className="relative">
              <img
                src={imageBase64}
                alt="Resposta do aluno"
                className="w-full rounded-2xl border border-slate-200"
              />
              <button
                onClick={() => setImageBase64('')}
                className="absolute top-4 right-4 p-2 bg-red-500 text-white rounded-xl hover:bg-red-600 transition-colors"
              >
                <X size={16} />
              </button>
            </div>
          ) : (
            <label className="cursor-pointer border-2 border-dashed border-slate-200 rounded-2xl p-12 flex flex-col items-center justify-center hover:border-blue-300 hover:bg-blue-50/50 transition-all">
              <Upload className="w-12 h-12 text-slate-300 mb-4" />
              <p className="text-sm font-bold text-slate-400 uppercase tracking-widest">
                Clique para enviar foto
              </p>
              <input type="file" accept="image/*" className="hidden" onChange={handleImageUpload} />
            </label>
          )}
        </div>

        <button
          onClick={handleGrade}
          disabled={isGrading || !imageBase64}
          className="w-full bg-gradient-to-r from-purple-600 to-indigo-700 text-white px-10 py-5 rounded-2xl font-black text-sm uppercase tracking-widest hover:scale-105 transition-all shadow-2xl shadow-purple-200 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 flex items-center justify-center gap-3"
        >
          {isGrading ? (
            <>
              <Loader2 className="w-5 h-5 animate-spin" />
              Gemini Corrigindo...
            </>
          ) : (
            <>
              <CheckCircle2 size={20} />
              Corrigir com IA
            </>
          )}
        </button>
      </div>
    </div>
  );
};

export default DissertativeGrader;
