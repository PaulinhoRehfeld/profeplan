
import React, { useState, useRef, useEffect } from 'react';
import { 
  Send, Bot, User, Menu, X, 
  Image as ImageIcon, Database, 
  PenTool, BrainCircuit, Loader2, Sparkle, 
  RefreshCcw, Info, FileText, Download, Copy, Check, Cloud,
  Mic, MicOff, Square, Key, ChevronLeft, ChevronRight
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
import { generateProfePlanStream } from './services/geminiService';
import { exportToDocx } from './services/exportService';
import { INITIAL_GREETING } from './constants';

// Client ID oficial (Sanitizado)
const GOOGLE_CLIENT_ID = '1074092770295-v0k138s26e7v69n56n614p11f7o06990.apps.googleusercontent.com';

// window.aistudio is now declared in types.ts
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
  const [isMobileNavOpen, setIsMobileNavOpen] = useState(false); // Renamed from isSidebarOpen
  const [selectedImage, setSelectedImage] = useState<{data: string, type: string} | null>(null);
  const [input, setInput] = useState('');
  const [isThinking, setIsThinking] = useState(false);
  const [isSavingToDrive, setIsSavingToDrive] = useState(false);
  const [discipline, setDiscipline] = useState('');
  const [grade, setGrade] = useState('');
  const [copiedId, setCopiedId] = useState<string | null>(null);
  const [error, setError] = useState('');
  
  // Audio states
  const [isRecording, setIsRecording] = useState(false);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioChunksRef = useRef<Blob[]>([]);

  // Gemini API Key state
  const [geminiApiKeySelected, setGeminiApiKeySelected] = useState(false);
  const [checkingApiKey, setCheckingApiKey] = useState(true);

  // States para controlar a expansão/recolhimento dos menus laterais em desktop
  const [isLeftNavExpanded, setIsLeftNavExpanded] = useState(true);
  const [isRightNavExpanded, setIsRightNavExpanded] = useState(true);


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

  // Efeito para verificar a Gemini API Key ao iniciar
  useEffect(() => {
    const checkKey = async () => {
      if (window.aistudio && typeof window.aistudio.hasSelectedApiKey === 'function') {
        const hasKey = await window.aistudio.hasSelectedApiKey();
        setGeminiApiKeySelected(hasKey);
      } else {
        console.warn("window.aistudio não disponível. A API Key do Gemini pode não ser carregada.");
        setGeminiApiKeySelected(true); 
      }
      setCheckingApiKey(false);
    };
    checkKey();
  }, []);

  const handleSelectGeminiApiKey = async () => {
    if (window.aistudio && typeof window.aistudio.openSelectKey === 'function') {
      await window.aistudio.openSelectKey();
      setGeminiApiKeySelected(true);
      setError(''); 
    } else {
      alert("A funcionalidade de seleção de chave de API do Gemini não está disponível neste ambiente.");
    }
  };

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
    if (!geminiApiKeySelected) {
      alert("Por favor, selecione sua chave de API do Gemini nas configurações para usar o microfone.");
      return;
    }
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
    if (!geminiApiKeySelected) {
      alert("Chave de API do Gemini não selecionada. Por favor, configure nas 'Configurações'.");
      return;
    }

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
        fullText += chunk.text || '';
        setMessages(prev => prev.map(m => m.id === aiId ? { ...m, content: fullText } : m));
      }
    } catch (error: any) {
      console.error(error);
      if (error.message && error.message.includes("Requested entity was not found.")) {
        alert("Sua chave de API do Gemini pode estar inválida ou expirada. Por favor, re-selecione nas configurações.");
        setGeminiApiKeySelected(false);
      }
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
      const fileName = `PROFEPLAN - ${discipline || 'Plano'} - ${grade || 'Geral'} - ${new Date().toLocaleDateString('pt-BR').replace(/\//g, '-')}`;

      const createResponse = await fetch('https://www.googleapis.com/drive/v3/files', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${googleToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          name: fileName,
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

      // Salva o metadata do arquivo no localStorage para ser exibido no DriveExplorer
      const newDriveFile: DriveFile = {
        id: file.id,
        name: fileName + '.docx', // Adicionar extensão para melhor visualização, embora seja um Google Doc
        type: 'DOC',
        createdAt: new Date(),
        size: 'Pequeno', // Tamanho real não é facilmente acessível aqui, pode ser um placeholder
      };

      const existingFilesRaw = localStorage.getItem(`profeplan_drive_${session.email}`);
      const existingFiles: DriveFile[] = existingFilesRaw ? JSON.parse(existingFilesRaw) : [];
      localStorage.setItem(`profeplan_drive_${session.email}`, JSON.stringify([...existingFiles, newDriveFile]));


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

    if (!geminiApiKeySelected) {
      alert("Chave de API do Gemini não selecionada. Por favor, configure nas 'Configurações'.");
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
        fullText += chunk.text || '';
        setMessages(prev => prev.map(m => m.id === aiId ? { ...m, content: fullText } : m));
      }
    } catch (error: any) {
      console.error(error);
      if (error.message && error.message.includes("Requested entity was not found.")) {
        alert("Sua chave de API do Gemini pode estar inválida ou expirada. Por favor, re-selecione nas configurações.");
        setGeminiApiKeySelected(false);
      }
      const errorMsgText = "### ⚠️ ERRO NO MOTOR DE IA\nNão foi possível completar o processamento técnico agora. Verifique sua conexão.";
      setMessages(prev => [...prev, { id: Date.now().toString(), role: MessageRole.ASSISTANT, content: errorMsgText, timestamp: new Date() }]);
    } finally {
      setIsThinking(false);
    }
  };

  // Fix: Defined `renderActiveContent` function to conditionally render components
  const renderActiveContent = () => {
    switch (activeMode) {
      case ToolMode.CHAT:
      case ToolMode.PLANNING: // Planning can also use the chat interface
      case ToolMode.ACTIVITIES:
      case ToolMode.INCLUSION:
      case ToolMode.SIMULATION:
      case ToolMode.AUDITOR:
        return (
          <>
            <div className="flex-1 overflow-y-auto p-8 custom-scrollbar">
              {messages.map((msg, index) => (
                <div key={msg.id} className={`flex ${msg.role === MessageRole.USER ? 'justify-end' : 'justify-start'} mb-8`}>
                  <div className={`flex items-start gap-4 max-w-[80%]`}>
                    {msg.role === MessageRole.ASSISTANT && (
                      <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center shrink-0 shadow-lg">
                        <Bot className="w-5 h-5" />
                      </div>
                    )}
                    <div className={`p-5 rounded-3xl shadow-lg relative ${
                      msg.role === MessageRole.USER 
                        ? 'bg-blue-500 text-white rounded-br-none' 
                        : 'bg-white text-slate-800 rounded-bl-none border border-slate-100'
                    }`}>
                      <MarkdownRenderer content={msg.content} />
                      <span className={`absolute text-[9px] font-medium opacity-60 mt-1 ${
                        msg.role === MessageRole.USER ? 'bottom-2 left-5 text-blue-100' : 'bottom-2 right-5 text-slate-400'
                      }`}>
                        {msg.timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                      </span>
                      {msg.role === MessageRole.ASSISTANT && msg.id !== 'initial' && (
                        <button 
                          onClick={() => handleCopyText(msg.content, msg.id)}
                          className="absolute -top-3 -right-3 p-2 bg-slate-100 text-slate-500 rounded-full shadow-md hover:bg-slate-200 transition-colors"
                          title="Copiar texto"
                        >
                          {copiedId === msg.id ? <Check className="w-4 h-4 text-emerald-500" /> : <Copy className="w-4 h-4" />}
                        </button>
                      )}
                    </div>
                    {msg.role === MessageRole.USER && (
                      <div className="w-10 h-10 bg-slate-800 text-white rounded-full flex items-center justify-center shrink-0 shadow-lg">
                        <User className="w-5 h-5" />
                      </div>
                    )}
                  </div>
                </div>
              ))}
              {isThinking && (
                <div className="flex justify-start mb-8">
                  <div className="flex items-start gap-4">
                    <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center shrink-0 shadow-lg">
                      <Bot className="w-5 h-5" />
                    </div>
                    <div className="p-5 bg-white text-slate-800 rounded-3xl rounded-bl-none shadow-lg border border-slate-100 flex items-center gap-3">
                      <Loader2 className="w-5 h-5 animate-spin text-blue-500" />
                      <span className="text-sm font-medium text-slate-600">PROFEPLAN está pensando...</span>
                    </div>
                  </div>
                </div>
              )}
              <div ref={messagesEndRef} />
            </div>

            <form onSubmit={handleSendMessage} className="bg-white p-8 border-t border-slate-100 flex items-center gap-4 sticky bottom-0 z-10">
              <div className="relative flex-1">
                {selectedImage && (
                  <div className="absolute -top-16 left-0 bg-slate-50 p-2 rounded-xl shadow-md flex items-center gap-2 text-xs font-medium text-slate-700">
                    <img src={selectedImage.data} alt="Preview" className="h-8 w-8 object-cover rounded" />
                    <span>Imagem anexada</span>
                    <button type="button" onClick={() => setSelectedImage(null)} className="p-1 rounded-full hover:bg-slate-100">
                      <X className="w-3 h-3" />
                    </button>
                  </div>
                )}
                <input
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  placeholder="Envie uma mensagem, solicite um plano de aula, atividade..."
                  className="w-full bg-slate-50 p-5 rounded-2xl text-sm border-2 border-transparent focus:border-blue-500 transition-all outline-none pr-32"
                  disabled={isThinking}
                />
                <div className="absolute right-3 top-1/2 -translate-y-1/2 flex items-center gap-2">
                  <button 
                    type="button" 
                    onClick={() => fileInputRef.current?.click()}
                    className="p-3 bg-slate-200 text-slate-600 rounded-xl hover:bg-slate-300 transition-all"
                    title="Anexar Imagem"
                    disabled={isThinking}
                  >
                    <ImageIcon className="w-5 h-5" />
                  </button>
                  <input
                    type="file"
                    ref={fileInputRef}
                    className="hidden"
                    accept="image/*"
                    onChange={(e) => {
                      const file = e.target.files?.[0];
                      if (file) {
                        const reader = new FileReader();
                        reader.onloadend = () => {
                          setSelectedImage({ data: reader.result as string, type: file.type });
                        };
                        reader.readAsDataURL(file);
                      }
                    }}
                  />
                  {isRecording ? (
                    <button
                      type="button"
                      onClick={stopRecording}
                      className="p-3 bg-red-500 text-white rounded-xl hover:bg-red-600 transition-all animate-pulse"
                      title="Parar Gravação"
                    >
                      <Square className="w-5 h-5" />
                    </button>
                  ) : (
                    <button
                      type="button"
                      onClick={startRecording}
                      className="p-3 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-all"
                      title="Gravar Mensagem de Voz"
                      disabled={isThinking}
                    >
                      <Mic className="w-5 h-5" />
                    </button>
                  )}
                </div>
              </div>
              <button
                type="submit"
                className="p-4 bg-blue-600 text-white rounded-2xl hover:bg-blue-700 transition-all shadow-lg hover:shadow-xl disabled:opacity-50 disabled:cursor-not-allowed"
                disabled={isThinking || (!input.trim() && !selectedImage && !isRecording)}
              >
                {isThinking ? (
                  <Loader2 className="w-6 h-6 animate-spin" />
                ) : (
                  <Send className="w-6 h-6" />
                )}
              </button>
            </form>
          </>
        );
      case ToolMode.FILES:
        return <DriveExplorer userEmail={session.email} />;
      case ToolMode.ADMIN:
        return session.role === 'ADMIN' ? <AdminDashboard /> : (
          <div className="flex-1 flex items-center justify-center text-slate-500 text-lg font-medium p-8">
            <Info className="w-6 h-6 mr-3" /> Acesso negado. Esta área é restrita a administradores.
          </div>
        );
      default:
        return (
          <div className="flex-1 flex items-center justify-center text-slate-500 text-lg font-medium p-8">
            <Info className="w-6 h-6 mr-3" /> Modo de ferramenta não implementado.
          </div>
        );
    }
  };

  return (
    <div className="flex h-screen bg-slate-50 overflow-hidden font-sans">
      <Sidebar 
        activeMode={activeMode} 
        setActiveMode={setActiveMode} 
        onOpenSettings={() => setIsSettingsOpen(true)} 
        isOpen={isMobileNavOpen} // Controls mobile overlay
        onClose={() => setIsMobileNavOpen(false)} 
        userRole={session.role}
        isDesktopExpanded={isLeftNavExpanded} // Controls desktop width
        onToggleDesktopExpand={() => setIsLeftNavExpanded(prev => !prev)}
      />
      
      <main 
        className={`flex-1 flex flex-col relative h-full transition-all duration-300 
          ${isLeftNavExpanded ? 'lg:ml-64' : 'lg:ml-20'} 
          ${isRightNavExpanded ? 'lg:mr-72' : 'lg:mr-20'} {/* CORREÇÃO AQUI: lg:mr-20 quando recolhido */}
        `}
      >
        <header className="h-20 bg-white/80 backdrop-blur-2xl border-b border-slate-100 flex items-center justify-between px-8 z-50 sticky top-0 shadow-sm">
          <div className="flex items-center gap-6">
            {/* Toggle para o sidebar esquerdo em mobile */}
            <button onClick={() => setIsMobileNavOpen(true)} className="lg:hidden p-3 text-slate-500 hover:bg-slate-50 rounded-2xl">
              <Menu />
            </button>
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
            {!geminiApiKeySelected && (
              <button 
                onClick={handleSelectGeminiApiKey}
                className="flex items-center gap-2 px-4 py-2 bg-red-500 text-white rounded-xl text-sm font-bold shadow-md hover:bg-red-600 transition-colors"
                title="API Key do Gemini não selecionada"
              >
                <Key className="w-4 h-4" />
                <span>API Key</span>
              </button>
            )}
          </div>
        </header>

        <div className="flex-1 overflow-hidden relative flex flex-col">
          {renderActiveContent()}
        </div>
      </main>

      <aside 
        className={`h-screen bg-white border-l border-slate-100 flex-col space-y-8 shrink-0 shadow-xl transition-all duration-300 lg:flex
          ${isRightNavExpanded ? 'lg:w-72 p-8' : 'lg:w-20 p-2'}
        `}
      >
        {/* Toggle button always visible at the top of the aside */}
        <div className={`flex items-center ${isRightNavExpanded ? 'justify-between' : 'justify-center'} mb-4`}> {/* Ajuste de justify aqui */}
          {/* Botão de toggle à esquerda quando expandido */}
          <button 
            onClick={() => setIsRightNavExpanded(prev => !prev)} 
            className="p-2 text-slate-500 hover:bg-slate-100 rounded-full"
            title={isRightNavExpanded ? 'Recolher menu lateral' : 'Expandir menu lateral'}
          >
            {/* Lógica do ícone: ChevronRight para recolher (aponta para a direita), ChevronLeft para expandir (aponta para a esquerda) */}
            {isRightNavExpanded ? <ChevronRight className="w-5 h-5" /> : <ChevronLeft className="w-5 h-5" />}
          </button>
          {isRightNavExpanded && ( // Título "Filtros Rápidos" à direita do botão quando expandido
            <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic">Filtros Rápidos</h3>
          )}
        </div>

        {isRightNavExpanded && ( // Content only visible when expanded
          <>
            <div>
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
          </>
        )}

        {/* Export buttons - always visible, but adapt content based on expanded state */}
        <div className="pt-2">
          {isRightNavExpanded && <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-4">Exportação</h3>}
          <div className={`grid grid-cols-1 gap-3 ${isRightNavExpanded ? '' : 'flex flex-col items-center'}`}>
            <button 
              onClick={handleExportDocx}
              className={`flex items-center gap-3 w-full p-4 bg-blue-50 text-blue-700 rounded-2xl text-[11px] font-black uppercase tracking-tight border border-blue-100 hover:bg-blue-100 transition-all
                ${!isRightNavExpanded ? 'justify-center !p-2' : ''}
              `}
              title={!isRightNavExpanded ? 'Salvar como Word' : 'Salvar como Word'}
            >
              <Download size={16} /> {isRightNavExpanded && 'Salvar como Word'}
            </button>
            <button 
              onClick={handleSaveGoogleDocs}
              disabled={isSavingToDrive}
              className={`flex items-center gap-3 w-full p-4 rounded-2xl text-[11px] font-black uppercase tracking-tight border transition-all ${
                isSavingToDrive 
                  ? 'bg-slate-100 text-slate-400 border-slate-200 shadow-none' 
                  : 'bg-emerald-50 text-emerald-700 border-emerald-100 hover:bg-emerald-100 shadow-sm'
              }
                ${!isRightNavExpanded ? 'justify-center !p-2' : ''}
              `}
              title={!isRightNavExpanded ? 'Google Docs' : 'Google Docs'}
            >
              {isSavingToDrive ? <Loader2 size={16} className="animate-spin" /> : <Cloud size={16} />} 
              {isRightNavExpanded && 'Google Docs'}
            </button>
          </div>
        </div>

        {isRightNavExpanded && ( // Card de IA Docente só visível quando expandido
          <div className="mt-auto pt-8 border-t border-slate-100">
            <div className="rounded-[2.5rem] p-6 text-white shadow-xl relative overflow-hidden group bg-gradient-to-br from-blue-600 to-indigo-700">
              <Sparkle className="absolute -bottom-6 -left-6 w-24 h-24 opacity-10 transition-transform group-hover:scale-125" />
              <p className="text-[9px] font-black uppercase tracking-widest mb-1 opacity-70 italic">IA DOCENTE</p>
              <p className="text-sm font-bold italic uppercase leading-tight tracking-tight">Gemini Workspace<br/>Sync Ativo</p>
            </div>
          </div>
        )}
      </aside>

      <SettingsModal 
        isOpen={isSettingsOpen} 
        onClose={() => setIsSettingsOpen(false)} 
        settings={settings} 
        setSettings={setSettings} 
        onConnectDrive={handleConnectDrive}
        isDriveConnected={!!googleToken}
        isGeminiApiKeySelected={geminiApiKeySelected}
        onSelectGeminiApiKey={handleSelectGeminiApiKey}
        userEmail={session.email}
      />
    </div>
  );
};

export default App;