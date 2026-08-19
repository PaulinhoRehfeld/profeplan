# Piloto real controlado — fronteira jurídica e operacional (Fase C)

Data da definição inicial: 19 de agosto de 2026.
Última reconciliação: 19 de agosto de 2026.

Referência de origem: Checkpoint 051 e `RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md`.

## Status

**Fronteira preenchida e piloto real autorizado de forma estritamente escopada.**

A autorização não é para a obra inteira e não autoriza publicação, redistribuição, corpus, treinamento, embeddings, retrieval/RAG, persistência hospedada ou produção. Ela cobre somente o artefato identificado pelo SHA-256 abaixo e a leitura profunda da parte única delimitada nas páginas físicas 34–35.

O PDF permanece fora do Git, em ambiente local efêmero. A execução material ainda precisa comprovar o teste dedicado contra o binário governado antes de qualquer declaração de sucesso.

## 1. Pergunta arquitetônica autorizada

O piloto responde somente:

> O mecanismo `cartografia preliminar → CartographicPartScope → inspeção seletiva → reconstrução candidata`, já comprovado em duas estruturas sintéticas, consegue reconstruir uma parte de um PDF editorial real preservando limites, dupla paginação, hierarquia, seletividade e evidências sem transformar a obra inteira em contexto?

## 2. Natureza do uso

O uso é **referencial, não substitutivo**. O Sócrates/ProfePlan deve indicar ao professor onde determinado conteúdo está na obra que ele já possui/utiliza, preservando estrutura, localização e metadados mínimos, sem reproduzir capítulos ou páginas integralmente.

Consequências vinculantes:

- persistir/expor somente estrutura, localização, metadados e trechos mínimos estritamente necessários;
- não permitir reconstrução da obra a partir dos dados armazenados;
- não publicar o PDF, imagens integrais ou texto extenso;
- qualquer citação literal deve ser curta e apenas auxiliar à localização/referência.

## 3. Base jurídica declarada pelo responsável pelo projeto

O responsável declarou que o exemplar utilizado é obtido por acesso próprio, na condição de professor, diretamente pelos canais liberados pelas editoras mediante cadastro, para consulta e elaboração de material didático. O arquivo usado nesta prova não depende de cópia de terceiro, não está sendo redistribuído e permanece fora do repositório.

Esta é uma declaração de rastreabilidade operacional e não um parecer jurídico independente.

## 4. Escopo material governado

| Campo | Valor governado | Status |
|---|---|---|
| Obra/edição | `Do seu jeito — Sociologia`; Editora Ática (SOMOS Educação); 1ª edição, São Paulo, 2024; Ensino Médio; Ciências Humanas e Sociais Aplicadas; volume único; Manual do Professor; PNLD 2026–2029; código `0113P260101204816` | ✅ |
| Base jurídica | acesso próprio do professor via cadastro junto à editora, para consulta/elaboração de material | ✅ |
| Arquivo | `DOSEUJEITO_PNLD26_SOCIOLOGIA_VU_MP.pdf`; 449 páginas físicas; SHA-256 `1e7f8d613fdb43a49d4a1f0a031465784b03b31b1d22e1779d279365ad82e39a` | ✅ |
| Parte única | `Unidade 1 — Antropologia → Capítulo 1 — O pensamento antropológico → Evolucionismo social` | ✅ |
| Páginas profundas | físicas 34–35; impressas 33–34 | ✅ |
| Limite cartográfico seguinte | `Trabalhando com quadrinhos`, impressa 35 / física 36 | ✅ |
| Ambiente | `private-inputs/pnld/piloto-real/livro-0-sociologia/`, fora do Git e sem infraestrutura hospedada | ✅ |
| Retenção | 30 dias corridos a partir do depósito ou até conclusão da revisão humana, o que ocorrer primeiro | ✅ |
| Descarte | remoção do PDF e artefatos temporários pelo responsável do projeto após conclusão/revisão conforme roadmap | ✅ |
| Revisão | revisão humana obrigatória antes de qualquer promoção ou reuso | ✅ |
| Proibições | sem publicação, corpus, produção, texto literal extenso, outra obra, RAG, embeddings ou armazenamento hospedado | ✅ |

**Fronteira material concluída.** Qualquer mudança de SHA-256, obra, edição, parte ou páginas exige uma nova delimitação explícita.

## 5. Evidência cartográfica observada antes da leitura profunda

A inspeção real do mesmo binário governado registrou:

- `Conheça seu livro`: física 5 / impressa 4;
- `Sumário`: físicas 7–9 / impressas 6–8;
- `Unidade 1 — Antropologia`: física 29 / impressa 28;
- `Capítulo 1 — O pensamento antropológico`: física 31 / impressa 30;
- `Evolucionismo social`: física 34 / impressa 33;
- próximo irmão `Trabalhando com quadrinhos`: física 36 / impressa 35;
- `PDF PageLabels` coerentes com a dupla paginação.

A cartografia preliminar não constitui autoridade canônica de conteúdo. Ela serve para delimitar seletivamente a parte e produzir `CartographicPartScope` candidato.

## 6. Diferença real observada no Sumário

O PDF possui texto nativo, mas uma entrada visual do Sumário pode chegar fragmentada em vários objetos textuais consecutivos (`título`, `pontilhado`, `label`). O fixture sintético anterior entregava essa entrada em um único `text_block`.

Classificação preliminar: **Resultado B — pequena generalização**.

A correção autorizada é mínima e provider-neutral: recompor a entrada lógica a partir de fragmentos consecutivos no `StructuralRecognitionService`, sem alterar contratos, sem OCR e sem regra específica para esta coleção.

## 7. Sequência operacional autorizada

```text
1. validar o SHA-256 do PDF local antes da prova
2. executar o teste dedicado com PROFEPLAN_REAL_PILOT_PDF
3. confirmar cartografia e dupla paginação
4. extrair nativamente somente o CartographicPartScope das físicas 34–35
5. reconstruir localmente a seção preservando Unidade → Capítulo → seção
6. registrar evidências, warnings e classificação arquitetônica
7. revisar humanamente o resultado
8. não promover para corpus/produção; encerrar e descartar conforme a política
```

## 8. Critérios de sucesso

A prova somente pode ser declarada verde se demonstrar materialmente:

1. SHA-256 exatamente igual ao governado;
2. 449 páginas físicas;
3. Sumário localizado e entradas fragmentadas recompostas sem regra específica da obra;
4. Unidade 1 física 29/impressa 28;
5. Capítulo 1 física 31/impressa 30, filho da Unidade 1;
6. `Evolucionismo social` filho do Capítulo 1;
7. escopo profundo exatamente nas físicas 34–35 / impressas 33–34;
8. reconstrução limitada ao `CartographicPartScope` autorizado;
9. elementos e relações apoiados por evidência;
10. estados cartográficos permanecendo candidatos;
11. contratos permanecendo em `1.0.0`;
12. provas sintéticas anteriores sem regressão.

CI ordinário sem o PDF não substitui essa prova material; nesse caso o teste real deve permanecer `skip` por desenho.

## 9. Fora de escopo

- obra inteira como contexto semântico;
- outra obra/coleção;
- OCR geral ou multimodal geral;
- corpus, chunks, embeddings, retrieval/RAG ou grafo global;
- validação semântica BNCC;
- migration, RPC ou nova persistência;
- Supabase/Storage hospedado;
- runtime multiagente;
- produção.

## 10. Reconciliação entre PR #118 e PR #124

O PR #118 já havia delimitado e observado materialmente este mesmo artefato, SHA-256 e parte única. O PR #124 repetiu parte da cartografia a partir da nova preparação local, mas introduziu divergências editoriais e tratou a escolha da parte como ainda pendente.

Esta versão reconcilia as duas linhas: preserva do #124 a confirmação local de acesso/arquivo e preserva do #118 a identidade bibliográfica governada, a hierarquia cartográfica, a dupla paginação e a parte única já delimitada. O próximo gate não é escolher uma nova parte; é executar o teste real dedicado contra o binário governado no runtime local com dependências do repositório.
