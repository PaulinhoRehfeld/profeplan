# PROFEPLAN-CONTINUITY-001 — continuidade institucional e portabilidade de contexto

**Status:** APROVADA
**Data:** 19 de agosto de 2026
**Organização:** WRtech
**Produto:** ProfePlan

## 1. Contexto

O desenvolvimento do ProfePlan acumulou conhecimento relevante em código, documentação, ADRs, PRs, checkpoints, conversas de IA, memória contextual e decisões operacionais.

A WRtech decidiu reduzir a dependência de uma conta pessoal de IA como mecanismo de continuidade e, paralelamente, preparar a migração dos gastos elegíveis para a empresa.

## 2. Decisão

Fica criado o **ProfePlan Continuity Pack** como camada institucional de portabilidade de contexto.

A decisão aprovada estabelece que:

1. a conta de IA atualmente utilizada não será abandonada ou substituída de forma abrupta;
2. nenhuma migração irreversível de workspace será realizada antes de existir documentação suficiente para continuidade;
3. despesas elegíveis deverão ser progressivamente vinculadas à WRtech conforme validação contábil e operacional;
4. conhecimento essencial do produto não poderá depender exclusivamente de histórico ou memória de uma ferramenta de IA;
5. código, schemas, ADRs, contratos, blueprints, roadmaps, checkpoints e evidências continuarão sendo as fontes de maior autoridade;
6. o Continuity Pack será uma camada de orientação e resolução de contexto, e não uma cópia de todo o repositório;
7. secrets, credenciais e dados pessoais desnecessários ficam explicitamente fora do pacote.

## 3. Princípio institucional

> A IA deve conhecer o ProfePlan porque consegue consultar o conhecimento canônico da WRtech, e não apenas porque participou de conversas anteriores.

## 4. Efeitos esperados

A decisão deverá permitir:

- continuidade entre conversas e contas;
- entrada de novos agentes sem reconstrução completa do histórico;
- menor custo de contexto;
- redução de contradições;
- melhor separação entre memória pessoal e patrimônio intelectual empresarial;
- troca futura de modelo, ferramenta ou plataforma com menor dependência;
- preparação segura para eventual workspace empresarial.

## 5. Estratégia financeira associada

A migração financeira deve ser tratada separadamente da migração de conhecimento.

A ordem preferencial é:

1. preservar a conta atual enquanto houver valor de continuidade;
2. verificar a adequação de faturamento e pagamento empresarial;
3. registrar a despesa conforme orientação contábil da WRtech;
4. somente adotar migração de workspace/conta quando houver necessidade organizacional real.

Esta decisão não substitui orientação contábil ou fiscal.

## 6. Critério para eventual migração de workspace

Antes de qualquer migração irreversível, deve existir um checkpoint que comprove, no mínimo:

- Continuity Pack funcional;
- documentos críticos atualizados;
- instruções relevantes preservadas;
- riscos registrados;
- acessos revisados;
- secrets fora da documentação;
- teste de portabilidade realizado.

## 7. Critério de portabilidade

A portabilidade será demonstrada quando um ambiente limpo, com acesso ao repositório e ao `15-CONTINUITY-BOOTSTRAP-PROMPT.md`, conseguir localizar as fontes relevantes e reconstruir corretamente:

- identidade do produto;
- arquitetura de alto nível;
- estado corrente;
- decisões vigentes;
- trabalho aberto;
- próximo gate;
- limites de execução.

## 8. Relação com documentos anteriores

Esta decisão não invalida documentos existentes. Ela cria uma camada de continuidade que deve apontar para as fontes mais específicas e atuais.

Documentação histórica permanece útil, mas não deve ser promovida automaticamente a verdade corrente quando conflitar com evidência executável ou decisões mais recentes.

## 9. Implementação inicial

A v1 do Continuity Pack será criada em:

`docs/profeplan-continuity/`

com uma seleção pequena de documentos de alto valor. Novos arquivos serão adicionados conforme necessidade comprovada, evitando sobrecarga documental.
