'use client';

import { useEffect } from 'react';
import Link from 'next/link';

export default function AdminError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error('Admin Error Boundary caught error:', error);
  }, [error]);

  return (
    <div
      className="panel stack"
      style={{ maxWidth: '600px', width: '100%', margin: '40px auto', textAlign: 'center' }}
    >
      <div>
        <p className="eyebrow" style={{ color: 'var(--danger)' }}>
          Erro do Administrador
        </p>
        <h2 className="title" style={{ fontSize: '24px' }}>
          Falha ao carregar dados do painel admin
        </h2>
      </div>
      <p className="subtitle">
        Não foi possível carregar as métricas operacionais ou os logs do sistema.
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
          Recarregar Painel
        </button>
        <Link href="/dashboard" className="button button-secondary">
          Voltar ao Dashboard
        </Link>
      </div>
    </div>
  );
}
