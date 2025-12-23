
import React, { useState, useRef, useEffect } from 'react';
import { 
  Send, Bot, User, Menu, X, 
  Image as ImageIcon, Database, 
  PenTool, BrainCircuit, Loader2, Sparkle, 
  RefreshCcw, Info
} from 'lucide-react';

// Componentes Locais
import Sidebar from './components/Sidebar';
import SettingsModal from './components/SettingsModal';
import LoginScreen from './components/LoginScreen';
import DriveExplorer from './components/DriveExplorer';
import MarkdownRenderer from './components/MarkdownRenderer';
import AdminDashboard from './components/AdminDashboard';

// Tipos e Serviços
import { Message, MessageRole, ToolMode, UserSettings, UserSession } from './types';
import { generateProfePlanStream } from './services/geminiService';
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

  useEffect(() => {
    if (session) {
      localStorage.setItem(`profeplan_chat_${session.email}`, JSON.stringify(messages));
    }
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, session]);

  if (!session || !session.isLoggedIn) {
    return <LoginScreen onLogin={setSession} />;
  }

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() && !selectedImage) return;

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
      console.error("Detailed Communication Error:", error);
      setIsThinking(false);
      
      const errorMsgText = "### ⚠️ SISTEMA TEMPORARIAMENTE INDISPONÍVEL\nOcorreu uma falha na conexão com os servidores centrais do PROFEPLAN.\n\n**Orientações para o Colega Professor:**\n1. Verifique se sua internet está estável.\n2. Se o erro persistir, aguarde alguns instantes e tente enviar novamente.\n3. O motor Gemini 3 está sendo reinicializado.";

      setMessages(prev => [...prev, { 
        id: Date.now().toString(), 
        role: MessageRole.ASSISTANT, 
        content: errorMsgText, 
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
                    <span className="text-[11px] font-black text-slate-400 uppercase tracking-[0.2em]">Engenharia Pedagógica em Curso...</span>
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
                  placeholder="Descreva seu objetivo pedagógico aqui..."
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
                <span className="text-[10px] font-black text-blue-600 bg-blue-50 px-3 py-1 rounded-full uppercase tracking-widest border border-blue-100">
                  {activeMode.replace('_', ' ')}
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
          <div className="rounded-[3rem] p-8 text-white shadow-2xl relative overflow-hidden group bg-gradient-to-br from-blue-600 to-indigo-700">
            <Sparkle className="absolute -bottom-8 -left-8 w-32 h-32 opacity-10 transition-transform duration-700 scale-110 group-hover:scale-125" />
            <p className="text-[11px] font-black uppercase tracking-widest mb-2 opacity-70 italic">Motor de Inteligência</p>
            <p className="text-2xl font-black italic uppercase leading-tight">Gemini 3 Flash<br/>Thinking Mode</p>
            <div className="mt-6 flex items-center gap-3 p-4 rounded-2xl border backdrop-blur-sm bg-white/10 border-white/20">
              <div className="w-2.5 h-2.5 rounded-full shadow-[0_0_10px_rgba(52,211,153,0.5)] bg-emerald-400 animate-pulse"></div>
              <p className="text-[10px] font-black uppercase tracking-widest text-white">Sincronização Ativa</p>
            </div>
          </div>
        </div>
      </aside>

      <SettingsModal isOpen={isSettingsOpen} onClose={() => setIsSettingsOpen(false)} settings={settings} setSettings={setSettings} />
    </div>
  );
};

export default App;
