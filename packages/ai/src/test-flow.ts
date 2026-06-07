import { prisma } from '@profeplan/db';
import { enhanceTermPlan } from './index';

async function main() {
  console.log('🚀 Starting PHASE-6-AI-FOUNDATION full-flow validation...\n');

  // 1. Setup mock/test environment and entities
  const testEmail = 'ai-test-teacher@profeplan.com';
  const testOrgSlug = 'ai-test-org';

  console.log('🧹 Cleaning up any leftover test data...');
  const existingUser = await prisma.user.findUnique({ where: { email: testEmail } });
  if (existingUser) {
    await prisma.termPlan.deleteMany({ where: { ownerId: existingUser.id } });
    await prisma.membership.deleteMany({ where: { userId: existingUser.id } });
    await prisma.user.delete({ where: { id: existingUser.id } });
  }
  const existingOrg = await prisma.organization.findUnique({ where: { slug: testOrgSlug } });
  if (existingOrg) {
    await prisma.organization.delete({ where: { id: existingOrg.id } });
  }

  console.log('📦 Creating test User and Organization...');
  const user = await prisma.user.create({
    data: {
      email: testEmail,
      fullName: 'Professor de Teste IA',
    },
  });

  const organization = await prisma.organization.create({
    data: {
      name: 'Organização de Teste IA',
      slug: testOrgSlug,
    },
  });

  console.log('🔗 Creating Membership linking User to Organization...');
  await prisma.membership.create({
    data: {
      userId: user.id,
      organizationId: organization.id,
      role: 'TEACHER',
    },
  });

  console.log('📝 Creating TermPlan to be enriched...');
  const termPlan = await prisma.termPlan.create({
    data: {
      organizationId: organization.id,
      ownerId: user.id,
      title: 'Planejamento de Língua Portuguesa - 6º Ano',
      year: 2026,
      term: 2,
      status: 'DRAFT',
    },
  });

  // 2. Define Mock OpenAI Client matching TermPlanAIClient shape
  const mockEnhancedPayload = {
    summary: 'Resumo enriquecido pelo assistente pedagógico IA do PROFEPLAN V2.',
    objectives: [
      'Desenvolver habilidades de leitura e interpretação de textos literários.',
      'Identificar elementos narrativos estruturais e figuras de linguagem.',
    ],
    suggestedSequence: [
      'Semana 1-2: Leitura de crônicas brasileiras clássicas.',
      'Semana 3-4: Oficina prática de escrita criativa e estilística.',
    ],
    assessmentIdeas: [
      'Avaliação formativa baseada na participação nas discussões de crônicas.',
      'Avaliação somativa com a produção e revisão paritária de um texto autoral.',
    ],
    differentiationStrategies: [
      'Disponibilização de audiobooks dos textos recomendados para acessibilidade.',
      'Roteiros de apoio estruturados para alunos que necessitam de suporte extra.',
    ],
    teacherNotes:
      'Recomenda-se reservar os últimos 15 minutos de cada aula para compartilhamento espontâneo de leituras.',
  };

  const mockClient = {
    responses: {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      create: async (params: { model: string; input: any; text: any }) => {
        console.log('\n🤖 [Mock OpenAI Client] Received Prompt:');
        console.log(`- Model: ${params.model}`);
        console.log(`- Messages Count: ${params.input.length}`);
        console.log(`- Strict Schema: ${params.text.format.strict}`);
        console.log(`- Format Name: ${params.text.format.name}`);

        return {
          output_text: JSON.stringify(mockEnhancedPayload),
        };
      },
    },
  };

  // 3. Run enhancement flow
  console.log('\n🔮 Executing enhanceTermPlan function with Mock OpenAI Client...');
  const result = await enhanceTermPlan(termPlan.id, {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    client: mockClient as any,
    model: 'mock-gpt-4o-mini',
  });

  console.log('\n✨ Execution completed. Verifying results...');

  // 4. Verify Returned Result
  if (result.termPlanId !== termPlan.id) {
    throw new Error(
      `Result termPlanId mismatch. Expected: ${termPlan.id}, Got: ${result.termPlanId}`
    );
  }
  if (result.model !== 'mock-gpt-4o-mini') {
    throw new Error(`Result model mismatch. Expected: mock-gpt-4o-mini, Got: ${result.model}`);
  }
  if (JSON.stringify(result.enhancedContent) !== JSON.stringify(mockEnhancedPayload)) {
    throw new Error('Result enhancedContent mismatch.');
  }
  console.log('✅ Returned result correctly matches mock payload!');

  // 5. Verify Database Persistence
  const updatedTermPlan = await prisma.termPlan.findUnique({
    where: { id: termPlan.id },
  });

  if (!updatedTermPlan) {
    throw new Error('Could not retrieve updated TermPlan from the database.');
  }

  console.log('\n🗄️ Checking persisted DB values:');
  console.log(`- aiModel: ${updatedTermPlan.aiModel}`);
  console.log(`- aiEnhancedAt: ${updatedTermPlan.aiEnhancedAt}`);
  console.log(`- aiEnhancedContent:`, JSON.stringify(updatedTermPlan.aiEnhancedContent, null, 2));

  if (updatedTermPlan.aiModel !== 'mock-gpt-4o-mini') {
    throw new Error('Persisted aiModel mismatch.');
  }
  if (!updatedTermPlan.aiEnhancedAt) {
    throw new Error('Persisted aiEnhancedAt is null.');
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  function deepEqual(a: any, b: any): boolean {
    if (a === b) return true;
    if (typeof a !== 'object' || a === null || typeof b !== 'object' || b === null) return false;
    const keysA = Object.keys(a);
    const keysB = Object.keys(b);
    if (keysA.length !== keysB.length) return false;
    for (const key of keysA) {
      if (!keysB.includes(key)) return false;
      if (!deepEqual(a[key], b[key])) return false;
    }
    return true;
  }

  if (!deepEqual(updatedTermPlan.aiEnhancedContent, mockEnhancedPayload)) {
    throw new Error('Persisted aiEnhancedContent mismatch.');
  }
  console.log('✅ Database persistence validated perfectly!');

  // 6. Cleanup
  console.log('\n🧹 Cleaning up test data from database...');
  await prisma.termPlan.delete({ where: { id: termPlan.id } });
  await prisma.membership.deleteMany({ where: { userId: user.id } });
  await prisma.user.delete({ where: { id: user.id } });
  await prisma.organization.delete({ where: { id: organization.id } });
  console.log('✅ Database cleaned up completely.');

  console.log('\n🎉 ALL FLOW VALIDATIONS PASSED SUCCESSFULLY!');
}

main().catch((err) => {
  console.error('\n❌ VALIDATION FLOW FAILED WITH ERROR:', err);
  process.exit(1);
});
