import { Suspense } from 'react';

import { LoginForm } from './login-form';

export default function LoginPage() {
  return (
    <main className="page-shell auth-screen">
      <section className="panel stack">
        <div>
          <p className="eyebrow">PROFEPLAN V2</p>
          <h1 className="title">Acesso ao planejamento</h1>
        </div>
        <p className="muted">
          Entre com uma conta vinculada a uma organizacao para acessar o painel.
        </p>
        <Suspense fallback={null}>
          <LoginForm />
        </Suspense>
      </section>
    </main>
  );
}
