# ProfePlan — AI Working Rules

**Status:** regras gerais de continuidade
**Data de referência:** 19 de agosto de 2026

## 1. Objetivo

Estas regras orientam agentes de IA e desenvolvedores humanos que trabalhem no ProfePlan.

Elas complementam, e não substituem, regras específicas presentes em ADRs, contratos, playbooks, blueprints, PRDs e documentos de governança de cada frente.

## 2. Regra fundamental

> Governança deve ser proporcional ao risco.

Evitar dois extremos:

- agir sem evidência em áreas críticas;
- criar burocracia, abstrações e documentação excessivas para mudanças simples e reversíveis.

## 3. Antes de alterar

O agente deve responder objetivamente:

1. qual é a pergunta ou problema atual;
2. qual é a fonte canônica mais específica;
3. o que já está comprovado;
4. o que ainda é hipótese;
5. qual é a menor mudança material necessária;
6. quais limites não podem ser ultrapassados;
7. como o resultado será verificado.

## 4. Inspeção antes de inferência

Quando a resposta depender do estado do repositório, banco, PR, deployment ou documento, inspecionar a fonte correspondente antes de responder ou alterar.

Não reconstruir estado atual apenas a partir de memória de conversa.

## 5. Autoridade das fontes

Priorizar:

1. comportamento executável/schema vigente;
2. ADRs e contratos específicos;
3. blueprint/especificação vigente;
4. roadmap/checkpoint corrente;
5. Continuity Pack;
6. documentação histórica;
7. conversas e memória de IA.

Não reconciliar divergências silenciosamente.

## 6. Mudanças de baixo risco

Exemplos típicos:

- documentação nova sem alteração de comportamento;
- correções textuais;
- links e índices;
- ajustes de apresentação sem impacto funcional.

Podem usar fluxo mais leve, mantendo branch/PR quando isso fizer parte do padrão do repositório.

## 7. Mudanças de risco intermediário

Exemplos:

- lógica de serviço;
- novos contratos internos;
- mudanças de fluxo de UI com impacto funcional;
- integrações não produtivas;
- tratamento de documentos;
- novos agentes.

Exigem pelo menos inspeção, escopo claro, testes proporcionais e evidência de resultado.

## 8. Mudanças de alto risco

Exigem autorização humana explícita e escopo delimitado quando envolverem:

- produção;
- credenciais/secrets;
- autenticação;
- pagamentos;
- migrations destrutivas;
- RLS/grants;
- dados pessoais ou sensíveis;
- material editorial protegido;
- revogação de chaves;
- cutover de infraestrutura;
- merge quando houver instrução explícita de não integrar;
- alteração de invariantes pedagógicas ou jurídicas relevantes.

## 9. Branches e PRs

Preferir mudanças rastreáveis.

Regras gerais:

- não editar `main` diretamente quando a mudança material puder ser revisada em branch;
- manter PR pequeno e coerente com uma pergunta principal;
- não misturar correção não relacionada;
- registrar o que foi validado e o que não foi validado;
- não fazer merge apenas porque CI está verde: respeitar gates humanos e documentais aplicáveis.

## 10. Código e arquitetura

Priorizar:

- baixo acoplamento;
- alta coesão;
- componentização;
- contratos explícitos;
- nomes claros;
- mudanças incrementais;
- compatibilidade com dados existentes;
- testes focados no risco real.

Não criar uma nova camada, provider, agente ou framework sem necessidade demonstrável.

## 11. IA e prompts

Regras críticas de negócio, segurança ou integridade não devem existir apenas em prompts se puderem ser expressas e testadas em código/contratos.

Prompts podem governar linguagem, estratégia cognitiva e formato, mas não devem ser o único mecanismo para invariantes críticas.

## 12. Contexto e custo

O agente deve carregar somente o contexto necessário à tarefa.

Evitar:

- enviar o livro inteiro quando uma parte delimitada resolve;
- ler toda a documentação quando um conjunto específico basta;
- usar modelos caros para tarefas mecânicas;
- repetir inspeções remotas sem mudança de estado;
- disparar CI repetidamente sem ganho de evidência.

Economia de tokens não justifica remover contexto essencial.

## 13. Dados e secrets

Nunca registrar em documentação ou chat:

- secret values;
- tokens;
- senhas;
- chaves privadas;
- dados pessoais desnecessários;
- laudos ou informações sensíveis de estudantes sem necessidade e autorização.

Usar nomes de variáveis, referências opacas e dados sintéticos quando possível.

## 14. Pedagogia

Nenhuma otimização técnica deve piorar a qualidade pedagógica.

Antes de alterar fluxos de planejamento, avaliação ou inclusão, verificar se a mudança preserva:

- coerência curricular;
- continuidade entre documentos;
- papel de revisão do professor;
- acessibilidade;
- privacidade;
- rastreabilidade;
- uso responsável de IA.

## 15. Conhecimento editorial e Knowledge Factory

Aplicar as regras específicas da Knowledge Factory.

Em especial:

- estrutura antes de chunks;
- seletividade antes de carga semântica ampla;
- evidência antes de confirmação;
- PDF protegido fora do Git;
- nenhuma expansão para OCR/embeddings/RAG sem gate próprio.

## 16. Critério de parada

O agente deve parar e pedir/aguardar autorização quando o próximo passo ultrapassar um limite explicitamente governado.

Não parar para confirmações banais quando a ação já estiver claramente autorizada e for reversível/baixo risco.

## 17. Saída esperada de um agente

Ao concluir uma frente material, registrar de forma compacta:

- estado inicial;
- mudança realizada;
- evidência produzida;
- riscos ou limitações remanescentes;
- próximo gate real;
- ações explicitamente não executadas.
