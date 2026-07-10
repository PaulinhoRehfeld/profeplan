// ============================================================================
// PROFEPLAN — Dummy Agent (S1-08)
// Agente dummy para validação do framework — representa Matemática (Pitágoras)
// ============================================================================

import {
  BaseDisciplineAgent,
  DisciplinaNome,
  TipoGeracao,
  type GeracaoResultado,
  AGENT_DISPLAY_NAMES,
} from '../../base/discipline-agent-base';

/**
 * Agente dummy para validação do framework.
 *
 * Representa um agente de Matemática (Pitágoras) minimalista
 * usado para testar o pipeline completo de ponta a ponta.
 */
export class DummyAgent extends BaseDisciplineAgent {
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.MATEMATICA]; // "Pitágoras"
  }

  protected buildSystemPrompt(): string {
    return 'Você é um agente dummy de Matemática. Responda com dados simulados.';
  }

  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.MATEMATICA;
  }

  public getHabilidadesPrioritarias(): string[] {
    return ['EF06MA01', 'EF06MA02', 'EM13MAT101'];
  }

  // Sobrescreve os métodos protegidos para funcionar de verdade:
  protected async _buildRagContext(_tipo: TipoGeracao): Promise<string> {
    return 'Contexto RAG simulado para Matemática.';
  }

  protected _selectPromptTemplate(tipo: TipoGeracao): string {
    return `Template de prompt para ${tipo}`;
  }

  protected async _callLLM(
    _prompt: string,
    _ragContext: string,
    params: Record<string, unknown>,
  ): Promise<string> {
    // Simula resposta do LLM
    return JSON.stringify({
      tema: params.tema || 'Tema padrão',
      conteudo: 'Conteúdo simulado pelo DummyAgent (Pitágoras).',
      duracao: '50 minutos',
    });
  }

  protected async _postProcess(
    raw: string,
    tipo: TipoGeracao,
  ): Promise<GeracaoResultado> {
    let conteudo: Record<string, unknown>;
    try {
      conteudo = JSON.parse(raw) as Record<string, unknown>;
    } catch {
      // Fallback: se o LLM retornar JSON inválido, usa o raw como texto
      conteudo = { raw, erro: 'Falha ao parsear JSON do LLM' };
    }
    return {
      sucesso: true,
      conteudo,
      metadados: {
        agente: this.displayName,
        disciplina: this.getDisciplina(),
        nivel: this.context.nivel,
        tipo,
        timestamp: new Date().toISOString(),
      },
    };
  }
}
