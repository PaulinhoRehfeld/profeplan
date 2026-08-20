# C.4 mínimo — confirmação estrutural de parte

**Data:** 20 de agosto de 2026
**Status:** implementação candidata no Draft PR técnico C.4

## 1. Pergunta respondida

Qual é a menor superfície executável capaz de transformar uma reconstrução candidata de uma parte delimitada em decisão estrutural revisável, sem reescrever o candidato e sem antecipar conhecimento pedagógico canônico?

## 2. Decisão

C.4 mínimo introduz uma camada separada de decisão:

```text
StructuralRecognitionSnapshot@1.0.0
        ↓ candidato
PartReconstructionCandidateSnapshot@1.0.0
        ↓ revisão C.4
PartStructureConfirmationSnapshot@1.0.0
```

Os snapshots anteriores permanecem imutáveis.

## 3. Estados de decisão

Cada elemento ou relação candidato pode receber uma decisão:

- `confirmed` — candidato aceito com a evidência existente;
- `corrected` — candidato exige correção explícita, preservando o original;
- `rejected` — candidato explicitamente rejeitado.

## 4. Evidência

Uma decisão C.4 deve referenciar evidência já pertencente ao candidato que está sendo decidido.

C.4 não cria evidência nova por inferência e não aceita evidência pertencente a outro alvo candidato.

## 5. Correções

### Elementos

Podem corrigir, quando necessário:
- tipo estrutural;
- texto observado/representação revisada;
- relação de parent element.

### Relações

Podem corrigir:
- tipo da relação;
- elemento de origem;
- elemento de destino.

Correções só são válidas no estado `corrected`. O estado `corrected` sem alteração material é inválido.

## 6. Revisão parcial

C.4 não promove silenciosamente candidatos sem decisão.

Quando nem todos os elementos e relações receberam decisão:
- o snapshot pode existir para continuidade de revisão;
- `reviewComplete = false`;
- warnings identificam candidatos ainda não revisados.

Somente revisão completa pode ser tratada como mapa estrutural integralmente decidido da parte.

## 7. Validações mínimas

O serviço deve rejeitar:
- alvo candidato inexistente;
- mais de uma decisão para o mesmo alvo;
- decisão sem evidência;
- evidência que não pertence ao alvo;
- `corrected` sem correção;
- correção em estado `confirmed` ou `rejected`;
- parent/endpoint corrigido que não exista entre os elementos candidatos.

## 8. Fronteira

C.4 mínimo NÃO:
- relê o PDF;
- amplia `CartographicPartScope`;
- processa a obra inteira;
- cria OCR;
- cria chunks/corpus;
- cria embeddings/retrieval/RAG;
- produz grafo global;
- promove componentes pedagógicos;
- persiste em banco/Storage;
- altera produção.

## 9. Provas

A primeira prova automatizada é sintética e deve demonstrar:
1. confirmação completa;
2. preservação imutável do candidato;
3. correção explícita;
4. rejeição explícita;
5. rejeição de evidência cruzada;
6. rejeição de correção vazia;
7. revisão parcial explícita;
8. rejeição de decisões duplicadas.

Após CI verde, a prova material seguinte reutiliza a mesma parte real governada do piloto, sem incluir o PDF no Git ou no CI remoto.

## 10. Gate para C.5

C.5 permanece bloqueado até que a passagem candidato → decisão estrutural seja comprovada na parte real e revisada humanamente.
