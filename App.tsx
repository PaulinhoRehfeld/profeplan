
import React, { useState, useRef, useEffect } from 'react';
import { Send, Bot, User, CheckCircle2, Menu, X, Image as ImageIcon, Volume2, Database, Trash2, CloudUpload } from 'lucide-react';
import Sidebar from './components/Sidebar';
import SettingsModal from './components/SettingsModal';
import LoginScreen from './components/LoginScreen';
import DriveExplorer from './components/DriveExplorer';
import MarkdownRenderer from './components/MarkdownRenderer';
import { Message, MessageRole, ToolMode, UserSettings, UserSession, DriveFile } from './types';
import { generateProfePlanStream, speakText } from './services/geminiService';
import { INITIAL_GREETING } from './constants';

const App: React.FC = () => {
  const [session, setSession] = useState<UserSession | null>(() => {
    const saved = localStorage.getItem('profeplan_session');
    return saved ? JSON.parse(saved) : null;
  });

  const [activeMode, setActiveMode] = useState<ToolMode>(ToolMode.CHAT);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [savingToDrive, setSavingToDrive] = useState<string | null>(null);
  const [showDriveToast, setShowDriveToast] = useState(false);
  const [selectedImage, setSelectedImage] = useState<{data: string, type: string} | null>(null);
  const [input, setInput] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [discipline, setDiscipline] = useState('');
  const [grade, setGrade] = useState('');
  
  const [messages, setMessages] = useState<Message[]>(() => {
    const saved = localStorage.getItem(`profeplan_chat_${session?.email}`);
    return saved ? JSON.parse(saved).map((m: any) => ({ ...m, timestamp: new Date(m.timestamp) })) : 
    [{ id: 'initial', role: MessageRole.ASSISTANT, content: INITIAL_GREETING, timestamp: new Date() }];
  });

  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (session) localStorage.setItem(`profeplan_chat_${session.email}`, JSON.stringify(messages));
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, session]);

  if (!session || !session.isLoggedIn) return <LoginScreen onLogin={setSession} />;

  const handleSaveToDrive = async (messageId: string, content: string) => {
    setSavingToDrive(messageId);
    await new Promise(r => setTimeout(r, 2500)); // Simula latência do Drive MG

    let prefix = "Doc";
    if (content.toLowerCase().includes("plano")) prefix = "Plano";
    else if (content.toLowerCase().includes("aula")) prefix = "Aula";
    else if (content.toLowerCase().includes("avalia")) prefix = "Avaliacao";

    const fileName = `${prefix}_${Date.now()}.doc`;
    const driveKey = `profeplan_drive_${session.email}`;
    const files: DriveFile[] = JSON.parse(localStorage.getItem(driveKey) || '[]');
    
    files.push({ id: fileName, name: fileName, type: 'DOC', createdAt: new Date(), size: '42kb' });
    localStorage.setItem(driveKey, JSON.stringify(files));

    setMessages(prev => prev.map(m => m.id === messageId ? { ...m, drivePath: fileName } : m));
    setSavingToDrive(null);
    setShowDriveToast(true);
    setTimeout(() => setShowDriveToast(false), 3000);
  };

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() && !selectedImage) return;

    const currentMsg = input;
    const currentImg = selectedImage;
    const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: currentMsg, timestamp: new Date() };
    
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setSelectedImage(null);
    setIsTyping(true);

    try {
      const history = messages.slice(-5).map(m => ({ role: m.role === MessageRole.USER ? 'user' : 'model', parts: [{ text: m.content }] }));
      const imgPart = currentImg ? { inlineData: { data: currentImg.data, mimeType: currentImg.type } } : undefined;
      const context = `[EDU-MG: ${discipline} | ${grade}] `;
      
      const stream = await generateProfePlanStream(context + currentMsg, history, imgPart);
      let fullText = '';
      const aiId = (Date.now() + 1).toString();
      setMessages(prev => [...prev, { id: aiId, role: MessageRole.ASSISTANT, content: '', timestamp: new Date() }]);

      for await (const chunk of stream) {
        fullText += chunk.text;
        setMessages(prev => prev.map(m => m.id === aiId ? { ...m, content: fullText } : m));
      }
    } finally {
      setIsTyping(false);
    }
  };

  return (
    <div className="flex h-screen bg-slate-50 overflow-hidden">
      <Sidebar activeMode={activeMode} setActiveMode={setActiveMode} onOpenSettings={() => setIsSettingsOpen(true)} isOpen={isSidebarOpen} onClose={() => setIsSidebarOpen(false)} userRole={session.role} />
      
      <main className="flex-1 lg:ml-64 flex flex-col relative">
        <header className="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-8 sticky top-0 z-50">
          <div className="flex items-center gap-4">
            <button onClick={() => setIsSidebarOpen(true)} className="lg:hidden p-2 text-slate-500"><Menu /></button>
            <h2 className="font-black text-slate-800 tracking-tighter uppercase italic">{activeMode === ToolMode.FILES ? 'Drive Pedagógico' : 'Assistente PROFEPLAN'}</h2>
          </div>
          <div className="flex items-center gap-3 bg-blue-50 px-4 py-2 rounded-2xl border border-blue-100">
            <Database className="w-4 h-4 text-blue-600" />
            <span className="text-[10px] font-black text-blue-700 tracking-widest uppercase">EDU-MG SYNC</span>
          </div>
        </header>

        {activeMode === ToolMode.FILES ? <div className="p-8 overflow-y-auto h-full"><DriveExplorer userEmail={session.email} /></div> : (
          <>
            <div className="flex-1 overflow-y-auto p-8 space-y-8 pb-40">
              {messages.map((m) => (
                <div key={m.id} className={`flex gap-4 ${m.role === MessageRole.USER ? 'flex-row-reverse' : ''}`}>
                  <div className={`w-10 h-10 rounded-2xl flex items-center justify-center shrink-0 ${m.role === MessageRole.USER ? 'bg-blue-600 text-white' : 'bg-slate-900 text-white'}`}>
                    {m.role === MessageRole.USER ? <User size={20} /> : <Bot size={24} />}
                  </div>
                  <div className={`max-w-[85%] ${m.role === MessageRole.USER ? 'items-end flex flex-col' : ''}`}>
                    <div className={`p-6 rounded-[32px] shadow-sm border ${m.role === MessageRole.USER ? 'bg-blue-600 text-white rounded-tr-none' : 'bg-white text-slate-800 rounded-tl-none'}`}>
                      <MarkdownRenderer content={m.content} />
                      {m.role === MessageRole.ASSISTANT && m.id !== 'initial' && (
                        <div className="mt-6 flex gap-4 pt-4 border-t border-slate-100">
                          <button onClick={() => speakText(m.content)} className="flex items-center gap-2 text-[10px] font-black uppercase text-slate-400 hover:text-blue-600 transition-colors"><Volume2 size={16} /> Ouvir</button>
                          {m.drivePath ? <div className="flex items-center gap-2 text-[10px] font-black uppercase text-emerald-600 bg-emerald-50 px-3 py-1 rounded-full border border-emerald-100"><CheckCircle2 size={14} /> No Drive</div> : (
                            <button onClick={() => handleSaveToDrive(m.id, m.content)} disabled={!!savingToDrive} className="flex items-center gap-2 text-[10px] font-black uppercase text-slate-400 hover:text-blue-600 transition-colors">
                              {savingToDrive === m.id ? 'Sincronizando...' : <><CloudUpload size={16} /> Salvar Drive</>}
                            </button>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              ))}
              <div ref={messagesEndRef} />
            </div>

            <div className="absolute bottom-0 left-0 right-0 p-8 bg-gradient-to-t from-slate-50 to-transparent">
              <form onSubmit={handleSendMessage} className="max-w-4xl mx-auto flex gap-2 bg-white p-2 rounded-[28px] border-2 border-slate-100 shadow-2xl">
                <input type="text" value={input} onChange={(e) => setInput(e.target.value)} placeholder="Como posso ajudar seu planejamento hoje, Paulo?" className="flex-1 px-6 font-bold text-slate-700 outline-none" />
                <button type="submit" className="bg-blue-600 text-white p-4 rounded-[22px] shadow-lg"><Send /></button>
              </form>
            </div>
          </>
        )}
      </main>

      <aside className="w-80 bg-white border-l border-slate-200 hidden xl:flex flex-col p-8 space-y-8">
        <h3 className="font-black text-[11px] uppercase tracking-widest text-slate-400 italic">Aula Atual</h3>
        <div className="space-y-4">
          <div><label className="text-[10px] font-bold uppercase text-slate-400">Disciplina</label><input type="text" value={discipline} onChange={e => setDiscipline(e.target.value)} className="w-full bg-slate-100 p-3 rounded-xl text-sm font-bold border-none" /></div>
          <div><label className="text-[10px] font-bold uppercase text-slate-400">Série</label><input type="text" value={grade} onChange={e => setGrade(e.target.value)} className="w-full bg-slate-100 p-3 rounded-xl text-sm font-bold border-none" /></div>
        </div>
      </aside>

      {showDriveToast && (
        <div className="fixed top-10 left-1/2 -translate-x-1/2 z-[100] bg-emerald-600 text-white px-8 py-4 rounded-[20px] shadow-2xl font-bold flex items-center gap-3 animate-bounce">
          <CheckCircle2 /> Sincronizado com educacao.mg.gov.br!
        </div>
      )}
    </div>
  );
};

export default App;
