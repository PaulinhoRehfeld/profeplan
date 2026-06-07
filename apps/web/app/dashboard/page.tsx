import { getCurrentUser } from '@profeplan/auth/session';
import { getTenantContext } from '@profeplan/auth/tenant';
import { prisma } from '@profeplan/db';
import Link from 'next/link';
import { LogoutButton } from './logout-button';
import { FeedbackForm } from './feedback-form';

export const dynamic = 'force-dynamic';

export default async function DashboardPage() {
  const authUser = await getCurrentUser();
  const tenant = await getTenantContext();

  const orgId = tenant?.organization.id || '';
  const termPlansCount = orgId
    ? await prisma.termPlan.count({ where: { organizationId: orgId } })
    : 0;
  const aiEnhancedCount = orgId
    ? await prisma.termPlan.count({
        where: { organizationId: orgId, aiEnhancedAt: { not: null } },
      })
    : 0;

  const isProfileComplete = !!tenant?.user.fullName;
  const isPlanCreated = termPlansCount > 0;
  const isAiUsed = aiEnhancedCount > 0;
  const onboardingFinished = isProfileComplete && isPlanCreated && isAiUsed;

  const isAdmin = tenant?.membership.role === 'OWNER' || tenant?.membership.role === 'ADMIN';

  return (
    <main className="page-shell">
      <section className="container stack">
        <header className="flex-row">
          <div className="title-section">
            <p className="eyebrow">Dashboard</p>
            <h1 className="title">Área do Professor</h1>
          </div>
          <div className="topbar-nav">
            {isAdmin ? (
              <Link
                href="/admin"
                className="button button-secondary"
                style={{ border: '1px dashed var(--primary)', color: 'var(--primary)' }}
              >
                ⚙ Painel Admin
              </Link>
            ) : null}
            <p className="muted" style={{ marginRight: '12px' }}>
              {authUser?.email}
            </p>
            <LogoutButton />
          </div>
        </header>

        {/* Onboarding Flow / Guia de Início */}
        {!onboardingFinished ? (
          <div
            className="ai-section"
            style={{
              padding: '24px',
              border: '1px solid var(--primary)',
              background: 'var(--primary-light)',
            }}
          >
            <h3 style={{ fontSize: '18px', fontWeight: '700', marginBottom: '8px' }}>
              🚀 Guia de Boas-vindas ao Beta
            </h3>
            <p className="muted" style={{ fontSize: '14px', marginBottom: '16px' }}>
              Complete as etapas básicas de onboarding para validar e testar a plataforma:
            </p>
            <div className="stack" style={{ gap: '12px' }}>
              <div
                className="flex-row"
                style={{
                  justifyContent: 'flex-start',
                  gap: '12px',
                  opacity: isProfileComplete ? 0.6 : 1,
                }}
              >
                <span style={{ fontSize: '20px' }}>{isProfileComplete ? '✅' : '⏳'}</span>
                <div>
                  <strong style={{ fontSize: '14px' }}>1. Configurar dados de perfil</strong>
                  <p className="muted" style={{ fontSize: '12px' }}>
                    Seu nome completo deve estar configurado no cadastro de professor.
                  </p>
                </div>
              </div>

              <div
                className="flex-row"
                style={{
                  justifyContent: 'flex-start',
                  gap: '12px',
                  opacity: isPlanCreated ? 0.6 : 1,
                }}
              >
                <span style={{ fontSize: '20px' }}>{isPlanCreated ? '✅' : '⏳'}</span>
                <div>
                  <strong style={{ fontSize: '14px' }}>2. Criar primeiro Planejamento</strong>
                  <p className="muted" style={{ fontSize: '12px' }}>
                    Adicione um planejamento bimestral/letivo na listagem.
                  </p>
                </div>
              </div>

              <div
                className="flex-row"
                style={{ justifyContent: 'flex-start', gap: '12px', opacity: isAiUsed ? 0.6 : 1 }}
              >
                <span style={{ fontSize: '20px' }}>{isAiUsed ? '✅' : '⏳'}</span>
                <div>
                  <strong style={{ fontSize: '14px' }}>3. Realizar enriquecimento com IA</strong>
                  <p className="muted" style={{ fontSize: '12px' }}>
                    Utilize o assistente pedagógico de IA em um dos seus planejamentos.
                  </p>
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div
            className="ai-section"
            style={{
              padding: '16px 24px',
              border: '1px solid var(--success)',
              background: 'var(--success-light)',
            }}
          >
            <p style={{ color: 'var(--success)', fontWeight: '700', fontSize: '15px' }}>
              🎉 Parabéns! Você concluiu todos os fluxos básicos do teste beta com sucesso!
            </p>
          </div>
        )}

        <div className="grid">
          <article className="card flex-row" style={{ gridColumn: '1 / -1', gap: '32px' }}>
            <div style={{ flex: 1 }} className="stack">
              <div>
                <span className="badge badge-ai" style={{ marginBottom: '8px' }}>
                  Módulo Ativo
                </span>
                <h2 style={{ fontSize: '20px', fontWeight: '700', marginBottom: '8px' }}>
                  Planejamentos de Período Letivo
                </h2>
                <p className="muted">
                  Crie, gerencie e melhore os planejamentos bimestrais de sua instituição com o
                  assistente pedagógico inteligente.
                </p>
              </div>
              <div>
                <Link href="/planning" className="button button-primary">
                  Acessar Planejamentos
                </Link>
              </div>
            </div>
            <div style={{ fontSize: '64px', opacity: 0.8 }} className="desktop-only-icon">
              📝
            </div>
          </article>

          <article className="card stack">
            <h3 style={{ fontSize: '16px', fontWeight: '700' }}>Dados do Usuário</h3>
            <div className="field">
              <span className="muted" style={{ fontSize: '13px' }}>
                Nome Completo
              </span>
              <p style={{ fontWeight: '600' }}>
                {tenant?.user.fullName ?? authUser?.email ?? 'Sem perfil local'}
              </p>
            </div>
            <div className="field">
              <span className="muted" style={{ fontSize: '13px' }}>
                Papel
              </span>
              <p style={{ fontWeight: '600' }}>
                {tenant?.membership.role ?? 'Sem papel atribuído'}
              </p>
            </div>
          </article>

          <article className="card stack">
            <h3 style={{ fontSize: '16px', fontWeight: '700' }}>Instituição de Ensino</h3>
            <div className="field">
              <span className="muted" style={{ fontSize: '13px' }}>
                Organização Atual
              </span>
              <p style={{ fontWeight: '600' }}>{tenant?.organization.name ?? 'Não configurada'}</p>
            </div>
            <div className="field">
              <span className="muted" style={{ fontSize: '13px' }}>
                Slug
              </span>
              <p style={{ fontWeight: '600' }}>{tenant?.organization.slug ?? '-'}</p>
            </div>
          </article>

          {/* Form de feedback integrado */}
          <div style={{ gridColumn: '1 / -1' }}>
            <FeedbackForm />
          </div>
        </div>
      </section>
    </main>
  );
}
