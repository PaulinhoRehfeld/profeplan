# D — CURRICULUM FACTORY — BNCC & CURRÍCULOS ESTADUAIS — Blueprint

**Status:** implantação prioritária

## 1. Missão do domínio

Estruturar de forma rastreável a BNCC e os documentos curriculares oficiais dos 26 estados e do Distrito Federal para consumo pelo ecossistema ProfePlan.

## 2. Escopo

- BNCC;
- currículos estaduais;
- competências;
- habilidades;
- objetos de conhecimento;
- unidades temáticas/eixos quando aplicáveis;
- etapas, anos/séries e componentes;
- progressões e relações entre documentos;
- versionamento e proveniência.

## 3. Princípios

1. Não inventar códigos, habilidades ou relações curriculares.
2. Toda unidade estruturada deve manter proveniência para fonte oficial.
3. Mudanças de versão devem ser rastreáveis.
4. O modelo precisa acomodar diferenças reais entre redes, não forçar todos os estados a um único formato editorial.
5. A fábrica deve produzir dados reutilizáveis, não apenas PDFs convertidos em texto.

## 4. Relações com outros projetos

### Consome de
- documentos oficiais da União, estados e DF;
- A: prioridades e governança;
- B: necessidades reais de produto.

### Fornece para
- B: contexto curricular;
- G: base curricular para PDI/DUA;
- H: relações com matrizes de avaliação;
- I: alinhamento de avaliações;
- J: alinhamento de apresentações;
- planejamentos e demais módulos pedagógicos.

### Interfaces
- datasets versionados;
- schemas curriculares;
- IDs canônicos;
- provenance metadata;
- APIs/consultas futuras.

### Documentos relacionados
- `../MASTER-BLUEPRINT.md`;
- futura pasta `projects/D-curriculum-factory/`.

## 5. Primeira prova recomendada

Começar com uma fonte federal (BNCC) e um currículo estadual, definindo primeiro o modelo de proveniência e normalização. Validar depois com um segundo estado estruturalmente diferente antes de escalar para 27 jurisdições.

## 6. Gate de escala

Não iniciar ingestão nacional em massa antes de:
- contrato de fonte/proveniência;
- modelo de dados curricular;
- política de versionamento;
- primeiro estado validado;
- segundo estado usado como prova de generalização;
- estratégia de atualização futura.