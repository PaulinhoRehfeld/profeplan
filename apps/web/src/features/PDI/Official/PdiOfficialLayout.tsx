import React, { useEffect, useState } from 'react';
import { useForm, FormProvider } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { useParams, useNavigate } from 'react-router-dom';
import { Loader2, Save } from 'lucide-react';
import { PdiSchema, PDIProfileData } from '../../../types/pdi-schema';
import { PdiDocumentService } from '../../../services/pdi/PdiDocumentService';
import { PdiSidebar } from './components/PdiSidebar';
import { Section1Institutional } from './sections/Section1_Institutional';
import { Section2StudentData } from './sections/Section2_StudentData';
import { Section4Psychomotor } from './sections/Section4_Psychomotor';
import { Section5Cognitive } from './sections/Section5_Cognitive';
import { Section6Communication } from './sections/Section6_Communication';
import { Section7TeacherEval } from './sections/Section7_TeacherEval';
import { useProfeplanAuth } from '../../../hooks/useProfeplanAuth';
import { supabase } from '../../../services/supabaseClient';

// Placeholder for other sections
const ComingSoon = ({ title }: { title: string }) => (
  <div className="p-8 border-2 border-dashed border-slate-200 rounded-xl text-center text-slate-400">
    <h2 className="text-xl font-bold mb-2">{title}</h2>
    <p>Esta seção será implementada em breve.</p>
  </div>
);

export const PdiOfficialLayout: React.FC = () => {
  const { studentId } = useParams<{ studentId: string }>();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [activeSection, setActiveSection] = useState<string>('institutional');
  const [pdiId, setPdiId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const { userProfile } = useProfeplanAuth();
  const [studentName, setStudentName] = useState<string>('');

  // Initialize React Hook Form
  const methods = useForm<PDIProfileData>({
    resolver: zodResolver(PdiSchema),
    mode: 'onBlur', // Validate on blur
    defaultValues: {
      // Default values init
      institutional: {},
      student_data: {},
      clinical_health: {},
      psychomotor: {},
      cognitive: {},
      communication: {},
      teacher_evaluations: [],
    },
  });

  const { reset, getValues } = methods;

  // Load PDI Data
  useEffect(() => {
    if (!studentId) return;

    const loadPdi = async () => {
      setLoading(true);
      try {
        // Fetch student name first for context
        const { data: student } = await supabase
          .from('school_students')
          .select('name')
          .eq('id', studentId)
          .single();

        if (student) setStudentName(student.name);

        // Default to current year or let backend handle it
        const result = await PdiDocumentService.getOrCreatePdi(
          studentId,
          new Date().getFullYear(),
          { profile: userProfile, studentName: student?.name }
        );

        if (result.error) throw result.error;
        if (result.data) {
          setPdiId(result.data.id);
          // Reset form with fetched content data
          reset(result.data.content_data as PDIProfileData);
        }
      } catch (error) {
        console.error('Failed to load PDI:', error);
        alert('Erro ao carregar PDI. Veja console.');
      } finally {
        setLoading(false);
      }
    };

    loadPdi();
  }, [studentId, reset]);

  // Auto-Save Logic (Debounced or generic handler)
  const handleSaveSection = async (sectionKey: keyof PDIProfileData) => {
    if (!pdiId) return;
    setSaving(true);
    try {
      const currentData = getValues();
      const sectionData = currentData[sectionKey];

      // Call Service
      await PdiDocumentService.updatePdiSection(pdiId, sectionKey, sectionData);

      // Optional: Show toast
    } catch (error) {
      console.error('Auto-save failed:', error);
    } finally {
      setSaving(false);
    }
  };

  if (loading)
    return (
      <div className="flex h-screen items-center justify-center">
        <Loader2 className="animate-spin w-8 h-8 text-blue-600" />
        <span className="ml-3 font-bold text-slate-600">Carregando PDI...</span>
      </div>
    );

  const renderActiveSection = () => {
    switch (activeSection) {
      case 'institutional':
        return <Section1Institutional onSave={() => handleSaveSection('institutional')} />;
      case 'student_data':
        return <Section2StudentData onSave={() => handleSaveSection('student_data')} />;
      case 'clinical_health':
        return <ComingSoon title="Seção III - Dados Clínicos" />;
      case 'psychomotor':
        return <Section4Psychomotor onSave={() => handleSaveSection('psychomotor')} />;
      case 'cognitive':
        return <Section5Cognitive onSave={() => handleSaveSection('cognitive')} />;
      case 'communication':
        return <Section6Communication onSave={() => handleSaveSection('communication')} />;
      case 'teacher_evaluations':
        return (
          <Section7TeacherEval
            onSave={() => handleSaveSection('teacher_evaluations' as keyof PDIProfileData)}
          />
        );
      default:
        return <Section1Institutional onSave={() => handleSaveSection('institutional')} />;
    }
  };

  return (
    <div className="flex h-screen bg-slate-50 overflow-hidden font-sans">
      {/* Form Provider Wraps Everything */}
      <FormProvider {...methods}>
        <PdiSidebar activeSection={activeSection} onSelectSection={setActiveSection} />

        <main className="flex-1 flex flex-col h-full overflow-hidden">
          {/* Header */}
          <header className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm">
            <div>
              <span className="text-xs font-black text-slate-400 uppercase tracking-widest">
                Plano de Desenvolvimento Individual
              </span>
              <h1 className="text-lg font-bold text-slate-900">PDI Oficial - Governo de Minas</h1>
            </div>

            <div className="flex items-center gap-4">
              {saving ? (
                <div className="flex items-center gap-2 text-blue-600 text-xs font-bold animate-pulse">
                  <Save className="w-4 h-4" /> Salvando...
                </div>
              ) : (
                <div className="flex items-center gap-2 text-green-600 text-xs font-bold">
                  <Save className="w-4 h-4" /> Salvo
                </div>
              )}
              <button
                onClick={() => navigate(-1)}
                className="px-4 py-2 text-slate-500 hover:bg-slate-100 rounded-lg text-sm font-bold"
              >
                Voltar
              </button>
            </div>
          </header>

          {/* Content Scrollable Area */}
          <div className="flex-1 overflow-y-auto p-8 md:p-12 scroll-smooth">
            <div className="max-w-4xl mx-auto bg-white rounded-2xl shadow-sm border border-slate-200 p-8 min-h-[500px]">
              {renderActiveSection()}
            </div>

            <div className="max-w-4xl mx-auto mt-8 text-center opacity-50">
              <img
                src="/logo-profeplan.png"
                className="h-8 mx-auto mb-2 grayscale"
                alt="Profeplan"
              />
              <p className="text-[10px] uppercase font-black tracking-widest text-slate-400">
                Documento Oficial • Confidencial
              </p>
            </div>
          </div>
        </main>
      </FormProvider>
    </div>
  );
};
