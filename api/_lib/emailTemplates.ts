// Templates HTML de e-mail com identidade visual PROFEPLAN.
// Paleta: fundo #0f172a (slate-950), azul #2563eb, texto branco.

const baseStyles = `
  body { margin: 0; padding: 0; background-color: #f1f5f9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
  .wrapper { max-width: 560px; margin: 32px auto; }
  .card { background: #0f172a; border-radius: 16px; overflow: hidden; }
  .header { background: linear-gradient(135deg, #1e3a8a 0%, #1d4ed8 100%); padding: 32px 40px; text-align: center; }
  .logo { font-size: 28px; font-weight: 900; color: #ffffff; letter-spacing: -1px; font-style: italic; }
  .tagline { font-size: 10px; font-weight: 700; color: #93c5fd; letter-spacing: 3px; text-transform: uppercase; margin-top: 4px; }
  .body { padding: 36px 40px; }
  .greeting { font-size: 18px; font-weight: 700; color: #ffffff; margin: 0 0 12px; }
  .text { font-size: 14px; color: #94a3b8; line-height: 1.7; margin: 0 0 20px; }
  .btn { display: inline-block; background: #2563eb; color: #ffffff !important; font-size: 14px; font-weight: 700; padding: 14px 32px; border-radius: 10px; text-decoration: none; margin: 8px 0 24px; }
  .divider { border: none; border-top: 1px solid #1e293b; margin: 24px 0; }
  .small { font-size: 11px; color: #475569; line-height: 1.6; }
  .footer { padding: 20px 40px 28px; text-align: center; }
  .footer-text { font-size: 11px; color: #334155; }
  .highlight { color: #60a5fa; font-weight: 600; }
`;

function layout(content: string): string {
  return `<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <style>${baseStyles}</style>
</head>
<body>
  <div class="wrapper">
    <div class="card">
      <div class="header">
        <div class="logo">PROFEPLAN</div>
        <div class="tagline">Ecossistema de Inteligência Pedagógica</div>
      </div>
      <div class="body">${content}</div>
      <div class="footer">
        <p class="footer-text">© ${new Date().getFullYear()} PROFEPLAN — Todos os direitos reservados<br/>
        Este e-mail foi enviado automaticamente. Não responda.</p>
      </div>
    </div>
  </div>
</body>
</html>`;
}

export function confirmationEmailTemplate(opts: {
  fullName: string;
  confirmationUrl: string;
  appUrl: string;
}): string {
  const name = opts.fullName.split(' ')[0];
  return layout(`
    <p class="greeting">Olá, ${name}! 👋</p>
    <p class="text">
      Sua conta no <span class="highlight">PROFEPLAN</span> foi criada com sucesso.<br/>
      Para ativar o acesso ao seu workspace pedagógico, confirme seu e-mail clicando no botão abaixo.
    </p>
    <div style="text-align:center">
      <a class="btn" href="${opts.confirmationUrl}">✓ Confirmar meu e-mail</a>
    </div>
    <hr class="divider"/>
    <p class="small">
      Este link é válido por <strong>24 horas</strong> e pode ser usado apenas uma vez.<br/><br/>
      Se você não criou uma conta no PROFEPLAN, ignore este e-mail com segurança.<br/><br/>
      Caso o botão não funcione, copie e cole este link no navegador:<br/>
      <span style="color:#2563eb;word-break:break-all">${opts.confirmationUrl}</span>
    </p>
  `);
}

export function welcomeEmailTemplate(opts: { fullName: string; appUrl: string }): string {
  const name = opts.fullName.split(' ')[0];
  return layout(`
    <p class="greeting">Bem-vindo ao PROFEPLAN, ${name}! 🎉</p>
    <p class="text">
      Sua conta está ativa. Agora você tem acesso ao <span class="highlight">ecossistema completo de planejamento pedagógico</span> com IA.
    </p>
    <p class="text">Com o PROFEPLAN você pode:</p>
    <ul style="color:#94a3b8;font-size:14px;line-height:2;padding-left:20px;margin:0 0 20px">
      <li>Criar planos de aula e de curso com IA</li>
      <li>Gerar PDIs personalizados para seus alunos</li>
      <li>Acessar o currículo CRMG estruturado</li>
      <li>Analisar turmas e desempenho</li>
    </ul>
    <div style="text-align:center">
      <a class="btn" href="${opts.appUrl}">Acessar meu Workspace →</a>
    </div>
    <hr class="divider"/>
    <p class="small">
      Em caso de dúvidas, entre em contato com o suporte pelo e-mail da sua escola ou administrador.
    </p>
  `);
}

export function passwordResetTemplate(opts: {
  fullName: string;
  resetUrl: string;
  appUrl: string;
}): string {
  const name = opts.fullName.split(' ')[0] || 'usuário';
  return layout(`
    <p class="greeting">Redefinição de senha</p>
    <p class="text">
      Olá, ${name}. Recebemos uma solicitação para redefinir a senha da sua conta no <span class="highlight">PROFEPLAN</span>.
    </p>
    <p class="text">Clique no botão abaixo para criar uma nova senha:</p>
    <div style="text-align:center">
      <a class="btn" href="${opts.resetUrl}">Redefinir minha senha</a>
    </div>
    <hr class="divider"/>
    <p class="small">
      Este link expira em <strong>1 hora</strong>.<br/><br/>
      Se você <strong>não</strong> solicitou redefinição de senha, ignore este e-mail.
      Sua conta permanece segura e nenhuma alteração foi feita.<br/><br/>
      Caso o botão não funcione, copie e cole este link:<br/>
      <span style="color:#2563eb;word-break:break-all">${opts.resetUrl}</span>
    </p>
  `);
}

export function invitationTemplate(opts: {
  to: string;
  inviterName: string;
  inviteUrl: string;
  role: string;
  appUrl: string;
}): string {
  const roleLabel =
    opts.role === 'admin'
      ? 'Administrador'
      : opts.role === 'manager'
        ? 'Gestor Escolar'
        : 'Professor';

  return layout(`
    <p class="greeting">Você foi convidado para o PROFEPLAN</p>
    <p class="text">
      <span class="highlight">${opts.inviterName}</span> convidou você para acessar o <span class="highlight">PROFEPLAN</span>
      como <strong style="color:#ffffff">${roleLabel}</strong>.
    </p>
    <p class="text">
      Clique no botão abaixo para criar sua conta e acessar o workspace pedagógico.
    </p>
    <div style="text-align:center">
      <a class="btn" href="${opts.inviteUrl}">Aceitar convite →</a>
    </div>
    <hr class="divider"/>
    <p class="small">
      Este convite é válido por <strong>7 dias</strong>.<br/><br/>
      Se você recebeu este e-mail por engano, ignore-o com segurança.
    </p>
  `);
}
