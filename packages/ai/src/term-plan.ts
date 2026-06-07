import { prisma } from '@profeplan/db';
import type { Prisma } from '@profeplan/db';
import { logger } from '@profeplan/logger';

import { getOpenAIModel } from './env';
import { createOpenAIClient } from './openai';
import { buildTermPlanEnhancementPrompt } from './prompts/term-plan';
import type { EnhanceTermPlanResult, TermPlanEnhancement } from './types';

type TermPlanAIClient = {
  responses: {
    create: (params: {
      model: string;
      input: ReturnType<typeof buildTermPlanEnhancementPrompt>;
      text: {
        format: {
          type: 'json_schema';
          name: string;
          strict: boolean;
          schema: typeof termPlanEnhancementJsonSchema;
        };
      };
    }) => Promise<{ output_text: string }>;
  };
};

export type EnhanceTermPlanOptions = {
  client?: TermPlanAIClient;
  model?: string;
};

const termPlanEnhancementJsonSchema = {
  type: 'object',
  additionalProperties: false,
  properties: {
    summary: { type: 'string' },
    objectives: {
      type: 'array',
      items: { type: 'string' },
    },
    suggestedSequence: {
      type: 'array',
      items: { type: 'string' },
    },
    assessmentIdeas: {
      type: 'array',
      items: { type: 'string' },
    },
    differentiationStrategies: {
      type: 'array',
      items: { type: 'string' },
    },
    teacherNotes: { type: 'string' },
  },
  required: [
    'summary',
    'objectives',
    'suggestedSequence',
    'assessmentIdeas',
    'differentiationStrategies',
    'teacherNotes',
  ],
} satisfies Record<string, unknown>;

function parseTermPlanEnhancement(outputText: string): TermPlanEnhancement {
  const parsed = JSON.parse(outputText) as TermPlanEnhancement;

  return parsed;
}

export async function enhanceTermPlan(
  termPlanId: string,
  options: EnhanceTermPlanOptions = {}
): Promise<EnhanceTermPlanResult> {
  const termPlan = await prisma.termPlan.findUnique({
    where: { id: termPlanId },
  });

  if (!termPlan) {
    throw new Error(`TermPlan ${termPlanId} was not found.`);
  }

  const model = options.model ?? getOpenAIModel();
  const client = options.client ?? createOpenAIClient();

  const startTime = Date.now();
  try {
    const response = await client.responses.create({
      model,
      input: buildTermPlanEnhancementPrompt(termPlan),
      text: {
        format: {
          type: 'json_schema',
          name: 'term_plan_enhancement',
          strict: true,
          schema: termPlanEnhancementJsonSchema,
        },
      },
    });

    const duration = Date.now() - startTime;
    const enhancedContent = parseTermPlanEnhancement(response.output_text);

    await prisma.termPlan.update({
      where: { id: termPlan.id },
      data: {
        aiEnhancedContent: enhancedContent as unknown as Prisma.InputJsonValue,
        aiEnhancedAt: new Date(),
        aiModel: model,
      },
    });

    // Check if tokens usage is available
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const usage = (response as any).usage;
    const tokens = usage
      ? {
          promptTokens: usage.prompt_tokens ?? usage.promptTokens,
          completionTokens: usage.completion_tokens ?? usage.completionTokens,
          totalTokens: usage.total_tokens ?? usage.totalTokens,
        }
      : undefined;

    // Log operational details & audit
    logger.info('Execucao de IA concluida com sucesso', {
      model,
      durationMs: duration,
      success: true,
      tokens,
    });

    logger.audit('AI_ENHANCEMENT', termPlan.ownerId, {
      termPlanId: termPlan.id,
      model,
      durationMs: duration,
      success: true,
      tokens,
    });

    // Audit planning update
    logger.audit('UPDATE_PLANNING', termPlan.ownerId, {
      termPlanId: termPlan.id,
      details: 'Planejamento enriquecido por IA',
    });

    return {
      termPlanId: termPlan.id,
      model,
      enhancedContent,
    };
  } catch (error) {
    const duration = Date.now() - startTime;

    logger.error(error as Error, {
      model,
      durationMs: duration,
      success: false,
    });

    logger.audit('AI_ENHANCEMENT', termPlan.ownerId, {
      termPlanId: termPlan.id,
      model,
      durationMs: duration,
      success: false,
      error: (error as Error).message,
    });

    throw error;
  }
}
