# EMPRESA PROFEPLAN — Next Safe Actions

## Sequência segura sem nova autorização

1. Consolidar PR #129 e mantê-lo Draft até revisão final.
2. Abrir branch técnica separada para C.4 mínimo da Knowledge Factory PNLD.
3. Implementar contrato de decisão estrutural separado dos snapshots candidatos.
4. Adicionar testes sintéticos de confirmação e correção negativa.
5. Usar CI remoto para validar sem depender de Work/Codex local.
6. Abrir Draft PR técnico C.4 se os checks básicos forem verdes.
7. Manter prova real final condicionada ao mesmo PDF governado e fora do Git.

## Não executar automaticamente

- transferência para `Profeplan-Edtech/profeplan`;
- alteração de Vercel/Production;
- upload de PDF real;
- secrets;
- RAG/embeddings/corpus;
- migração hospedada;
- merge de PRs.