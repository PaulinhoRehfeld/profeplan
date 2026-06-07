'use client';

import Link from 'next/link';
import { use, useEffect, useState, useCallback } from 'react';

type TermPlan = {
  id: string;
  title: string;
  year: number;
  term: number;
  status: 'DRAFT' | 'REVIEW' | 'PUBLISHED';
  aiEnhancedContent: {
    summary: string;
    objectives: string[];
    suggestedSequence: string[];
    assessmentIdeas: string[];
    differentiationStrategies: string[];
    teacherNotes: string;
  } | null;
  aiEnhancedAt: string | null;
  aiModel: string | null;
  createdAt: string;
};

export default function PlanDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);

  const [plan, setPlan] = useState<TermPlan | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isEnhancing, setIsEnhancing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<
    'summary' | 'objectives' | 'sequence' | 'assessment' | 'differentiation' | 'notes'
  >('summary');

  const fetchPlan = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const response = await fetch(`/api/planning/terms/${id}`);
      if (!response.ok) {
        const errData = await response.json().catch(() => ({}));
        throw new Error(errData.error?.message || 'Falha ao buscar planejamento.');
      }
      const res = await response.json();
      setPlan(res.data.termPlan);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Falha ao buscar planejamento.');
    } finally {
      setIsLoading(false);
    }
  }, [id]);

  useEffect(() => {
    fetchPlan();
  }, [fetchPlan]);

  async function handleEnhance() {
    setIsEnhancing(true);
    setError(null);
    try {
      const response = await fetch(`/api/planning/terms/${id}/enhance`, {
        method: 'POST',
      });
      const resData = await response.json().catch(() => ({}));
      if (!response.ok) {
        throw new Error(resData.error?.message || 'Falha ao enriquecer planejamento.');
      }
      await fetchPlan(); // Refresh data from API
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Falha ao enriquecer planejamento.');
    } finally {
      setIsEnhancing(false);
    }
  }

  if (isLoading) {
    return (
      <main className="page-shell">
        <div className="loading-container">
          <div className="spinner spinner-primary"></div>
          <p className="loading-text">Carregando detalhes do planejamento...</p>
        </div>
      </main>
    );
  }

  if (!plan) {
    return (
      <main className="page-shell">
        <section className="container stack" style={{ maxWidth: '600px' }}>
          <div className="error-banner">
            <div>
              <h3>Erro</h3>
              <p>{error || 'Não foi possível encontrar o planejamento solicitado.'}</p>
            </div>
          </div>
          <Link
            href="/planning"
            className="button button-secondary"
            style={{ alignSelf: 'center' }}
          >
            Voltar para Planejamentos
          </Link>
        </section>
      </main>
    );
  }

  const isEnhanced = !!plan.aiEnhancedContent;

  return (
    <main className="page-shell">
      <section className="container stack">
        <header className="flex-row">
          <div className="title-section">
            <div className="topbar-nav" style={{ gap: '8px' }}>
              <Link
                href="/planning"
                className="muted"
                style={{ fontSize: '14px', fontWeight: '600' }}
              >
                ← Voltar para Lista
              </Link>
            </div>
            <h1 className="title">{plan.title}</h1>
            <p className="subtitle">
              Ano Letivo: {plan.year} | Período: {plan.term}º Bimestre
            </p>
          </div>
          <div className="topbar-nav">
            <span className={`badge badge-${plan.status.toLowerCase()}`}>{plan.status}</span>
            {isEnhanced && <span className="badge badge-ai">✨ IA Ativa</span>}
          </div>
        </header>

        {error && (
          <div className="error-banner">
            <div>
              <h3>Ocorreu um problema</h3>
              <p>{error}</p>
            </div>
          </div>
        )}

        <div
          className="grid"
          style={{
            gridTemplateColumns: isEnhanced ? '1fr 2fr' : '1fr',
            gap: '32px',
            alignItems: 'start',
          }}
        >
          {/* Main Info Card */}
          <article className="panel stack">
            <h2
              style={{
                fontSize: '18px',
                fontWeight: '700',
                borderBottom: '1px solid var(--border)',
                paddingBottom: '12px',
              }}
            >
              Informações do Planejamento
            </h2>
            <div className="field">
              <span className="muted" style={{ fontSize: '13px' }}>
                Identificador
              </span>
              <code
                style={{
                  fontSize: '13px',
                  backgroundColor: 'var(--surface-secondary)',
                  padding: '6px 10px',
                  borderRadius: '4px',
                  overflowWrap: 'anywhere',
                }}
              >
                {plan.id}
              </code>
            </div>
            <div className="field">
              <span className="muted" style={{ fontSize: '13px' }}>
                Criado em
              </span>
              <p style={{ fontWeight: '500' }}>
                {new Date(plan.createdAt).toLocaleString('pt-BR')}
              </p>
            </div>

            {!isEnhanced && !isEnhancing && (
              <div
                className="stack"
                style={{
                  marginTop: '16px',
                  borderTop: '1px solid var(--border)',
                  paddingTop: '20px',
                }}
              >
                <h3 style={{ fontSize: '15px', fontWeight: '700' }}>Enriquecer com IA</h3>
                <p className="muted" style={{ fontSize: '13px', lineHeight: '1.4' }}>
                  Melhore este planejamento gerando sequências didáticas, estratégias de inclusão e
                  sugestões de avaliação com Inteligência Artificial.
                </p>
                <button className="button button-ai" onClick={handleEnhance}>
                  ✨ Enriquecer Planejamento
                </button>
              </div>
            )}

            {isEnhancing && (
              <div
                className="stack"
                style={{
                  marginTop: '16px',
                  borderTop: '1px solid var(--border)',
                  paddingTop: '20px',
                  alignItems: 'center',
                  textAlign: 'center',
                }}
              >
                <div
                  className="spinner spinner-primary"
                  style={{ width: '32px', height: '32px', borderWidth: '3px' }}
                ></div>
                <p className="loading-text" style={{ fontSize: '14px', fontWeight: '600' }}>
                  O assistente pedagógico está estruturando seu planejamento com IA...
                </p>
                <span className="muted" style={{ fontSize: '12px' }}>
                  Isso pode levar alguns segundos.
                </span>
              </div>
            )}

            {isEnhanced && (
              <div
                className="stack"
                style={{
                  marginTop: '16px',
                  borderTop: '1px solid var(--border)',
                  paddingTop: '20px',
                }}
              >
                <h3 style={{ fontSize: '15px', fontWeight: '700' }}>Metadados da IA</h3>
                <div className="field">
                  <span className="muted" style={{ fontSize: '12px' }}>
                    Modelo Utilizado
                  </span>
                  <p style={{ fontWeight: '600', fontSize: '13px' }}>{plan.aiModel}</p>
                </div>
                <div className="field">
                  <span className="muted" style={{ fontSize: '12px' }}>
                    Processado em
                  </span>
                  <p style={{ fontWeight: '500', fontSize: '13px' }}>
                    {plan.aiEnhancedAt ? new Date(plan.aiEnhancedAt).toLocaleString('pt-BR') : '-'}
                  </p>
                </div>
                <button
                  className="button button-secondary"
                  onClick={handleEnhance}
                  disabled={isEnhancing}
                >
                  🔄 Refazer Enriquecimento
                </button>
              </div>
            )}
          </article>

          {/* AI Enriched Result Card */}
          {isEnhanced && plan.aiEnhancedContent && (
            <article className="ai-section">
              <header className="ai-header">
                <h2 className="ai-header-title">✦ Conteúdo Enriquecido por IA</h2>
                <span className="badge badge-ai">Ativo</span>
              </header>

              <div className="tab-list" style={{ overflowX: 'auto', whiteSpace: 'nowrap' }}>
                <button
                  type="button"
                  className={`tab-item ${activeTab === 'summary' ? 'tab-item-active' : ''}`}
                  onClick={() => setActiveTab('summary')}
                >
                  Resumo
                </button>
                <button
                  type="button"
                  className={`tab-item ${activeTab === 'objectives' ? 'tab-item-active' : ''}`}
                  onClick={() => setActiveTab('objectives')}
                >
                  Objetivos
                </button>
                <button
                  type="button"
                  className={`tab-item ${activeTab === 'sequence' ? 'tab-item-active' : ''}`}
                  onClick={() => setActiveTab('sequence')}
                >
                  Sequência Didática
                </button>
                <button
                  type="button"
                  className={`tab-item ${activeTab === 'assessment' ? 'tab-item-active' : ''}`}
                  onClick={() => setActiveTab('assessment')}
                >
                  Avaliação
                </button>
                <button
                  type="button"
                  className={`tab-item ${activeTab === 'differentiation' ? 'tab-item-active' : ''}`}
                  onClick={() => setActiveTab('differentiation')}
                >
                  Inclusão / Adapt.
                </button>
                <button
                  type="button"
                  className={`tab-item ${activeTab === 'notes' ? 'tab-item-active' : ''}`}
                  onClick={() => setActiveTab('notes')}
                >
                  Notas
                </button>
              </div>

              {/* Tab Contents */}
              <div className="stack" style={{ minHeight: '200px' }}>
                {activeTab === 'summary' && (
                  <div className="ai-card">
                    <h3 className="ai-card-title">📖 Resumo Pedagógico</h3>
                    <p className="ai-card-content">{plan.aiEnhancedContent.summary}</p>
                  </div>
                )}

                {activeTab === 'objectives' && (
                  <div className="ai-card">
                    <h3 className="ai-card-title">🎯 Objetivos de Aprendizagem Sugeridos</h3>
                    <ul className="ai-list">
                      {plan.aiEnhancedContent.objectives.map((obj, i) => (
                        <li key={i} className="ai-list-item">
                          {obj}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {activeTab === 'sequence' && (
                  <div className="ai-card">
                    <h3 className="ai-card-title">🗓️ Sequência de Tópicos Sugerida</h3>
                    <ul className="ai-list">
                      {plan.aiEnhancedContent.suggestedSequence.map((seq, i) => (
                        <li key={i} className="ai-list-item">
                          {seq}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {activeTab === 'assessment' && (
                  <div className="ai-card">
                    <h3 className="ai-card-title"> 📝 Estratégias de Avaliação</h3>
                    <ul className="ai-list">
                      {plan.aiEnhancedContent.assessmentIdeas.map((idea, i) => (
                        <li key={i} className="ai-list-item">
                          {idea}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {activeTab === 'differentiation' && (
                  <div className="ai-card">
                    <h3 className="ai-card-title">♿ Diferenciação e Inclusão</h3>
                    <ul className="ai-list">
                      {plan.aiEnhancedContent.differentiationStrategies.map((strategy, i) => (
                        <li key={i} className="ai-list-item">
                          {strategy}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {activeTab === 'notes' && (
                  <div className="ai-card">
                    <h3 className="ai-card-title">💡 Observações Gerais e Notas Práticas</h3>
                    <p className="ai-card-content" style={{ whiteSpace: 'pre-wrap' }}>
                      {plan.aiEnhancedContent.teacherNotes}
                    </p>
                  </div>
                )}
              </div>
            </article>
          )}

          {/* Prompt card if not enhanced and not enhancing */}
          {!isEnhanced && !isEnhancing && (
            <article className="ai-section" style={{ borderStyle: 'solid', borderWidth: '1px' }}>
              <div style={{ textAlign: 'center', padding: '32px 16px' }} className="stack">
                <span style={{ fontSize: '48px' }}>🤖</span>
                <h3 style={{ fontSize: '20px', fontWeight: '800' }}>
                  Potencialize com o Assistente Pedagógico
                </h3>
                <p
                  className="muted"
                  style={{ maxWidth: '480px', margin: '0 auto', fontSize: '14px' }}
                >
                  Use Inteligência Artificial para gerar dinamicamente os objetivos, a sequência
                  didática sugerida, ideias de avaliação formativa e estratégias de inclusão
                  adaptadas para este bimestre.
                </p>
                <div style={{ marginTop: '16px' }}>
                  <button className="button button-ai" onClick={handleEnhance}>
                    ✨ Começar Enriquecimento
                  </button>
                </div>
              </div>
            </article>
          )}
        </div>
      </section>
    </main>
  );
}
