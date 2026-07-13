import React, { useEffect, useState } from 'react';
import { PdiDocumentService, PdiRecord } from '../services/pdi/PdiDocumentService';
import { FileText, Calendar, Clock, Activity, BookOpen, AlertCircle, Quote } from 'lucide-react';
import { supabase } from '../services/supabaseClient'; // For fetching student details

interface StudentPdiViewProps {
  studentId: string;
}

const StudentPdiView: React.FC<StudentPdiViewProps> = ({ studentId }) => {
  const [records, setRecords] = useState<PdiRecord[]>([]);
  const [loading, setLoading] = useState(true);
  const [studentName, setStudentName] = useState('');

  useEffect(() => {
    loadData();
  }, [studentId]);

  const loadData = async () => {
    setLoading(true);
    try {
      // Fetch Name
      const { data: student } = await supabase
        .from('school_students')
        .select('name')
        .eq('id', studentId)
        .single();
      if (student) setStudentName(student.name);

      // Fetch Timeline
      const timeline = await PdiDocumentService.getStudentTimeline(studentId);
      setRecords(timeline);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const getIcon = (type: string) => {
    switch (type) {
      case 'EVALUATION':
        return <Activity size={16} className="text-purple-600" />;
      case 'LESSON_PLAN':
        return <BookOpen size={16} className="text-blue-600" />;
      case 'OCCURRENCE':
        return <AlertCircle size={16} className="text-red-600" />;
      case 'OBSERVATION':
        return <Quote size={16} className="text-emerald-600" />;
      default:
        return <FileText size={16} className="text-slate-600" />;
    }
  };

  const getTitle = (type: string) => {
    switch (type) {
      case 'EVALUATION':
        return 'Avaliação da Aprendizagem (Bloco X)';
      case 'LESSON_PLAN':
        return 'Proposta Pedagógica (Bloco VIII)';
      case 'OCCURRENCE':
        return 'Registro Ocorrência (Bloco VII)';
      case 'OBSERVATION':
        return 'Observação (Bloco V)';
      default:
        return 'Registro PDI';
    }
  };

  if (loading)
    return (
      <div className="p-8 text-center text-slate-400 text-xs font-bold uppercase">
        Carregando PDI...
      </div>
    );

  return (
    <div className="bg-white rounded-2xl border border-slate-100 overflow-hidden">
      <div className="p-6 bg-slate-50 border-b border-slate-100">
        <h3 className="text-lg font-black text-slate-800 uppercase italic tracking-tight">
          PDI Digital: {studentName}
        </h3>
        <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">
          Linha do Tempo de Acompanhamento
        </p>
      </div>

      <div className="p-6 relative">
        {/* Timeline Line */}
        <div className="absolute left-9 top-6 bottom-6 w-px bg-slate-100"></div>

        <div className="space-y-8">
          {records.length === 0 ? (
            <p className="text-center text-slate-400 text-sm py-8">
              Nenhum registro encontrado neste PDI ainda.
            </p>
          ) : (
            records.map((record) => (
              <div key={record.id} className="relative pl-12">
                {/* Dot */}
                <div className="absolute left-0 top-0 w-6 h-6 bg-white border border-slate-200 rounded-full flex items-center justify-center z-10 shadow-sm">
                  {getIcon(record.type)}
                </div>

                {/* Content */}
                <div className="bg-white border border-slate-100 rounded-xl p-4 shadow-sm hover:shadow-md transition-shadow">
                  <div className="flex justify-between items-start mb-2">
                    <div>
                      <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">
                        {getTitle(record.type)}
                      </p>
                      <h4 className="text-sm font-bold text-slate-800">{record.title}</h4>
                    </div>
                    <span className="text-[10px] font-bold text-slate-300 flex items-center gap-1 bg-slate-50 px-2 py-1 rounded">
                      <Calendar size={10} /> {new Date(record.date).toLocaleDateString('pt-BR')}
                    </span>
                  </div>

                  <div className="text-xs text-slate-600 leading-relaxed bg-slate-50/50 p-3 rounded-lg border border-slate-50">
                    {record.type === 'EVALUATION' ? (
                      <div>
                        <p>
                          <span className="font-bold">Disciplina:</span>{' '}
                          {(record.content as any).subject}
                        </p>
                        <p>
                          <span className="font-bold">Nota Total:</span>{' '}
                          {(record.content as any).points} pontos
                        </p>
                        <p>
                          <span className="font-bold">Período:</span>{' '}
                          {(record.content as any).period}
                        </p>
                      </div>
                    ) : record.type === 'OCCURRENCE' || record.type === 'OBSERVATION' ? (
                      <p>{(record.content as any).description}</p>
                    ) : (
                      <pre className="whitespace-pre-wrap font-sans">
                        {JSON.stringify(record.content, null, 2)}
                      </pre>
                    )}
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
};

export default StudentPdiView;
