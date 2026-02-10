// Central type exports
export * from './pdi';
export * from './pdi-schema';

// Additional type exports for Assessment
export interface Question {
    id: string;
    text: string;
    type: 'multiple_choice' | 'true_false' | 'short_answer';
    options?: string[];
    correctAnswer?: string | boolean;
}

// Re-export PDIProfileData as PdiData for backward compatibility
export type { PDIProfileData as PdiData } from './pdi-schema';

// User Profile type
export interface UserProfile {
    id: string;
    email: string;
    name?: string;
    role?: 'teacher' | 'supervisor' | 'admin';
    school_name?: string;
    city?: string;
    school?: {
        name?: string;
        city?: string;
        sre?: string;
    };
}

// Term Plan types
export interface TermPlan {
    id: string;
    period: number;
    regime: 'Bimestre' | 'Trimestre';
    subject: string;
    grade: string;
    level: string;
    workloadWeekly: number;
    reserves: {
        monthlyExam: boolean;
        termExam: boolean;  // Changed from bimonthlyExam to termExam
        recovery: boolean;
    };
    totalClasses: number;
    gradingGrid: {
        vistos: number;
        trabalhos: number;
        monthlyExam: number;
        termExam: number;  // Changed from bimonthlyExam
        others: number;
    };
    stateBase: string;
    educationSphere: string;
    generatedText: string;
    lessons?: any[];
    created_at?: string;
}
