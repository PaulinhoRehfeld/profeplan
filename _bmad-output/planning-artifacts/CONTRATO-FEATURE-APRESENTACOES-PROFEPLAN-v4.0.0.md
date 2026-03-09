---
feature: "Apresentações & Slides"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-09"
status: "draft"
---

# Contrato de Comportamento – Apresentações & Slides (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Permitir que o professor gere **roteiros de apresentação** de aula:

- Estruturados em slides (capa, conteúdo, interação, conclusão).
- Reutilizáveis em diferentes ferramentas:
  - **Canva** (via CSV),
  - **PowerPoint/PPTX**,
  - **Prezi** (novo fluxo).
- Conectados ao contexto de ensino (tema, aulas recentes, planejamento).

---

## 2. Entidades e Serviços Envolvidos

- **Serviços de IA**
  - `AiPresentationService.generatePresentationJSON(topic, context, slideCount, style, includeInteractions)`:
    - Usa Azure OpenAI via `getGenAIClient`.
    - Retorna JSON:
      - `title`, `theme`, `slides[]` com:
        - `order`, `type`, `title`,
        - `contentBulletPoints[]`,
        - `imageSuggestion`,
        - `speakerNotes`.

- **Componentes de UI**
  - `PresentationCreator.tsx`:
    - Formulário de criação (tema, nº de slides, estilo visual, interações).
    - Carrega `recentLessons` via `getTeacherContext(userId, 4)`.
    - Gera apresentação (`generatePresentationJSON`) e gerencia:
      - Preview,
      - Modo apresentação fullscreen,
      - Exportação para Canva (CSV),
      - Salvamento na memória/`generated_contents`.
  - `CanvaExportModal.tsx`:
    - Recebe CSV gerado por `PresentationCreator`.
  - `PresentationModal.tsx`:
    - Roteiro em Markdown para copiar/usar em ferramentas externas (ajustado neste contrato para ser base Prezi).

- **Persistência**
  - `saveLessonToMemory(userId, title, contentMarkdown, json, ...)` (Supabase).
  - `saveGeneratedContent(userId, type, folder, title, contentMarkdown)`:
    - Aqui, `type: 'apresentacao'`, `folder: 'APRESENTAÇÕES'`.

- **Exportação PPTX (avançado)**
  - `presentationGenerator.generateHighFidelityPPT(slideData, topic)`:
    - Usa `pptxgenjs` + imagens do `unsplashService`.
    - (Fluxo não acoplado ao criador principal, mas compatível).

---

## 3. Fluxos Principais

### 3.1 Geração do Roteiro de Slides (JSON)

**Entrada:**

- Tópico/assunto (`topic`), opcionalmente selecionado de `recentLessons`.
- Parâmetros:
  - `slideCount`, `style`, `includeInteractions`.

**Comportamento esperado:**

1. `PresentationCreator.handleGenerate`:
   - Valida que `topic` não está vazio.
   - Chama `generatePresentationJSON(topic, context='', slideCount, style, includeInteractions)`.
2. `AiPresentationService.generatePresentationJSON`:
   - Constrói instrução rica (designer instrucional) com:
     - Tema, contexto, nº de slides, estilo visual, interações.
   - Exige saída em JSON com:
     - `title`, `theme`, `slides[]` (ver estrutura acima).
   - Faz parsing do JSON e devolve objeto JS.
3. `PresentationCreator`:
   - Guarda o JSON em `generatedPresentation`.
   - Atualiza a sidebar com ações (Canva, Apresentar, Salvar, Regerar).

**Contrato forte:**

- A IA **não pode** devolver texto solto; a saída deve ser JSON válido parseável.
- `slides` deve respeitar aproximadamente `slideCount` (pode variar levemente, mas nunca ser ignorado).

---

### 3.2 Exportação para Canva (CSV)

**Entrada:**

- `generatedPresentation` preenchido.

**Comportamento esperado:**

1. `getCSVData()` em `PresentationCreator`:
   - Gera CSV com header:
     - `Titulo_Slide;Conteudo_Texto;Sugestao_Imagem;Nota_Orador`.
   - Cada slide gera uma linha:
     - `title`,
     - `contentBulletPoints` concatenados,
     - `imageSuggestion`,
     - `speakerNotes`.
   - Faz saneamento de `;` → `,` para evitar quebrar colunas.
2. `CanvaExportModal` recebe `data={getCSVData()}` e orienta o usuário a importar no Canva.

**Contrato:**

- O CSV deve ser sempre gerado a partir de `generatedPresentation`, nunca de texto solto.

---

### 3.3 Exportação para Prezi (Base Prezi – NOVO)

**Objetivo:**

- Oferecer um botão e uma base textual amigável para que o professor:
  - Cole o roteiro da apresentação no Prezi.
  - Caso ainda não tenha conta, receba um **convite** com o link de indicação configurado pelo PROFEPLAN.

**Comportamento esperado:**

1. Quando há `generatedPresentation`, a sidebar deve exibir um botão adicional:
   - Ex.: **"Base para Prezi"**.
2. Ao clicar:
   - Abre um `PresentationModal` (ou modal equivalente) contendo:
     - Um roteiro em Markdown derivado de `generatedPresentation`:
       - `# {title}`.
       - Para cada slide:
         - `## Slide {order} – {title}`.
         - Lista de `contentBulletPoints`.
         - Opcionalmente, bloco “Sugestão de imagem” e “Notas do apresentador”.
     - Uma seção de instruções curtas:
       - Como criar uma nova apresentação no Prezi e colar o conteúdo.
     - **Convite Prezi** com o link de indicação:
       - `https://prezi.com/signup/?referral_token=7RUZ6-emB3FN`
       - Mensagem clara do tipo:
         - “Se ainda não tiver conta no Prezi, cadastre-se usando este convite”.
3. O modal deve disponibilizar:
   - Botão para copiar o conteúdo (`Copiar Texto`).
   - Fechar.

**Contrato forte:**

- A base para Prezi **sempre** deve incluir o convite com o link indicado pelo owner do sistema.
- O conteúdo exibido deve ser derivado **diretamente** de `generatedPresentation` (JSON), não de versões intermediárias não rastreáveis.

---

### 3.4 Salvamento na Memória / Histórico

**Entrada:**

- `generatedPresentation` pronto, usuário clica em “Salvar na Memória”.

**Comportamento esperado:**

1. `PresentationCreator.handleSavePresentation`:
   - Monta `contentMarkdown` unindo slides em formato Markdown:
     - `## {title}\n{bulletPoints}\n...`.
   - Chama:
     - `saveLessonToMemory(userId, generatedPresentation.title, contentMarkdown, generatedPresentation, undefined)`.
     - `saveGeneratedContent(userId, 'apresentacao', 'APRESENTAÇÕES', generatedPresentation.title, contentMarkdown)`.
2. Exibe mensagem: “Apresentação salva com sucesso!” ou erro amigável.

**Contrato:**

- O JSON completo (`generatedPresentation`) deve ser preservado em `saveLessonToMemory` para reedição futura.

---

## 4. Integrações e Limites

- **Planejamento / Planos de Aula**
  - Hoje o contexto (`context`) ainda não está fortemente ligado a TermPlans/Planos de Aula.
  - Contrato prevê futura evolução:
    - Permitir, por exemplo, gerar apresentação a partir de uma aula/planejamento selecionado.

- **PPTX / Gamma / Outros**
  - `PresentationModal` e `presentationGenerator` podem oferecer fluxos adicionais:
    - PPTX de alta fidelidade,
    - Roteiro para ferramentas como Gamma.
  - Contrato atual apenas exige que o **fluxo Prezi** esteja disponível em paralelo ao Canva.

---

## 5. Erros, Estados e Mensagens

- **Sem tópico definido**
  - Bloquear geração com alerta: “Por favor, defina um tema ou selecione uma aula.”.

- **Erro da IA (Azure OpenAI)**
  - Mensagem: “Erro ao gerar slides: {mensagem}”.
  - Não deve quebrar a tela ou travar o formulário.

- **Erro ao salvar**
  - Mensagens claras:
    - “Erro ao salvar apresentação.” com log em console.

- **Fluxo Prezi**
  - Mesmo em caso de falha de qualquer outra integração (Canva, PPTX), o botão/Base Prezi deve continuar utilizável enquanto houver `generatedPresentation`.

---

## 6. Checklist de Validação (para agentes/QA)

1. **JSON da apresentação**
   - [ ] `generatePresentationJSON` retorna JSON válido com `title`, `theme`, `slides[]`.
   - [ ] `slides[].contentBulletPoints` e `slides[].speakerNotes` fazem sentido pedagógico.

2. **Exportação Canva**
   - [ ] O CSV gerado corresponde fielmente às informações do JSON.

3. **Exportação Prezi**
   - [ ] O botão/Base Prezi aparece sempre que há `generatedPresentation`.
   - [ ] O conteúdo mostrado no modal é derivado diretamente de `generatedPresentation`.
   - [ ] O convite com o link `https://prezi.com/signup/?referral_token=7RUZ6-emB3FN` está visível e claro.

4. **Salvamento**
   - [ ] `saveLessonToMemory` recebe o JSON completo.
   - [ ] `saveGeneratedContent` salva o Markdown legível.

