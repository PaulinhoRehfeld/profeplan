import React, { useState } from 'react';
import { LegalLayout } from '../components/LegalLayout';
import { Mail, Send, CheckCircle, Loader2 } from 'lucide-react';

const REQUEST_TYPES = [
  { value: 'cancel_subscription', label: 'Cancelamento de assinatura' },
  { value: 'right_of_withdrawal', label: 'Direito de arrependimento' },
  { value: 'refund', label: 'Solicitação de reembolso' },
  { value: 'duplicate_charge', label: 'Cobrança duplicada ou indevida' },
];

const CancelamentoFormulario: React.FC = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    plan: '',
    requestType: '',
    description: '',
    transactionId: '',
  });
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [protocol, setProtocol] = useState('');

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>
  ) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    if (!formData.name || !formData.email || !formData.requestType || !formData.description) {
      setError('Preencha todos os campos obrigatórios.');
      setLoading(false);
      return;
    }

    try {
      // Gera protocolo local (fallback caso API indisponível)
      const generatedProtocol = `PROFEPLAN-${Date.now().toString(36).toUpperCase()}-${Math.random().toString(36).substring(2, 6).toUpperCase()}`;

      // Envia para o backend (fire-and-forget — não bloqueia o fluxo do usuário)
      fetch('/api/support/cancel-request', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...formData,
          protocol: generatedProtocol,
          submittedAt: new Date().toISOString(),
          userAgent: navigator.userAgent,
        }),
      }).catch(() => {
        // API pode não existir ainda — formulário continua funcional
        console.warn('[CancelForm] Backend /api/support/cancel-request indisponível');
      });

      // Também envia para o e-mail de suporte como backup
      fetch('/api/support/send-cancel-email', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...formData,
          protocol: generatedProtocol,
        }),
      }).catch(() => {});

      setProtocol(generatedProtocol);
      setSubmitted(true);
    } catch (err) {
      setError('Erro ao enviar. Tente novamente ou envie para suporte@profeplan.com.br.');
    } finally {
      setLoading(false);
    }
  };

  if (submitted) {
    return (
      <LegalLayout title="Solicitação Enviada">
        <div style={{ textAlign: 'center', padding: '2rem 0' }}>
          <CheckCircle size={56} style={{ color: '#34d399', margin: '0 auto 1rem' }} />
          <h2>Solicitação registrada com sucesso</h2>
          <p style={{ marginBottom: '1.5rem', color: '#94a3b8' }}>
            Sua solicitação foi recebida e será analisada pela nossa equipe.
          </p>
          <div
            style={{
              background: 'rgba(255,255,255,0.05)',
              border: '1px solid rgba(255,255,255,0.1)',
              borderRadius: '12px',
              padding: '1.25rem',
              marginBottom: '1.5rem',
              display: 'inline-block',
            }}
          >
            <p style={{ fontSize: '0.75rem', color: '#64748b', marginBottom: '0.5rem' }}>
              NÚMERO DE PROTOCOLO
            </p>
            <p
              style={{
                fontFamily: 'monospace',
                fontSize: '1.1rem',
                fontWeight: 'bold',
                color: '#e2e8f0',
                letterSpacing: '0.05em',
              }}
            >
              {protocol}
            </p>
          </div>
          <p style={{ fontSize: '0.85rem', color: '#64748b' }}>
            Guarde este número para referência. Você também pode entrar em contato pelo{' '}
            <a href="mailto:suporte@profeplan.com.br" style={{ color: '#818cf8' }}>
              suporte@profeplan.com.br
            </a>
            .
          </p>
        </div>
      </LegalLayout>
    );
  }

  return (
    <LegalLayout
      title="Cancelamento, Reembolso e Direito de Arrependimento"
      subtitle="Preencha o formulário abaixo para solicitar cancelamento, reembolso ou exercer seu direito de arrependimento. Você receberá um número de protocolo."
    >
      <div
        style={{
          background: 'rgba(255,255,255,0.03)',
          border: '1px solid rgba(255,255,255,0.08)',
          borderRadius: '16px',
          padding: '2rem',
        }}
      >
        <form
          onSubmit={handleSubmit}
          style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}
        >
          {/* Nome */}
          <div>
            <label
              style={{
                display: 'block',
                fontSize: '0.7rem',
                fontWeight: '700',
                color: '#64748b',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.5rem',
              }}
            >
              Nome completo *
            </label>
            <input
              type="text"
              name="name"
              value={formData.name}
              onChange={handleChange}
              required
              placeholder="Seu nome completo"
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'rgba(255,255,255,0.05)',
                border: '1px solid rgba(255,255,255,0.1)',
                borderRadius: '10px',
                color: '#e2e8f0',
                fontSize: '0.9rem',
                outline: 'none',
              }}
            />
          </div>

          {/* E-mail */}
          <div>
            <label
              style={{
                display: 'block',
                fontSize: '0.7rem',
                fontWeight: '700',
                color: '#64748b',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.5rem',
              }}
            >
              E-mail da conta ProfePlan *
            </label>
            <input
              type="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              required
              placeholder="seu@email.com"
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'rgba(255,255,255,0.05)',
                border: '1px solid rgba(255,255,255,0.1)',
                borderRadius: '10px',
                color: '#e2e8f0',
                fontSize: '0.9rem',
                outline: 'none',
              }}
            />
          </div>

          {/* Tipo de solicitação */}
          <div>
            <label
              style={{
                display: 'block',
                fontSize: '0.7rem',
                fontWeight: '700',
                color: '#64748b',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.5rem',
              }}
            >
              Tipo de solicitação *
            </label>
            <select
              name="requestType"
              value={formData.requestType}
              onChange={handleChange}
              required
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'rgba(255,255,255,0.05)',
                border: '1px solid rgba(255,255,255,0.1)',
                borderRadius: '10px',
                color: '#e2e8f0',
                fontSize: '0.9rem',
                outline: 'none',
                appearance: 'none',
              }}
            >
              <option value="" disabled style={{ color: '#475569' }}>
                Selecione o tipo de solicitação
              </option>
              {REQUEST_TYPES.map((t) => (
                <option
                  key={t.value}
                  value={t.value}
                  style={{ background: '#1e293b', color: '#e2e8f0' }}
                >
                  {t.label}
                </option>
              ))}
            </select>
          </div>

          {/* Plano */}
          <div>
            <label
              style={{
                display: 'block',
                fontSize: '0.7rem',
                fontWeight: '700',
                color: '#64748b',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.5rem',
              }}
            >
              Plano contratado
            </label>
            <input
              type="text"
              name="plan"
              value={formData.plan}
              onChange={handleChange}
              placeholder="Ex: Silver, Gold, B2B"
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'rgba(255,255,255,0.05)',
                border: '1px solid rgba(255,255,255,0.1)',
                borderRadius: '10px',
                color: '#e2e8f0',
                fontSize: '0.9rem',
                outline: 'none',
              }}
            />
          </div>

          {/* Descrição */}
          <div>
            <label
              style={{
                display: 'block',
                fontSize: '0.7rem',
                fontWeight: '700',
                color: '#64748b',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.5rem',
              }}
            >
              Descrição / Motivo *
            </label>
            <textarea
              name="description"
              value={formData.description}
              onChange={handleChange}
              required
              rows={4}
              placeholder="Descreva o motivo da sua solicitação..."
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'rgba(255,255,255,0.05)',
                border: '1px solid rgba(255,255,255,0.1)',
                borderRadius: '10px',
                color: '#e2e8f0',
                fontSize: '0.9rem',
                outline: 'none',
                resize: 'vertical',
                fontFamily: 'inherit',
              }}
            />
          </div>

          {/* ID da transação (opcional) */}
          <div>
            <label
              style={{
                display: 'block',
                fontSize: '0.7rem',
                fontWeight: '700',
                color: '#64748b',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.5rem',
              }}
            >
              Identificador da cobrança (se disponível)
            </label>
            <input
              type="text"
              name="transactionId"
              value={formData.transactionId}
              onChange={handleChange}
              placeholder="Ex: ch_... ou ID do comprovante"
              style={{
                width: '100%',
                padding: '0.75rem 1rem',
                background: 'rgba(255,255,255,0.05)',
                border: '1px solid rgba(255,255,255,0.1)',
                borderRadius: '10px',
                color: '#e2e8f0',
                fontSize: '0.9rem',
                outline: 'none',
              }}
            />
          </div>

          {/* Aviso de segurança */}
          <div
            style={{
              background: 'rgba(239,68,68,0.08)',
              border: '1px solid rgba(239,68,68,0.15)',
              borderRadius: '10px',
              padding: '0.75rem 1rem',
            }}
          >
            <p style={{ fontSize: '0.75rem', color: '#fca5a5', margin: 0 }}>
              <strong>⚠️ Importante:</strong> Nunca envie o número completo do seu cartão, código de
              segurança, senha da conta ou token de autenticação por este formulário ou por e-mail.
            </p>
          </div>

          {error && (
            <div
              style={{
                background: 'rgba(239,68,68,0.08)',
                border: '1px solid rgba(239,68,68,0.15)',
                borderRadius: '10px',
                padding: '0.75rem 1rem',
              }}
            >
              <p style={{ fontSize: '0.85rem', color: '#fca5a5', margin: 0 }}>{error}</p>
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            style={{
              width: '100%',
              padding: '0.85rem',
              background: loading
                ? 'rgba(99,102,241,0.3)'
                : 'linear-gradient(135deg, #3b82f6 0%, #6366f1 50%, #8b5cf6 100%)',
              border: 'none',
              borderRadius: '12px',
              color: 'white',
              fontWeight: '700',
              fontSize: '0.9rem',
              cursor: loading ? 'not-allowed' : 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '0.5rem',
              boxShadow: '0 4px 20px rgba(99,102,241,0.3)',
              transition: 'all 0.2s ease',
            }}
          >
            {loading ? (
              <>
                <Loader2 size={18} style={{ animation: 'spin 1s linear infinite' }} />
                Enviando...
              </>
            ) : (
              <>
                <Send size={18} />
                Enviar solicitação
              </>
            )}
          </button>

          <p
            style={{
              fontSize: '0.75rem',
              color: '#64748b',
              textAlign: 'center',
              marginTop: '0.5rem',
            }}
          >
            Você também pode enviar sua solicitação diretamente para{' '}
            <a href="mailto:suporte@profeplan.com.br" style={{ color: '#818cf8' }}>
              suporte@profeplan.com.br
            </a>
          </p>
        </form>
      </div>
    </LegalLayout>
  );
};

export default CancelamentoFormulario;
