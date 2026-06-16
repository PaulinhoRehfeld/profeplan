# 🏛️ PROFEPLAN — Comparativo Evolutivo de Repositórios (V4 vs V5)

> [!NOTE]
> Este documento foi elaborado para a reunião de alinhamento com a equipe e stakeholders. O objetivo é apresentar o estado atual da plataforma (**O que temos**) e a visão de futuro (**Onde pretendemos chegar**), de forma acessível tanto para desenvolvedores quanto para pessoas sem conhecimento técnico prévio sobre o aplicativo.

---

## 🎯 1. Visão Geral do Ecossistema

O **PROFEPLAN** é um ecossistema de software focado em atender o mercado educacional público (**B2G**), fornecendo geração assistida por Inteligência Artificial de planejamentos pedagógicos, planos de aula individuais e Planos de Desenvolvimento Individual (PDI) para educação inclusiva.

Atualmente, o projeto está estruturado em repositórios distintos para separar a governança do design/especificações da implementação de código propriamente dita:

1. **`blueprint_v4`**: O repositório conceitual e documental da versão 4.0. Ele funciona como o "esqueleto" ou "projeto de engenharia" do que foi planejado para a arquitetura, modelo de dados, interface e regras de negócio da V4.
2. **`profeplan_v5`**: O novo repositório criado para abrigar a evolução tecnológica e de produto para a versão 5.0, visando expansão nacional, consolidação da infraestrutura e melhorias de performance e segurança.
3. **Monorepo Local (`PROFEPLAN`)**: A implementação funcional e em produção da V4 (atualmente na versão `4.0.1`), que materializa em código as especificações descritas no blueprint da V4.

---

## 📊 2. Tabela Comparativa: `blueprint_v4` vs `profeplan_v5`

A tabela abaixo resume as diferenças fundamentais de propósito, arquitetura e objetivos de negócio entre a base da versão atual (V4) e a evolução planejada para a nova versão (V5):

| Dimensão / Aspecto | 📂 `blueprint_v4` (Estado Atual / Base V4) | 🚀 `profeplan_v5` (Futuro / Alvo V5) | Impacto para o Negócio / Equipe |
| :--- | :--- | :--- | :--- |
| **Natureza do Repositório** | Repositório exclusivo de **documentação** e especificações arquiteturais. Não contém código executável. | Repositório principal de **código-fonte** e novos componentes da versão 5.0. | Separação clara entre o histórico conceitual (V4) e o código evolutivo em produção (V5). |
| **Foco do Negócio & Escopo** | Validação do MVP e atendimento aos professores da rede pública de Minas Gerais (SEE/MG). | Expansão B2G nacional, permitindo adaptação rápida para secretarias e escolas de outros estados do Brasil. | Abertura de mercado e escalabilidade comercial para vendas governamentais em larga escala. |
| **Modelo de Arquitetura** | **Monorepo Industrial** separado em Loja (`apps/web` em React) e Indústrias offline (`packages/` em Python). | Evolução para **Microserviços e Orquestração Consolidada** com melhor comunicação entre serviços. | Redução de latência nas requisições do usuário e simplificação da manutenção do código. |
| **Arquitetura de IA** | Chamadas híbridas: Azure OpenAI para geração textual e Google Gemini para embeddings e RAG. | Sistema Multi-Agente otimizado com orquestração dinâmica e maior controle de custos na nuvem (Azure OpenAI). | Respostas mais rápidas da IA, maior precisão de conformidade com a BNCC e redução do custo por plano gerado. |
| **Educação Inclusiva (PDI)** | Geração manual de planos adaptados a partir da ficha de observações do aluno. | Módulo de PDI/DUA automatizado de ponta a ponta integrado diretamente ao fluxo de turmas. | Diferencial competitivo crucial no mercado de educação pública (cumprimento de cotas e exigências legais). |
| **Autenticação & Firewall** | Supabase Auth com OAuth 2.0 secundário (Google Classroom) para contornar firewalls de redes estaduais. | Segurança federada robusta, com autenticação reforçada e RLS (Row Level Security) avançado. | Garantia de que o app funciona de forma ininterrupta nas redes restritas de escolas estaduais. |
| **Desenvolvimento e CI/CD** | Fluxos de CI/CD básicos com publicação no Vercel e Supabase local. | Pipeline de CI/CD automatizado com testes automatizados de ponta a ponta (E2E) e deploy azul-verde (blue-green). | Lançamentos de novas features mais seguros, sem risco de derrubar o aplicativo dos professores em horário letivo. |

---

## 🔍 3. Onde Estamos Hoje (O que temos na V4)

A implementação atual da **Versão 4** da plataforma é baseada no modelo de **Holding Industrial de Software**:

* **As Indústrias (`packages/`)**: Processamento pesado de dados feito de forma offline (batch). Por exemplo, a leitura e estruturação de dados da BNCC e dos currículos de Minas Gerais (`industry-curriculum`), e a normalização de metadados de livros didáticos do PNLD (`industry-pnld`).
* **A Loja (`apps/web`)**: O aplicativo React/Vite no qual o professor interage. A interface é extremamente leve porque apenas exibe os dados que as Indústrias já processaram e salvaram no Supabase, garantindo fluidez mesmo em celulares antigos ou redes móveis lentas.
* **A Logística (Supabase)**: Nosso banco de dados centralizado que gerencia autenticação, controle de acesso e armazenamento dos planejamentos e dados de turmas.

> [!IMPORTANT]
> **Status da V4:** A arquitetura atual está 100% implementada e estável em ambiente de desenvolvimento (versão 4.0.1), fornecendo o alicerce sólido sobre o qual construiremos a V5.

---

## 🔮 4. Para Onde Vamos (O Alvo da V5)

A **Versão 5** visa transformar o PROFEPLAN de uma aplicação focada em Minas Gerais para um **Ecossistema Nacional B2G**:

1. **Multi-Redes de Ensino**: O sistema permitirá carregar matrizes curriculares de qualquer estado ou município de forma dinâmica, sem necessidade de refatorar o código da aplicação.
2. **Integração Fluida com RAG (Retrieval-Augmented Generation)**: Melhoria no AiCore para evitar alucinações da IA na BNCC, garantindo que os planejamentos gerados citem códigos oficiais corretos.
3. **Mapeamento de Inclusão Automatizado**: O sistema alertará proativamente o professor sobre alunos que necessitam de planos adaptados (PDI) e guiará a IA didática para sugerir dinâmicas inclusivas de acordo com a DUA (Desenho Universal para a Aprendizagem).
4. **Interface Mobile Otimizada**: Uso expandido do Capacitor para gerar aplicativos nativos (Android/iOS) extremamente polidos e com suporte a sincronização offline parcial.

---

## 📅 5. Próximos Passos Recomendados para a Equipe

1. **Alinhamento do Novo Integrante**: O novo membro da equipe deve ler o documento `docs/overview-profeplan.md` e a arquitetura geral em `docs/arquitetura-geral-profeplan.md` para entender o fluxo de dados.
2. **Planejamento de Migração de Código**: Definir o cronograma de clonagem e migração de componentes reutilizáveis do repositório de desenvolvimento atual para o repositório oficial da V5 (`profeplan_v5`).
3. **Configuração de Ambientes (V5)**: Setup do banco Supabase de staging da V5 com suporte a múltiplos esquemas para testes de isolamento de redes de ensino estaduais.
