import React, { useState, useEffect } from 'react';
import {
  Presentation,
  MonitorPlay,
  Sparkles,
  RefreshCw,
  Layers,
  Type,
  Palette,
  SlidersHorizontal,
  Image as ImageIcon,
  Download,
  LayoutTemplate,
  Save,
  ChevronLeft,
  ChevronRight,
  X,
  Clock,
} from 'lucide-react';
import { generatePresentationJSON } from '../services/ai/AiPresentationService';
import { getTeacherContext } from '../services/supabaseService';
import { savePresentation } from '../features/Presentation/PresentationService';
import CanvaExportModal from './CanvaExportModal';
import PresentationModal from './PresentationModal';

interface PresentationCreatorProps {
  userId: string;
  setSidebarContent?: (content: React.ReactNode) => void;
}

const PresentationCreator: React.FC<PresentationCreatorProps> = ({ userId, setSidebarContent }) => {
  // Estados do Formulário
  const [topic, setTopic] = useState('');
  const [slideCount, setSlideCount] = useState(8);
  const [visualStyle, setVisualStyle] = useState('Moderno e Clean');
  const [includeInteractions, setIncludeInteractions] = useState(true);
  const [isGenerating, setIsGenerating] = useState(false);
  const [recentLessons, setRecentLessons] = useState<any[]>([]);

  // Estados Funcionais
  const [generatedPresentation, setGeneratedPresentation] = useState<any | null>(null);
  const [isCanvaModalOpen, setIsCanvaModalOpen] = useState(false);
  const [isPreziModalOpen, setIsPreziModalOpen] = useState(false);
  const [isPresenting, setIsPresenting] = useState(false);
  const [currentSlideIndex, setCurrentSlideIndex] = useState(0);

  // Carregar Aulas Recentes
  useEffect(() => {
    const fetchRecent = async () => {
      try {
        const { recentLessons } = await getTeacherContext(userId, 4);
        setRecentLessons(recentLessons || []);
      } catch (error) {
        console.error('Erro ao buscar aulas recentes:', error);
      }
    };
    fetchRecent();
  }, [userId]);

  // Efeito para injetar a Sidebar Dinâmica (Command Center)
  useEffect(() => {
    if (!setSidebarContent) return;

    if (generatedPresentation) {
      // Sidebar quando JÁ TEMOS a apresentação gerada
      setSidebarContent(
        <div className="space-y-6 animate-in slide-in-from-right-4 duration-500">
          <div className="bg-gradient-to-br from-fuchsia-50 to-purple-50 border border-fuchsia-100 rounded-[2.5rem] p-6 shadow-lg">
            <h3 className="text-[10px] font-black text-fuchsia-600 uppercase tracking-[0.2em] mb-6 italic">
              Estúdio de Slides
            </h3>

            <div className="space-y-3">
              <button
                onClick={() => setIsCanvaModalOpen(true)}
                className="w-full bg-gradient-to-r from-purple-600 to-fuchsia-600 text-white px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:scale-105 transition-all shadow-lg active:scale-95 group"
              >
                <Sparkles size={18} className="animate-pulse" />
                Editar no Canva
              </button>

              <button
                onClick={() => setIsPreziModalOpen(true)}
                className="w-full bg-indigo-600 text-white px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-indigo-700 hover:scale-105 transition-all shadow-lg active:scale-95 group"
              >
                <Presentation
                  size={18}
                  className="group-hover:translate-y-0.5 transition-transform"
                />
                Base para Prezi
              </button>

              <button
                onClick={() => setIsPresenting(true)}
                className="w-full bg-white text-purple-700 px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-purple-50 border border-purple-100 transition-all shadow-sm active:scale-95 group"
              >
                <MonitorPlay
                  size={18}
                  className="group-hover:translate-x-0.5 transition-transform"
                />
                Apresentar Agora
              </button>

              <button
                onClick={handleSavePresentation}
                className="w-full bg-white text-slate-700 px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-slate-50 border border-slate-200 transition-all shadow-sm active:scale-95 group"
              >
                <Save size={18} className="group-hover:scale-110 transition-transform" />
                Salvar na Memória
              </button>

              <button
                onClick={() => setGeneratedPresentation(null)}
                className="w-full bg-slate-100 text-slate-500 px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-slate-200 transition-all active:scale-95 group"
              >
                <RefreshCw
                  size={18}
                  className="group-hover:rotate-180 transition-transform duration-500"
                />
                Regerar / Novo
              </button>
            </div>
          </div>

          <div className="bg-slate-900 rounded-[2.5rem] p-6 shadow-xl text-white relative overflow-hidden">
            <div className="absolute top-0 right-0 w-32 h-32 bg-fuchsia-500/10 blur-3xl"></div>
            <h3 className="text-[9px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4 flex items-center gap-2">
              <LayoutTemplate size={12} className="text-fuchsia-400" /> Status da Aula
            </h3>
            <div className="grid grid-cols-2 gap-4">
              <div className="bg-white/5 p-3 rounded-2xl text-center">
                <p className="text-[9px] text-slate-400 uppercase tracking-widest mb-1">Slides</p>
                <p className="text-xl font-black">{generatedPresentation.slides.length}</p>
              </div>
              <div className="bg-white/5 p-3 rounded-2xl text-center">
                <p className="text-[9px] text-slate-400 uppercase tracking-widest mb-1">
                  Tempo Est.
                </p>
                <p className="text-xl font-black text-fuchsia-400">
                  ~{generatedPresentation.slides.length * 2}min
                </p>
              </div>
            </div>
          </div>
        </div>
      );
    } else {
      // Sidebar Inicial (Configuração) - Oculta os campos genéricos
      setSidebarContent(
        <div className="space-y-6 animate-in fade-in duration-500">
          <div className="bg-white border border-slate-100 rounded-[2.5rem] p-6 shadow-sm">
            <h3 className="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4 italic">
              Ações de Apresentação
            </h3>
            <p className="text-xs text-slate-500 font-medium leading-relaxed">
              Configure os parâmetros ao lado para gerar sua aula visual. O assistente criará a
              estrutura completa para exportação.
            </p>
          </div>
        </div>
      );
    }

    return () => setSidebarContent(null);
  }, [generatedPresentation, setSidebarContent]);

  const handleGenerate = async () => {
    if (!topic) return alert('Por favor, defina um tema ou selecione uma aula.');

    setIsGenerating(true);
    try {
      // Chama a nova função JSON do Gemini
      const result = await generatePresentationJSON(
        topic,
        '', // Contexto (pode vir de select no futuro)
        slideCount,
        visualStyle,
        includeInteractions,
        userId
      );
      setGeneratedPresentation(result);
    } catch (e: any) {
      alert('Erro ao gerar slides: ' + e.message);
    } finally {
      setIsGenerating(false);
    }
  };

  const handleSavePresentation = async () => {
    if (!generatedPresentation) return;

    try {
      await savePresentation(userId, generatedPresentation);
      alert('Apresentação salva com sucesso!');
    } catch (error) {
      console.error('Erro ao salvar:', error);
      alert('Erro ao salvar apresentação.');
    }
  };

  const handleNextSlide = () => {
    if (generatedPresentation && currentSlideIndex < generatedPresentation.slides.length - 1) {
      setCurrentSlideIndex((prev) => prev + 1);
    }
  };

  const handlePrevSlide = () => {
    if (currentSlideIndex > 0) {
      setCurrentSlideIndex((prev) => prev - 1);
    }
  };

  // Transformação para o formato CSV do CanvaModal
  const getCSVData = () => {
    if (!generatedPresentation) return '';
    // Header
    let csv = 'Titulo_Slide;Conteudo_Texto;Sugestao_Imagem;Nota_Orador\n';
    // Rows
    generatedPresentation.slides.forEach((s: any) => {
      const content = s.contentBulletPoints?.join(' | ') || '';
      const safeContent = content.replace(/;/g, ',');
      const safeTitle = s.title.replace(/;/g, ',');
      const safeImg = (s.imageSearchQuery || s.imageSuggestion || '').replace(/;/g, ',');
      const safeNote = (s.speakerNotes || '').replace(/;/g, ',');
      csv += `${safeTitle};${safeContent};${safeImg};${safeNote}\n`;
    });
    return csv;
  };

  // MODO APRESENTAÇÃO (FULL SCREEN OVERLAY)
  if (isPresenting && generatedPresentation) {
    const slide = generatedPresentation.slides[currentSlideIndex];
    return (
      <div className="fixed inset-0 bg-slate-900 z-50 flex flex-col items-center justify-center text-white">
        <button
          onClick={() => setIsPresenting(false)}
          className="absolute top-6 right-6 p-2 bg-white/10 hover:bg-white/20 rounded-full transition-colors"
        >
          <X size={24} />
        </button>

        <div className="w-full max-w-6xl aspect-video bg-white text-slate-900 rounded-3xl p-16 shadow-2xl relative overflow-hidden flex flex-col">
          {/* Background Decor */}
          <div
            className={`absolute top-0 right-0 w-96 h-96 rounded-full blur-3xl opacity-30 pointer-events-none -mr-20 -mt-20 ${visualStyle.includes('Lúdico') ? 'bg-yellow-400' : 'bg-fuchsia-600'}`}
          ></div>

          {/* Header Slide */}
          <div className="mb-12 relative z-10 flex justify-between items-start">
            <div>
              <span className="text-sm font-black text-slate-400 uppercase tracking-[0.2em] mb-2 block">
                Slide {slide.order} / {generatedPresentation.slides.length}
              </span>
              <h1 className="text-5xl font-black text-slate-900 leading-tight max-w-4xl">
                {slide.title}
              </h1>
            </div>
            {slide.type === 'interacao' && (
              <div className="bg-fuchsia-100 text-fuchsia-600 px-4 py-2 rounded-full font-bold text-sm uppercase tracking-widest animate-pulse">
                Interação
              </div>
            )}
          </div>

          {/* Content */}
          <div className="flex-1 relative z-10 grid grid-cols-2 gap-12">
            <div className="space-y-6">
              <ul className="space-y-4">
                {slide.contentBulletPoints?.map((pt: string, i: number) => (
                  <li
                    key={i}
                    className="text-2xl font-medium text-slate-700 flex gap-4 leading-relaxed"
                  >
                    <span className="text-fuchsia-500 mt-2">•</span> {pt}
                  </li>
                ))}
              </ul>
            </div>
            <div className="flex items-center justify-center bg-slate-100 rounded-3xl border-2 border-dashed border-slate-300 relative group">
              <div className="text-center p-8">
                <ImageIcon
                  size={48}
                  className="mx-auto text-slate-300 mb-4 group-hover:scale-110 transition-transform"
                />
                <p className="text-sm text-slate-400 italic font-medium max-w-xs mx-auto">
                  "{slide.imageSearchQuery || slide.imageSuggestion}"
                </p>
              </div>
            </div>
          </div>

          {/* Speaker Notes (Opcional - só mostra se passar o mouse perto do rodapé?) - Por enquanto fixo no rodapé bem discreto */}
          <div className="mt-8 pt-6 border-t border-slate-100">
            <p className="text-sm text-slate-400 font-medium italic">
              <span className="font-bold text-slate-500 not-italic uppercase tracking-wider mr-2">
                Roteiro:
              </span>
              {slide.speakerNotes}
            </p>
          </div>
        </div>

        {/* Controls */}
        <div className="absolute bottom-8 flex items-center gap-6">
          <button
            onClick={handlePrevSlide}
            disabled={currentSlideIndex === 0}
            className="p-4 bg-white/10 hover:bg-white/20 rounded-full disabled:opacity-30 transition-all active:scale-95"
          >
            <ChevronLeft size={32} />
          </button>
          <span className="text-xl font-black tracking-widest">
            {currentSlideIndex + 1} / {generatedPresentation.slides.length}
          </span>
          <button
            onClick={handleNextSlide}
            disabled={currentSlideIndex === generatedPresentation.slides.length - 1}
            className="p-4 bg-white/10 hover:bg-white/20 rounded-full disabled:opacity-30 transition-all active:scale-95"
          >
            <ChevronRight size={32} />
          </button>
        </div>
      </div>
    );
  }

  // MODO EDITOR (PADRÃO)
  if (generatedPresentation) {
    return (
      <div className="w-full max-w-6xl mx-auto space-y-8 animate-in slide-in-from-bottom-8 duration-700">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-3xl font-black text-slate-900 tracking-tight uppercase italic break-words max-w-2xl">
              {generatedPresentation.title}
            </h2>
            <p className="text-xs font-bold text-fuchsia-600 uppercase tracking-widest mt-2 flex items-center gap-2">
              <LayoutTemplate size={14} /> Tema Visual: {generatedPresentation.theme}
            </p>
          </div>
        </div>

        {/* Grid de Slides (Preview) */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {generatedPresentation.slides.map((slide: any, idx: number) => (
            <div
              key={idx}
              className="bg-white border border-slate-200 rounded-[2rem] overflow-hidden shadow-sm hover:shadow-xl transition-all group hover:-translate-y-1 cursor-pointer"
              onClick={() => {
                setCurrentSlideIndex(idx);
                setIsPresenting(true);
              }}
            >
              {/* Header do Slide */}
              <div className="bg-slate-50 px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                <span className="text-[10px] font-black text-slate-400 uppercase tracking-widest">
                  Slide {slide.order} • {slide.type}
                </span>
                {slide.type === 'interacao' && <Sparkles size={14} className="text-fuchsia-500" />}
              </div>

              {/* Conteúdo do Slide */}
              <div className="p-6 h-64 overflow-y-auto custom-scrollbar">
                <h4 className="font-bold text-lg text-slate-800 mb-4 leading-tight">
                  {slide.title}
                </h4>
                <ul className="space-y-2 mb-6">
                  {slide.contentBulletPoints?.map((pt: string, i: number) => (
                    <li key={i} className="text-xs text-slate-600 font-medium flex gap-2">
                      <span className="text-fuchsia-400">•</span> {pt}
                    </li>
                  ))}
                </ul>
                {(slide.imageSearchQuery || slide.imageSuggestion) && (
                  <div className="bg-fuchsia-50 p-3 rounded-xl border border-fuchsia-100 flex gap-3 items-center">
                    <ImageIcon size={16} className="text-fuchsia-500 shrink-0" />
                    <p className="text-[9px] text-fuchsia-800 italic leading-tight line-clamp-3">
                      IMG: {slide.imageSearchQuery || slide.imageSuggestion}
                    </p>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>

        <CanvaExportModal
          isOpen={isCanvaModalOpen}
          onClose={() => setIsCanvaModalOpen(false)}
          data={getCSVData()}
        />

        {generatedPresentation && (
          <PresentationModal
            isOpen={isPreziModalOpen}
            onClose={() => setIsPreziModalOpen(false)}
            title={generatedPresentation.title}
            content={getPreziMarkdownFromPresentation(generatedPresentation)}
            subtitle="Base para Prezi (cole este roteiro em uma nova apresentação)"
            showPreziInvite
          />
        )}
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-10 animate-in fade-in duration-500">
      <div className="text-center space-y-4">
        <div className="w-16 h-16 bg-gradient-to-br from-purple-600 to-fuchsia-600 rounded-3xl mx-auto flex items-center justify-center text-white shadow-2xl shadow-purple-200 mb-6">
          <Presentation size={32} />
        </div>
        <h2 className="text-3xl font-black text-slate-900 tracking-tight uppercase italic">
          Criar Apresentação de Impacto
        </h2>
        <p className="text-sm font-medium text-slate-500 max-w-lg mx-auto">
          Transforme suas ideias em slides visuais automaticamente. Selecione o tema, configure o
          estilo e deixe a IA estruturar sua aula.
        </p>
      </div>

      <div className="bg-white border border-slate-200 rounded-[3rem] p-10 shadow-xl shadow-slate-200/50 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-64 bg-fuchsia-50 rounded-full blur-3xl -z-10 -mr-20 -mt-20 opacity-50"></div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {/* Coluna 1: O que? */}
          <div className="space-y-6">
            <div className="space-y-3">
              <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                Tema ou Assunto da Aula
              </label>
              <div className="space-y-2">
                {recentLessons.length > 0 && (
                  <select
                    onChange={(e) => setTopic(e.target.value)}
                    className="w-full px-6 py-4 bg-purple-50 border border-purple-100 rounded-2xl text-xs font-bold text-purple-800 outline-none focus:ring-2 focus:ring-purple-200 cursor-pointer appearance-none"
                  >
                    <option value="">✨ Selecionar aula recente...</option>
                    {recentLessons.map((l, i) => (
                      <option key={i} value={l.topic}>
                        {l.topic}
                      </option>
                    ))}
                  </select>
                )}
                <input
                  type="text"
                  value={topic}
                  onChange={(e) => setTopic(e.target.value)}
                  placeholder="Ou digite um tema novo..."
                  className="w-full px-6 py-5 bg-slate-50 border border-slate-200 rounded-2xl font-bold text-slate-900 outline-none focus:ring-2 focus:ring-purple-100 focus:bg-white transition-all shadow-inner"
                />
              </div>
            </div>

            <div className="space-y-3">
              <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                Quantidade de Slides
              </label>
              <div className="flex items-center gap-4 bg-slate-50 p-2 rounded-2xl border border-slate-200">
                <input
                  type="range"
                  min="5"
                  max="20"
                  step="1"
                  value={slideCount}
                  onChange={(e) => setSlideCount(Number(e.target.value))}
                  className="flex-1 h-2 bg-slate-200 rounded-lg appearance-none cursor-pointer accent-purple-600 ml-4"
                />
                <span className="w-12 h-10 flex items-center justify-center bg-white rounded-xl font-black text-purple-600 text-sm shadow-sm">
                  {slideCount}
                </span>
              </div>
            </div>
          </div>

          {/* Coluna 2: Como? */}
          <div className="space-y-6">
            <div className="space-y-3">
              <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                Estilo Visual
              </label>
              <div className="grid grid-cols-2 gap-3">
                {['Moderno', 'Lúdico', 'Corporativo', 'Minimalista'].map((s) => (
                  <button
                    key={s}
                    onClick={() => setVisualStyle(s)}
                    className={`p-3 rounded-2xl text-xs font-bold border-2 transition-all ${
                      visualStyle === s
                        ? 'border-purple-600 bg-purple-50 text-purple-700'
                        : 'border-transparent bg-slate-50 text-slate-500 hover:bg-slate-100'
                    }`}
                  >
                    {s}
                  </button>
                ))}
              </div>
            </div>

            <div className="flex items-center justify-between bg-slate-50 p-4 rounded-2xl border border-slate-200">
              <div className="flex items-center gap-3">
                <div className="bg-white p-2 rounded-xl text-fuchsia-500 shadow-sm">
                  <Sparkles size={16} />
                </div>
                <div>
                  <p className="text-xs font-bold text-slate-900">Incluir Interações</p>
                  <p className="text-[10px] text-slate-400">Perguntas e enquetes</p>
                </div>
              </div>
              <button
                onClick={() => setIncludeInteractions(!includeInteractions)}
                className={`w-12 h-7 rounded-full transition-colors flex items-center px-1 ${includeInteractions ? 'bg-fuchsia-500' : 'bg-slate-300'}`}
              >
                <div
                  className={`w-5 h-5 bg-white rounded-full shadow-md transform transition-transform ${includeInteractions ? 'translate-x-5' : 'translate-x-0'}`}
                />
              </button>
            </div>
          </div>
        </div>

        <div className="pt-8 mt-4 border-t border-slate-100">
          <button
            onClick={handleGenerate}
            disabled={isGenerating || !topic}
            className="w-full py-6 bg-slate-900 hover:bg-purple-700 text-white rounded-[2rem] font-black text-sm uppercase tracking-[0.2em] shadow-2xl shadow-purple-200 transition-all hover:scale-[1.01] active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3"
          >
            {isGenerating ? <RefreshCw className="animate-spin" /> : <Layers />}
            {isGenerating ? 'Criando Roteiro Visual...' : 'Gerar Apresentação'}
          </button>
        </div>
      </div>
    </div>
  );
};

// Helper para montar a base Prezi a partir de generatedPresentation
function getPreziMarkdownFromPresentation(presentation: any): string {
  if (!presentation || !presentation.slides) return '';

  const lines: string[] = [];
  lines.push(`# ${presentation.title || 'Apresentação'}`);
  lines.push('');
  lines.push(`Tema visual: **${presentation.theme || 'Padrão'}**`);
  lines.push('');

  presentation.slides.forEach((slide: any) => {
    lines.push(`## Slide ${slide.order} – ${slide.title}`);
    if (Array.isArray(slide.contentBulletPoints) && slide.contentBulletPoints.length > 0) {
      slide.contentBulletPoints.forEach((pt: string) => {
        lines.push(`- ${pt}`);
      });
    }
    const imageQuery = slide.imageSearchQuery || slide.imageSuggestion;
    if (imageQuery) {
      lines.push('');
      lines.push(`> Sugestão de imagem: _${imageQuery}_`);
    }
    if (slide.speakerNotes) {
      lines.push('');
      lines.push(`> Notas para o professor: _${slide.speakerNotes}_`);
    }
    lines.push('');
  });

  lines.push('---');
  lines.push('');
  lines.push('**Instruções sugeridas para o Prezi:**');
  lines.push('1. Acesse o Prezi e crie uma nova apresentação em branco.');
  lines.push('2. Se ainda não tiver conta, use o convite informado acima no modal.');
  lines.push(
    '3. Use cada seção de `## Slide ...` como base para um quadro (frame) da apresentação.'
  );
  lines.push(
    '4. Copie os bullet points para o conteúdo de cada quadro e ajuste o design como preferir.'
  );

  return lines.join('\n');
}

export default PresentationCreator;
