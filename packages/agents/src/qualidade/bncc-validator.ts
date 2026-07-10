// ============================================================================
// PROFEPLAN — BNCC Validator Agent (Quality Gate)
// S3-02: Valida códigos BNCC contra o currículo de Minas Gerais
// ============================================================================

import { BaseQualityGate } from './quality-gate-pipeline';
import type { GateResult } from './quality-gate-pipeline';
import { TipoGeracao } from '../base/discipline-agent-base';
import type { GeracaoResultado } from '../base/discipline-agent-base';
import type { GeracaoRequest } from '../coordenacao/orchestrator-agent';

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/**
 * Registro individual de uma habilidade no índice BNCC.
 *
 * Representa uma linha do {@link curriculo_mg.json} após parsing,
 * contendo o código da habilidade, a disciplina vinculada, o ano
 * escolar e a descrição textual da habilidade.
 */
interface HabilidadeRecord {
  /** Código BNCC da habilidade (ex: `EF06LP01`, `EM13MAT101`). */
  readonly codigo: string;
  /** Nome da disciplina normalizada (ex: `Língua Portuguesa`). */
  readonly disciplina: string;
  /** Ano escolar (ex: `6º Ano EF`, `1ª Série EM`). */
  readonly ano: string;
  /** Descrição textual completa da habilidade. */
  readonly descricao: string;
}

// ---------------------------------------------------------------------------
// Regex
// ---------------------------------------------------------------------------

/**
 * Expressão regular para extrair códigos de habilidades BNCC de
 * qualquer conteúdo textual.
 *
 * Padrões suportados:
 * - Ensino Fundamental: `EF` + 2 dígitos do ano + 2 letras da área + 2 dígitos sequenciais
 *   Ex: `EF06LP01`, `EF09MA05`
 * - Ensino Médio: `EM13` + 3 letras da área + 3 dígitos sequenciais
 *   Ex: `EM13LP01`, `EM13MAT101`, `EM13CHS102`
 *
 * @internal
 */
const BNCC_CODE_REGEX = /\b(EF\d{2}[A-Z]{2}\d{2}|EM13[A-Z]{3}\d{3})\b/g;

// ============================================================================
// BNCCValidatorAgent
// ============================================================================

/**
 * Quality gate que valida códigos de habilidades BNCC citados no
 * conteúdo gerado contra um índice de habilidades oficiais.
 *
 * **Regras de validação:**
 * 1. Se nenhum código BNCC for encontrado → `WARNING` (score 0.85).
 * 2. Se algum código não existir no índice → `BLOCKER` (score 0).
 * 3. Se algum código pertencer a disciplina diferente da requisitada → `BLOCKER` (score 0).
 * 4. Se todos os códigos forem válidos e da disciplina correta → `INFO` (score 1.0).
 *
 * **Não-aplicabilidade:**
 * Este gate **não** é executado para gerações do tipo {@link TipoGeracao.PDI_ADAPTACAO},
 * pois PDIs não requerem vinculação com habilidades BNCC.
 *
 * **Índice de habilidades:**
 * Atualmente utiliza um índice mock com ~50 habilidades conhecidas.
 * TODO: Carregar `curriculo_mg.json` completo (1576 registros) em produção.
 *
 * @example
 * ```ts
 * const gate = new BNCCValidatorAgent();
 * const result = await gate.check(geracaoResultado, {
 *   disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
 *   // ...outros campos
 * } as GeracaoRequest);
 * if (!result.passed) {
 *   console.error(result.message, result.suggestion);
 * }
 * ```
 */
export class BNCCValidatorAgent extends BaseQualityGate {
  /** Índice de habilidades: código → lista de registros. */
  private readonly habilidadeIndex: Map<string, HabilidadeRecord[]> = new Map();

  /** Constrói o validador e popula o índice mock inicial. */
  public constructor() {
    super();
    // TODO: Carregar curriculo_mg.json (1576 registros)
    // Por enquanto, popula com habilidades conhecidas dos agentes
    this._initMockIndex();
  }

  /** @inheritdoc */
  public get name(): string {
    return 'BNCC Validator';
  }

  /**
   * Determina se este gate é aplicável ao tipo de geração.
   *
   * PDIs de adaptação não requerem validação BNCC, pois são
   * documentos individualizados que não seguem o currículo padrão.
   *
   * @param tipo — Tipo de geração sendo validada.
   * @returns `true` para todos os tipos exceto {@link TipoGeracao.PDI_ADAPTACAO}.
   */
  public isApplicable(tipo: TipoGeracao): boolean {
    return tipo !== TipoGeracao.PDI_ADAPTACAO;
  }

  /**
   * Executa a validação BNCC sobre o conteúdo gerado.
   *
   * Algoritmo:
   * 1. Extrai códigos BNCC do campo `habilidades_bncc` do conteúdo
   *    (fallback: busca regex em todos os campos string).
   * 2. Se nenhum código for encontrado → `WARNING`.
   * 3. Para cada código, verifica existência no índice e pertinência
   *    à disciplina correta.
   * 4. Códigos inexistentes → `BLOCKER`.
   * 5. Códigos de disciplina errada → `BLOCKER`.
   * 6. Todos válidos → `INFO` com score 1.0.
   *
   * @param resultado — Resultado da geração produzida pelo agente de disciplina.
   * @param req       — Requisição original que originou a geração.
   * @returns Promise com o {@link GateResult} contendo score, passed, mensagem etc.
   */
  public async check(
    resultado: GeracaoResultado,
    req: GeracaoRequest,
  ): Promise<GateResult> {
    const conteudo = resultado.conteudo;
    const codigosCitados = this._extractBNCCCodes(conteudo);

    // --- Nenhum código BNCC encontrado ---
    if (codigosCitados.length === 0) {
      return {
        gate: this.name,
        passed: true,
        severity: 'WARNING',
        score: 0.85,
        message: 'Nenhum código BNCC encontrado no conteúdo gerado.',
        suggestion: 'Inclua códigos de habilidades BNCC no campo "habilidades_bncc".',
      };
    }

    // --- Valida cada código contra o índice ---
    const invalidos: string[] = [];
    const disciplinaErrada: string[] = [];

    for (const codigo of codigosCitados) {
      const registros = this.habilidadeIndex.get(codigo);

      // Código não existe no índice
      if (!registros || registros.length === 0) {
        invalidos.push(codigo);
        continue;
      }

      // Normaliza nome da disciplina para comparação (NFD → sem acentos)
      // Converte enum (LINGUA_PORTUGUESA → lingua portuguesa) e
      // nomes com acentos (Língua Portuguesa → lingua portuguesa)
      const discReq = this._normalize(req.disciplina.replace(/_/g, ' '));
      const matchDisciplina = registros.some(
        (r) => {
          const discIndex = this._normalize(r.disciplina);
          return discIndex.includes(discReq) || discReq.includes(discIndex);
        },
      );

      if (!matchDisciplina) {
        disciplinaErrada.push(codigo);
      }
    }

    // --- Códigos inexistentes → BLOCKER ---
    if (invalidos.length > 0) {
      return {
        gate: this.name,
        passed: false,
        severity: 'BLOCKER',
        score: 0,
        message: `Códigos BNCC INEXISTENTES: ${invalidos.join(', ')}`,
        suggestion: 'Remova códigos inventados. Use apenas códigos da BNCC oficial.',
      };
    }

    // --- Códigos de disciplina errada → BLOCKER ---
    if (disciplinaErrada.length > 0) {
      return {
        gate: this.name,
        passed: false,
        severity: 'BLOCKER',
        score: 0,
        message: `Códigos de OUTRA disciplina: ${disciplinaErrada.join(', ')}`,
        suggestion: `Estes códigos não pertencem a ${req.disciplina}. Verifique.`,
      };
    }

    // --- Todos válidos ---
    return {
      gate: this.name,
      passed: true,
      severity: 'INFO',
      score: 1.0,
      message: `${codigosCitados.length} código(s) BNCC validados com sucesso.`,
    };
  }

  // -----------------------------------------------------------------------
  // Private helpers
  // -----------------------------------------------------------------------

  /**
   * Normaliza uma string removendo acentos e convertendo para lowercase.
   *
   * Utiliza decomposição Unicode NFD (Normalization Form D) para separar
   * caracteres base de seus diacríticos combinantes (acentos, cedilha, til, etc.)
   * e então remove os caracteres combinantes do intervalo U+0300–U+036F.
   *
   * Exemplos:
   * - `'Língua Portuguesa'` → `'lingua portuguesa'`
   * - `'Matemática'` → `'matematica'`
   * - `'História'` → `'historia'`
   * - `'Ciências'` → `'ciencias'`
   *
   * @param str — String a ser normalizada.
   * @returns String sem acentos, em lowercase.
   */
  private _normalize(str: string): string {
    return str
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase();
  }

  /**
   * Extrai códigos BNCC do conteúdo gerado.
   *
   * Estratégia (em ordem de prioridade):
   * 1. Campo `habilidades_bncc` (array de strings) — via explícita do agente.
   * 2. Fallback: busca com {@link BNCC_CODE_REGEX} em todos os campos
   *    do tipo string do conteúdo.
   *
   * @param conteudo — Mapa chave-valor do conteúdo gerado.
   * @returns Lista de códigos BNCC únicos encontrados.
   */
  private _extractBNCCCodes(conteudo: Record<string, unknown>): string[] {
    // Caminho feliz: campo explícito
    const habilidades = conteudo.habilidades_bncc as string[] | undefined;
    if (Array.isArray(habilidades)) {
      return habilidades.filter((h): h is string => typeof h === 'string');
    }

    // Fallback: regex em todos os campos string
    const allValues = Object.values(conteudo).filter(
      (v): v is string => typeof v === 'string',
    );
    const codes: string[] = [];
    for (const val of allValues) {
      const matches = val.match(BNCC_CODE_REGEX);
      if (matches) {
        codes.push(...matches);
      }
    }
    return [...new Set(codes)];
  }

  /**
   * Inicializa o índice de habilidades com dados mock.
   *
   * Cobre habilidades representativas de:
   * - Língua Portuguesa (EF 6º–9º, EM)
   * - Matemática (EF 6º–9º, EM)
   * - História (EF 6º–9º)
   * - Geografia (EF 6º–9º)
   * - Ciências (EF 6º–9º)
   * - Ciências Humanas e Sociais Aplicadas (EM)
   * - Ciências da Natureza e suas Tecnologias (EM)
   *
   * TODO: Substituir por carga real de `curriculo_mg.json`.
   */
  private _initMockIndex(): void {
    // --- Ensino Fundamental ---
    const lpEF = [
      'EF06LP01', 'EF06LP02',
      'EF07LP01', 'EF07LP02',
      'EF08LP01', 'EF08LP02',
      'EF09LP01', 'EF09LP02',
    ];
    for (const c of lpEF) this._addMock(c, 'Língua Portuguesa');

    const matEF = [
      'EF06MA01', 'EF06MA02',
      'EF07MA01', 'EF08MA01',
      'EF09MA01', 'EF09MA05',
    ];
    for (const c of matEF) this._addMock(c, 'Matemática');

    const histEF = ['EF06HI01', 'EF07HI01', 'EF08HI01', 'EF09HI01'];
    for (const c of histEF) this._addMock(c, 'História');

    const geoEF = ['EF06GE01', 'EF07GE01', 'EF08GE01', 'EF09GE01'];
    for (const c of geoEF) this._addMock(c, 'Geografia');

    const cieEF = ['EF06CI01', 'EF07CI01', 'EF08CI01', 'EF09CI01'];
    for (const c of cieEF) this._addMock(c, 'Ciências');

    // --- Ensino Médio ---
    const emCodes = [
      'EM13LP01', 'EM13LP02',
      'EM13MAT101', 'EM13MAT102',
      'EM13CHS101', 'EM13CHS102',
      'EM13CNT101', 'EM13CNT102',
    ];
    for (const c of emCodes) this._addMock(c, 'Geral');
  }

  /**
   * Adiciona uma habilidade mock ao índice.
   *
   * @param codigo     — Código BNCC da habilidade.
   * @param disciplina — Nome da disciplina associada.
   */
  private _addMock(codigo: string, disciplina: string): void {
    if (!this.habilidadeIndex.has(codigo)) {
      this.habilidadeIndex.set(codigo, []);
    }
    this.habilidadeIndex.get(codigo)!.push({
      codigo,
      disciplina,
      ano: 'MOCK',
      descricao: `[MOCK] Habilidade ${codigo}`,
    });
  }
}
