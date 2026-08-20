# Knowledge Factory PNLD — C.4 Read-only Finding

**Data:** 20 de agosto de 2026
**Natureza:** registro transversal; não substitui documentação especializada C

## Achado

A inspeção do estado atual após o Checkpoint 054 confirmou que:

- `StructuralRecognitionSnapshot@1.0.0` produz cartografia candidata;
- `PartReconstructionCandidateSnapshot@1.0.0` produz elementos e relações candidatas apoiadas por evidência;
- os serviços atuais preservam seletividade e escopo de parte;
- não existe no código um contrato separado de decisão estrutural `confirmed/corrected/rejected`;
- a busca por esses estados localiza apenas a documentação C.4, não implementação existente.

## Gap mínimo

Criar uma camada de decisão separada que:

1. preserve snapshots candidatos sem mutação;
2. referencie elementos/relações candidatos por ID;
3. exija evidência já pertencente ao candidato;
4. permita `confirmed`, `corrected` ou `rejected`;
5. produza snapshot revisável próprio;
6. não promova conhecimento pedagógico canônico;
7. não introduza novo parser, OCR, banco, embeddings ou RAG.

## Consequência

O primeiro incremento C.4 pode ser implementado como contrato + serviço puro + testes sintéticos, mantendo a prova real como gate posterior sobre a mesma parte governada do piloto.