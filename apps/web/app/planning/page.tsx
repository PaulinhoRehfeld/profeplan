'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';

type TermPlan = {
  id: string;
  title: string;
  year: number;
  term: number;
  status: 'DRAFT' | 'REVIEW' | 'PUBLISHED';
  aiEnhancedContent: Record<string, unknown> | null;
  createdAt: string;
};

export default function PlanningPage() {
  const [termPlans, setTermPlans] = useState<TermPlan[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchPlans() {
      try {
        const response = await fetch('/api/planning/terms');
        if (!response.ok) {
          const errData = await response.json().catch(() => ({}));
          throw new Error(errData.error?.message || 'Falha ao buscar planejamentos.');
        }
        const res = await response.json();
        setTermPlans(res.data.termPlans || []);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Falha ao buscar planejamentos.');
      } finally {
        setIsLoading(false);
      }
    }
    fetchPlans();
  }, []);

  return (
    <main className="page-shell">
      <section className="container stack">
        <header className="flex-row">
          <div className="title-section">
            <div className="topbar-nav" style={{ gap: '8px' }}>
              <Link
                href="/dashboard"
                className="muted"
                style={{ fontSize: '14px', fontWeight: '600' }}
              >
                ← Voltar ao Painel
              </Link>
            </div>
            <h1 className="title">Planejamentos Bimestrais</h1>
            <p className="subtitle">Gerencie os planos pedagógicos letivos da sua organização.</p>
          </div>
          <div>
            <Link href="/planning/new" className="button button-primary">
              + Novo Planejamento
            </Link>
          </div>
        </header>

        {error && (
          <div className="error-banner">
            <div>
              <h3>Erro ao carregar dados</h3>
              <p>{error}</p>
            </div>
          </div>
        )}

        {isLoading ? (
          <div className="loading-container">
            <div className="spinner spinner-primary"></div>
            <p className="loading-text">Carregando seus planejamentos...</p>
          </div>
        ) : termPlans.length === 0 ? (
          <div className="empty-state">
            <span className="empty-state-icon">📂</span>
            <h2>Nenhum planejamento encontrado</h2>
            <p className="muted">
              Você ainda não criou nenhum planejamento para este período. Comece criando um novo
              plano letivo.
            </p>
            <Link
              href="/planning/new"
              className="button button-primary"
              style={{ marginTop: '8px' }}
            >
              Criar Primeiro Planejamento
            </Link>
          </div>
        ) : (
          <div className="grid">
            {termPlans.map((plan) => {
              const isEnhanced = !!plan.aiEnhancedContent;
              return (
                <Link
                  key={plan.id}
                  href={`/planning/${plan.id}`}
                  className="card stack"
                  style={{ textDecoration: 'none', color: 'inherit' }}
                >
                  <div className="flex-row" style={{ alignItems: 'flex-start' }}>
                    <span className={`badge badge-${plan.status.toLowerCase()}`}>
                      {plan.status}
                    </span>
                    {isEnhanced && <span className="badge badge-ai">✨ IA Ativa</span>}
                  </div>
                  <div>
                    <h2 style={{ fontSize: '18px', fontWeight: '700', marginBottom: '4px' }}>
                      {plan.title}
                    </h2>
                    <p className="muted" style={{ fontSize: '14px' }}>
                      Ano Letivo: {plan.year} | Período: {plan.term}º Bimestre
                    </p>
                  </div>
                  <div
                    style={{
                      borderTop: '1px solid var(--border)',
                      paddingTop: '12px',
                      fontSize: '13px',
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center',
                    }}
                  >
                    <span className="muted">
                      Criado em {new Date(plan.createdAt).toLocaleDateString('pt-BR')}
                    </span>
                    <span style={{ color: 'var(--primary)', fontWeight: '600' }}>Detalhes →</span>
                  </div>
                </Link>
              );
            })}
          </div>
        )}
      </section>
    </main>
  );
}
