
import React, { useState, useRef, useEffect } from 'react';
import { 
  Send, Bot, User, CheckCircle2, Menu, X, 
  Image as ImageIcon, Volume2, Database, 
  CloudUpload, Sparkles, Home, PenTool, FileDown,
  BrainCircuit, Loader2, Sparkle, Key, ShieldAlert, RefreshCcw
} from 'lucide-react';

// Componentes Locais
import Sidebar from './components/Sidebar';
import SettingsModal from './components/SettingsModal';
import LoginScreen from './components/LoginScreen';
import DriveExplorer from './components/DriveExplorer';
import MarkdownRenderer from './components/MarkdownRenderer';
import AdminDashboard from './components/AdminDashboard';

// Tipos e Serviços
import { Message, MessageRole, ToolMode, UserSettings, UserSession, DriveFile } from './types';
import { generateProfePlanStream, speakPedagogicalText } from './services/geminiService';
import { exportToDocx } from './services/exportService';
import { INITIAL_GREETING } from './constants';

const App: React.FC = () => {
  const [session, setSession] = useState<UserSession | null>(() => {
    try {
      const saved = localStorage.getItem('profeplan_session');
      return saved ? JSON.parse(saved) : null;
    } catch (e) {
      return null;
    }
  });

  const [settings, setSettings] = useState<UserSettings>({
    userName: 'Professor(a)',
    institution: '',
    network: 'Estadual',
    stateUF: 'MG',
    favoriteMethodology: 'Gamificação',
    toneOfVoice: 'Prático e Inspiracional',
    detailLevel: 'Completo',
    theme: 'light'
  });

  const [activeMode, setActiveMode] = useState<ToolMode>(ToolMode.CHAT);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [selectedImage, setSelectedImage] = useState<{data: string, type: string} | null>(null);
  const [input, setInput] = useState('');
  const [isThinking, setIsThinking] = useState(false);
  const [discipline, setDiscipline] = useState('');
  const [grade, setGrade] = useState('');
  const [hasKey, setHasKey] = useState(true);
  
  const [messages, setMessages] = useState<Message[]>(() => {
    if (!session) return [];
    try {
      const saved = localStorage.getItem(`profeplan_chat_${session.email}`);
      if (saved) {
        return JSON.parse(saved).map((m: any) => ({ ...m, timestamp: new Date(m.timestamp) }));
      }
    } catch (e) {}
    return [{ id: 'initial', role: MessageRole.ASSISTANT, content: INITIAL_GREETING, timestamp: new Date() }];
  });

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Monitoramento contínuo da chave de API
  useEffect(() => {
    const checkKey = async () => {
      const aistudio = (window as any).aistudio;
      if (aistudio && typeof aistudio.hasSelectedApiKey === 'function') {
        const selected = await aistudio.hasSelectedApiKey();
        setHasKey(selected);
      }
    };
    checkKey();
    const interval = setInterval(checkKey, 5000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    if (session) {
      localStorage.setItem(`profeplan_chat_${session.email}`, JSON.stringify(messages));
    }
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, session]);

  if (!session || !session.isLoggedIn) {
    return <LoginScreen onLogin={setSession} />;
  }

  const handleSelectKey = async () => {
    const aistudio = (window as any).aistudio;
    if (aistudio && typeof aistudio.openSelectKey === 'function') {
      await aistudio.openSelectKey();
      // Assume sucesso imediato para melhorar a UX, o SDK lidará com falhas reais
      setHasKey(true);
    } else {
      alert("Ambiente de nuvem PROFEPLAN não detectado. Use o botão de login oficial.");
    }
  };

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() && !selectedImage) return;

    if (!hasKey) {
      await handleSelectKey();
      return;
    }

    const currentMsg = input;
    const currentImg = selectedImage;
    const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: currentMsg, timestamp: new Date() };
    
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setSelectedImage(null);
    setIsThinking(true);

    try {
      const history = messages.slice(-8).map(m => ({ 
        role: m.role === MessageRole.USER ? 'user' : 'model', 
        parts: [{ text: m.content }] 
      }));
      
      const imgPart = currentImg ? { inlineData: { data: currentImg.data, mimeType: currentImg.type } } : undefined;
      const contextString = `[DISCIPLINA: ${discipline} | SÉRIE: ${grade}] `;
      
      const stream = await generateProfePlanStream(`${contextString} ${currentMsg}`, history, activeMode, imgPart);
      
      let fullText = '';
      const aiId = (Date.now() + 1).toString();
      setMessages(prev => [...prev, { id: aiId, role: MessageRole.ASSISTANT, content: '', timestamp: new Date() }]);

      for await (const chunk of stream) {
        if (isThinking) setIsThinking(false);
        fullText += chunk.text || '';
        setMessages(prev => prev.map(m => m.id === aiId ? { ...m, content: fullText } : m));
      }
    } catch (error: any) {
      console.error("Detailed API Error:", error);
      setIsThinking(false);
      
      const errorMsgText = error?.message || String(error);
      let errorMessage = "### ⚠️ FALHA CRÍTICA DE MOTOR\nNão foi possível processar seu raciocínio agora.";
      
      if (errorMsgText.includes("Requested entity was not found") || errorMsgText.includes("404")) {
        setHasKey(false);
        errorMessage += "\n\n**O motor Gemini 3 Pro exige uma chave de API de um projeto pago (Billing Ativo).**\n\nPor favor, reative o motor no botão abaixo:";
      } else {
        errorMessage += "\n\nOcorreu uma instabilidade na conexão. Verifique sua rede ou tente novamente em instantes.";
      }

      setMessages(prev => [...prev, { 
        id: Date.now().toString(), 
        role: MessageRole.ASSISTANT, 
        content: errorMessage, 
        timestamp: new Date() 
      }]);
    } finally {
      setIsThinking(false);
    }
  };

  const renderActiveContent = () => {
    switch(activeMode) {
      case ToolMode.FILES: return <div className="p-8 h-full overflow-y-auto"><DriveExplorer userEmail={session.email} /></div>;
      case ToolMode.ADMIN: return <div className="p-8 h-full overflow-y-auto"><AdminDashboard /></div>;
      default: return (
        <>
          <div className="flex-1 overflow-y-auto p-4 lg:p-8 space-y-10 pb-44 custom-scrollbar bg-slate-50/30">
            {!hasKey && (
              <div className="max-w-4xl mx-auto mb-8 bg-amber-50 border-2 border-amber-200 p-8 rounded-[2.5rem] flex flex-col md:flex-row items-center justify-between gap-6 shadow-2xl shadow-amber-900/10 animate-in slide-in-from-top-4">
                <div className="flex items-center gap-5">
                  <div className="bg-amber-500 p-4 rounded-2xl shadow-lg shadow-amber-500/20">
                    <ShieldAlert className="text-white w-7 h-7" />
                  </div>
                  <div>
                    <p className="font-black text-amber-900 uppercase text-xs tracking-widest mb-1">Motor Pro Aguardando Ativação</p>
                    <p className="text-[11px] text-amber-700 font-semibold leading-relaxed">O Thinking Mode v3.0 requer uma chave de API com faturamento ativo.</p>
                  </div>
                </div>
                <button 
                  onClick={handleSelectKey}
                  className="bg-slate-900 text-white px-8 py-4 rounded-2xl font-black text-[11px] uppercase tracking-[0.2em] shadow-xl hover:bg-black transition-all flex items-center gap-3 active:scale-95 shrink-0"
                >
                  <Key size={18} className="text-blue-400" /> Ativar Agora
                </button>
              </div>
            )}

            <div className="max-w-4xl mx-auto space-y-10">
              {messages.map((m) => (
                <div key={m.id} className={`flex gap-5 group ${m.role === MessageRole.USER ? 'flex-row-reverse' : ''} animate-in fade-in slide-in-from-bottom-4 duration-300`}>
                  <div className={`w-12 h-12 rounded-[1.25rem] flex items-center justify-center shrink-0 shadow-xl transition-all group-hover:scale-110 border ${
                    m.role === MessageRole.USER ? 'bg-blue-600 text-white border-blue-500' : 'bg-slate-900 text-white border-slate-800'
                  }`}>
                    {m.role === MessageRole.USER ? <User size={24} /> : <Bot size={26} />}
                  </div>
                  <div className={`max-w-[85%] lg:max-w-[75%] ${m.role === MessageRole.USER ? 'items-end flex flex-col' : ''}`}>
                    <div className={`p-7 rounded-[2.5rem] border shadow-sm transition-all relative ${
                      m.role === MessageRole.USER 
                        ? 'bg-blue-600 text-white border-blue-500 rounded-tr-none' 
                        : 'bg-white text-slate-800 border-slate-100 rounded-tl-none hover:shadow-md'
                    }`}>
                      <MarkdownRenderer content={m.content} />
                      
                      {m.role === MessageRole.ASSISTANT && m.content.includes("⚠️") && (
                        <div className="mt-8 pt-6 border-t border-slate-100 flex justify-center">
                          <button 
                            onClick={handleSelectKey}
                            className="flex items-center gap-3 bg-red-600 text-white px-8 py-4 rounded-2xl font-black text-[10px] uppercase tracking-widest shadow-xl shadow-red-500/20 hover:bg-red-700 transition-all active:scale-95"
                          >
                            <RefreshCcw size={16} /> Reativar Motor Pro
                          </button>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              ))}
              
              {isThinking && (
                <div className="flex gap-5 animate-pulse">
                  <div className="w-12 h-12 rounded-[1.25rem] bg-slate-200 flex items-center justify-center text-slate-400 shadow-inner">
                    <BrainCircuit size={22} className="animate-spin-slow" />
                  </div>
                  <div className="bg-white border border-slate-100 p-8 rounded-[2.5rem] rounded-tl-none shadow-sm flex items-center gap-4">
                    <div className="flex gap-1.5">
                      <div className="w-2 h-2 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '0s' }}></div>
                      <div className="w-2 h-2 bg-blue-500 rounded-full animate-bounce" style={{ animationDelay: '0.2s' }}></div>
                      <div className="w-2 h-2 bg-blue-600 rounded-full animate-bounce" style={{ animationDelay: '0.4s' }}></div>
                    </div>
                    <span className="text-[11px] font-black text-slate-400 uppercase tracking-[0.2em]">Sincronizando Currículo...</span>
                  </div>
                </div>
              )}
              <div ref={messagesEndRef} className="h-4" />
            </div>
          </div>

          <div className="absolute bottom-0 left-0 right-0 p-6 lg:p-10 bg-gradient-to-t from-slate-50 via-slate-50/95 to-transparent">
            <form onSubmit={handleSendMessage} className="max-w-4xl mx-auto bg-white rounded-[3rem] border-2 border-slate-200 shadow-2xl overflow-hidden focus-within:border-blue-400 focus-within:ring-8 focus-within:ring-blue-100 transition-all duration-300">
              <div className="flex gap-2 p-4 items-center">
                <button type="button" onClick={() => fileInputRef.current?.click()} className="p-4 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-[1.5rem] transition-all">
                  <ImageIcon size={24} />
                </button>
                <input type="file" ref={fileInputRef} className="hidden" />
                <input 
                  type="text" 
                  value={input} 
                  onChange={(e) => setInput(e.target.value)} 
                  placeholder={hasKey ? "Qual o seu objetivo pedagógico agora?" : "Selecione sua chave de API para continuar..."}
                  className="flex-1 px-5 py-3 font-bold text-slate-700 outline-none bg-transparent placeholder:text-slate-300 transition-all"
                />
                <button 
                  type="submit" 
                  disabled={isThinking || !input.trim()}
                  className={`p-5 rounded-[2rem] shadow-xl transition-all active:scale-90 ${
                    input.trim() ? 'bg-blue-600 text-white hover:bg-blue-700' : 'bg-slate-100 text-slate-400'
                  }`}
                >
                  {isThinking ? <Loader2 size={24} className="animate-spin" /> : <Send size={24} />}
                </button>
              </div>
            </form>
          </div>
        </>
      );
    }
  };

  return (
    <div className="flex h-screen bg-slate-50 overflow-hidden font-sans">
      <Sidebar 
        activeMode={activeMode} 
        setActiveMode={setActiveMode} 
        onOpenSettings={() => setIsSettingsOpen(true)} 
        isOpen={isSidebarOpen} 
        onClose={() => setIsSidebarOpen(false)} 
        userRole={session.role} 
      />
      
      <main className="flex-1 lg:ml-64 flex flex-col relative h-full">
        <header className="h-24 bg-white/80 backdrop-blur-2xl border-b border-slate-100 flex items-center justify-between px-8 z-50 sticky top-0 shadow-sm">
          <div className="flex items-center gap-6">
            <button onClick={() => setIsSidebarOpen(true)} className="lg:hidden p-3 text-slate-500 hover:bg-slate-50 rounded-2xl"><Menu /></button>
            <div className="flex flex-col">
              <div className="flex items-center gap-3">
                <span className={`text-[10px] font-black px-3 py-1 rounded-full uppercase tracking-widest border transition-colors ${hasKey ? 'text-blue-600 bg-blue-50 border-blue-100' : 'text-amber-600 bg-amber-50 border-amber-100'}`}>
                  {hasKey ? activeMode.replace('_', ' ') : 'PENDENTE'}
                </span>
                <h2 className="font-black text-slate-900 tracking-tighter uppercase italic text-lg">PROFEPLAN v3.0</h2>
              </div>
              <span className="text-[10px] font-bold text-slate-400 uppercase tracking-[0.2em] mt-1 italic">
                {discipline || 'Nível Geral'} • {grade || 'Base Nacional'}
              </span>
            </div>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="hidden md:flex items-center gap-3 bg-slate-900 px-5 py-2.5 rounded-2xl shadow-lg border border-slate-800">
              <Database className="w-4 h-4 text-blue-400" />
              <span className="text-[10px] font-black text-white uppercase tracking-widest">{session.accessLevel}</span>
            </div>
            {!hasKey && (
              <button 
                onClick={handleSelectKey}
                className="flex items-center gap-2 bg-gradient-to-r from-amber-500 to-orange-600 text-white px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-xl shadow-amber-500/20 animate-pulse hover:scale-105 transition-transform"
              >
                <Key size={14} /> Ativar Motor
              </button>
            )}
          </div>
        </header>

        <div className="flex-1 overflow-hidden relative flex flex-col">
          {renderActiveContent()}
        </div>
      </main>

      <aside className="w-80 bg-white border-l border-slate-100 hidden xl:flex flex-col p-10 space-y-10 shrink-0 shadow-2xl shadow-slate-200">
        <div>
          <h3 className="font-black text-[11px] uppercase tracking-[0.3em] text-slate-300 italic mb-6">Parâmetros de Contexto</h3>
          <div className="space-y-6">
            <div className="space-y-2">
              <label className="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Disciplina Principal</label>
              <input 
                type="text" 
                value={discipline} 
                onChange={e => setDiscipline(e.target.value)} 
                placeholder="Ex: Física Quântica" 
                className="w-full bg-slate-50 p-5 rounded-3xl text-sm font-black border-2 border-transparent focus:border-blue-500 transition-all outline-none shadow-inner" 
              />
            </div>
            <div className="space-y-2">
              <label className="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Turma / Série</label>
              <input 
                type="text" 
                value={grade} 
                onChange={e => setGrade(e.target.value)} 
                placeholder="Ex: 9º Ano Fundamental" 
                className="w-full bg-slate-50 p-5 rounded-3xl text-sm font-black border-2 border-transparent focus:border-blue-500 transition-all outline-none shadow-inner" 
              />
            </div>
          </div>
        </div>

        <div className="mt-auto pt-10 border-t border-slate-100">
          <div className={`rounded-[3rem] p-8 text-white shadow-2xl relative overflow-hidden group transition-all duration-700 ${hasKey ? 'bg-gradient-to-br from-blue-600 to-indigo-700' : 'bg-slate-300'}`}>
            <Sparkle className={`absolute -bottom-8 -left-8 w-32 h-32 opacity-10 transition-transform duration-700 ${hasKey ? 'scale-110 group-hover:scale-125' : 'scale-75'}`} />
            <p className="text-[11px] font-black uppercase tracking-widest mb-2 opacity-70 italic">Status Inteligência</p>
            <p className="text-2xl font-black italic uppercase leading-tight">Gemini 3 Pro<br/>Thinking Mode</p>
            <div className={`mt-6 flex items-center gap-3 p-4 rounded-2xl border backdrop-blur-sm transition-all ${hasKey ? 'bg-white/10 border-white/20' : 'bg-black/5 border-black/10'}`}>
              <div className={`w-2.5 h-2.5 rounded-full shadow-[0_0_10px_rgba(52,211,153,0.5)] ${hasKey ? 'bg-emerald-400 animate-pulse' : 'bg-slate-500'}`}></div>
              <p className={`text-[10px] font-black uppercase tracking-widest ${hasKey ? 'text-white' : 'text-slate-600'}`}>
                {hasKey ? 'Sincronização Ativa' : 'Aguardando Ativação'}
              </p>
            </div>
          </div>
        </div>
      </aside>

      <SettingsModal isOpen={isSettingsOpen} onClose={() => setIsSettingsOpen(false)} settings={settings} setSettings={setSettings} />
    </div>
  );
};

export default App;
