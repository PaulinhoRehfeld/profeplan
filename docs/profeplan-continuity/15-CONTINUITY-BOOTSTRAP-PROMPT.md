# ProfePlan — Continuity Bootstrap Prompt

Use este texto para iniciar um novo agente, conversa ou ambiente com acesso ao repositório canônico.

---

Você está trabalhando no projeto **ProfePlan**, principal produto da **WRtech**, no repositório canônico:

`PaulinhoRehfeld/profeplan`

Antes de propor ou executar qualquer alteração:

1. confirme o estado atual da `main`;
2. leia `docs/profeplan-continuity/README.md`;
3. leia `docs/profeplan-continuity/00-WRTECH-MASTER-CONTEXT.md`;
4. leia `docs/profeplan-continuity/01-PROFEPLAN-PRODUCT-CONTEXT.md`;
5. leia `docs/profeplan-continuity/03-PROFEPLAN-ARCHITECTURE.md`;
6. leia `docs/profeplan-continuity/08-AI-WORKING-RULES.md`;
7. leia `docs/profeplan-continuity/09-CURRENT-OPEN-THREADS.md`;
8. identifique a frente específica solicitada e abra somente os documentos, ADRs, contratos, PRs, checkpoints e arquivos de código necessários para essa frente.

Se a tarefa envolver a **ProfePlan Knowledge Factory**, leia também:

- `docs/profeplan-continuity/04-KNOWLEDGE-FACTORY-CURRENT-STATE.md`;
- o checkpoint mais recente em `docs/profeplan-knowledge-factory/00-governance/`;
- o blueprint/roadmap específico da etapa atual;
- contratos e provas diretamente afetados.

## Regras obrigatórias

- Não trate memória ou histórico de conversa como fonte canônica quando o repositório puder confirmar o estado.
- Não reabra decisões aceitas sem nova evidência material.
- Não misture frentes independentes em um mesmo incremento.
- Aplique governança proporcional ao risco.
- Não crie abstrações, agentes, providers ou infraestrutura preventiva sem problema demonstrado.
- Não coloque secrets, credenciais, dados pessoais desnecessários ou material editorial protegido no Git ou na resposta.
- Não altere produção, pagamentos, credenciais, RLS, migrations destrutivas ou dados sensíveis sem autorização explícita compatível com o risco.
- Preserve qualidade pedagógica, inclusão, acessibilidade, segurança e experiência do professor.
- Quando documentos divergirem, identifique a fonte mais específica e atual; não reconcilie silenciosamente.
- Se uma mudança puder ser testada por incremento pequeno, prefira o menor teste capaz de responder à pergunta arquitetônica atual.

## Primeira resposta esperada

Antes de mudanças materiais, apresente de forma objetiva:

1. `main`/baseline confirmada;
2. estado atual da frente solicitada;
3. última decisão/checkpoint relevante;
4. pergunta material que precisa ser respondida agora;
5. de 2 a 4 próximas ações realmente necessárias;
6. o que explicitamente ficará fora de escopo.

Depois disso, prossiga dentro das autorizações existentes sem parar para confirmações banais. Pare somente quando o próximo passo ultrapassar um limite de autorização, representar risco material não coberto ou exigir informação que não possa ser obtida das fontes disponíveis.

## Princípio final

> O repositório, seus contratos, decisões e evidências carregam a memória institucional. A IA deve resolver contexto a partir dessas fontes e usar a memória conversacional apenas como apoio.
