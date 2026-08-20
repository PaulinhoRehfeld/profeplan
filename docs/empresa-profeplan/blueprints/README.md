# Índice de Blueprints — EMPRESA PROFEPLAN

Esta pasta contém **somente os Blueprints dos domínios A–M**.

## Regra

Cada Blueprint deve conter, conforme maturidade disponível:

1. missão e fronteira do domínio;
2. estado atual;
3. capacidades principais;
4. relações com outros projetos;
5. interfaces relevantes;
6. documentos relacionados;
7. gate de maturidade ou reconciliação.

## Knowledge Bridge obrigatório

Cada Blueprint deve explicitar:

### Consome de
- domínios, fontes e datasets necessários.

### Fornece para
- domínios consumidores de seus resultados.

### Interfaces
- contratos;
- schemas;
- APIs;
- datasets;
- documentos.

### Documentos relacionados
- caminhos canônicos e evidências.

## Índice A–M

| ID | Blueprint | Estado do domínio |
|---|---|---|
| A | [EMPRESA PROFEPLAN & PUCTEC](A-EMPRESA-PROFEPLAN-PUCTEC-BLUEPRINT.md) | operacional / contínuo |
| B | [APLICATIVO PROFEPLAN](B-APLICATIVO-PROFEPLAN-BLUEPRINT.md) | operacional / evolução |
| C | [KNOWLEDGE FACTORY PNLD](C-KNOWLEDGE-FACTORY-PNLD-BLUEPRINT.md) | desenvolvimento ativo |
| D | [CURRICULUM FACTORY](D-CURRICULUM-FACTORY-BNCC-ESTADOS-BLUEPRINT.md) | implantação prioritária |
| E | [SITE / SAAS / UX](E-SITE-SAAS-UX-BLUEPRINT.md) | operacional / evolução |
| F | [MARKETING & VENDAS](F-MARKETING-VENDAS-BLUEPRINT.md) | implantação urgente |
| G | [PDI / DUA FACTORY](G-PDI-DUA-FACTORY-BLUEPRINT.md) | arquitetura a construir |
| H | [ENEM / SAEB](H-ENEM-SAEB-BLUEPRINT.md) | futuro próximo |
| I | [AVALIAÇÕES](I-AVALIACOES-BLUEPRINT.md) | existente / evolução |
| J | [APRESENTAÇÕES](J-APRESENTACOES-BLUEPRINT.md) | existente / evolução |
| K | [EVOLUTION / NEXUS / CRM](K-EVOLUTION-NEXUS-CRM-BLUEPRINT.md) | futuro |
| L | [NEB](L-NEB-BLUEPRINT.md) | futuro |
| M | [PROFEPLAN KIDS](M-PROFEPLAN-KIDS-BLUEPRINT.md) | incubation / discovery |

## Regra de profundidade

Blueprints de domínios imaturos permanecem deliberadamente enxutos. Eles devem registrar fronteira e dependências, não inventar arquitetura que ainda não foi validada.

## Relação com documentação especializada

O Blueprint é a porta de entrada do domínio, não um substituto dos documentos especializados. Por exemplo, o Blueprint C aponta para `docs/profeplan-knowledge-factory/`, que continua sendo a documentação técnica principal da Knowledge Factory PNLD durante seu desenvolvimento ativo.