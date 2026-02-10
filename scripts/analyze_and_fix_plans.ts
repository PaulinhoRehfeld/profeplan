import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

// Polyfill import.meta.env for services that might still use it safely
// @ts-ignore
if (typeof import.meta === 'undefined') (global as any).import = { meta: { env: process.env } };

const DRY_RUN = process.argv.includes('--dry-run');

async function main() {
    console.log(`🚀 Starting Plan Audit (DRY_RUN: ${DRY_RUN})`);

    // Dynamic import to ensure env vars are loaded
    const { supabase } = await import('../src/services/supabaseClient');
    const { PlanningAuthority } = await import('../src/services/PlanningAuthorityService');
    // Types cannot be dynamically imported for values, but TermPlan is a type.
    // We don't need to import TermPlan value.

    // 1. Fetch all plans
    const { data: plans, error } = await supabase
        .from('term_plans')
        .select('*');

    if (error) {
        console.error("❌ Error fetching plans:", error);
        process.exit(1);
    }

    console.log(`📦 Found ${plans.length} plans to review.`);

    let processed = 0;
    let fixed = 0;
    let skipped = 0;

    for (const plan of plans) {
        // if (fixed >= 1) break; // Removed for full run
        processed++;
        console.log(`\n-----------------------------------------------------------`);
        console.log(`🔍 Reviewing Plan ${processed}/${plans.length}: ${plan.subject} - ${plan.grade}`);

        if (!plan.generated_text) {
            console.warn("⚠️ Plan has no text content. Skipping.");
            continue; // Or should we regenerate from scratch? Let's skip empty for now.
        }

        // 2. Audit with RLM Specialist
        console.log("   🤖 Asking RLM Specialist to audit...");
        try {
            const auditPrompt = `
            ANALISE O SEGUINTE PLANO DE ENSINO DO ${plan.grade} TRIMESTRE ${plan.period} DE ${plan.subject}.
            
            CRITÉRIOS DE SUCESSO DO PROGRAMA (ZERO ERRO):
            1. O conteúdo deve ser estritamente adequado ao nível ${plan.grade} (${plan.level || 'Ensino Médio'}).
            2. Deve citar a BNCC (Habilidades).
            3. Deve ter cronograma de aulas coerente com ${plan.total_classes} aulas.
            4. NÃO pode mencionar "Bimestre" se for "Trimestre" (Regime: ${plan.regime}).

            Sua saída deve ser APENAS UM JSON no formato:
            {
                "approved": boolean,
                "reason": "string (curta justificativa)",
                "critical_feedback": "string (se reprovado, instrução clara para correção)"
            }
            
            PLANO PARA ANÁLISE:
            ${plan.generated_text}
            `;

            const auditResponseText = await PlanningAuthority.askSpecialist(auditPrompt);
            const cleanText = auditResponseText.replace(/```json/g, '').replace(/```/g, '').trim();
            const auditResult = JSON.parse(cleanText);

            if (auditResult.approved) {
                console.log("   ✅ Plan ID " + plan.id + " APPROVED.");
                // Mark as verified in DB if column exists (optional)
            } else {
                console.log("   ❌ Plan ID " + plan.id + " REJECTED.");
                console.log("   📝 Reason:", auditResult.reason);
                console.log("   🔧 Fix Instruction:", auditResult.critical_feedback);

                if (DRY_RUN) {
                    console.log("   [DRY RUN] Would regenerate plan now.");
                } else {
                    console.log("   🔄 Regenerating plan with feedback...");

                    // Reconstruct Intent
                    const intent = {
                        userId: plan.user_id,
                        subject: plan.subject,
                        grade: plan.grade,
                        level: plan.level || 'Ensino Médio',
                        period: plan.period,
                        regime: plan.regime,
                        teacherName: 'Professor(a)', // Fallback
                        stateBase: plan.state_base,
                        educationSphere: plan.education_sphere,
                        totalClasses: plan.total_classes,
                        reserves: plan.reserves,
                        feedback: `[REVISÃO AUTOMÁTICA RLM]: O plano anterior foi rejeitado por: ${auditResult.critical_feedback}. Corrija imediatamente.`,
                        pnld_book_id: null // Unless we store it?
                    };

                    try {
                        const newMarkdown = await PlanningAuthority.executePlanning(intent);

                        // Update DB
                        const { error: updateError } = await supabase
                            .from('term_plans')
                            .update({
                                generated_text: newMarkdown,
                                updated_at: new Date().toISOString()
                            })
                            .eq('id', plan.id);

                        if (updateError) {
                            console.error("   ❌ Error updating plan in DB:", updateError);
                        } else {
                            console.log("   ✅ Plan Regenerated and Saved.");
                            fixed++;
                        }
                    } catch (genError) {
                        console.error("   ❌ Error regenerating plan:", genError);
                    }
                }
            }

        } catch (e) {
            console.error("   ❌ Error during audit process:", e);
        }
    }

    console.log(`\n\n📊 SUMMARY:`);
    console.log(`   Total: ${plans.length}`);
    console.log(`   Fixed: ${fixed}`);
    console.log(`   Dry Run: ${DRY_RUN}`);
    console.log(`   Finished.`);
}

main();
