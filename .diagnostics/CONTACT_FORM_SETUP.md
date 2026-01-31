# Configuração do Formulário de Contato

## 📧 Web3Forms Setup

O formulário de contato da landing page usa o serviço **Web3Forms** para envio de emails sem necessidade de backend próprio.

### 1️⃣ Criar Conta no Web3Forms

1. Acesse: <https://web3forms.com/>
2. Clique em "Get Started Free"
3. Faça login com GitHub ou Email
4. É **100% GRATUITO** (até 250 submissões/mês)

### 2️⃣ Obter Access Key

1. No painel do Web3Forms, clique em "Create New Form"
2. Configure:
   - **Email**: `suporte@profeplan.com.br`
   - **Form Name**: `ProfePlan Landing Page`
3. Copie o **Access Key** gerado (exemplo: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`)

### 3️⃣ Configurar no Código

Edite o arquivo: `src/components/ContactSection.tsx`

Localize a linha 30:

```typescript
access_key: 'YOUR_ACCESS_KEY_HERE', // Será configurada posteriormente
```

Substitua por:

```typescript
access_key: 'SUA_ACCESS_KEY_AQUI',
```

### 4️⃣ Teste o Formulário

1. Execute o projeto: `npm run dev`
2. Acesse: `http://localhost:5173`
3. Role até a seção "Contato"
4. Preencha e envie um email de teste
5. Verifique a caixa de entrada: `suporte@profeplan.com.br`

## 📱 WhatsApp

O botão do WhatsApp está configurado para:

- **Número**: (33) 99998-9922
- **Mensagem padrão**: "Olá! Gostaria de mais informações sobre o ProfePlan."

A mensagem é **editável** pelo usuário antes do envio.

### Alterar Número do WhatsApp

Edite o arquivo: `src/components/ContactSection.tsx`

Localize a linha 72:

```typescript
const whatsappLink = `https://wa.me/5533999989922?text=${whatsappMessage}`;
```

Formato: `55` (Brasil) + `33` (DDD) + `999989922` (número)

## 🎨 Personalização

### Alterar Email de Destino

No arquivo `ContactSection.tsx`, linha 36:

```typescript
to_email: 'suporte@profeplan.com.br'
```

### Alterar Mensagem Padrão do WhatsApp

No arquivo `ContactSection.tsx`, linha 71:

```typescript
const whatsappMessage = encodeURIComponent('Sua mensagem aqui');
```

## ✅ Checklist de Deploy

- [ ] Criar conta no Web3Forms
- [ ] Obter Access Key
- [ ] Substituir `YOUR_ACCESS_KEY_HERE` pela chave real
- [ ] Testar envio de email em localhost
- [ ] Testar botão do WhatsApp
- [ ] Verificar recebimento no email `suporte@profeplan.com.br`
- [ ] Deploy para produção

## 🔒 Segurança

⚠️ **IMPORTANTE**: A Access Key do Web3Forms é segura para uso no frontend. Ela:

- Está vinculada ao domínio do site
- Só aceita envios do domínio registrado
- Tem rate limiting automático
- Pode ser revogada a qualquer momento no painel

Mas para maior segurança, considere criar uma **variável de ambiente**:

1. Crie `.env`:

```
VITE_WEB3FORMS_ACCESS_KEY=sua_access_key_aqui
```

1. No código:

```typescript
access_key: import.meta.env.VITE_WEB3FORMS_ACCESS_KEY,
```

1. Adicione ao `.gitignore`:

```
.env
.env.local
```

## 📊 Monitoramento

Acesse o painel do Web3Forms para:

- Ver estatísticas de envios
- Ler mensagens recebidas
- Configurar notificações
- Exportar dados

## 🆘 Troubleshooting

### Erro ao enviar formulário

1. Verifique se a Access Key está correta
2. Confirme que o domínio está liberado no Web3Forms
3. Cheque o console do navegador para erros
4. Verifique a conexão de internet

### Mensagem não chegou

1. Verifique a pasta de SPAM
2. Confirme o email configurado no Web3Forms
3. Aguarde até 5 minutos (pode ter delay)

### WhatsApp não abre

1. Verifique se o número está no formato correto
2. Teste em diferentes dispositivos
3. Confirme que o navegador permite abrir links externos
