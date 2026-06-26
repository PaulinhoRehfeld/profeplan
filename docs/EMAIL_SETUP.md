# Configuração do Sistema de E-mail — PROFEPLAN

## Visão Geral

O PROFEPLAN usa o **Resend** como provedor de e-mail transacional. A integração funciona via API REST diretamente nas Vercel Serverless Functions — sem pacotes extras, sem dependência do servidor de e-mail interno do Supabase.

**Por que Resend e não o e-mail padrão do Supabase?**
O Free Tier do Supabase limita a 2 e-mails por hora. O Resend oferece 3.000 e-mails/mês gratuitos, com entregabilidade profissional (SPF, DKIM, DMARC).

---

## 1. Criar Conta no Resend

1. Acesse [resend.com](https://resend.com) e clique em **Sign Up**
2. Crie a conta com seu e-mail (Google ou GitHub também funcionam)
3. Confirme o e-mail de verificação

---

## 2. Verificar o Domínio `profeplan.com.br`

Sem verificação de domínio, o Resend só consegue enviar para o seu próprio e-mail (limite: 1/dia). Verificar o domínio remove esse limite.

### 2.1 Adicionar o domínio

No painel do Resend:
1. Clique em **Domains** → **Add Domain**
2. Digite `profeplan.com.br`
3. Selecione a região **São Paulo (sa-east-1)** se disponível, ou **US East**
4. Clique em **Add**

### 2.2 Configurar registros DNS

O Resend vai exibir os registros que você precisa adicionar no provedor DNS do domínio. Adicione todos:

#### SPF (TXT)
```
Nome: @  (ou profeplan.com.br)
Tipo: TXT
Valor: v=spf1 include:amazonses.com ~all
```

#### DKIM (TXT ou CNAME — o Resend informa o correto)
```
Nome: resend._domainkey.profeplan.com.br
Tipo: TXT
Valor: (valor gerado pelo Resend — copie do painel)
```

#### DMARC (TXT)
```
Nome: _dmarc.profeplan.com.br
Tipo: TXT
Valor: v=DMARC1; p=none; rua=mailto:suporte@profeplan.com.br
```

> **Nota:** A propagação de DNS pode levar de alguns minutos a 48 horas. O Resend verifica automaticamente e marca o domínio como verificado quando os registros estiverem ativos.

---

## 3. Criar a API Key

1. No painel do Resend: **API Keys** → **Create API Key**
2. Nome sugerido: `profeplan-prod`
3. Permissão: **Full Access** (ou "Sending Access" se quiser ser mais restritivo)
4. Clique em **Add**
5. **Copie a chave imediatamente** — ela só é exibida uma vez. Começa com `re_`

---

## 4. Configurar Variáveis na Vercel

No painel da Vercel:
1. Acesse seu projeto → **Settings** → **Environment Variables**
2. Adicione as seguintes variáveis (todos os environments: Production, Preview, Development):

| Variável | Valor | Tipo |
|---|---|---|
| `RESEND_API_KEY` | `re_sua_chave_aqui` | Secret |
| `SMTP_FROM_EMAIL` | `noreply@profeplan.com.br` | Plain |
| `SMTP_FROM_NAME` | `PROFEPLAN` | Plain |
| `APP_URL` | `https://profeplan.vercel.app` | Plain |
| `SUPABASE_URL` | URL do seu projeto Supabase | Plain |
| `SUPABASE_SERVICE_ROLE_KEY` | Chave service_role do Supabase | Secret |

> **Após adicionar variáveis**, faça um novo deploy para que as funções serverless as usem.

---

## 5. Configurar SMTP no Supabase (para recuperação de senha)

O Supabase ainda precisa de SMTP configurado para enviar e-mails de **recuperação de senha** quando o usuário clica em "Esqueci minha senha" na tela padrão.

No painel do Supabase:
1. **Authentication** → **Emails** → **SMTP Settings**
2. Ative **"Enable Custom SMTP"**
3. Preencha:

| Campo | Valor |
|---|---|
| Sender name | PROFEPLAN |
| Sender email | noreply@profeplan.com.br |
| Host | smtp.resend.com |
| Port | 465 |
| Username | resend |
| Password | `re_sua_chave_resend` |

4. Clique em **Save** → **Send test email** para verificar

> Com o SMTP do Supabase configurado via Resend, a recuperação de senha também passa pelo Resend — sem limite de envio.

---

## 6. Testar a Integração

### 6.1 Teste de cadastro

1. Acesse a tela de cadastro do PROFEPLAN
2. Crie uma conta com um e-mail real
3. Verifique se o e-mail de confirmação chegou (verifique o Spam)
4. Nos logs da Vercel (Functions → Logs), procure por `[Email] Enviado com sucesso`

### 6.2 Teste de recuperação de senha

1. Na tela de login, clique em "Esqueci minha senha" (se implementado)
2. Verifique se o e-mail chegou

### 6.3 Verificar no painel do Resend

Em **Emails** no painel do Resend, você verá todos os e-mails enviados com status de entrega.

---

## 7. Fluxo de Cadastro (técnico)

```
Frontend (LoginScreen)
  ↓ POST /api/auth/signup  { email, password, fullName }
  
Vercel Serverless (api/auth/signup.ts)
  ↓ supabaseAdmin.auth.admin.generateLink({ type: 'signup', ... })
    → Cria usuário no Supabase Auth
    → Gera link de confirmação (não envia e-mail)
  ↓ sendEmailConfirmation({ to, fullName, confirmationUrl })
    → Resend API → E-mail de confirmação chega ao usuário
  ↓ Retorna { success: true, message: "..." }
  
Usuário clica no link
  ↓ https://[SUPABASE_URL]/auth/v1/verify?token=...&type=signup
    → Supabase confirma o e-mail
    → Redireciona para APP_URL/login
```

---

## 8. Troubleshooting

### E-mail não chegou
- Verifique o Spam
- No painel do Resend (Emails), verifique se o e-mail foi enviado e qual o status
- Nos logs da Vercel, procure por `[Email] Falha ao enviar via Resend` ou `RESEND_API_KEY não configurada`

### Erro "RESEND_API_KEY não configurada"
- A variável não foi adicionada na Vercel ou o deploy não foi refeito após adicionar
- Faça um novo deploy após adicionar as variáveis

### Domínio não verificado
- O Resend exige que o domínio esteja verificado para enviar para qualquer e-mail
- Enquanto não verifica, você só pode enviar para o e-mail da sua conta Resend
- Para testes imediatos, use `onboarding@resend.dev` como `SMTP_FROM_EMAIL` (requer conta Resend mas sem verificação de domínio)

### Link de confirmação expirado
- O link gerado pelo `generateLink()` expira em 24 horas
- O usuário precisa criar uma nova conta ou o admin precisa reenviar manualmente via Supabase Dashboard → Auth → Users → Send magic link

---

## 9. Checklist de Produção

- [ ] Conta Resend criada
- [ ] Domínio `profeplan.com.br` adicionado no Resend
- [ ] Registros DNS (SPF, DKIM, DMARC) adicionados no provedor
- [ ] Domínio verificado no painel Resend (status: verde)
- [ ] API Key criada e copiada
- [ ] `RESEND_API_KEY` adicionada na Vercel (Production)
- [ ] `SMTP_FROM_EMAIL`, `SMTP_FROM_NAME`, `APP_URL` adicionadas na Vercel
- [ ] `SUPABASE_SERVICE_ROLE_KEY` adicionada na Vercel
- [ ] SMTP configurado no Supabase Auth com as credenciais Resend
- [ ] Deploy realizado após adicionar variáveis
- [ ] Teste de cadastro realizado com e-mail real
- [ ] Teste de recuperação de senha realizado
- [ ] Logs da Vercel verificados (sem erros)
