'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState, type FormEvent } from 'react';

export default function NewPlanningPage() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsLoading(true);
    setError(null);

    const formData = new FormData(event.currentTarget);
    const title = String(formData.get('title') ?? '').trim();
    const year = Number(formData.get('year'));
    const term = Number(formData.get('term'));

    try {
      const response = await fetch('/api/planning/terms', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ title, year, term }),
      });

      const resData = await response.json().catch(() => ({}));

      if (!response.ok) {
        throw new Error(resData.error?.message || 'Falha ao criar planejamento.');
      }

      const createdPlan = resData.data?.termPlan;
      if (!createdPlan?.id) {
        throw new Error('ID do planejamento não retornado pelo servidor.');
      }

      router.push(`/planning/${createdPlan.id}`);
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Falha ao criar planejamento.');
      setIsLoading(false);
    }
  }

  return (
    <main className="page-shell">
      <section className="container stack" style={{ maxWidth: '600px' }}>
        <header className="title-section">
          <Link
            href="/planning"
            className="muted"
            style={{ fontSize: '14px', fontWeight: '600', marginBottom: '8px' }}
          >
            ← Voltar para Lista
          </Link>
          <h1 className="title">Novo Planejamento</h1>
          <p className="subtitle">
            Preencha as informações básicas para iniciar o planejamento bimestral.
          </p>
        </header>

        {error && (
          <div className="error-banner">
            <div>
              <h3>Erro de validação</h3>
              <p>{error}</p>
            </div>
          </div>
        )}

        <form className="panel stack" onSubmit={handleSubmit}>
          <div className="field">
            <label htmlFor="title">Título do Planejamento</label>
            <input
              id="title"
              name="title"
              type="text"
              placeholder="Ex: 1º Bimestre - Matemática - 8º Ano"
              required
              disabled={isLoading}
            />
          </div>

          <div className="grid" style={{ gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
            <div className="field">
              <label htmlFor="year">Ano Letivo</label>
              <input
                id="year"
                name="year"
                type="number"
                defaultValue={new Date().getFullYear()}
                required
                disabled={isLoading}
              />
            </div>

            <div className="field">
              <label htmlFor="term">Bimestre / Período</label>
              <select id="term" name="term" required disabled={isLoading}>
                <option value="1">1º Bimestre</option>
                <option value="2">2º Bimestre</option>
                <option value="3">3º Bimestre</option>
                <option value="4">4º Bimestre</option>
              </select>
            </div>
          </div>

          <div className="flex-row" style={{ justifyContent: 'flex-end', marginTop: '12px' }}>
            <Link
              href="/planning"
              className="button button-secondary"
              style={{ pointerEvents: isLoading ? 'none' : 'auto' }}
            >
              Cancelar
            </Link>
            <button className="button button-primary" type="submit" disabled={isLoading}>
              {isLoading ? (
                <>
                  <div className="spinner"></div>
                  <span>Criando...</span>
                </>
              ) : (
                'Salvar Planejamento'
              )}
            </button>
          </div>
        </form>
      </section>
    </main>
  );
}
