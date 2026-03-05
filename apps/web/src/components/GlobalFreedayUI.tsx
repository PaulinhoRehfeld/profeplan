import React, { useEffect, useRef, useState } from 'react';
import { useFreedayContext, FreedayState } from '../contexts/FreedayContext';

// ==================== Sound Wave Animation ====================
const SoundWave: React.FC<{ bars?: number }> = ({ bars = 5 }) => (
    <div className="freeday-wave" aria-hidden="true">
        {Array.from({ length: bars }).map((_, i) => (
            <span key={i} className="freeday-wave-bar" style={{ animationDelay: `${i * 0.1}s` }} />
        ))}
    </div>
);

// ==================== Mic Icon ====================
const MicIcon = () => (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
        <path d="M12 1a4 4 0 0 1 4 4v6a4 4 0 0 1-8 0V5a4 4 0 0 1 4-4z" />
        <path d="M19 10a1 1 0 0 0-2 0 5 5 0 0 1-10 0 1 1 0 0 0-2 0 7 7 0 0 0 6 6.93V19H9a1 1 0 0 0 0 2h6a1 1 0 0 0 0-2h-2v-2.07A7 7 0 0 0 19 10z" />
    </svg>
);

// ==================== Main Widget ====================
export const GlobalFreedayUI: React.FC = () => {
    const { state, messages, isSupported, startListening, stopListening, clearMessages } =
        useFreedayContext();

    const [expanded, setExpanded] = useState(false);
    const [inputText, setInputText] = useState('');
    const { sendTextMessage } = useFreedayContext();
    const messagesEndRef = useRef<HTMLDivElement>(null);

    const isListening = state === 'listening';
    const isSpeaking = state === 'speaking';
    const isThinking = state === 'thinking';

    useEffect(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, [messages]);

    const handleMicClick = () => {
        if (isListening) {
            stopListening();
        } else {
            startListening();
        }
    };

    const handleSendText = (e: React.FormEvent) => {
        e.preventDefault();
        if (!inputText.trim()) return;
        sendTextMessage(inputText.trim());
        setInputText('');
    };

    const getButtonLabel = (): string => {
        if (isListening) return 'Ouvindo...';
        if (isSpeaking) return 'Falando...';
        if (isThinking) return 'Pensando...';
        return 'FREEDAY';
    };

    return (
        <>
            <style>{FREEDAY_STYLES}</style>

            {/* Floating Trigger Button */}
            <button
                id="freeday-trigger"
                className={`freeday-fab ${state !== 'idle' ? `freeday-fab--${state}` : ''}`}
                onClick={() => setExpanded((prev) => !prev)}
                aria-label="Abrir FREEDAY"
                title={getButtonLabel()}
            >
                <span className="freeday-fab-ring" />
                <span className="freeday-fab-inner">
                    {(isListening || isSpeaking) && <SoundWave />}
                    {!isListening && !isSpeaking && (
                        <span className="freeday-fab-logo">F</span>
                    )}
                </span>
                <span className="freeday-fab-label">{getButtonLabel()}</span>
            </button>

            {/* Expanded Panel */}
            {expanded && (
                <div className="freeday-panel" role="dialog" aria-label="FREEDAY Assistant">
                    {/* Header */}
                    <div className="freeday-panel__header">
                        <div className="freeday-panel__title">
                            <span className="freeday-status-dot" data-state={state} />
                            <span>FREEDAY</span>
                            {isThinking && <span className="freeday-thinking-dots">...</span>}
                        </div>
                        <div className="freeday-panel__actions">
                            <button
                                onClick={clearMessages}
                                className="freeday-btn-ghost"
                                title="Limpar conversa"
                                aria-label="Limpar conversa"
                            >
                                ✕ Limpar
                            </button>
                            <button
                                onClick={() => setExpanded(false)}
                                className="freeday-btn-ghost"
                                aria-label="Fechar"
                            >
                                ╲╱
                            </button>
                        </div>
                    </div>

                    {/* Messages */}
                    <div className="freeday-panel__messages">
                        {messages.length === 0 && (
                            <div className="freeday-empty">
                                <span>👋</span>
                                <p>Olá, Gerson. Estou pronta.</p>
                                <p className="freeday-hint">
                                    {isSupported
                                        ? 'Clique no microfone ou digite sua pergunta.'
                                        : 'Voz não suportada. Use o campo de texto.'}
                                </p>
                            </div>
                        )}
                        {messages.map((msg, i) => (
                            <div
                                key={i}
                                className={`freeday-msg freeday-msg--${msg.role}`}
                                aria-label={msg.role === 'user' ? 'Gerson' : 'FREEDAY'}
                            >
                                <span className="freeday-msg__label">
                                    {msg.role === 'user' ? 'Gerson' : 'FREEDAY'}
                                </span>
                                <p className="freeday-msg__text">{msg.content}</p>
                            </div>
                        ))}
                        <div ref={messagesEndRef} />
                    </div>

                    {/* Input Area */}
                    <div className="freeday-panel__footer">
                        {isSupported && (
                            <button
                                id="freeday-mic-btn"
                                className={`freeday-mic-btn ${isListening ? 'freeday-mic-btn--active' : ''}`}
                                onClick={handleMicClick}
                                aria-label={isListening ? 'Parar de ouvir' : 'Falar com FREEDAY'}
                                title={isListening ? 'Parar' : 'Falar'}
                            >
                                <MicIcon />
                            </button>
                        )}
                        <form className="freeday-form" onSubmit={handleSendText}>
                            <input
                                id="freeday-text-input"
                                className="freeday-input"
                                type="text"
                                placeholder="Digite um comando..."
                                value={inputText}
                                onChange={(e) => setInputText(e.target.value)}
                                disabled={isThinking}
                                aria-label="Mensagem para FREEDAY"
                            />
                            <button
                                id="freeday-send-btn"
                                type="submit"
                                className="freeday-send-btn"
                                disabled={!inputText.trim() || isThinking}
                                aria-label="Enviar"
                            >
                                ↑
                            </button>
                        </form>
                    </div>
                </div>
            )}
        </>
    );
};

// ==================== Inline CSS for zero-dependency styling ====================
const FREEDAY_STYLES = `
  /* === FAB Button === */
  .freeday-fab {
    position: fixed;
    bottom: 24px;
    right: 24px;
    z-index: 9999;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    background: none;
    border: none;
    cursor: pointer;
    outline: none;
  }

  .freeday-fab-ring {
    position: absolute;
    inset: -4px;
    border-radius: 50%;
    border: 2px solid rgba(99, 102, 241, 0.4);
    animation: freeday-pulse 3s ease-in-out infinite;
  }

  .freeday-fab--listening .freeday-fab-ring {
    border-color: rgba(16, 185, 129, 0.8);
    animation: freeday-pulse 0.8s ease-in-out infinite;
  }
  .freeday-fab--speaking .freeday-fab-ring {
    border-color: rgba(99, 102, 241, 0.9);
    animation: freeday-pulse 0.6s ease-in-out infinite;
  }
  .freeday-fab--thinking .freeday-fab-ring {
    border-color: rgba(245, 158, 11, 0.8);
    animation: freeday-pulse 1s ease-in-out infinite;
  }

  .freeday-fab-inner {
    width: 56px;
    height: 56px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    box-shadow: 0 4px 24px rgba(79, 70, 229, 0.5);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  .freeday-fab:hover .freeday-fab-inner {
    transform: scale(1.08);
    box-shadow: 0 6px 32px rgba(79, 70, 229, 0.7);
  }
  .freeday-fab--listening .freeday-fab-inner {
    background: linear-gradient(135deg, #059669 0%, #10b981 100%);
    box-shadow: 0 4px 24px rgba(16, 185, 129, 0.5);
  }
  .freeday-fab--speaking .freeday-fab-inner {
    background: linear-gradient(135deg, #4f46e5 0%, #a855f7 100%);
  }
  .freeday-fab--thinking .freeday-fab-inner {
    background: linear-gradient(135deg, #d97706 0%, #f59e0b 100%);
  }

  .freeday-fab-logo {
    font-size: 22px;
    font-weight: 900;
    color: white;
    font-family: 'Inter', sans-serif;
    letter-spacing: -1px;
  }

  .freeday-fab-label {
    font-size: 10px;
    font-weight: 700;
    color: #4f46e5;
    letter-spacing: 0.08em;
    text-transform: uppercase;
  }
  .freeday-fab--listening .freeday-fab-label { color: #059669; }
  .freeday-fab--speaking .freeday-fab-label { color: #7c3aed; }
  .freeday-fab--thinking .freeday-fab-label { color: #d97706; }

  /* === Sound Wave === */
  .freeday-wave {
    display: flex;
    align-items: center;
    gap: 3px;
    height: 24px;
  }
  .freeday-wave-bar {
    display: block;
    width: 3px;
    border-radius: 99px;
    background: white;
    animation: freeday-wave 0.8s ease-in-out infinite alternate;
  }
  .freeday-wave-bar:nth-child(1) { height: 8px; }
  .freeday-wave-bar:nth-child(2) { height: 16px; }
  .freeday-wave-bar:nth-child(3) { height: 22px; }
  .freeday-wave-bar:nth-child(4) { height: 16px; }
  .freeday-wave-bar:nth-child(5) { height: 8px; }

  @keyframes freeday-wave {
    from { transform: scaleY(0.4); }
    to   { transform: scaleY(1.0); }
  }
  @keyframes freeday-pulse {
    0%, 100% { opacity: 1; transform: scale(1); }
    50%       { opacity: 0.5; transform: scale(1.08); }
  }

  /* === Panel === */
  .freeday-panel {
    position: fixed;
    bottom: 96px;
    right: 24px;
    z-index: 9998;
    width: 340px;
    max-height: 520px;
    display: flex;
    flex-direction: column;
    border-radius: 20px;
    background: rgba(15, 15, 25, 0.95);
    backdrop-filter: blur(24px);
    box-shadow: 0 24px 80px rgba(0, 0, 0, 0.6), 0 0 0 1px rgba(255,255,255,0.08);
    overflow: hidden;
    animation: freeday-slide-in 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  }

  @keyframes freeday-slide-in {
    from { opacity: 0; transform: translateY(16px) scale(0.96); }
    to   { opacity: 1; transform: translateY(0) scale(1); }
  }

  .freeday-panel__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 14px 16px 12px;
    border-bottom: 1px solid rgba(255,255,255,0.08);
    flex-shrink: 0;
  }
  .freeday-panel__title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-family: 'Inter', sans-serif;
    font-weight: 700;
    font-size: 15px;
    color: white;
    letter-spacing: 0.04em;
  }
  .freeday-status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #6b7280;
    transition: background 0.3s;
  }
  .freeday-status-dot[data-state="idle"]      { background: #6b7280; }
  .freeday-status-dot[data-state="listening"] { background: #10b981; animation: freeday-blink 0.8s infinite; }
  .freeday-status-dot[data-state="thinking"]  { background: #f59e0b; animation: freeday-blink 1s infinite; }
  .freeday-status-dot[data-state="speaking"]  { background: #818cf8; animation: freeday-blink 0.6s infinite; }
  @keyframes freeday-blink {
    0%, 100% { opacity: 1; }
    50%      { opacity: 0.3; }
  }
  .freeday-thinking-dots {
    font-size: 18px;
    color: #f59e0b;
    letter-spacing: 2px;
    animation: freeday-blink 1s infinite;
  }

  .freeday-panel__actions {
    display: flex;
    align-items: center;
    gap: 4px;
  }
  .freeday-btn-ghost {
    background: none;
    border: none;
    color: rgba(255,255,255,0.45);
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 8px;
    transition: color 0.2s, background 0.2s;
  }
  .freeday-btn-ghost:hover {
    color: white;
    background: rgba(255,255,255,0.08);
  }

  /* === Messages === */
  .freeday-panel__messages {
    flex: 1;
    overflow-y: auto;
    padding: 12px 14px;
    display: flex;
    flex-direction: column;
    gap: 10px;
    scrollbar-width: thin;
    scrollbar-color: rgba(255,255,255,0.1) transparent;
  }
  .freeday-empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    padding: 32px 0;
    color: rgba(255,255,255,0.4);
    font-family: 'Inter', sans-serif;
    text-align: center;
  }
  .freeday-empty span { font-size: 28px; }
  .freeday-empty p { font-size: 14px; margin: 0; }
  .freeday-hint { font-size: 11px !important; color: rgba(255,255,255,0.25) !important; }

  .freeday-msg { display: flex; flex-direction: column; gap: 3px; max-width: 90%; }
  .freeday-msg--user { align-self: flex-end; align-items: flex-end; }
  .freeday-msg--assistant { align-self: flex-start; align-items: flex-start; }
  .freeday-msg__label {
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgba(255,255,255,0.35);
    font-family: 'Inter', sans-serif;
  }
  .freeday-msg__text {
    margin: 0;
    padding: 10px 13px;
    border-radius: 14px;
    font-size: 13.5px;
    line-height: 1.5;
    font-family: 'Inter', sans-serif;
  }
  .freeday-msg--user .freeday-msg__text {
    background: linear-gradient(135deg, #4f46e5, #7c3aed);
    color: white;
    border-bottom-right-radius: 4px;
  }
  .freeday-msg--assistant .freeday-msg__text {
    background: rgba(255,255,255,0.08);
    color: rgba(255,255,255,0.9);
    border-bottom-left-radius: 4px;
  }

  /* === Footer === */
  .freeday-panel__footer {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 12px;
    border-top: 1px solid rgba(255,255,255,0.08);
    flex-shrink: 0;
  }
  .freeday-form {
    display: flex;
    flex: 1;
    align-items: center;
    gap: 6px;
    background: rgba(255,255,255,0.07);
    border-radius: 99px;
    border: 1px solid rgba(255,255,255,0.1);
    padding: 0 8px 0 14px;
    transition: border-color 0.2s;
  }
  .freeday-form:focus-within { border-color: rgba(99, 102, 241, 0.6); }
  .freeday-input {
    flex: 1;
    background: none;
    border: none;
    outline: none;
    color: white;
    font-size: 13.5px;
    padding: 9px 0;
    font-family: 'Inter', sans-serif;
  }
  .freeday-input::placeholder { color: rgba(255,255,255,0.3); }

  .freeday-mic-btn {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    border: none;
    background: rgba(99, 102, 241, 0.2);
    color: #818cf8;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: background 0.2s, color 0.2s, transform 0.1s;
    flex-shrink: 0;
  }
  .freeday-mic-btn:hover { background: rgba(99, 102, 241, 0.35); transform: scale(1.05); }
  .freeday-mic-btn--active {
    background: linear-gradient(135deg, #059669, #10b981);
    color: white;
    animation: freeday-pulse 0.8s ease-in-out infinite;
  }
  .freeday-send-btn {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    border: none;
    background: linear-gradient(135deg, #4f46e5, #7c3aed);
    color: white;
    font-size: 16px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: opacity 0.2s, transform 0.1s;
    flex-shrink: 0;
  }
  .freeday-send-btn:disabled { opacity: 0.35; cursor: default; }
  .freeday-send-btn:not(:disabled):hover { transform: scale(1.1); }

  @media (max-width: 400px) {
    .freeday-panel { width: calc(100vw - 24px); right: 12px; bottom: 88px; }
    .freeday-fab { bottom: 16px; right: 16px; }
  }
`;
