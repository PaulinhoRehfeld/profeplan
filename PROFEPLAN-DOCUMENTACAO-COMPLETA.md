PROFEPLAN: Documento Técnico de Especificações e Regras de Negócio (Core)
1. Visão Geral do Produto
O PROFEPLAN é um ecossistema SaaS de Inteligência Artificial voltado para a educação básica. Seu objetivo é eliminar a sobrecarga burocrática dos professores através da geração automatizada de planos de aula, avaliações e adaptações curriculares (PDI), com alinhamento rigoroso à Base Nacional Comum Curricular (BNCC) e ao Programa Nacional do Livro e do Material Didático (PNLD).
•	Modelo de Negócio: B2B2C.
•	Bottom-Up (Gratuito): Foco no professor (Persona: Ana), entregando velocidade (planos em menos de 3 minutos) e redução de burnout.
•	Top-Down (Premium B2B): Foco em Escolas/Secretarias (Persona: Carlos), oferecendo gestão centralizada, padronização e RAG com material didático próprio (pool de créditos escolar).
2. Diferenciais Tecnológicos (Não Modificar)
•	Arquitetura Híbrida de IA: * Geração de Texto (Core): Utiliza Azure OpenAI (para planos, PDI, chat, avaliações) centralizado no AiCore.
o	Embeddings e Busca Vetorial (RAG): Utiliza Google Gemini (vetores de 768 dimensões) integrado nativamente ao banco de dados Supabase (vector(768)). Essa divisão é estrita para não quebrar o banco de dados.
•	Assistente FREEDAY: Agente conversacional de IA (voz e texto) onipresente, que atua como mentora pedagógica contextual e interface autônoma de operação do sistema.
3. O Ponto Crítico: Modelagem de Turmas, Alunos e PDI (ALERTA DE CORREÇÃO)
Atenção IA de Engenharia: Em refatorações anteriores, os vínculos relacionais entre Alunos, suas necessidades específicas e o módulo de PDI foram corrompidos ou simplificados. A arquitetura abaixo é OBRIGATÓRIA e deve ser restaurada.
3.1. Hierarquia de Vínculos Escolares
A base de dados deve respeitar a seguinte cadeia relacional: Escola (Gestão/Créditos) ↔ Professor ↔ Turma (Ano/Série) ↔ Aluno ↔ Disciplina.
3.2. Identificação e Perfil do Aluno (Obrigatório)
O sistema não pode tratar alunos apenas como "nomes em uma lista". O cadastro do aluno dentro de uma turma deve conter metadados cruciais para a educação inclusiva:
•	Dados Básicos: Nome, Turma, Idade.
•	Perfil Inclusivo (Condições): O banco de dados DEVE registrar mapeamentos específicos de deficiências (físicas, visuais, auditivas, intelectuais), neurodivergências (TEA, TDAH, Dislexia, etc.) e altas habilidades/superdotação.
•	Observações Pedagógicas: Campo de texto rico para o professor registrar o histórico e as necessidades do dia a dia do aluno.
3.3. O Motor do PDI (Plano de Desenvolvimento Individual)
O PDI é uma das ferramentas mais importantes do PROFEPLAN e não pode funcionar de forma genérica.
•	Gatilho Baseado no Aluno: Ao gerar uma adaptação de plano de aula (PDI), o sistema OBRIGATORIAMENTE deve buscar o ID do Aluno selecionado e injetar no prompt da Azure OpenAI as condições específicas cadastradas no perfil daquele aluno.
•	Adaptação Curricular Real: A IA deve cruzar o plano de aula original (conteúdo da BNCC) com a condição do aluno, gerando estratégias de ensino adaptadas, tempos diferenciados de prova e formatos de materiais específicos para a neurodivergência apontada.
•	Rastreabilidade: O documento de PDI gerado deve ficar permanentemente vinculado ao Perfil do Aluno e à Turma, permitindo que o professor e a escola acompanhem a evolução pedagógica.
4. Funcionalidades Essenciais da Plataforma
•	Planejamento Trimestral e de Aula: Wizards guiados para geração rápida de aulas formatadas e alinhadas à BNCC.
•	Gestão Escolar e Turmas: Cards de turmas, gestão de alunos e visualização de status (ex: "PDI pendente").
•	Simulados e Avaliações: Geração rápida de questões baseadas no conteúdo ensinado e exportação em PDF.
•	Meus Arquivos: Gestão de rascunhos, planos salvos e materiais injetados pela escola.
5. Diretriz de Ação para a IA (Arquiteto)
Ao processar este documento, o agente de engenharia deve:
1.	Auditar o schema do banco de dados (Supabase) e os tipos do TypeScript para as tabelas students, classes e pdi_documents.
2.	Identificar onde a relação Aluno -> Neurodivergência/Deficiência -> Prompt do PDI foi perdida.
3.	Propor as correções de código (migrations de banco, interfaces e funções no AiCore/PdiDocumentService) para restaurar essa funcionalidade com prioridade máxima.
________________________________________
Módulo 1: Configurações, Onboarding e Perfil Profissional
1.1. Regra de Primeiro Acesso (Onboarding Obrigatório)
Para garantir que a IA tenha o contexto correto ao gerar os planos e documentos, o preenchimento do Perfil Profissional é um passo bloqueante inicial.
•	Comportamento: Se um usuário recém-registrado fizer login e os dados básicos do seu perfil estiverem vazios ou incompletos, o sistema deve interceptar a navegação e abrir automaticamente o modal de "Configurações > Perfil e Preferências".
•	O usuário não poderá gerar planos ou acessar outras abas até salvar essas configurações iniciais.
1.2. Dados do Perfil e Vínculo Institucional
•	Nome Completo
•	E-mail Institucional: Utilizado para fins de registro oficial.
•	MASP / Matrícula: Campo alfanumérico (ex: Matrícula SIAFI).
•	Vínculo Empregatício Múltiplo: O sistema permite a adição de múltiplos cargos/escolas (botão "+ Adicionar 2ª Escola").
1.3. Busca de Escolas e Regra do INEP (Regra de Negócio Crítica)
O vínculo da escola com o Código INEP é fundamental para a gestão top-down. A seguinte regra OBRIGATÓRIA deve ser aplicada:
•	Autocompletar Inteligente: O campo "Nome da Escola" deve buscar em um banco de dados pré-cadastrado. Ao selecionar uma escola, o sistema preenche "Cidade" e "Código INEP".
•	Fallback Manual: Se o professor digitar o nome de uma escola e ela não constar na base, ele tem a liberdade de manter o nome digitado.
•	Proteção do Banco de Dados (NÃO SALVAR VARIAÇÕES): Se a escola for digitada manualmente, o campo código INEP deve permanecer vazio (null). O sistema NÃO DEVE salvar esse novo nome na tabela global de escolas, evitando poluição. O nome manual fica salvo apenas no escopo do perfil daquele professor.
1.4. Personalização de Documentos (Exportação)
Garante que os PDFs gerados saiam prontos para entrega:
•	Logo da Instituição: Upload de imagem (PNG/JPG).
•	Cabeçalho Personalizado: Campo de texto (ex: Secretaria de Educação...).
•	Rodapé Personalizado: Campo de texto para endereço/contatos.
1.5. Preferências de IA (Contexto Padrão)
O professor define o comportamento base da IA no System Prompt:
•	Metodologia Padrão (ex: Sala de Aula Invertida).
•	Estilo Pedagógico.
•	Foco Avaliativo.
•	Tom de Escrita.
________________________________________
Módulo 2: Minhas Turmas e Gestão de Alunos (Importação SIMADE e PDI)
2.1. Criação de Turmas (Importação via PDF)
A criação de turmas é feita através do upload do PDF (Relação Nominal de Alunos). O motor de extração (RAG/Vision) deve identificar e popular o cabeçalho:
•	Código e Nome da Escola (Ex: "023299" - "EE PROFESSOR ANTÔNIO LAGO")
•	Código e Identificação da Turma (Ex: "2072687" - "1º EM REG 1")
•	Ano Letivo, Turno e Disciplina
2.2. Extração Nominal de Alunos (Parsing Rigoroso)
A IA deve varrer a lista e cadastrá-los separando em 3 campos distintos:
•	Seq. (Número da Chamada)
•	Código (Matrícula do Aluno)
•	Nome Completo
2.3. Funcionalidade Crítica: Campo "Observações" e Gatilho do PDI
•	Regra de Negócio: Ao lado do nome de cada aluno deve existir o campo "Observações". É nele que o professor registrará informações de inclusão (laudos de TDAH, TEA, etc).
•	Vínculo: Se o campo "Observações" estiver preenchido, o sistema vincula esse aluno ao módulo de PDI e sinaliza visualmente na lista.
2.4. Diretrizes da IA para Geração de PDI (Privacidade e Ética)
•	Embasamento Científico: A IA deve buscar bibliografias e sites confiáveis para propor adaptações.
•	Proteção e Privacidade (Não-Exposição): O documento gerado NÃO DEVE citar explicitamente o termo clínico, transtorno ou deficiência do aluno no corpo das atividades. O objetivo é adaptar o material sem rotular o aluno caso o documento seja lido por terceiros.
2.5. Portabilidade e Retenção de Histórico
•	Regra de Migração: Se um aluno for transferido de turma ou avançar de ano, todo o seu histórico migra junto com ele, incluindo Código de matrícula, Observações e PDIs gerados anteriormente.
________________________________________
Módulo 3: Planejamento Trimestral e Engenharia de Agentes Autônomos
3.1. Arquitetura Multi-Agentes
Operado por uma arquitetura avançada de Agentes Autônomos Orquestrados, que delegam tarefas (Agente RAG da BNCC, Agente PNLD) em loops contínuos até que o plano atenda aos parâmetros informados.
3.2. Guardrails Estritos (Tolerância Zero a Alucinações)
•	Fidelidade Documental: O agente está PROIBIDO de inventar currículos. Todo o planejamento deve ser gerado consultando ESTRITAMENTE os documentos oficiais na base de dados (BNCC).
3.3. Integração Estrita com o Livro Didático (PNLD)
Se o professor ativar "Utilizar Livro PNLD":
•	Livro na Base: O planejamento DEVE referenciar os capítulos e páginas específicas.
•	Livro Não Encontrado: O sistema usará a BNCC temporariamente e engatilhará um "Robô Autônomo de Busca" para encontrar o livro na internet e incorporá-lo à base futuramente.
3.4. Ciclos de Verificação e Aprovação
•	O professor precisa revisar e aprovar o rascunho gerado.
•	Feedback como Regra Suprema: Qualquer alteração solicitada aciona um Verification Loop. O agente dará prioridade máxima a essa observação na reestruturação do plano.
________________________________________
Módulo 4: Elaboração de Aulas Semanais e Diárias
4.1. Regra de Ouro: Varredura de Contexto
Antes de gerar qualquer aula, o Agente de IA DEVE realizar uma varredura completa em todo o Planejamento Trimestral. Ele não deve ler apenas o "título" da aula atual, mas analisar aulas passadas e futuras para garantir continuidade. Isso alinha aulas, materiais, atividades e avaliações.
4.2. Parâmetros de Entrada e Contexto
•	Dados Base, Vínculo Escolar e um campo para Observações/Foco Específico (Prompt Direcional do dia).
4.3. A Chave de Alinhamento (Guardrail BNCC e PNLD)
•	Se ATIVADA: A IA busca Competências e Habilidades reais (PROIBIDO alucinar códigos).
•	PNLD: Se previsto no trimestral, a IA deve referenciar as páginas exatas do livro neste plano diário.
4.4. Estrutura Padronizada de Saída
O plano deve ser estruturado em seções claras: Cabeçalho, Habilidades BNCC, Objetivos, Recursos, Desenvolvimento (Introdução, Desenvolvimento e Fechamento) e Avaliação Diária.
4.5. Ações de Pós-Geração
•	Salvar, Exportar (PDF) e botão de Refazer Plano (com input de feedback humano).
________________________________________
Módulo 5: Adaptações PDI/DUA (Inclusão e Acessibilidade)
5.1. A Dependência Estrutural Crítica
Para carregar o PDI, o sistema DEVE validar:
1.	Turmas Ativas.
2.	Filtro de Inclusão (lista APENAS alunos com "Observações" preenchidas).
3.	Seletor de Contexto (qual Plano/Aula será adaptado).
5.2. O Agente Especialista em DUA (Tripla Varredura)
O Subagente de DUA executa:
•	Leitura do Perfil do Aluno (Observações).
•	Leitura do Plano de Aula original.
•	Busca na base (RAG) por diretrizes de inclusão.
•	Ação: Cruza as informações para gerar a estratégia.
5.3. Guardrails de Ética e Privacidade
•	Os documentos NUNCA devem expor o laudo clínico no título ou corpo do material do aluno. Foco 100% na estratégia pedagógica.
5.4. Estrutura de Saída e Histórico
•	Identificação, Objetivo, Estratégias, Adaptação do Material e Critérios de Avaliação.
•	Todo PDI é permanentemente atrelado ao banco de dados do Aluno.
________________________________________
Módulo 6: Simulados ENEM/Saeb (Banco de Dados Estático)
6.1. O Banco de Dados de 17.000 Questões
•	Tolerância Zero para Alucinações: Neste módulo, a IA atua exclusivamente como Bibliotecária. É PROIBIDO inventar ou alterar questões. As buscas ocorrem diretamente no banco de dados isolado (17.000 questões).
6.2. Modos de Busca
•	Modo Manual: Busca por palavras-chave, código BNCC ou ano.
•	Modo Espelho (Via Plano): A IA varre o Planejamento Trimestral e busca no banco apenas questões que cobram as habilidades já ensinadas.
6.3. Área de Trabalho e Pós-Processamento
•	As questões vão para a "Minha Seleção".
•	Botões de Ação: Equilibrar (Lógica TRI), geração de Versão A/B (Antifraude) com gabarito embaralhado, e Exportação.
________________________________________
Módulo 7: Avaliações Contextualizadas (Criação Inédita)
7.1. Fonte da Verdade e Varredura
A IA gera questões inéditas, mas está PROIBIDA de inventar baseada em conhecimentos genéricos.
•	Regra: O Agente DEVE ler o Planejamento Trimestral e os Planos de Aula ministrados. A prova só pode cobrar o que foi documentado nesses artefatos.
7.2. Controle Granular de Dificuldade
O professor controla a matriz com inputs exatos:
•	[ Nº ] Questões Fáceis
•	[ Nº ] Questões Médias
•	[ Nº ] Questões Difíceis
7.3. Balanceamento Estatístico de Gabarito
•	Respostas corretas distribuídas aleatoriamente.
•	Regra do 2: Nenhuma alternativa correta pode ter predominância superior a 2 questões de diferença em relação às outras.
7.4. Sistema Antifraude (Provas A / B / C)
•	O professor pode gerar versões A, B e C. O sistema embaralha a ordem das questões e a ordem das alternativas, gerando um Gabarito Mestre unificado.
________________________________________
Módulo 8: Meus Arquivos e Gestão de Documentos
8.1. Taxonomia e Nomenclatura Automática
O sistema está PROIBIDO de salvar documentos com nomes genéricos ("Aula 1").
•	Fórmula Obrigatória: [Tipo do Documento] [Número/Referência] - [Tema Específico] - [Disciplina]
•	(Ex: Aula 04 - Revolução Francesa - História)
8.2. Interface de Edição (Modo Foco)
•	Ocultação de Painéis: Ao clicar em "Editar", oculta-se qualquer janela paralela.
•	O professor é levado para um editor em tela cheia para ver a "folha de papel" final antes da impressão.
8.3. Filtros Inteligentes e Exportação Unificada
•	Filtros por Escola, Turma e Categoria (Planos, Provas, PDI).
•	A exportação aplica automaticamente o cabeçalho/logo configurado no Módulo 1.
________________________________________
Módulo 9: FREEDAY - Agente Autônomo de Voz
9.1. Omnipresença (Global UI)
A FREEDAY não é apenas uma página de chat.
•	O botão de acionamento deve ser um componente global, fixado na interface de todas as abas e módulos do sistema.
9.2. Interação Multimodal (Voz como Prioridade)
Focada em áudio para deixar as mãos do professor livres:
•	Speech-to-Text (STT): Capta, transcreve e envia comandos.
•	Text-to-Speech (TTS): Respostas conversacionais curtas e a capacidade de ler em voz alta os documentos gerados na tela (ex: "FREEDAY, leia o plano de aula para mim").
9.3. Function Calling e Execução de Tarefas
A FREEDAY é um Agente de Execução com controle sobre a interface:
•	Navegação: Capacidade de redirecionar a tela (ex: "Abra minhas turmas").
•	Ações de Sistema: Aciona botões sem uso do mouse (ex: "Salve este documento", "Exporte para PDF").
9.4. Consciência de Contexto (Context Awareness)
•	Injeção de Estado: Cada vez que a FREEDAY é acionada, o sistema envia silenciosamente o contexto da tela atual (ex: "O professor está editando o PDI do aluno Carlos").
•	Isso permite comandos relativos como: "Refaça o segundo parágrafo deste texto" ou "Imprima esta prova".

