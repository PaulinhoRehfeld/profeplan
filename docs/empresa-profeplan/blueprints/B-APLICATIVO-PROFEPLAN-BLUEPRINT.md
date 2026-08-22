# B — APLICATIVO PROFEPLAN — Blueprint

**Status:** operacional / evolução

## 1. Missão do domínio

Ser a principal plataforma usada pelo professor e a camada de entrega das capacidades produzidas pelas fábricas especializadas do ecossistema ProfePlan.

## 2. Papel arquitetônico

O Aplicativo não deve concentrar toda a lógica de conhecimento. Ele orquestra experiência, contexto, fluxos pedagógicos, persistência e consumo de serviços especializados.

## 3. Capacidades

- planejamento anual, periódico, semanal e plano de aula;
- avaliações e banco de questões;
- inclusão/PDI;
- relatórios;
- assistente pedagógico;
- apresentações e demais módulos disponibilizados ao professor;
- integração progressiva das fábricas C, D, G, H, I e J.

## 4. Estado atual

O produto está rodando de forma satisfatória e deve ser tratado como operacional, ainda sujeito a melhorias. A existência de rotas ou protótipos não equivale automaticamente a funcionalidade comercial pronta.

## 5. Relações com outros projetos

### Consome de
- C: conteúdo editorial PNLD estruturado;
- D: currículo oficial estruturado;
- G: adaptações, PDI e DUA;
- H: referências ENEM/SAEB;
- I: mecanismos de avaliação;
- J: geração de apresentações;
- E: UX, onboarding e acesso;
- A: regras institucionais e prioridades.

### Fornece para
- F: evidências reais de produto e feedback de uso;
- A: métricas e sinais operacionais;
- professor final: entregas pedagógicas.

### Interfaces
- APIs;
- contratos de dados;
- schemas;
- autenticação;
- módulos de UI;
- eventos de uso.

### Documentos relacionados
- documentação atual do aplicativo em `docs/`;
- auditorias de frontend;
- `../governance/DOCUMENT-MAP.md`.

## 6. Gate de reconciliação documental

Antes de mover documentação para `projects/B-aplicativo-profeplan/`:
- mapear rotas e módulos realmente ativos;
- validar arquitetura vigente no código;
- registrar débitos técnicos relevantes;
- separar documentação histórica de estado atual;
- consolidar roadmap de evolução.