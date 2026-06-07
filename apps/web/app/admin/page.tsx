import { getTenantContext } from '@profeplan/auth/tenant';
import { prisma } from '@profeplan/db';
import Link from 'next/link';
import * as fs from 'fs';
import * as path from 'path';

export const dynamic = 'force-dynamic';

function getWorkspaceRoot(): string {
  let dir = process.cwd();
  while (dir && dir !== path.parse(dir).root) {
    if (fs.existsSync(path.join(dir, 'pnpm-workspace.yaml'))) {
      return dir;
    }
    dir = path.dirname(dir);
  }
  return process.cwd();
}

interface FeedbackEntry {
  id: string;
  userEmail: string;
  userFullName: string;
  organizationName: string;
  rating: number;
  comment: string;
  createdAt: string;
}

function getFeedbacks(): FeedbackEntry[] {
  try {
    const workspaceRoot = getWorkspaceRoot();
    const feedbackFile = path.join(workspaceRoot, 'logs', 'feedbacks.json');
    if (fs.existsSync(feedbackFile)) {
      const content = fs.readFileSync(feedbackFile, 'utf8');
      const parsed = JSON.parse(content || '[]');
      return Array.isArray(parsed) ? parsed.reverse() : [];
    }
  } catch (err) {
    console.error('Failed to parse feedbacks:', err);
  }
  return [];
}

interface LogEntry {
  timestamp: string;
  level: string;
  correlationId?: string;
  message?: string;
  action?: string;
  actor?: string;
  details?: unknown;
  stack?: string;
  context?: unknown;
}

function getRecentLogs(): LogEntry[] {
  try {
    const workspaceRoot = getWorkspaceRoot();
    const logFile = path.join(workspaceRoot, 'logs', 'app.log');
    if (fs.existsSync(logFile)) {
      const content = fs.readFileSync(logFile, 'utf8');
      const lines = content.trim().split('\n').filter(Boolean);
      const logs = lines.map((line) => {
        try {
          return JSON.parse(line) as LogEntry;
        } catch {
          return {
            timestamp: new Date().toISOString(),
            level: 'INFO',
            message: line,
          } as LogEntry;
        }
      });
      return logs.reverse().slice(0, 15);
    }
  } catch (err) {
    console.error('Failed to parse logs:', err);
  }
  return [];
}

export default async function AdminPage() {
  const tenant = await getTenantContext();
  const isAdmin = tenant?.membership.role === 'OWNER' || tenant?.membership.role === 'ADMIN';

  if (!isAdmin) {
    return (
      <main className="page-shell">
        <section
          className="panel stack"
          style={{ maxWidth: '600px', width: '100%', margin: '40px auto', textAlign: 'center' }}
        >
          <div>
            <p className="eyebrow" style={{ color: 'var(--danger)' }}>
              Acesso Negado
            </p>
            <h1 className="title">Área Restrita</h1>
          </div>
          <p className="subtitle">
            Você não possui permissões administrativas para visualizar esta página.
          </p>
          <div style={{ marginTop: '12px' }}>
            <Link href="/dashboard" className="button button-primary">
              Voltar ao Dashboard
            </Link>
          </div>
        </section>
      </main>
    );
  }

  // Fetch metrics
  const totalUsers = await prisma.user.count();
  const totalOrgs = await prisma.organization.count();
  const totalPlans = await prisma.termPlan.count();
  const totalAiPlans = await prisma.termPlan.count({ where: { aiEnhancedAt: { not: null } } });

  const feedbacks = getFeedbacks();
  const logs = getRecentLogs();

  return (
    <main className="page-shell">
      <section className="container stack" style={{ maxWidth: '1200px' }}>
        <header className="flex-row">
          <div className="title-section">
            <p className="eyebrow">Painel do Administrador</p>
            <h1 className="title">Métricas & Auditoria do PROFEPLAN</h1>
          </div>
          <div>
            <Link href="/dashboard" className="button button-secondary">
              ← Dashboard do Professor
            </Link>
          </div>
        </header>

        {/* Estatísticas Consolidadas */}
        <div
          className="grid"
          style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '16px' }}
        >
          <div className="card stack" style={{ padding: '20px', gap: '8px' }}>
            <span style={{ fontSize: '13px', color: 'var(--muted)', fontWeight: '600' }}>
              Professores Cadastrados
            </span>
            <span style={{ fontSize: '36px', fontWeight: '800', color: 'var(--primary)' }}>
              {totalUsers}
            </span>
          </div>

          <div className="card stack" style={{ padding: '20px', gap: '8px' }}>
            <span style={{ fontSize: '13px', color: 'var(--muted)', fontWeight: '600' }}>
              Organizações / Escolas
            </span>
            <span style={{ fontSize: '36px', fontWeight: '800', color: '#6366f1' }}>
              {totalOrgs}
            </span>
          </div>

          <div className="card stack" style={{ padding: '20px', gap: '8px' }}>
            <span style={{ fontSize: '13px', color: 'var(--muted)', fontWeight: '600' }}>
              Planejamentos Criados
            </span>
            <span style={{ fontSize: '36px', fontWeight: '800', color: 'var(--foreground)' }}>
              {totalPlans}
            </span>
          </div>

          <div className="card stack" style={{ padding: '20px', gap: '8px' }}>
            <span style={{ fontSize: '13px', color: 'var(--muted)', fontWeight: '600' }}>
              Enriquecimentos IA
            </span>
            <span
              style={{
                fontSize: '36px',
                fontWeight: '800',
                background:
                  'linear-gradient(135deg, var(--ai-gradient-start), var(--ai-gradient-end))',
                WebkitBackgroundClip: 'text',
                WebkitTextFillColor: 'transparent',
              }}
            >
              {totalAiPlans}
            </span>
          </div>
        </div>

        <div className="grid" style={{ gridTemplateColumns: '2fr 1fr', gap: '24px' }}>
          {/* Feedbacks Coletados */}
          <div className="stack" style={{ gap: '16px' }}>
            <h2 style={{ fontSize: '20px', fontWeight: '700' }}>
              ⭐ Feedbacks dos Professores Beta ({feedbacks.length})
            </h2>
            <div className="stack" style={{ gap: '12px' }}>
              {feedbacks.length === 0 ? (
                <div className="empty-state" style={{ padding: '32px' }}>
                  <p className="muted">Nenhum feedback recebido até o momento.</p>
                </div>
              ) : (
                feedbacks.map((fb: FeedbackEntry) => (
                  <article
                    key={fb.id}
                    className="card stack"
                    style={{ gap: '8px', padding: '16px' }}
                  >
                    <div className="flex-row">
                      <strong style={{ fontSize: '14px' }}>
                        {fb.userFullName || fb.userEmail}
                      </strong>
                      <span style={{ color: '#fbbf24', fontWeight: '700', fontSize: '16px' }}>
                        {'★'.repeat(fb.rating)}
                        <span style={{ color: '#d1d5db' }}>{'★'.repeat(5 - fb.rating)}</span>
                      </span>
                    </div>
                    <p style={{ fontSize: '14px', lineHeight: '1.4' }}>{fb.comment}</p>
                    <div className="flex-row" style={{ fontSize: '11px', color: 'var(--muted)' }}>
                      <span>Organização: {fb.organizationName || '-'}</span>
                      <span>{new Date(fb.createdAt).toLocaleString()}</span>
                    </div>
                  </article>
                ))
              )}
            </div>
          </div>

          {/* Histórico de Auditoria */}
          <div className="stack" style={{ gap: '16px' }}>
            <h2 style={{ fontSize: '20px', fontWeight: '700' }}>🔍 Histórico Operacional (Logs)</h2>
            <div
              className="card stack"
              style={{
                background: '#0f172a',
                color: '#38bdf8',
                fontFamily: 'monospace',
                fontSize: '12px',
                padding: '16px',
                maxHeight: '500px',
                overflowY: 'auto',
                border: '1px solid #1e293b',
                borderRadius: 'var(--radius-md)',
                gap: '12px',
              }}
            >
              {logs.length === 0 ? (
                <span style={{ color: '#64748b' }}>Nenhum log encontrado.</span>
              ) : (
                logs.map((log, index) => {
                  const dateStr = new Date(log.timestamp).toLocaleTimeString();
                  if (log.level === 'AUDIT') {
                    return (
                      <div
                        key={index}
                        style={{ borderBottom: '1px solid #1e293b', paddingBottom: '8px' }}
                      >
                        <span style={{ color: '#10b981' }}>
                          [{dateStr}] AUDIT - {log.action}
                        </span>
                        <div style={{ color: '#94a3b8', fontSize: '11px', paddingLeft: '8px' }}>
                          Ator: {log.actor} <br />
                          {log.details ? `Detalhes: ${JSON.stringify(log.details)}` : ''}
                        </div>
                      </div>
                    );
                  }
                  if (log.level === 'ERROR') {
                    return (
                      <div
                        key={index}
                        style={{ borderBottom: '1px solid #1e293b', paddingBottom: '8px' }}
                      >
                        <span style={{ color: '#ef4444' }}>
                          [{dateStr}] ERROR - {log.message}
                        </span>
                        <div
                          style={{
                            color: '#fca5a5',
                            fontSize: '11px',
                            paddingLeft: '8px',
                            overflowX: 'auto',
                          }}
                        >
                          ID: {log.correlationId}
                        </div>
                      </div>
                    );
                  }
                  return (
                    <div
                      key={index}
                      style={{ borderBottom: '1px solid #1e293b', paddingBottom: '8px' }}
                    >
                      <span style={{ color: '#38bdf8' }}>
                        [{dateStr}] INFO - {log.message}
                      </span>
                    </div>
                  );
                })
              )}
            </div>
          </div>
        </div>
      </section>
    </main>
  );
}
