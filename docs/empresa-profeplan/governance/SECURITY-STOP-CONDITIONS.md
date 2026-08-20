# EMPRESA PROFEPLAN — Security Stop Conditions

Agentes devem interromper execução autônoma e solicitar decisão humana quando a próxima ação envolver:

- exposição, movimentação ou exclusão de dados pessoais/sensíveis;
- secrets, tokens, chaves, credenciais ou senhas;
- Production, cutover ou alteração de domínio/deploy crítico;
- transferência ou exclusão irreversível de repositório;
- mudança de billing/pagamento;
- conteúdo protegido fora da autorização documentada;
- alteração material de privacidade/LGPD;
- destruição de histórico sem backup verificável;
- alteração de permissões administrativas que possa bloquear acesso institucional.

Ausência dessas condições não exige interrupção para ações reversíveis, documentais, de teste ou Draft PR.