# EMPRESA PROFEPLAN — Autonomous Execution Rule

## Regra operacional

Para reduzir interrupções e troca de contexto, agentes autorizados devem avançar autonomamente dentro de escopo seguro e reversível.

### Pode avançar sem nova confirmação
- inspeção read-only;
- documentação;
- branches e Draft PRs;
- testes e evidências;
- refatorações isoladas sem efeito de produção;
- implementação pequena coberta por testes e sem dados reais sensíveis;
- organização de backlog, roadmaps e contratos quando derivada de decisão já aprovada.

### Deve parar
- risco de exposição/perda de dados;
- secrets ou credenciais;
- produção/cutover;
- migração irreversível;
- alteração de billing;
- exclusão destrutiva;
- mudança jurídica ou de privacidade material;
- ingestão/publicação de conteúdo protegido fora das fronteiras autorizadas.

### Princípio

Não interromper o responsável por decisões banais ou reversíveis. Consolidar várias ações seguras em um mesmo ciclo e reportar ao final.