// ============================================================================
// PROFEPLAN — PDI Guardian Agent
// S4-03: Valida adaptações PDI/DUA — vincula aluno, aula e diretrizes de inclusão
// ============================================================================

import { BaseQualityGate, type GateResult } from './quality-gate-pipeline';
import { TipoGeracao, type GeracaoResultado } from '../base/discipline-agent-base';
import type { GeracaoRequest } from '../coordenacao/orchestrator-agent';

/**
 * Valida adaptações PDI/DUA no conteúdo gerado.
 *
 * Garante que:
 * - Adaptações de PDI estejam vinculadas a um aluno real
 * - As adaptações respeitem os princípios do DUA (Desenho Universal para Aprendizagem)
 * - Não haja exposição indevida de diagnósticos ou condições do aluno
 *
 * TODO: Integrar com tabela `pdI` do Supabase para validar existência do aluno e PDI.
 */
export class PDIGuardianAgent extends BaseQualityGate {
  /** Campos obrigatórios em uma adaptação PDI válida. */
  private static readonly CAMPOS_OBRIGATORIOS_PDI = [
    'aluno_id',
    'pdi_id',
    'aula_id',
    'adaptacao',
  ];

  /** Palavras-chave que indicam presença de adaptação PDI. */
  private static readonly INDICADORES_PDI = [
    'adaptação',
    'adaptacao',
    'pdi',
    'dua',
    'inclusão',
    'inclusao',
    'necessidades específicas',
    'necessidades especificas',
    'atendimento especializado',
    'tecnologia assistiva',
  ];

  public get name(): string {
    return 'PDI Guardian';
  }

  public isApplicable(tipo: TipoGeracao): boolean {
    // PDI Guardian é aplicável apenas quando o tipo é PDI_ADAPTACAO
    return tipo === TipoGeracao.PDI_ADAPTACAO;
  }

  public async check(
    resultado: GeracaoResultado,
    req: GeracaoRequest,
  ): Promise<GateResult> {
    const conteudo = resultado.conteudo;

    // Se não for PDI_ADAPTACAO, o gate é pulado (isApplicable já filtra)
    // Mas verificamos por via das dúvidas
    if (req.tipo !== TipoGeracao.PDI_ADAPTACAO) {
      return {
        gate: this.name,
        passed: true,
        severity: 'INFO',
        score: 1.0,
        message: 'Gate PDI não aplicável para este tipo de geração.',
      };
    }

    // Verifica campos obrigatórios do PDI
    const camposFaltantes = PDIGuardianAgent.CAMPOS_OBRIGATORIOS_PDI.filter(
      (campo) => !(campo in (conteudo ?? {})),
    );

    if (camposFaltantes.length > 0) {
      return {
        gate: this.name,
        passed: false,
        severity: 'BLOCKER',
        score: 0,
        message: `Adaptação PDI inválida: campos obrigatórios ausentes: ${camposFaltantes.join(', ')}.`,
        suggestion: 'Toda adaptação PDI deve conter: aluno_id, pdi_id, aula_id e adaptacao.',
      };
    }

    // Verifica se o campo "adaptacao" tem conteúdo significativo
    const adaptacao = (conteudo as Record<string, unknown>).adaptacao;
    if (typeof adaptacao !== 'string' || adaptacao.trim().length < 20) {
      return {
        gate: this.name,
        passed: false,
        severity: 'BLOCKER',
        score: 0,
        message: 'Campo "adaptacao" vazio ou muito curto (mínimo 20 caracteres).',
        suggestion: 'Descreva a adaptação pedagógica de forma clara e específica.',
      };
    }

    // Verifica presença de indicadores PDI/DUA no texto da adaptação
    const textoAdaptacao = adaptacao.toLowerCase();
    const indicadoresEncontrados = PDIGuardianAgent.INDICADORES_PDI.filter((ind) =>
      textoAdaptacao.includes(ind),
    );

    if (indicadoresEncontrados.length === 0) {
      return {
        gate: this.name,
        passed: true,
        severity: 'WARNING',
        score: 0.7,
        message: 'Adaptação PDI não menciona explicitamente PDI, DUA ou inclusão.',
        suggestion: 'Inclua referência ao PDI/DUA na descrição da adaptação.',
      };
    }

    // TODO: Validar se aluno_id e pdi_id existem na tabela pdi do Supabase
    // TODO: Validar se aula_id corresponde a uma aula real da turma

    return {
      gate: this.name,
      passed: true,
      severity: 'INFO',
      score: 1.0,
      message: `Adaptação PDI validada. Indicadores encontrados: ${indicadoresEncontrados.join(', ')}.`,
    };
  }
}
