# EMPRESA PROFEPLAN — GitHub Migration Checklist

**Destino previsto:** `Profeplan-Edtech/profeplan`
**Origem atual:** `PaulinhoRehfeld/profeplan`
**Status:** transferência NÃO autorizada por este documento

## 1. Objetivo

Definir o gate de segurança para a futura transferência nativa do repositório principal para a organização oficial.

## 2. Pré-transferência — identidade e baseline

- [ ] Confirmar `main` e SHA imediatamente antes do corte.
- [ ] Registrar PRs abertos e branches ativas.
- [ ] Confirmar que `Profeplan-Edtech/profeplan` não existe ou não conflita.
- [ ] Confirmar owners e permissões da organização.
- [ ] Definir janela curta sem merges durante a transferência.

## 3. GitHub Actions e governança

- [ ] Inventariar workflows ativos.
- [ ] Registrar secrets por NOME, nunca por valor.
- [ ] Registrar variables por NOME e escopo.
- [ ] Registrar environments e regras de aprovação.
- [ ] Registrar branch protections/rulesets.
- [ ] Registrar GitHub Apps instalados.
- [ ] Registrar webhooks e integrações dependentes do owner/repo.
- [ ] Verificar permissões de Actions na organização destino.

## 4. Vercel e deploy

- [ ] Identificar projeto(s) Vercel ligados ao repositório.
- [ ] Confirmar integração Git nativa e owner/repo esperado.
- [ ] Registrar Production Branch.
- [ ] Registrar Preview behavior.
- [ ] Confirmar domínio e aliases independentes da URL GitHub.
- [ ] Preparar teste de Preview após a transferência antes de qualquer mudança adicional.

## 5. Supabase e serviços externos

- [ ] Identificar referências literais ao owner/repo em configurações, OAuth, webhooks ou automações.
- [ ] Confirmar que Supabase não depende de URL GitHub antiga para runtime crítico.
- [ ] Revisar Stripe, e-mail e demais integrações somente quando houver evidência de vínculo com GitHub.

## 6. Ambiente local

- [ ] Localizar clone local real usado no Ubuntu/Windows.
- [ ] Registrar `git remote -v` antes do corte.
- [ ] Preparar atualização de `origin` para `Profeplan-Edtech/profeplan`.
- [ ] Verificar branches locais não publicadas.
- [ ] Não apagar o clone antigo durante a validação.

## 7. Transferência

- [ ] Executar transferência nativa pelo GitHub, não clone/push para repositório novo.
- [ ] Confirmar preservação de commits, branches, tags, issues e PRs.
- [ ] Confirmar SHA da `main` após o corte.
- [ ] Confirmar redirects do endereço antigo.

## 8. Pós-transferência

- [ ] Validar Actions.
- [ ] Validar branch protections/rulesets.
- [ ] Validar Vercel Preview.
- [ ] Validar Production sem promover mudança desnecessária.
- [ ] Atualizar remotes locais.
- [ ] Atualizar referências canônicas em documentação atual.
- [ ] Preservar referências históricas quando fizerem parte da genealogia real.
- [ ] Atualizar Continuity Pack e MASTER-BLUEPRINT.
- [ ] Registrar checkpoint de migração concluída.

## 9. Stop conditions

Interromper a transferência se:
- secrets/variables críticos não estiverem inventariados;
- integração Vercel não puder ser validada;
- houver branch local não publicada relevante;
- houver conflito de nome no destino;
- permissões da organização forem insuficientes;
- a `main` tiver mudado sem reconciliação do baseline.