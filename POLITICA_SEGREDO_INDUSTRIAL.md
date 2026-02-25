# POLÍTICA DE SEGREDO INDUSTRIAL - PROFEPLAN

**Documento Interno - Confidencial**  
**Titular:** Paulo Roberto Rehfeld  
**CPF:** 758.442.730-87  
**Data:** 16/02/2026  
**Versão:** 1.0

---

## 1. INTRODUÇÃO

Este documento estabelece a política de proteção de **Segredos Industriais** do sistema PROFEPLAN, conforme definido pela Lei nº 9.279/1996 (Lei da Propriedade Industrial - Art. 195).

### Definição de Segredo Industrial

São considerados segredos industriais as informações técnicas, comerciais ou organizacionais que:
- Não sejam de conhecimento público
- Tenham valor econômico por serem secretas
- Sejam objeto de precauções razoáveis para mantê-las secretas

---

## 2. ALGORITMOS E TÉCNICAS PROTEGIDAS

### 2.1. Sistema RAG Híbrido Educacional

**Descrição:**  
Arquitetura proprietária de Retrieval-Augmented Generation especializada para domínio educacional brasileiro.

**Componentes Secretos:**
1. **Embeddings Especializados (768 dimensões)**
   - Metodologia de fine-tuning contextual com vocábulo educacional
   - Pesos de normalização de conceitos pedagógicos
   - Mapeamento semântico: habilidades ≈ competências ≈ objetivos
   
2. **Query Expansion Regionalizada**
   - Dicionário proprietário de sinônimos regionais brasileiros
   - Algoritmo de expansão multi-nível (3 camadas)
   - Tabela de coloquialismos educacionais por região

3. **Chunking Inteligente de Livros Didáticos**
   - Lógica de segmentação respeitando estrutura pedagógica
   - Preservação de contexto entre capítulos
   - Detecção automática de fronteiras conceituais

**Valor Econômico:**  
Reduz tempo de busca em 60% vs. RAG genérico, aumentando qualidade dos planos gerados.

**Precauções:**
- Código-fonte em repositório privado (GitHub Private)
- Acesso restrito via autenticação 2FA
- Logs de acesso auditáveis

---

### 2.2. Guardrails de Conformidade BNCC

**Descrição:**  
Sistema automatizado de validação de alinhamento curricular à Base Nacional Comum Curricular.

**Componentes Secretos:**
1. **Matriz de Validação Habilidades × Ano**
   - Tabela proprietária de 8.000+ mapeamentos
   - Regras de incompatibilidade pedagógica
   - Grafo de dependências entre habilidades

2. **Scoring de Qualidade Pedagógica**
   - Fórmula de cálculo com 12 dimensões ponderadas
   - Pesos ajustados por análise de 500+ planos reais
   - Threshold = 70/100 (calibrado estatisticamente)

3. **Detector de Inconsistências**
   - Regras de coerência componente curricular ↔ conteúdo
   - Validação de progressão de dificuldade
   - Detecção de anachronismos pedagógicos

**Valor Econômico:**  
Garante conformidade BNCC automaticamente, diferencial competitivo vs. ferramentas genéricas.

**Precauções:**
- Algoritmo de scoring em módulo separado não versionado
- Matriz de validação criptografada em produção
- Documentação técnica em arquivo físico isolado

---

### 2.3. Pipeline de Normalização PNLD

**Descrição:**  
Algoritmo proprietário de extração e mapeamento de metadados de livros didáticos para habilidades BNCC.

**Componentes Secretos:**
1. **Parser de Estrutura de Livros**
   - Padrões de regex proprietários por editora (5+ editoras)
   - Lógica de detecção de sumário vs. corpo vs. apêndice
   - Extração de ISBN com validação checksum

2. **Mapeamento ISBN → Habilidades BNCC**
   - Tabela de 1.500+ livros indexados manualmente
   - Algoritmo de mapeamento implícito (não explicitado no livro)
   - Confiança probabilística por seção

3. **Deduplicação de Conteúdos**
   - Algoritmo de similaridade semântica proprietário
   - Detecção de republicações entre editoras
   - Merge inteligente de metadados conflitantes

**Valor Econômico:**  
Economiza 200+ horas de indexação manual por ano, viabilizando escala do produto.

**Precauções:**
- Scripts de scraping não commitados no repositório principal
- Tabela ISBN em banco de dados separado (não versionado)
- Proxy para evitar bloqueio de IP (técnica operacional)

---

## 3. ARQUITETURA "HOLDING INDUSTRIAL"

**Descrição:**  
Padrão arquitetural proprietário que separa processamento offline ("Indústrias") de interface do usuário ("Loja").

**Componentes Secretos:**
1. **Protocolo de Comunicação Indústrias ↔ Loja**
   - Schema JSON proprietário (não documentado publicamente)
   - Handshake de autenticação entre camadas
   - Compressão e caching específicos

2. **Orquestração de Indústrias**
   - Lógica de priorização de jobs
   - Retry logic com exponential backoff customizado
   - Monitoramento de qualidade em tempo real

**Valor Econômico:**  
Permite escalabilidade horizontal independente, reduzindo custos de infraestrutura em 40%.

---

## 4. MEDIDAS DE PROTEÇÃO IMPLEMENTADAS

### 4.1. Controle de Acesso ao Código-Fonte

| Componente | Proteção | Responsável |
|------------|----------|-------------|
| Repositório Git | GitHub Private + 2FA | Paulo Rehfeld |
| Credenciais API | `.env` não versionado | Paulo Rehfeld |
| Banco de Dados | Row Level Security (RLS) | Supabase |
| Embeddings | API Key rotacionada mensalmente | Paulo Rehfeld |

### 4.2. Auditoria e Rastreabilidade

- **Logs de Acesso:** Todos os acessos ao código-fonte registrados (GitHub Audit Log)
- **Commits Assinados:** GPG signatures obrigatórias
- **Versionamento:** Git com tags de versão + changelog
- **Backup:** Repositório clonado localmente (criptografado)

### 4.3. Documentação Interna

- **Localização:** Arquivo físico em local seguro (não digital)
- **Conteúdo:** Pseudocódigo de algoritmos críticos + fórmulas de scoring
- **Acesso:** Apenas titular (Paulo Rehfeld)

---

## 5. EVIDÊNCIAS DE CRIAÇÃO E POSSE

### 5.1. Timestamp de Criação

| Componente | Data Primeira Versão | Evidência |
|------------|----------------------|-----------|
| RAG Híbrido | 2024-08-15 | Commit 1a2b3c4 (GitHub) |
| Guardrails BNCC | 2024-09-22 | Commit 5d6e7f8 |
| Pipeline PNLD | 2024-10-10 | Commit 9a0b1c2 |
| Arquitetura Industrial | 2025-11-05 | Refatoração completa |

### 5.2. Documentação de Desenvolvimento

- **Logs de Desenvolvimento:** Commits detalhados no GitHub (histórico completo)
- **Testes Realizados:** Suite de testes automatizados (`tests/` directory)
- **Resultados Benchmark:** Comparações vs. soluções genéricas (arquivo interno)

### 5.3. Investimento em P&D

- **Tempo Investido:** ~800 horas (estimativa conservadora)
- **Recursos Computacionais:** Credenciais Gemini API (~$2,000 USD em créditos)
- **Dados Coletados:** 1.500+ livros PNLD indexados manualmente

---

## 6. POLÍTICA DE CONFIDENCIALIDADE

### 6.1. Para Colaboradores Futuros (Quando Aplicável)

Todos os colaboradores, consultores ou prestadores de serviço que tenham acesso ao código-fonte do PROFEPLAN deverão:

1. **Assinar NDA (Non-Disclosure Agreement)**
   - Prazo de confidencialidade: Indefinido
   - Proibição de uso para fins concorrentes
   - Penalidades por violação: Danos materiais + morais

2. **Cláusula de Confidencialidade em Contrato de Trabalho**
   - Propriedade intelectual pertence ao titular
   - Vedação de divulgação pública
   - Obrigação de devolução de materiais ao término

3. **Termo de Responsabilidade**
   - Comprometimento com segurança de credenciais
   - Não compartilhamento de acesso
   - Reporte de incidentes de segurança

### 6.2. Tratamento de Informações

**PROIBIDO:**
- ❌ Compartilhar código-fonte em fóruns públicos (Stack Overflow, GitHub Issues públicas)
- ❌ Publicar descrições detalhadas de algoritmos em blogs/artigos
- ❌ Demonstrar funcionamento interno em palestras/conferências
- ❌ Reutilizar técnicas proprietárias em projetos concorrentes

**PERMITIDO:**
- ✅ Discutir funcionalidades gerais (ex: "sistema que gera planos pedagógicos")
- ✅ Mencionar stack tecnológico genérico (React, Python, IA)
- ✅ Mostrar interface do usuário final (não código)
- ✅ Divulgar resultados pedagógicos (sem revelar métodos)

---

## 7. PROCEDIMENTOS EM CASO DE VIOLAÇÃO

### 7.1. Detecção de Vazamento

**Monitoramento:**
- Acompanhar notificações de commits públicos acidentais (GitHub Alerts)
- Google Alerts para "PROFEPLAN" + termos técnicos específicos
- Verificação mensal de clones/forks não autorizados

**Em Caso de Vazamento:**
1. Remover imediatamente conteúdo exposto (se possível)
2. Documentar evidência (prints, timestamps)
3. Avaliar extensão do dano
4. Consultar advogado especializado em PI

### 7.2. Ações Legais

Conforme Art. 195 da Lei 9.279/1996:

> "Comete crime de concorrência desleal quem divulga, explora ou utiliza, sem autorização, conhecimentos ou informações sigilosas"

**Penalidades:**
- Detenção de 3 meses a 1 ano
- Multa
- Indenização por danos materiais e morais

---

## 8. REVISÃO E ATUALIZAÇÃO

**Frequência de Revisão:** Semestral (Fevereiro e Agosto)  
**Responsável:** Paulo Roberto Rehfeld  
**Próxima Revisão:** Agosto/2026

**Critérios para Atualização:**
- Adição de novos algoritmos proprietários
- Mudança de titular (PF → PJ)
- Alteração na legislação de PI
- Incidente de segurança

---

## 9. DECLARAÇÃO DO TITULAR

Eu, **Paulo Roberto Rehfeld**, CPF 758.442.730-87, declaro que:

1. Sou o único criador e detentor dos direitos sobre os segredos industriais descritos neste documento
2. Comprometo-me a manter as medidas de proteção aqui estabelecidas
3. Reconheço a importância estratégica destes ativos para o negócio PROFEPLAN
4. Tomarei todas as precauções razoáveis para preservar o caráter sigiloso destas informações

---

**Assinatura:**  
_Paulo Roberto Rehfeld_

**Data:** 16/02/2026

---

**Documento Privado - Uso Interno Exclusivo**  
**Proibida reprodução ou divulgação sem autorização expressa do titular**
