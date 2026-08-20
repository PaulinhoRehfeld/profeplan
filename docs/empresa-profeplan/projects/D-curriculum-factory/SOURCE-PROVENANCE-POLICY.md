# Curriculum Factory — Source & Provenance Policy

## 1. Princípio

Nenhum dado curricular canônico pode existir sem vínculo rastreável com uma fonte oficial identificada.

## 2. Para cada fonte registrar

- órgão emissor;
- título oficial;
- jurisdição;
- etapa/componentes abrangidos;
- versão/edição quando disponível;
- data de publicação e vigência quando disponíveis;
- URL ou origem oficial;
- data de obtenção;
- hash do arquivo quando houver ingestão local;
- status de validade;
- documento substituído/sucessor quando conhecido.

## 3. Proveniência de unidades curriculares

Competências, habilidades, objetos de conhecimento, eixos, unidades temáticas e demais unidades estruturadas devem manter localizador capaz de retornar à fonte: página, seção, código oficial ou combinação equivalente.

## 4. Normalização

A normalização pode harmonizar nomes de campos e relações técnicas, mas não pode:

- inventar códigos;
- fundir unidades distintas sem decisão explícita;
- transformar inferência em texto oficial;
- ocultar diferenças entre estados;
- tratar documento revogado como vigente.

## 5. Versionamento

Mudanças oficiais devem gerar nova versão identificável. Histórico não deve ser sobrescrito silenciosamente.

## 6. Estados mínimos da fonte

- `identified` — fonte localizada, ainda não validada;
- `validated` — origem e versão confirmadas;
- `active` — aceita como fonte vigente para estruturação;
- `superseded` — substituída por fonte posterior;
- `archived` — preservada apenas para histórico.

## 7. Escala

Antes de processar 26 estados + DF, validar o modelo em:

1. BNCC como referência federal;
2. um currículo estadual piloto;
3. um segundo currículo estadual estruturalmente diferente.

Somente depois decidir automação em massa.
