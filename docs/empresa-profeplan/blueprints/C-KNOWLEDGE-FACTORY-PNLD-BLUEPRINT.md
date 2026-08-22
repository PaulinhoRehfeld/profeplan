# C — KNOWLEDGE FACTORY PNLD — Blueprint

**Status:** desenvolvimento ativo

## 1. Missão do domínio

Construir a fábrica especializada em ingestão, cartografia, reconstrução estrutural e evidência sobre livros e materiais PNLD autorizados, preservando limites editoriais, paginação física/impressa, proveniência e revisão humana.

## 2. Princípio arquitetônico

> O livro é contêiner; a parte editorial é a unidade de reconstrução. Chunks não determinam a estrutura. A estrutura determina os chunks.

## 3. Pipeline conceitual

```text
obra/arquivo autorizado
→ cartografia preliminar
→ delimitação de parte
→ reconstrução local
→ relações entre elementos/partes
→ evidências
→ grafo/representação estruturada
→ consumo posterior pelo produto
```

## 4. Estado atual

A documentação especializada permanece em `docs/profeplan-knowledge-factory/` e NÃO será movida durante o desenvolvimento ativo. O marco mais recente consolidado na `main` corresponde ao piloto real governado integrado pelo PR #125.

## 5. Relações com outros projetos

### Consome de
- fontes PNLD autorizadas;
- A: limites jurídicos, institucionais e orçamentários;
- futuramente D quando relações curriculares forem necessárias.

### Fornece para
- B: conteúdo editorial estruturado e localizável;
- I: contexto para avaliações;
- J: contexto para apresentações;
- outros fluxos pedagógicos autorizados.

### Interfaces
- contratos estruturais;
- evidências;
- mapas de páginas/partes;
- schemas;
- datasets derivados permitidos.

### Documentos relacionados
- `../../profeplan-knowledge-factory/README.md`;
- `../../profeplan-knowledge-factory/BLUEPRINT.md`;
- checkpoints, ADRs e contratos sob `../../profeplan-knowledge-factory/`.

## 6. Gate de maturidade PNLD v1

Antes de qualquer migração física do domínio:
- concluir o próximo marco estrutural estável;
- reconciliar Blueprint especializado;
- validar contratos vigentes;
- registrar evidência final do marco;
- consolidar checkpoint de saída;
- explicitar próxima fase e escopo negativo.

## 7. Regra de segurança e direito autoral

Conteúdo protegido não deve ser reproduzido ou redistribuído como corpus aberto. Persistência e exposição devem respeitar finalidade, autorização, proveniência e minimização necessárias ao produto.