# EMPRESA PROFEPLAN — Reorganization Roadmap

**Status:** roadmap documental e institucional

## 1. Objetivo

Organizar a EMPRESA PROFEPLAN sem interromper desenvolvimento ativo, sem mover documentação prematuramente e sem transformar governança em fim em si mesma.

## 2. Princípio

A reorganização será feita por maturidade de domínio:

```text
desenvolvimento ativo
→ marco estável
→ reconciliação documental
→ Blueprint consolidado
→ migração física quando útil
→ manutenção contínua
```

## 3. Fase 0 — Camada mestre

Status: **em execução**.

Entregas:
- README institucional;
- MASTER-BLUEPRINT;
- índice A–M;
- mapa de maturidade;
- mapa de dependências;
- matriz documental inicial.

Sem mover documentos existentes.

## 4. Fase 1 — Knowledge Factory PNLD

Objetivo: concluir o próximo grande marco estrutural estável antes de reorganizar fisicamente `docs/profeplan-knowledge-factory/`.

Gate de saída:
- arquitetura vigente reconciliada;
- contratos principais atualizados;
- evidências e checkpoints coerentes;
- Blueprint PNLD consolidado;
- estado e próxima fase explicitados.

Após o gate, decidir se a pasta física atual permanece ou se passa a integrar `projects/C-knowledge-factory-pnld/`.

## 5. Fase 2 — Curriculum Factory

Objetivo: iniciar estrutura oficial da BNCC e currículos dos 26 estados + DF.

Entregas mínimas antes de escala:
- escopo documental;
- provenance/source policy;
- modelo de dados curricular;
- estratégia de versionamento;
- primeiro estado piloto;
- teste de generalização para um segundo estado.

## 6. Fase 3 — Marketing & Vendas

Objetivo: ativar geração de receita sem esperar conclusão das fábricas técnicas.

Entregas:
- Matriz de Veracidade;
- Product Evidence Pack;
- posicionamento;
- funil mínimo;
- campanhas e conteúdos rastreáveis ao produto real;
- métricas comerciais.

## 7. Fase 4 — Aplicativo e Site/SaaS/UX

Estado atual: operacional/em evolução.

Ação: não reconstruir. Criar reconciliação documental baseada no que está funcionando, registrar débitos e só então migrar documentação para as casas definitivas.

## 8. Fase 5 — PDI/DUA

Objetivo: estruturar fábrica baseada em evidência científica, legislação e currículo.

Antes de implementação ampla:
- política de fontes;
- modelo de evidência;
- limites clínico/pedagógicos;
- privacidade e dados sensíveis;
- contratos de adaptação e relatório.

## 9. Fases subsequentes

- H ENEM/SAEB: consolidar matrizes, provas e descritores.
- I Avaliações: reconciliar capacidades existentes e integrações com H/D/G/C.
- J Apresentações: consolidar geração e consumo de contexto.
- M Kids: manter discovery contínuo para meta de fevereiro de 2027.
- K Nexus/CRM e L NEB: manter como futuros até decisão explícita.

## 10. Migração GitHub

A transferência de propriedade do monorepo é uma frente independente da reorganização documental.

Destino previsto:
`Profeplan-Edtech/profeplan`

Pré-condições:
- auditoria de Vercel;
- Actions;
- secrets/variables/environments;
- branch protections;
- Apps/webhooks;
- remotes locais;
- PRs/branches em andamento;
- validação pós-transferência preparada.

A transferência não depende de todos os domínios estarem reorganizados.

## 11. Regra de prioridade

Quando houver conflito entre documentação e entrega de valor, priorizar a documentação mínima necessária para permitir execução segura e continuidade.