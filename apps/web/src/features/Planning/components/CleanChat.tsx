import React from 'react';
import {
  Bot,
  User,
  Loader2,
  Send,
  Trash2,
  CalendarRange,
  LayoutDashboard,
  Users,
  BookOpen,
  Save,
  Download,
} from 'lucide-react';
import { Message, MessageRole } from '../../../types';
import { QuestionSearchWidget } from '../../../components/QuestionFinder/QuestionSearchWidget';
import { IconButton } from '../../../components/ui';

interface CleanChatProps {
  messages: Message[];
  isThinking: boolean;
  input: string;
  setInput: (val: string) => void;
  handleSendMessage: (e: React.FormEvent) => void;
  handleClearChat: () => void;
  messagesEndRef: React.RefObject<HTMLDivElement | null>;
  onSave?: (content: string) => void;
  onExport?: (content: string) => void;
}

const suggestions = [
  {
    title: 'Organizar o trimestre',
    description: 'Quero planejar uma sequência de aulas.',
    prompt: 'Quero planejar uma sequência de aulas para este trimestre. Por onde começo?',
    icon: CalendarRange,
    iconStyle: 'bg-indigo-50 text-indigo-700',
  },
  {
    title: 'Criar plano de aula',
    description: 'Quero montar um plano completo agora.',
    prompt:
      'Quero criar um plano de aula completo para a próxima aula. O que você precisa saber de mim?',
    icon: LayoutDashboard,
    iconStyle: 'bg-blue-50 text-blue-700',
  },
  {
    title: 'Alinhar à BNCC e ao CRMG',
    description: 'Preciso localizar habilidades curriculares.',
    prompt: 'Tenho dúvidas sobre como alinhar minhas aulas à BNCC/CRMG. Pode me orientar?',
    icon: BookOpen,
    iconStyle: 'bg-emerald-50 text-emerald-700',
  },
  {
    title: 'Organizar minhas turmas',
    description: 'Quero estruturar estudantes e turmas.',
    prompt: 'Quero organizar melhor minhas turmas e alunos no ProfePlan. Por onde começo?',
    icon: Users,
    iconStyle: 'bg-sky-50 text-sky-700',
  },
];

export const CleanChat: React.FC<CleanChatProps> = ({
  messages,
  isThinking,
  input,
  setInput,
  handleSendMessage,
  handleClearChat,
  messagesEndRef,
  onSave,
  onExport,
}) => (
  <div className="relative flex h-full flex-1 flex-col bg-slate-50">
    <div
      className="custom-scrollbar flex-1 space-y-5 overflow-y-auto px-4 py-6 sm:px-6 lg:px-10"
      role="log"
      aria-live="polite"
      aria-label="Conversa com o assistente pedagógico"
    >
      {messages.length === 0 && (
        <section className="mx-auto flex min-h-full w-full max-w-4xl flex-col items-center justify-center py-8 text-center">
          <span className="mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-indigo-100 text-indigo-700">
            <Bot aria-hidden="true" className="h-8 w-8" />
          </span>
          <h2 className="text-2xl font-semibold text-slate-950 sm:text-3xl">Como posso ajudar?</h2>
          <p className="mt-2 max-w-2xl text-base leading-6 text-slate-600">
            Peça ideias, tire dúvidas ou comece com uma das sugestões abaixo. Você poderá revisar
            todo o conteúdo gerado.
          </p>

          <div className="mt-8 grid w-full grid-cols-1 gap-3 sm:grid-cols-2">
            {suggestions.map((suggestion) => {
              const SuggestionIcon = suggestion.icon;
              return (
                <button
                  key={suggestion.title}
                  type="button"
                  onClick={() => setInput(suggestion.prompt)}
                  className="ui-focus-ring ui-reduce-motion flex min-h-24 items-start gap-4 rounded-xl border border-slate-200 bg-white p-4 text-left transition-colors hover:border-indigo-300 hover:bg-indigo-50/40"
                >
                  <span
                    className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-lg ${suggestion.iconStyle}`}
                  >
                    <SuggestionIcon aria-hidden="true" className="h-5 w-5" />
                  </span>
                  <span>
                    <span className="block text-base font-semibold text-slate-900">
                      {suggestion.title}
                    </span>
                    <span className="mt-1 block text-sm leading-5 text-slate-600">
                      {suggestion.description}
                    </span>
                  </span>
                </button>
              );
            })}
          </div>
        </section>
      )}

      {messages.map((message) => {
        const isUser = message.role === MessageRole.USER;
        return (
          <article
            key={message.id}
            className={`mx-auto flex max-w-4xl gap-3 ${isUser ? 'flex-row-reverse' : ''}`}
          >
            <span
              className={`flex h-9 w-9 shrink-0 items-center justify-center rounded-full ${
                isUser
                  ? 'bg-indigo-700 text-white'
                  : 'border border-slate-200 bg-white text-emerald-700'
              }`}
              aria-hidden="true"
            >
              {isUser ? <User className="h-4 w-4" /> : <Bot className="h-4 w-4" />}
            </span>
            <div
              className={`max-w-[88%] rounded-2xl px-4 py-3 text-base leading-6 shadow-sm sm:max-w-[80%] ${
                isUser
                  ? 'rounded-tr-sm bg-indigo-700 text-white'
                  : 'rounded-tl-sm border border-slate-200 bg-white text-slate-800'
              }`}
            >
              <p className="whitespace-pre-wrap">{message.content}</p>
              {!isUser && message.content.length > 80 && (onSave || onExport) && (
                <div className="mt-4 flex flex-wrap gap-2 border-t border-slate-200 pt-3">
                  {onSave && (
                    <button
                      type="button"
                      onClick={() => onSave(message.content)}
                      className="ui-focus-ring inline-flex min-h-9 items-center gap-2 rounded-lg bg-emerald-50 px-3 text-sm font-semibold text-emerald-800 hover:bg-emerald-100"
                    >
                      <Save aria-hidden="true" className="h-4 w-4" /> Salvar
                    </button>
                  )}
                  {onExport && (
                    <button
                      type="button"
                      onClick={() => onExport(message.content)}
                      className="ui-focus-ring inline-flex min-h-9 items-center gap-2 rounded-lg bg-indigo-50 px-3 text-sm font-semibold text-indigo-800 hover:bg-indigo-100"
                    >
                      <Download aria-hidden="true" className="h-4 w-4" /> Baixar DOCX
                    </button>
                  )}
                </div>
              )}
            </div>
          </article>
        );
      })}

      {isThinking && (
        <div className="mx-auto flex max-w-4xl items-center gap-3" role="status">
          <span className="flex h-9 w-9 items-center justify-center rounded-full border border-slate-200 bg-white">
            <Loader2
              aria-hidden="true"
              className="h-5 w-5 animate-spin text-emerald-700 ui-reduce-motion"
            />
          </span>
          <span className="rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm font-medium text-slate-600">
            Preparando uma resposta pedagógica...
          </span>
        </div>
      )}
      <div ref={messagesEndRef} />
    </div>

    <div className="sticky bottom-0 z-10 border-t border-slate-200 bg-white p-3 pb-[calc(0.75rem+env(safe-area-inset-bottom))] sm:p-4">
      <form onSubmit={handleSendMessage} className="mx-auto flex max-w-4xl items-end gap-2">
        <label htmlFor="pedagogical-assistant-input" className="sr-only">
          Mensagem para o assistente pedagógico
        </label>
        <textarea
          id="pedagogical-assistant-input"
          value={input}
          onChange={(event) => setInput(event.target.value)}
          onKeyDown={(event) => {
            if (event.key === 'Enter' && !event.shiftKey) {
              event.preventDefault();
              handleSendMessage(event);
            }
          }}
          placeholder="Digite sua dúvida ou solicitação pedagógica..."
          className="ui-focus-ring custom-scrollbar max-h-32 min-h-12 flex-1 resize-none rounded-xl border border-slate-300 bg-white px-4 py-3 text-base text-slate-900 placeholder:text-slate-500"
          rows={1}
        />
        <IconButton
          type="submit"
          label={isThinking ? 'Aguarde a resposta' : 'Enviar mensagem'}
          disabled={!input.trim() || isThinking}
          icon={
            isThinking ? (
              <Loader2 aria-hidden="true" className="h-5 w-5 animate-spin ui-reduce-motion" />
            ) : (
              <Send aria-hidden="true" className="h-5 w-5" />
            )
          }
          variant="primary"
          className="h-12 w-12 shrink-0"
        />
      </form>
      {messages.length > 0 && (
        <div className="mx-auto mt-2 flex max-w-4xl justify-end">
          <button
            type="button"
            onClick={handleClearChat}
            className="ui-focus-ring inline-flex min-h-9 items-center gap-2 rounded-lg px-3 text-sm font-medium text-slate-600 hover:bg-red-50 hover:text-red-700"
          >
            <Trash2 aria-hidden="true" className="h-4 w-4" /> Limpar conversa
          </button>
        </div>
      )}
    </div>

    <div className="px-4 pb-8 pt-4">
      <QuestionSearchWidget />
    </div>
  </div>
);
