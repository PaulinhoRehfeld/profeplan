'use client';

import { useEffect } from 'react';
import Link from 'next/link';

export default function PlanningError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error('Planning Error Boundary caught error:', error);
  }, [error]);

  return (
    <div
      className="panel stack"
      style={{ maxWidth: '600px', width: '100%', margin: '40px auto', textAlign: 'center' }}
    >
      <div>
        <p className="eyebrow" style={{ color: 'var(--danger)' }}>
          Erro no Planejamento
        </p>
        <h2 className="title" style={{ fontSize: '24px' }}>
          Falha no módulo de planejamentos
        </h2>
      </div>
      <p className="subtitle">
        Ocorreu um problema ao carregar ou processar os planejamentos letivos.
      </p>

      {error.digest && (
        <div
          style={{
            background: 'var(--surface-secondary)',
            padding: '10px',
            borderRadius: 'var(--radius-sm)',
            fontSize: '12px',
            color: 'var(--muted)',
            fontFamily: 'monospace',
          }}
        >
          Digest: {error.digest}
        </div>
      )}

      <div
        className="flex-row"
        style={{ justifyContent: 'center', marginTop: '12px', gap: '16px' }}
      >
        <button className="button button-primary" onClick={() => reset()} type="button">
          Recarregar
        </button>
        <Link href="/dashboard" className="button button-secondary">
          Voltar ao Painel
        </Link>
      </div>
    </div>
  );
}
