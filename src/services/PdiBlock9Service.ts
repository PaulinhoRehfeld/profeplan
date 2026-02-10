/**
 * PDI Block 9 Auto-Generation Service
 * Handles automatic generation of Block 9 adaptations when teachers save lesson plans
 */

import { PdiDocumentService } from './pdi/PdiDocumentService';
import { generateBlock9Adaptation } from './geminiService';
import { Block9AdaptationEntry } from '../types/pdi';
import { supabase } from './supabaseClient';

export const PdiBlock9Service = {
    /**
     * Automatically generate Block 9 adaptations for all students with active PDIs
     * when a teacher saves a lesson plan.
     * 
     * Called by PlanningService after saving a lesson.
     */
    async generateAdaptationsForLesson(
        lessonId: string,
        lessonTitle: string,
        lessonContent: string,
        subject: string,
        gradeLevel: string,
        habilidadesBncc: string[],
        classId: string,
        schoolId: string,
        userId: string,
        year: number
    ): Promise<{ success: boolean; adaptationsCreated: number; errors: string[] }> {

        console.log(`🔄 PDI Block 9: Checking for students with active PDIs in class ${classId}...`);

        const errors: string[] = [];
        let adaptationsCreated = 0;

        try {
            // 1. Get all students in this class who have an active PDI for the current period
            const { data: studentsWithPdi, error: studentsError } = await supabase
                .from('pdi_documents')
                .select(`
                    id,
                    student_id,
                    year,
                    content_data,
                    school_students (
                        id,
                        name
                    )
                `)
                .eq('school_id', schoolId)
                .eq('year', year)
                .eq('status', 'em_andamento');

            if (studentsError) {
                console.error('Error fetching students with PDI:', studentsError);
                errors.push(`Erro ao buscar alunos com PDI: ${studentsError.message}`);
                return { success: false, adaptationsCreated: 0, errors };
            }

            if (!studentsWithPdi || studentsWithPdi.length === 0) {
                console.log('✓ No students with active PDI found for this period.');
                return { success: true, adaptationsCreated: 0, errors: [] };
            }

            console.log(`📋 Found ${studentsWithPdi.length} student(s) with active PDI. Generating adaptations...`);

            // 2. For each student, generate Block 9 adaptation
            for (const pdiDoc of studentsWithPdi) {
                try {
                    const studentName = (pdiDoc.school_students as any)?.name || 'Estudante';

                    // Extract student context from content_data
                    const content = (pdiDoc.content_data || {}) as any;
                    const studentContext = {
                        nome_completo: (pdiDoc.school_students as any)?.name || studentName,
                        diagnostico_clinico: content.clinical_health?.diagnosis_cid,
                        necessidades_especificas: content.pedagogical?.specific_needs,
                        potencialidades: content.cognitive?.potentials,
                        desafios: content.cognitive?.challenges,
                        objetivo_geral: content.pedagogical?.general_objective,
                        recursos_tecnologicos: content.pedagogical?.technological_resources,
                        materiais_adaptados: content.pedagogical?.adapted_materials,
                    };

                    // Check if Block 1 is filled (required for adaptation)
                    if (!studentContext.nome_completo) {
                        console.warn(`⚠️ PDI ${pdiDoc.id}: Block 1 não preenchido. Pulando adaptação.`);
                        errors.push(`${studentName}: Formulário base (Blocos 1-8) incompleto`);
                        continue;
                    }

                    console.log(`🤖 Gerando adaptação para ${studentContext.nome_completo}...`);

                    // 3. Generate adaptation using AI
                    const adaptationResult = await generateBlock9Adaptation(
                        lessonContent,
                        lessonTitle,
                        subject,
                        gradeLevel,
                        habilidadesBncc,
                        studentContext,
                        userId
                    );

                    // 4. Create Block 9 entry
                    const newAdaptation: Omit<Block9AdaptationEntry, 'generated_at' | 'generated_by_ai'> = {
                        lesson_id: lessonId,
                        lesson_title: lessonTitle,
                        subject: subject,
                        habilidades_bncc: habilidadesBncc,
                        adaptacao_metodologica: adaptationResult.adaptacao_metodologica,
                        recursos_adaptados: adaptationResult.recursos_adaptados,
                        objetivos_adaptados: adaptationResult.objetivos_adaptados,
                        estrategias_ensino: adaptationResult.estrategias_ensino,
                        tempo_estimado: adaptationResult.tempo_estimado,
                    };

                    // 5. Save to PDI
                    const saved = await PdiDocumentService.addBlock9Adaptation(
                        pdiDoc.id,
                        newAdaptation,
                    );

                    if (saved) {
                        adaptationsCreated++;
                        console.log(`✅ Adaptação criada para ${studentContext.nome_completo}`);
                    } else {
                        errors.push(`${studentContext.nome_completo}: Erro ao salvar adaptação`);
                    }

                } catch (studentError: any) {
                    console.error(`Error generating adaptation for student:`, studentError);
                    const studentName = (pdiDoc.school_students as any)?.name || 'Estudante';
                    errors.push(`${studentName}: ${studentError.message || 'Erro desconhecido'}`);
                }
            }

            console.log(`✅ PDI Block 9: ${adaptationsCreated} adaptações criadas com sucesso.`);

            return {
                success: true,
                adaptationsCreated,
                errors,
            };

        } catch (error: any) {
            console.error('Fatal error in Block 9 generation:', error);
            return {
                success: false,
                adaptationsCreated,
                errors: [error.message || 'Erro fatal ao gerar adaptações'],
            };
        }
    },

    /**
     * Get all Block 9 adaptations for a specific student's PDI
     */
    async getStudentAdaptations(pdiId: string): Promise<Block9AdaptationEntry[]> {
        try {
            const { data: pdi } = await PdiDocumentService.getPdiDocument(pdiId);
            if (!pdi) {
                return [];
            }
            return (pdi.block_9_content || []) as Block9AdaptationEntry[];
        } catch (error) {
            console.error('Error fetching Block 9 adaptations:', error);
            return [];
        }
    },

    /**
     * Get statistics about Block 9 for a PDI
     */
    async getAdaptationStats(pdiId: string): Promise<{
        total: number;
        last_generated?: string;
        subjects: string[];
    }> {
        const adaptations = await this.getStudentAdaptations(pdiId);

        const subjects = [...new Set(adaptations.map(a => a.subject))];
        const lastGenerated = adaptations.length > 0
            ? adaptations.sort((a, b) =>
                new Date(b.generated_at).getTime() - new Date(a.generated_at).getTime()
            )[0].generated_at
            : undefined;

        return {
            total: adaptations.length,
            last_generated: lastGenerated,
            subjects: subjects as string[],
        };
    },
};
