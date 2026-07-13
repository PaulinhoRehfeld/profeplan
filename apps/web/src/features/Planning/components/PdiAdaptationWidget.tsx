import React, { useState, useEffect } from 'react';
import { Accessibility, Sparkles, AlertCircle, CheckCircle2, Save } from 'lucide-react';
import { PdiDocumentService } from '../../../services/pdi/PdiDocumentService';
import { AiAdaptationService } from '../../../services/ai/AiAdaptationService';
import { supabase } from '../../../services/supabaseClient';

interface PdiAdaptationWidgetProps {
  userId: string;
  studentId: string;
  pdiId: string;
  studentName: string;
  lessonTopic: string;
  lessonObjective: string;
}

export const PdiAdaptationWidget: React.FC<PdiAdaptationWidgetProps> = ({
  userId,
  studentId,
  pdiId,
  studentName,
  lessonTopic,
  lessonObjective,
}) => {
  // State
  const [loading, setLoading] = useState(false);
  const [generating, setGenerating] = useState(false);
  const [existingAdaptation, setExistingAdaptation] = useState<any>(null);

  // Adaptation Fields
  const [adaptationGoal, setAdaptationGoal] = useState('');
  const [adaptationStrategy, setAdaptationStrategy] = useState('');

  // Feedback Fields (Only if exists)
  const [achievedStatus, setAchievedStatus] = useState<
    'ALCANCADO' | 'PARCIAL' | 'NAO_ALCANCADO' | null
  >(null);
  const [autonomyLevel, setAutonomyLevel] = useState<'TOTAL' | 'PARCIAL' | 'NENHUMA' | null>(null);

  useEffect(() => {
    loadAdaptation();
  }, [pdiId, lessonTopic]);

  const loadAdaptation = async () => {
    setLoading(true);
    // Find if we already have an adaptation for this lesson topic
    const { data } = await supabase
      .from('pdi_lesson_adaptations')
      .select('*')
      .eq('pdi_document_id', pdiId)
      .eq('lesson_topic', lessonTopic) // Naive matching, ideally use ID
      .maybeSingle();

    if (data) {
      setExistingAdaptation(data);
      setAdaptationGoal(data.adaptation_goal);
      setAdaptationStrategy(data.adaptation_strategy);
      setAchievedStatus(data.achieved_status);
      setAutonomyLevel(data.autonomy_level);
    }
    setLoading(false);
  };

  const handleGenerate = async () => {
    setGenerating(true);
    try {
      // 1. Fetch Profile
      const { data: pdi } = await PdiDocumentService.getOrCreatePdi(studentId);
      if (!pdi || !pdi.content_data) throw new Error('PDI data missing');

      const profile = {
        name: studentName,
        psychomotor: pdi.content_data.psychomotor,
        cognitive: pdi.content_data.cognitive,
        communication: pdi.content_data.communication,
      };

      // 2. Generate
      const result = await AiAdaptationService.generateLessonAdaptation(
        profile,
        lessonTopic,
        lessonObjective,
        userId
      );

      setAdaptationGoal(result.goal);
      setAdaptationStrategy(result.strategy);
    } catch (e) {
      console.error(e);
      alert('Erro ao gerar adaptação.');
    } finally {
      setGenerating(false);
    }
  };

  const handleSave = async () => {
    const payload = {
      pdi_document_id: pdiId,
      teacher_id: userId,
      lesson_topic: lessonTopic,
      adaptation_goal: adaptationGoal,
      adaptation_strategy: adaptationStrategy,
      achieved_status: achievedStatus,
      autonomy_level: autonomyLevel,
      status: achievedStatus ? 'COMPLETED' : 'PENDING',
    };

    const { error } = await supabase
      .from('pdi_lesson_adaptations')
      .upsert({ ...payload, id: existingAdaptation?.id }) // Upsert if ID exists
      .select()
      .single();

    if (error) {
      alert('Erro ao salvar');
    } else {
      // alert("Salvo!");
      loadAdaptation();
    }
  };

  if (loading) return <div className="p-4 text-xs">Carregando adaptações...</div>;

  const isCompleted = existingAdaptation?.status === 'COMPLETED';

  return (
    <div
      className={`border rounded-xl mb-4 transition-all ${isCompleted ? 'bg-emerald-50 border-emerald-200' : 'bg-white border-indigo-100 shadow-sm'}`}
    >
      {/* HEADER */}
      <div className="flex items-center justify-between p-3 border-b border-indigo-50/50">
        <div className="flex items-center gap-2">
          <div
            className={`w-8 h-8 rounded-lg flex items-center justify-center ${isCompleted ? 'bg-emerald-100 text-emerald-600' : 'bg-indigo-100 text-indigo-600'}`}
          >
            <Accessibility size={16} />
          </div>
          <div>
            <h4 className="text-xs font-black uppercase text-slate-700 tracking-wide">
              Adaptação: {studentName}
            </h4>
            <p className="text-[10px] text-slate-400 font-medium">
              Seção IX - Adequação Curricular
            </p>
          </div>
        </div>
        {!existingAdaptation && !adaptationGoal && (
          <button
            onClick={handleGenerate}
            disabled={generating}
            className="flex items-center gap-2 px-3 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg text-[10px] font-bold uppercase tracking-widest transition-all disabled:opacity-50"
          >
            {generating ? <Sparkles size={12} className="animate-spin" /> : <Sparkles size={12} />}
            Gerar com IA
          </button>
        )}
        {(adaptationGoal || existingAdaptation) && (
          <button
            onClick={handleSave}
            className="flex items-center gap-2 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-[10px] font-bold uppercase tracking-widest transition-all"
          >
            <Save size={12} /> Salvar
          </button>
        )}
      </div>

      {/* CONTENT */}
      {adaptationGoal || existingAdaptation ? (
        <div className="p-3 space-y-3">
          {/* 1. THE PLAN */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div>
              <label className="text-[9px] font-bold text-slate-400 uppercase block mb-1">
                Objetivo Adaptado
              </label>
              <textarea
                value={adaptationGoal}
                onChange={(e) => setAdaptationGoal(e.target.value)}
                className="w-full text-xs p-2 bg-slate-50 border border-slate-200 rounded-lg focus:bg-white resize-none"
                rows={3}
              />
            </div>
            <div>
              <label className="text-[9px] font-bold text-slate-400 uppercase block mb-1">
                Estratégia / Recurso
              </label>
              <textarea
                value={adaptationStrategy}
                onChange={(e) => setAdaptationStrategy(e.target.value)}
                className="w-full text-xs p-2 bg-slate-50 border border-slate-200 rounded-lg focus:bg-white resize-none"
                rows={3}
              />
            </div>
          </div>

          {/* 2. THE FEEDBACK (Only if plan is saved) */}
          {existingAdaptation && (
            <div className="pt-3 border-t border-slate-100 animate-in fade-in">
              <p className="text-[9px] font-black text-slate-400 uppercase mb-2 flex items-center gap-1">
                <CheckCircle2 size={10} /> Registro de Aula (Feedback)
              </p>
              <div className="flex flex-wrap gap-2">
                {/* Achieved Status */}
                <select
                  value={achievedStatus || ''}
                  onChange={(e) => setAchievedStatus(e.target.value as any)}
                  className="text-xs p-2 bg-white border border-slate-200 rounded-lg font-bold text-slate-600"
                >
                  <option value="">Status do Objetivo...</option>
                  <option value="ALCANCADO">Objetivo Alcançado</option>
                  <option value="PARCIAL">Parcialmente Alcançado</option>
                  <option value="NAO_ALCANCADO">Não Alcançado</option>
                </select>

                {/* Autonomy Level */}
                <select
                  value={autonomyLevel || ''}
                  onChange={(e) => setAutonomyLevel(e.target.value as any)}
                  className="text-xs p-2 bg-white border border-slate-200 rounded-lg font-bold text-slate-600"
                >
                  <option value="">Nível de Autonomia...</option>
                  <option value="TOTAL">Com Autonomia Total</option>
                  <option value="PARCIAL">Com Ajuda/Mediação</option>
                  <option value="NENHUMA">Muita Dificuldade</option>
                </select>
              </div>
            </div>
          )}
        </div>
      ) : (
        <div className="p-6 text-center text-slate-400">
          <p className="text-xs">Nenhuma adaptação gerada.</p>
        </div>
      )}
    </div>
  );
};
