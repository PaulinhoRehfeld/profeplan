# D — Curriculum Factory — Porta de Entrada

**Status:** implantação prioritária

## Objetivo

Estruturar BNCC e currículos oficiais dos 26 estados + DF como dados curriculares rastreáveis, versionados e reutilizáveis pelo ProfePlan.

## Primeiros documentos

- `SOURCE-PROVENANCE-POLICY.md` — regras de fonte, proveniência e versionamento.
- `PILOT-PLAN.md` — menor prova vertical antes de escala nacional.

## Regra

Não iniciar ingestão nacional em massa antes de provar que o modelo funciona em fontes com estruturas editoriais diferentes.

## Fluxo inicial

```text
fonte oficial
→ identificação/versionamento
→ mapeamento estrutural
→ normalização mínima
→ preservação de proveniência
→ validação
→ dataset curricular
→ consumo pelo Aplicativo e demais fábricas
```

## Consumidores prioritários

- Aplicativo ProfePlan;
- planejamentos;
- Avaliações;
- PDI/DUA;
- ENEM/SAEB;
- Apresentações.
