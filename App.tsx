
import React, { useState, useRef, useEffect } from 'react';
import { 
  Send, Bot, User, Menu, X, 
  Image as ImageIcon, Database, 
  PenTool, BrainCircuit, Loader2, Sparkle, 
  RefreshCcw, Info, FileText, Download, Copy, Check, Cloud,
  Mic, MicOff, Square
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
import { exportToDocx } from './services/exportService';
import { INITIAL_GREETING } from './constants';

// Client ID oficial (Sanitizado)
const GOOGLE_CLIENT_ID = '1074092770295-v0k138s26e7v69n56n614p11f7o06990.apps.googleusercontent.com';

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
    favoriteMethodology: 'Gamification',
    toneOfVoice: 'Prático e Inspiracional',
    detailLevel: 'Completo',
    theme: 'light'
  });

  const [googleToken, setGoogleToken] = useState<string | null>(() => localStorage.getItem('google_drive_token'));
  const [activeMode, setActiveMode] = useState<ToolMode>(ToolMode.CHAT);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [selectedImage, setSelectedImage] = useState<{data: string, type: string} | null>(null);
  const [input, setInput] = useState('');
  const [isThinking, setIsThinking] = useState(false);
  const [isSavingToDrive, setIsSavingToDrive] = useState(false);
  const [discipline, setDiscipline] = useState('');
  const [grade, setGrade] = useState('');
  const [copiedId, setCopiedId] = useState<string | null>(null);
  
  // Audio states
  const [isRecording, setIsRecording] = useState(false);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioChunksRef = useRef<Blob[]>([]);

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

  // --- AUDIO RECORDING LOGIC ---

  const getSupportedMimeType = () => {
    const types = ['audio/webm', 'audio/ogg', 'audio/mp4', 'audio/aac'];
    for (const type of types) {
      if (MediaRecorder.isTypeSupported(type)) return type;
    }
    return '';
  };

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mimeType = getSupportedMimeType();
      const mediaRecorder = new MediaRecorder(stream, mimeType ? { mimeType } : undefined);
      
      mediaRecorderRef.current = mediaRecorder;
      audioChunksRef.current = [];

      mediaRecorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          audioChunksRef.current.push(event.data);
        }
      };

      mediaRecorder.onstop = () => {
        const finalMimeType = mediaRecorder.mimeType || 'audio/webm';
        const blob = new Blob(audioChunksRef.current, { type: finalMimeType });
        handleSendVoice(blob);
      };

      mediaRecorder.start();
      setIsRecording(true);
    } catch (err) {
      console.error("Erro ao acessar microfone:", err);
      alert("Não foi possível acessar seu microfone. Verifique as permissões de áudio do seu navegador.");
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current && isRecording) {
      mediaRecorderRef.current.stop();
      setIsRecording(false);
      mediaRecorderRef.current.stream.getTracks().forEach(track => track.stop());
    }
  };

  const blobToBase64 = (blob: Blob): Promise<string> => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onloadend = () => {
        const base64String = (reader.result as string)?.split(',')[1];
        if (base64String) resolve(base64String);
        else reject("Falha na conversão para base64");
      };
      reader.onerror = reject;
      reader.readAsDataURL(blob);
    });
  };

  const handleSendVoice = async (blob: Blob) => {
    setIsThinking(true);
    try {
      const base64Audio = await blobToBase64(blob);
      const audioPart = {
        inlineData: {
          data: base64Audio,
          mimeType: blob.type
        }
      };

      const userMsg: Message = { 
        id: Date.now().toString(), 
        role: MessageRole.USER, 
        content: "🎤 [Mensagem de Voz Enviada]", 
        timestamp: new Date() 
      };
      
      setMessages(prev => [...prev, userMsg]);
      
      const history = messages.slice(-10).map(m => ({ 
        role: m.role === MessageRole.USER ? 'user' : 'model', 
        parts: [{ text: m.content }] 
      }));
      
      // Solicitar explicitamente transcrição e processamento pedagógico
      const voicePrompt = "Por favor, transcreva o áudio acima e processe as orientações pedagógicas contidas nele.";
      const stream = await generateProfePlanStream(voicePrompt, history, activeMode, undefined, audioPart);
      
      let fullText = '';
      const aiId = (Date.now() + 1).toString();
      setMessages(prev => [...prev, { id: aiId, role: MessageRole.ASSISTANT, content: '', timestamp: new Date() }]);

      for await (const chunk of stream) {
        if (isThinking) setIsThinking(false);
        fullText += chunk.text || '';
        setMessages(prev => prev.map(m => m.id === aiId ? { ...m, content: fullText } : m));
      }
    } catch (error: any) {
      setIsThinking(false);
      console.error(error);
      const errorMsgText = "### ⚠️ FALHA NO PROCESSAMENTO DE ÁUDIO\nO motor de IA não conseguiu processar sua mensagem de voz. Tente falar mais perto do microfone ou digite sua solicitação.";
      setMessages(prev => [...prev, { id: Date.now().toString(), role: MessageRole.ASSISTANT, content: errorMsgText, timestamp: new Date() }]);
    } finally {
      setIsThinking(false);
    }
  };

  // --- GOOGLE DRIVE INTEGRATION ---
  
  const handleConnectDrive = () => {
    try {
      const google = (window as any).google;
      if (!google || !google.accounts || !google.accounts.oauth2) {
        alert("Aguarde o carregamento do módulo de segurança do Google (GSI) e tente novamente.");
        return;
      }

      const client = google.accounts.oauth2.initTokenClient({
        client_id: GOOGLE_CLIENT_ID.trim(),
        scope: 'https://www.googleapis.com/auth/drive.file',
        callback: (response: any) => {
          if (response.access_token) {
            setGoogleToken(response.access_token);
            localStorage.setItem('google_drive_token', response.access_token);
            alert("Sincronização Cloud vinculada com sucesso!");
          } else if (response.error) {
            console.error("OAuth Error:", response);
            alert(`Falha na conexão: ${response.error_description || response.error}`);
          }
        },
      });
      client.requestAccessToken({ prompt: 'consent' });
    } catch (err) {
      console.error("Critical Google SDK Failure:", err);
      alert("Houve um erro técnico ao abrir o portal do Google. Verifique se o Client ID está autorizado para esta origem.");
    }
  };

  const handleSaveGoogleDocs = async () => {
    if (!googleToken) {
      alert("Seu Google Drive ainda não está conectado. Vá em Configurações.");
      setIsSettingsOpen(true);
      return;
    }

    const lastAiMessage = [...messages].reverse().find(m => m.role === MessageRole.ASSISTANT && m.id !== 'initial');
    if (!lastAiMessage) {
      alert("Não há planejamento recente para salvar.");
      return;
    }

    setIsSavingToDrive(true);
    try {
      const createResponse = await fetch('https://www.googleapis.com/drive/v3/files', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${googleToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          name: `PROFEPLAN - ${discipline || 'Plano'} - ${grade || 'Geral'}`,
          mimeType: 'application/vnd.google-apps.document'
        })
      });

      const file = await createResponse.json();
      
      if (file.error) {
        if (file.error.code === 401) {
          alert("Sessão Google expirada. Refaça a conexão nas configurações.");
          setGoogleToken(null);
          localStorage.removeItem('google_drive_token');
          return;
        }
        throw new Error(file.error.message);
      }

      const uploadResponse = await fetch(`https://www.googleapis.com/upload/drive/v3/files/${file.id}?uploadType=media`, {
        method: 'PATCH',
        headers: {
          'Authorization': `Bearer ${googleToken}`,
          'Content-Type': 'text/plain; charset=UTF-8'
        },
        body: lastAiMessage.content
      });

      if (!uploadResponse.ok) throw new Error("Erro ao sincronizar o conteúdo pedagógico.");

      window.open(`https://docs.google.com/document/d/${file.id}/edit`, '_blank');
    } catch (error: any) {
      console.error("Drive Sync Fail:", error);
      alert(`Erro na sincronização: ${error.message || "Falha desconhecida."}`);
    } finally {
      setIsSavingToDrive(false);
    }
  };

  const handleExportDocx = async () => {
    const lastAiMsg = [...messages].reverse().find(m => m.role === MessageRole.ASSISTANT && m.id !== 'initial');
    if (!lastAiMsg) return;
    const title = `Plano_${discipline || 'Doc'}_${Date.now()}`;
    await exportToDocx(lastAiMsg.content, title);
  };

  const handleCopyText = (text: string, id: string) => {
    navigator.clipboard.writeText(text);
    setCopiedId(id);
    setTimeout(() => setCopiedId(null), 2000);
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
      setIsThinking(false);
      const errorMsgText = "### ⚠️ ERRO NO MOTOR DE IA\nNão foi possível completar o processamento técnico agora. Verifique sua conexão.";
      setMessages(prev => [...prev, { id: Date.now().toString(), role: MessageRole.ASSISTANT, content: errorMsgText, timestamp: new Date() }]);
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
          <div className="flex-1 overflow-y-auto p-4 lg:p-8 space-y-10 pb-32 custom-scrollbar bg-slate-50/30">
            <div className="max-w-4xl mx-auto space-y-10">
              {messages.map((m) => (
                <div key={m.id} className={`flex gap-5 group ${m.role === MessageRole.USER ? 'flex-row-reverse' : ''} animate-in fade-in slide-in-from-bottom-4 duration-300`}>
                  <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 shadow-md ${
                    m.role === MessageRole.USER ? 'bg-blue-600 text-white' : 'bg-slate-900 text-white'
                  }`}>
                    {m.role === MessageRole.USER ? <User size={20} /> : <Bot size={22} />}
                  </div>
                  <div className={`max-w-[85%] lg:max-w-[80%] flex flex-col ${m.role === MessageRole.USER ? 'items-end' : 'items-start'}`}>
                    <div className={`p-6 rounded-[2rem] border shadow-sm relative ${
                      m.role === MessageRole.USER 
                        ? 'bg-blue-600 text-white border-blue-500 rounded-tr-none' 
                        : 'bg-white text-slate-800 border-slate-100 rounded-tl-none'
                    }`}>
                      <MarkdownRenderer content={m.content} />
                      
                      {m.role === MessageRole.ASSISTANT && m.content.length > 50 && (
                        <div className="absolute top-2 -right-12 flex flex-col gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                          <button 
                            onClick={() => handleCopyText(m.content, m.id)}
                            className="p-2.5 bg-white border border-slate-100 rounded-xl shadow-sm text-slate-400 hover:text-blue-600 transition-all"
                          >
                            {copiedId === m.id ? <Check size={16} className="text-green-500" /> : <Copy size={16} />}
                          </button>
                        </div>
                      )}
                    </div>
                    <span className="text-[9px] font-bold text-slate-300 mt-2 uppercase tracking-widest">
                      {m.timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                    </span>
                  </div>
                </div>
              ))}
              
              {isThinking && (
                <div className="flex gap-5 animate-pulse">
                  <div className="w-10 h-10 rounded-xl bg-slate-200 flex items-center justify-center text-slate-400">
                    <BrainCircuit size={20} className="animate-spin-slow" />
                  </div>
                  <div className="bg-white border border-slate-100 p-6 rounded-[2rem] rounded-tl-none shadow-sm flex items-center gap-4">
                    <span className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Processando Raciocínio...</span>
                  </div>
                </div>
              )}
              <div ref={messagesEndRef} className="h-4" />
            </div>
          </div>

          <div className="absolute bottom-0 left-0 right-0 p-4 lg:p-6 bg-gradient-to-t from-slate-50 to-transparent">
            <form onSubmit={handleSendMessage} className="max-w-3xl mx-auto bg-white rounded-full border border-slate-200 shadow-xl overflow-hidden focus-within:border-blue-400 transition-all relative">
              <div className="flex gap-1 p-2 items-center">
                <button type="button" onClick={() => fileInputRef.current?.click()} className="p-3 text-slate-400 hover:text-blue-600 rounded-full" title="Anexar Imagem ou PDF">
                  <ImageIcon size={20} />
                </button>
                <input type="file" ref={fileInputRef} className="hidden" accept="image/*,application/pdf" />
                
                <button 
                  type="button" 
                  onClick={isRecording ? stopRecording : startRecording} 
                  className={`p-3 rounded-full transition-all ${
                    isRecording ? 'bg-red-50 text-red-600 animate-pulse' : 'text-slate-400 hover:text-blue-600'
                  }`}
                  title={isRecording ? "Parar e Enviar Áudio" : "Gravar Mensagem de Voz"}
                >
                  {isRecording ? <Square size={20} fill="currentColor" /> : <Mic size={20} />}
                </button>

                <input 
                  type="text" 
                  value={input} 
                  onChange={(e) => setInput(e.target.value)} 
                  placeholder={isRecording ? "Gravando áudio pedagógico..." : "O que vamos planejar agora?"}
                  disabled={isRecording}
                  className="flex-1 px-4 py-2 font-medium text-slate-700 outline-none bg-transparent placeholder:text-slate-300 disabled:opacity-50"
                />
                <button 
                  type="submit" 
                  disabled={isThinking || (!input.trim() && !selectedImage) || isRecording}
                  className={`p-3 rounded-full transition-all ${
                    (input.trim() || selectedImage) ? 'bg-blue-600 text-white hover:bg-blue-700' : 'bg-slate-100 text-slate-400'
                  }`}
                >
                  {isThinking ? <Loader2 size={20} className="animate-spin" /> : <Send size={20} />}
                </button>
              </div>
            </form>
            {isRecording && (
               <div className="max-w-3xl mx-auto mt-2 text-center animate-bounce">
                  <span className="text-[10px] font-black text-red-500 uppercase tracking-widest">Escutando... Clique no quadrado para finalizar.</span>
               </div>
            )}
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
        <header className="h-20 bg-white/80 backdrop-blur-2xl border-b border-slate-100 flex items-center justify-between px-8 z-50 sticky top-0 shadow-sm">
          <div className="flex items-center gap-6">
            <button onClick={() => setIsSidebarOpen(true)} className="lg:hidden p-3 text-slate-500 hover:bg-slate-50 rounded-2xl"><Menu /></button>
            <div className="flex flex-col">
              <div className="flex items-center gap-3">
                <span className="text-[9px] font-black text-blue-600 bg-blue-50 px-2 py-0.5 rounded-full uppercase tracking-tighter border border-blue-100">
                  {activeMode.replace('_', ' ')}
                </span>
                <h2 className="font-black text-slate-900 tracking-tighter uppercase italic text-base">PROFEPLAN v3.0</h2>
              </div>
              <span className="text-[9px] font-bold text-slate-400 uppercase tracking-widest mt-0.5 italic">
                {discipline || 'Geral'} • {grade || 'Série'}
              </span>
            </div>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="hidden md:flex items-center gap-2 bg-slate-900 px-4 py-2 rounded-xl shadow-md">
              <Database className="w-3.5 h-3.5 text-blue-400" />
              <span className="text-[9px] font-black text-white uppercase tracking-widest">{session.accessLevel}</span>
            </div>
          </div>
        </header>

        <div className="flex-1 overflow-hidden relative flex flex-col">
          {renderActiveContent()}
        </div>
      </main>

      <aside className="w-72 bg-white border-l border-slate-100 hidden xl:flex flex-col p-8 space-y-8 shrink-0 shadow-xl">
        <div>
          <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-6">Filtros Rápidos</h3>
          <div className="space-y-5">
            <div className="space-y-2">
              <label className="text-[9px] font-black uppercase text-slate-400 tracking-widest ml-1">Disciplina</label>
              <input 
                type="text" 
                value={discipline} 
                onChange={e => setDiscipline(e.target.value)} 
                placeholder="Ex: Geografia" 
                className="w-full bg-slate-50 p-4 rounded-2xl text-xs font-bold border-2 border-transparent focus:border-blue-500 transition-all outline-none" 
              />
            </div>
            <div className="space-y-2">
              <label className="text-[9px] font-black uppercase text-slate-400 tracking-widest ml-1">Turma / Série</label>
              <input 
                type="text" 
                value={grade} 
                onChange={e => setGrade(e.target.value)} 
                placeholder="Ex: 9º Ano" 
                className="w-full bg-slate-50 p-4 rounded-2xl text-xs font-bold border-2 border-transparent focus:border-blue-500 transition-all outline-none" 
              />
            </div>
          </div>
        </div>

        <div className="pt-2">
          <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-4">Exportação</h3>
          <div className="grid grid-cols-1 gap-3">
            <button 
              onClick={handleExportDocx}
              className="flex items-center gap-3 w-full p-4 bg-blue-50 text-blue-700 rounded-2xl text-[11px] font-black uppercase tracking-tight border border-blue-100 hover:bg-blue-100 transition-all"
            >
              <Download size={16} /> Salvar como Word
            </button>
            <button 
              onClick={handleSaveGoogleDocs}
              disabled={isSavingToDrive}
              className={`flex items-center gap-3 w-full p-4 rounded-2xl text-[11px] font-black uppercase tracking-tight border transition-all ${
                isSavingToDrive 
                  ? 'bg-slate-100 text-slate-400 border-slate-200 shadow-none' 
                  : 'bg-emerald-50 text-emerald-700 border-emerald-100 hover:bg-emerald-100 shadow-sm'
              }`}
            >
              {isSavingToDrive ? <Loader2 size={16} className="animate-spin" /> : <Cloud size={16} />} 
              Google Docs
            </button>
          </div>
        </div>

        <div className="mt-auto pt-8 border-t border-slate-100">
          <div className="rounded-[2.5rem] p-6 text-white shadow-xl relative overflow-hidden group bg-gradient-to-br from-blue-600 to-indigo-700">
            <Sparkle className="absolute -bottom-6 -left-6 w-24 h-24 opacity-10 transition-transform group-hover:scale-125" />
            <p className="text-[9px] font-black uppercase tracking-widest mb-1 opacity-70 italic">IA DOCENTE</p>
            <p className="text-sm font-bold italic uppercase leading-tight tracking-tight">Gemini Workspace<br/>Sync Ativo</p>
          </div>
        </div>
      </aside>

      <SettingsModal 
        isOpen={isSettingsOpen} 
        onClose={() => setIsSettingsOpen(false)} 
        settings={settings} 
        setSettings={setSettings} 
        onConnectDrive={handleConnectDrive}
        isDriveConnected={!!googleToken}
      />
    </div>
  );
};

export default App;
