# Modo de execução consciente de custo e contexto

**Status:** política operacional da ProfePlan Knowledge Factory.

**Data:** 19 de agosto de 2026.

## Objetivo

Reduzir consumo desnecessário de contexto, créditos e sessões agênticas sem reduzir rigor arquitetônico, rastreabilidade, qualidade de testes ou segurança operacional.

A regra principal é separar **raciocínio e orquestração** de **execução mecânica**. Modelos/agentes avançados não devem ser usados como terminal permanente nem para redescobrir decisões já documentadas.

## Princípio operacional

> Pensar uma vez, executar de forma determinística sempre que possível e escalar para autonomia agêntica apenas quando ela trouxer ganho material.

A arquitetura do produto não muda por causa desta política. O que muda é o modo de desenvolver, testar e operar os trabalhos da Knowledge Factory.

## Papéis dos ambientes

### 1. Conversa principal — orquestração

A conversa principal é a fonte de decisão para:

- arquitetura e desenho da solução;
- leitura e reconciliação da documentação canônica;
- definição de escopo, gates e critérios de sucesso;
- análise de resultados e falhas;
- preparação de código, patches, testes e comandos;
- inspeção remota do GitHub quando disponível;
- decisão sobre escalonamento para agente avançado.

Ela deve evitar reenviar ao executor histórico que já esteja consolidado em documentos canônicos.

### 2. Execução local — terminal/VS Code

O terminal local é o executor preferencial para operações determinísticas, incluindo:

- Git;
- execução de scripts;
- testes;
- inspeção de arquivos locais e artefatos privados;
- criação de diretórios e preparação de inputs;
- aplicação de patches previamente definidos;
- coleta de evidências de execução.

O terminal não precisa receber o histórico completo da Knowledge Factory. Deve receber apenas o necessário para a tarefa corrente.

### 3. Conversa de execução local — contexto mínimo

Quando útil, pode existir uma conversa separada dedicada exclusivamente à execução local.

Ela recebe um **Execution Pack** curto e autocontido, não o contexto integral do projeto.

Formato mínimo recomendado:

```text
TAREFA
Objetivo
Branch
Diretório de trabalho
Arquivos envolvidos
Alterações permitidas
Alterações proibidas
Comandos
Critério de sucesso
Evidência a devolver
```

Essa conversa não redefine arquitetura, não amplia escopo e não substitui a conversa principal como orquestradora.

### 4. Work/Codex ou agente avançado — exceção justificada

A autonomia agêntica deve ser usada quando a tarefa exigir ganho real de exploração ou iteração, por exemplo:

- diagnóstico cuja causa ainda não esteja delimitada;
- alteração transversal em muitos arquivos interdependentes;
- refatoração estrutural;
- navegação autônoma por uma superfície ampla do repositório;
- ciclos repetidos de ler → modificar → testar → corrigir;
- ambiguidade técnica relevante que não possa ser resolvida economicamente na camada de orquestração.

Não é uso padrão para operações mecânicas, documentação rotineira, Git básico, execução de testes conhecidos ou aplicação de mudanças já especificadas.

## Regra de contexto mínimo

Toda execução deve receber o menor contexto que ainda permita realizar a tarefa corretamente.

Preferir:

- arquivos explicitamente necessários;
- trechos relevantes em vez do repositório inteiro;
- contratos e critérios de sucesso já fechados;
- comandos determinísticos;
- referências a documentos canônicos em vez da reprodução de seu conteúdo completo.

Evitar:

- reler o repositório inteiro a cada tarefa;
- reexplicar decisões arquitetônicas já registradas;
- manter sessões agênticas longas apenas para executar comandos simples;
- enviar fixtures, PDFs ou artefatos fora da janela necessária;
- ativar integrações e ferramentas não necessárias à tarefa.

## Escalonamento de custo

A escolha de capacidade/modelo deve seguir a complexidade material da tarefa:

1. **execução determinística sem agente**, quando possível;
2. **modelo/agente mais leve adequado**, para tarefas simples;
3. **modelo intermediário**, para implementação e debugging normal;
4. **modelo avançado**, apenas quando ambiguidade, profundidade ou autonomia justificarem o custo.

A escolha do modelo nunca deve reduzir os gates de segurança, jurídico, proveniência ou qualidade.

## Execução determinística preferencial

Quando a decisão já estiver fechada, preferir artefatos reproduzíveis:

- patches;
- scripts locais;
- comandos Git explícitos;
- testes direcionados;
- verificações de diff;
- geração controlada de arquivos.

Uma execução determinística deve declarar previamente o que pode mudar e como o sucesso será verificado.

## Evidência e retorno

Cada Execution Pack deve retornar somente a evidência necessária para a próxima decisão, por exemplo:

- `git status`;
- diff relevante;
- saída de teste;
- hash/checksum;
- erro completo da operação que falhou;
- caminho do artefato criado.

Não devolver logs extensos ou dumps integrais quando um trecho suficiente resolver a próxima decisão.

## Relação com a governança proporcional ao risco

Esta política complementa `RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md`.

- **Risco** determina o nível de autorização.
- **Custo/contexto** determina o modo mais econômico de executar dentro da autorização existente.

Uma ação ser Nível A não significa que deva ser entregue a um agente avançado. Da mesma forma, economia de créditos nunca autoriza reduzir uma ação de Nível B ou C para Nível A.

## Aplicação imediata ao piloto real

Para o piloto real da Fase C:

- decisões de cartografia, parte, janela e critérios ficam na conversa orquestradora;
- o PDF permanece no ambiente local privado autorizado e fora do Git;
- comandos de inspeção e execução são preparados como Execution Packs mínimos;
- o terminal local executa operações determinísticas;
- apenas resultados/evidências necessários retornam para análise;
- agente avançado é acionado somente se surgir problema que realmente exija exploração autônoma.

## Regra de continuidade

Ao iniciar uma nova conversa ou sessão, não reconstruir o projeto por memória informal. Recuperar primeiro:

1. documento canônico da fase/lote;
2. checkpoint ou roadmap corrente;
3. branch/PR atual, quando houver;
4. último Execution Pack e sua evidência, se a ação estiver em andamento.

Esse conjunto deve ser suficiente para retomar o trabalho sem carregar histórico conversacional desnecessário.
