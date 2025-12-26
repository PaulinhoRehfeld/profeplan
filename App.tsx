
import React, { useState, useRef, useEffect } from 'react';
import { 
  Send, Bot, User, Menu, X, 
  Image as ImageIcon, Database, 
  PenTool, BrainCircuit, Loader2, Sparkle, 
  RefreshCcw, Info, FileText, Download, Copy, Check, Cloud,
  Mic, MicOff, Square, Key, Crown, AlertCircle
} from 'lucide-react';

// Componentes Locais
import Sidebar from './components/Sidebar';
import SettingsModal from './components/SettingsModal';
import LoginScreen from './components/LoginScreen';
import DriveExplorer from './components/DriveExplorer';
import MarkdownRenderer from './components/MarkdownRenderer';
import AdminDashboard from './components/AdminDashboard';

// Tipos e Serviços
import { Message, MessageRole, ToolMode, UserSettings, UserSession } from './types'; // Removed DriveFile
import { generateProfePlanStream } from './services/geminiService';
import { exportToDocx } from './services/exportService';
import { saveGeneratedContent, updateLearningProfile } from './services/databaseService';
import { INITIAL_GREETING } from './constants';

// REMOVIDO: GOOGLE_CLIENT_ID
// const GOOGLE_CLIENT_ID = '1074092770295-v0k138s26e7v69n56n614p11f7o06990.apps.googleusercontent.com';

const App: React.FC = () => {
  const [session, setSession] = useState<UserSession | null>(() => {
    try {
      const saved = localStorage.getItem('profeplan_session');
      return saved ? JSON.parse(saved) : null;
    } catch (e) {
      return null;
    }
  });

  const [settings, setSettings] = useState<UserSettings>(() => {
    try {
      const saved = localStorage.getItem('profeplan_settings');
      return saved ? JSON.parse(saved) : {
        userName: 'Professor(a)',
        institution: '',
        network: 'Estadual',
        stateUF: 'MG',
        favoriteMethodology: 'Gamification',
        toneOfVoice: 'Prático e Inspiracional',
        detailLevel: 'Completo',
        theme: 'light'
      };
    } catch (e) {
      return {
        userName: 'Professor(a)',
        institution: '',
        network: 'Estadual',
        stateUF: 'MG',
        favoriteMethodology: 'Gamification',
        toneOfVoice: 'Prático e Inspiracional',
        detailLevel: 'Completo',
        theme: 'light'
      };
    }
  });

  useEffect(() => {
    localStorage.setItem('profeplan_settings', JSON.stringify(settings));
  }, [settings]);

  // REMOVIDO: Estados relacionados ao Google Drive
  // const [googleToken, setGoogleToken] = useState<string | null>(() => localStorage.getItem('google_drive_token'));
  const [activeMode, setActiveMode] = useState<ToolMode>(ToolMode.CHAT);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isMobileNavOpen, setIsMobileNavOpen] = useState(false);
  const [selectedImage, setSelectedImage] = useState<{data: string, type: string} | null>(null);
  const [input, setInput] = useState('');
  const [isThinking, setIsThinking] = useState(false);
  // REMOVIDO: Estado isSavingToDrive
  // const [isSavingToDrive, setIsSavingToDrive] = useState(false);
  const [discipline, setDiscipline] = useState('');
  const [grade, setGrade] = useState('');
  const [error, setError] = useState('');
  
  // const [geminiApiKeySelected, setGeminiApiKeySelected] = useState(false); // REMOVIDO
  const [isLeftNavExpanded, setIsLeftNavExpanded] = useState(true);

  const [messages, setMessages] = useState<Message[]>(() => {
    if (!session) return [];
    try {
      const saved = localStorage.getItem(`profeplan_chat_${session.email}`);
      if (saved) {
        const parsed = JSON.parse(saved);
        return parsed.map((m: any) => ({ ...m, timestamp: new Date(m.timestamp) }));
      }
    } catch (e) {}
    return [{ id: 'initial', role: MessageRole.ASSISTANT, content: INITIAL_GREETING, timestamp: new Date() }];
  });

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (session) {
      localStorage.setItem(`profeplan_chat_${session.email}`, JSON.stringify(messages));
    }
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, session]);

  // REMOVIDO: Lógica de verificação da chave de API do Gemini pelo window.aistudio
  /*
  useEffect(() => {
    const checkKey = async () => {
      if (window.aistudio && typeof window.aistudio.hasSelectedApiKey === 'function') {
        const hasKey = await window.aistudio.hasSelectedApiKey();
        setGeminiApiKeySelected(hasKey);
      } else {
        setGeminiApiKeySelected(true); 
      }
    };
    checkKey();
  }, []);
  */

  // REMOVIDO: Função para seleção da chave de API do Gemini
  /*
  const handleSelectGeminiApiKey = async () => {
    if (window.aistudio && typeof window.aistudio.openSelectKey === 'function') {
      await window.aistudio.openSelectKey();
      setGeminiApiKeySelected(true);
      setError(''); 
    }
  };
  */

  if (!session || !session.isLoggedIn) {
    return <LoginScreen onLogin={setSession} />;
  }

  // REMOVIDO: handleConnectDrive
  /*
  const handleConnectDrive = () => {
    const google = (window as any).google;
    if (!google) return;
    const client = google.accounts.oauth2.initTokenClient({
      client_id: GOOGLE_CLIENT_ID,
      scope: 'https://www.googleapis.com/auth/drive.file',
      callback: (response: any) => {
        if (response.access_token) {
          setGoogleToken(response.access_token);
          localStorage.setItem('google_drive_token', response.access_token);
        }
      },
    });
    client.requestAccessToken({ prompt: 'consent' });
  };
  */

  // REMOVIDO: handleSaveGoogleDocs
  /*
  const handleSaveGoogleDocs = async () => {
    if (!googleToken) { setIsSettingsOpen(true); return; }
    const lastAiMessage = [...messages].reverse().find(m => m.role === MessageRole.ASSISTANT && m.id !== 'initial');
    if (!lastAiMessage) return;

    setIsSavingToDrive(true);
    try {
      const fileName = `PROFEPLAN - ${discipline || 'Documento'} - ${grade || 'Geral'}`;
      let customContent = (settings.headerText ? settings.headerText + "\n\n" : "") + 
                         lastAiMessage.content + 
                         (settings.footerText ? "\n\n" + settings.footerText : "");

      const createResponse = await fetch('https://www.googleapis.com/drive/v3/files', {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${googleToken}`, 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: fileName, mimeType: 'application/vnd.google-apps.document' })
      });
      const file = await createResponse.json();
      await fetch(`https://www.googleapis.com/upload/drive/v3/files/${file.id}?uploadType=media`, {
        method: 'PATCH',
        headers: { 'Authorization': `Bearer ${googleToken}`, 'Content-Type': 'text/plain; charset=UTF-8' },
        body: customContent
      });
      window.open(`https://docs.google.com/document/d/${file.id}/edit`, '_blank');
    } catch (err) {
      setError("Erro ao salvar no Google Drive. Verifique sua conexão.");
    } finally { 
      setIsSavingToDrive(false); 
    }
  };
  */

  const handleExportDocx = async () => {
    const lastAiMsg = [...messages].reverse().find(m => m.role === MessageRole.ASSISTANT && m.id !== 'initial');
    if (!lastAiMsg) return;
    const title = `PROFEPLAN_${discipline || 'Doc'}_${new Date().toLocaleDateString('pt-BR').replace(/\//g, '-')}`;
    await exportToDocx(lastAiMsg.content, title, settings);
  };

  const mapModeToType = (mode: ToolMode): 'plano' | 'aula' | 'avaliacao' | 'documento' => {
    switch(mode) {
      case ToolMode.PLANNING: return 'plano';
      case ToolMode.ACTIVITIES: return 'aula';
      case ToolMode.SIMULATION: return 'avaliacao';
      default: return 'documento';
    }
  };

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() && !selectedImage) return;
    // if (!geminiApiKeySelected) { handleSelectGeminiApiKey(); return; } // REMOVIDO: Validação da chave de API

    const currentMsg = input;
    const currentImg = selectedImage;
    const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: currentMsg, timestamp: new Date() };
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setSelectedImage(null);
    setIsThinking(true);

    try {
      const history = messages.slice(-10).map(m => ({ 
        role: m.role === MessageRole.USER ? 'user' : 'model', 
        parts: [{ text: m.content }] 
      }));
      const stream = await generateProfePlanStream(currentMsg, history, activeMode, currentImg ? { inlineData: { data: currentImg.data.split(',')[1], mimeType: currentImg.type } } : undefined);
      
      let fullText = '';
      const aiId = (Date.now() + 1).toString();
      setMessages(prev => [...prev, { id: aiId, role: MessageRole.ASSISTANT, content: '', timestamp: new Date() }]);

      for await (const chunk of stream) {
        fullText += chunk.text || '';
        setMessages(prev => prev.map(m => m.id === aiId ? { ...m, content: fullText } : m));
      }

      // Persistência automática no Supabase após geração completa
      if (fullText.trim().length > 50) {
        const type = mapModeToType(activeMode);
        
        // Geração do título a partir da solicitação do professor
        const cleanedPrompt = currentMsg
          .replace(/^(crie (um|uma)|elabore (um|uma)|gere (um|uma)|desenvolva (um|uma)|faça (um|uma)|escreva (um|uma)|sobre a|sobre o|uma|um|o|a)\s*/i, '')
          .trim();
        const topicForTitle = cleanedPrompt.length > 70 ? cleanedPrompt.substring(0, 70) + '...' : cleanedPrompt;
        const finalTitle = `${type.toUpperCase()} - ${topicForTitle.charAt(0).toUpperCase() + topicForTitle.slice(1) || 'Documento'}`;

        await saveGeneratedContent(session.id, type, finalTitle, fullText);
        await updateLearningProfile(session.id, {
          last_mode: activeMode,
          last_discipline: discipline,
          last_grade: grade
        });
      }
    } catch (err) {
      console.error("Erro API:", err);
      // ALTERADO: Mensagem de erro sem referência à chave de API Gemini
      setError("Houve uma falha na geração. Verifique sua conexão com a internet.");
    } finally { 
      setIsThinking(false); 
    }
  };

  return (
    <div className="flex h-screen bg-slate-50 overflow-hidden font-sans">
      <Sidebar 
        activeMode={activeMode} setActiveMode={setActiveMode} 
        onOpenSettings={() => setIsSettingsOpen(true)} 
        isOpen={isMobileNavOpen} onClose={() => setIsMobileNavOpen(false)} 
        userRole={session.role} isDesktopExpanded={isLeftNavExpanded}
        onToggleDesktopExpand={() => setIsLeftNavExpanded(prev => !prev)}
      />
      
      <main className={`flex-1 flex flex-col relative h-full transition-all duration-300 ${isLeftNavExpanded ? 'lg:ml-64' : 'lg:ml-20'}`}>
        <header className="h-20 bg-white/90 backdrop-blur-xl border-b border-slate-100 flex items-center justify-between px-10 z-50 sticky top-0 shadow-sm">
          <div className="flex items-center gap-4">
             <button onClick={() => setIsMobileNavOpen(true)} className="lg:hidden p-2 text-slate-500"><Menu size={24} /></button>
             <div className="flex flex-col">
                <h2 className="font-black text-slate-900 tracking-tighter uppercase italic text-lg leading-none">PROFEPLAN v3.3</h2>
                <div className="flex items-center gap-2 mt-1">
                  <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full animate-pulse"></span>
                  <span className="text-[9px] font-black text-slate-400 uppercase tracking-widest">{activeMode}</span>
                </div>
             </div>
          </div>
          <div className="flex items-center gap-4">
            {/* REMOVIDO: Botão de Configurar API Key */}
            {/*
            {!geminiApiKeySelected && (
              <button onClick={handleSelectGeminiApiKey} className="px-4 py-2 bg-red-50 text-red-600 rounded-xl text-[10px] font-black uppercase tracking-widest border border-red-200 animate-pulse">
                 Configurar API Key
              </button>
            )}
            */}
            <div className="h-8 w-px bg-slate-100 mx-2"></div>
            <div className="flex items-center gap-3">
               <div className="text-right hidden sm:block">
                  <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Workspace de</p>
                  <p className="text-xs font-black text-slate-900">{settings.userName}</p>
               </div>
               <div className="w-10 h-10 bg-slate-900 rounded-2xl flex items-center justify-center text-white font-black text-sm shadow-xl shadow-slate-200">
                  {settings.userName.charAt(0)}
               </div>
            </div>
          </div>
        </header>

        <div className="flex-1 overflow-hidden relative flex flex-col bg-white">
          {activeMode === ToolMode.FILES ? (
            <div className="flex-1 overflow-y-auto px-10 py-10 custom-scrollbar">
              <DriveExplorer userId={session.id} userEmail={session.email} settings={settings} />
            </div>
          ) : activeMode === ToolMode.ADMIN ? (
             <div className="flex-1 overflow-y-auto px-10 py-10">
                <AdminDashboard />
             </div>
          ) : (
            <div className="flex-1 flex flex-col overflow-hidden relative">
              <div className="flex-1 overflow-y-auto custom-scrollbar px-10 py-10">
                {messages.map((msg) => (
                  <div key={msg.id} className={`flex ${msg.role === MessageRole.USER ? 'justify-end' : 'justify-start'} mb-10`}>
                    <div className={`flex items-start gap-5 max-w-[85%]`}>
                      {msg.role === MessageRole.ASSISTANT && (
                        <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-indigo-700 text-white rounded-2xl flex items-center justify-center shrink-0 shadow-xl shadow-blue-100 transition-transform hover:scale-110">
                          <Bot size={20} />
                        </div>
                      )}
                      <div className={`p-6 rounded-[2.5rem] shadow-2xl relative transition-all ${
                        msg.role === MessageRole.USER ? 'bg-blue-600 text-white rounded-tr-none' : 'bg-white border border-slate-100 rounded-tl-none'
                      }`}>
                        <MarkdownRenderer content={msg.content} />
                      </div>
                    </div>
                  </div>
                ))}
                {isThinking && (
                  <div className="flex justify-start mb-10">
                    <div className="flex items-center gap-4 bg-slate-50 p-6 rounded-[2.5rem] border border-slate-100 shadow-sm animate-pulse">
                      <div className="w-10 h-10 bg-blue-600 rounded-2xl flex items-center justify-center shadow-lg shadow-blue-200">
                        <Loader2 className="w-5 h-5 animate-spin text-white" />
                      </div>
                      <div>
                        <p className="text-xs font-black text-slate-900 uppercase tracking-widest italic">Processando Engenharia Pedagógica...</p>
                        <p className="text-[10px] text-slate-400 font-bold uppercase">Thinking Mode Ativado (32k Tokens)</p>
                      </div>
                    </div>
                  </div>
                )}
                <div ref={messagesEndRef} />
              </div>

              {/* Barra de Entrada Ajustada para ser flexível e dinâmica */}
              <div className="bg-white/80 backdrop-blur-2xl border-t border-slate-100 p-8 pt-4">
                {error && (
                  <div className="mb-4 p-4 bg-red-50 text-red-600 rounded-2xl text-[10px] font-black uppercase tracking-widest border border-red-100 flex items-center gap-3 animate-in slide-in-from-bottom-2">
                    <AlertCircle className="w-4 h-4" /> {error}
                  </div>
                )}
                <form onSubmit={handleSendMessage} className="flex items-center gap-4 max-w-6xl mx-auto">
                  <div className="flex-1 flex items-center gap-3 bg-slate-50 p-3 rounded-[2.5rem] border-2 border-transparent focus-within:border-blue-200 focus-within:bg-white transition-all shadow-inner relative group">
                    <input 
                      type="text" value={input} 
                      onChange={(e) => setInput(e.target.value)} 
                      className="flex-1 bg-transparent px-4 py-3 text-sm outline-none font-medium placeholder:text-slate-400" 
                      placeholder="Solicite um plano de aula, atividade ou tire uma dúvida pedagógica..." 
                    />
                    <button 
                      type="button" onClick={() => fileInputRef.current?.click()}
                      className="p-3 text-slate-400 hover:text-blue-600 transition-all hover:bg-white hover:shadow-sm rounded-2xl"
                      title="Anexar documento ou imagem"
                    >
                      <ImageIcon size={20} />
                    </button>
                    <input 
                      type="file" ref={fileInputRef} className="hidden" 
                      accept="image/*,.pdf,.doc,.docx"
                      onChange={(e) => {
                        const file = e.target.files?.[0];
                        if (file && file.type.startsWith('image/')) {
                          const reader = new FileReader();
                          reader.onload = (event) => setSelectedImage({ data: event.target?.result as string, type: file.type });
                          reader.readAsDataURL(file);
                        }
                      }} 
                    />
                  </div>
                  <button 
                    type="submit" disabled={isThinking || (!input.trim() && !selectedImage)}
                    className="p-6 bg-slate-900 text-white rounded-[2rem] shadow-2xl shadow-slate-200 hover:bg-blue-600 active:scale-95 transition-all disabled:opacity-50"
                  >
                    {isThinking ? <Loader2 size={24} className="animate-spin" /> : <Send size={24} />}
                  </button>
                </form>
                {selectedImage && (
                  <div className="mt-4 flex items-center gap-3 p-3 bg-blue-50 border border-blue-100 rounded-2xl w-fit mx-auto animate-in zoom-in-50">
                    <div className="w-8 h-8 rounded-lg overflow-hidden border border-blue-200">
                      <img src={selectedImage.data} alt="Preview" className="w-full h-full object-cover" />
                    </div>
                    <span className="text-[10px] font-black uppercase text-blue-700 tracking-widest">Documento Pedagógico Anexado</span>
                    <button onClick={() => setSelectedImage(null)} className="p-1.5 hover:bg-blue-100 rounded-full transition-colors"><X size={14} className="text-blue-600" /></button>
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </main>

      <aside className="h-screen bg-white border-l border-slate-100 flex-col shrink-0 lg:flex lg:w-72 p-10 space-y-10 overflow-y-auto hidden">
        <div>
          <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-8">Gestão de Documentos</h3>
          <div className="space-y-4">
            <button onClick={handleExportDocx} className="flex items-center gap-4 w-full p-5 bg-blue-50 text-blue-700 rounded-2xl font-black uppercase text-[10px] border border-blue-100 hover:bg-blue-100 transition-all active:scale-95 shadow-sm group">
              <Download size={18} className="group-hover:translate-y-0.5 transition-transform" /> Exportar Word
            </button>
            {/* REMOVIDO: Botão Google Docs
            <button onClick={handleSaveGoogleDocs} disabled={isSavingToDrive} className="flex items-center gap-4 w-full p-5 bg-emerald-50 text-emerald-700 rounded-2xl font-black uppercase text-[10px] border border-emerald-100 hover:bg-emerald-100 transition-all active:scale-95 shadow-sm group disabled:opacity-50">
              {isSavingToDrive ? <Loader2 size={18} className="animate-spin" /> : <Cloud size={18} className="group-hover:-translate-y-0.5 transition-transform" />} Google Docs
            </button>
            */}
          </div>
        </div>

        <div>
          <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-8">Contextualização</h3>
          <div className="space-y-6">
            <div className="space-y-2">
              <label className="text-[9px] font-black text-slate-400 uppercase tracking-[0.3em] ml-1">Disciplina Principal</label>
              <input 
                type="text" value={discipline} onChange={(e) => setDiscipline(e.target.value)}
                placeholder="Ex: Geografia"
                className="w-full px-5 py-4 bg-slate-50 border border-slate-100 rounded-2xl text-xs font-black outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all shadow-inner"
              />
            </div>
            <div className="space-y-2">
              <label className="text-[9px] font-black text-slate-400 uppercase tracking-[0.3em] ml-1">Série Docente</label>
              <input 
                type="text" value={grade} onChange={(e) => setGrade(e.target.value)}
                placeholder="Ex: 9º Ano EF"
                className="w-full px-5 py-4 bg-slate-50 border border-slate-100 rounded-2xl text-xs font-black outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all shadow-inner"
              />
            </div>
          </div>
        </div>

        <div className="pt-10 border-t border-slate-100 mt-auto">
           <div className="bg-gradient-to-br from-slate-950 to-slate-900 p-8 rounded-[2.5rem] text-white shadow-2xl relative overflow-hidden group">
              <div className="absolute top-0 right-0 w-24 h-24 bg-blue-600/10 blur-3xl group-hover:bg-blue-600/20 transition-all"></div>
              <p className="text-[9px] font-black uppercase tracking-[0.3em] text-blue-400 mb-3 flex items-center gap-2">
                 <Crown size={12} /> Licença Ativa
              </p>
              <p className="font-black text-lg tracking-tighter italic mb-4 uppercase">{session.accessLevel} ACCOUNT</p>
              <div className="bg-white/5 p-3 rounded-xl border border-white/10 text-[9px] font-bold text-slate-400 uppercase tracking-widest text-center">
                 Sincronizado com Supabase
              </div>
           </div>
        </div>
      </aside>

      <SettingsModal 
        isOpen={isSettingsOpen} onClose={() => setIsSettingsOpen(false)} 
        settings={settings} setSettings={setSettings} 
        // REMOVIDO: Props relacionadas ao Google Drive
        // onConnectDrive={handleConnectDrive} isDriveConnected={!!googleToken}
        // isGeminiApiKeySelected={geminiApiKeySelected} onSelectGeminiApiKey={handleSelectGeminiApiKey} // REMOVIDO
        userEmail={session.email}
      />
    </div>
  );
};

export default App;