'use client';

import { useEffect } from 'react';
import Link from 'next/link';

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error('Global Error Boundary caught error:', error);
  }, [error]);

  return (
    <main className="page-shell">
      <section
        className="panel stack"
        style={{ maxWidth: '600px', width: '100%', margin: '40px auto', textAlign: 'center' }}
      >
        <div>
          <p className="eyebrow" style={{ color: 'var(--danger)' }}>
            Erro Crítico
          </p>
          <h1 className="title">Ops! Algo deu errado</h1>
        </div>
        <p className="subtitle">
          Ocorreu um erro inesperado no processamento da página. O sistema operacional do PROFEPLAN
          já foi notificado.
        </p>

        {error.digest && (
          <div
            style={{
              background: 'var(--surface-secondary)',
              padding: '12px',
              borderRadius: 'var(--radius-sm)',
              fontSize: '13px',
              color: 'var(--muted)',
              fontFamily: 'monospace',
            }}
          >
            ID do Erro (Digest): {error.digest}
          </div>
        )}

        <div
          className="flex-row"
          style={{ justifyContent: 'center', marginTop: '12px', gap: '16px' }}
        >
          <button className="button button-primary" onClick={() => reset()} type="button">
            Tentar Novamente
          </button>
          <Link href="/dashboard" className="button button-secondary">
            Voltar ao Painel
          </Link>
        </div>
      </section>
    </main>
  );
}
