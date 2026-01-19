
export enum MessageRole {
  USER = 'user',
  ASSISTANT = 'assistant',
  SYSTEM = 'system'
}

export interface Message {
  id: string;
  role: MessageRole;
  content: string;
  timestamp: Date;
  drivePath?: string;
}

export type UserRole = 'ADMIN' | 'TEACHER';
export type AccessLevel = 'BASICO' | 'PRO' | 'ADMIN' | 'SILVER' | 'GOLD';

export interface UserSession {
  id: string;
  email: string;
  role: UserRole;
  accessLevel: AccessLevel;
  isLoggedIn: boolean;
  isEmailConfirmed?: boolean; // New field for security lock
  // driveConnected: boolean; // REMOVIDO: Integração com Google Drive
}

export interface UserSettings {
  userName: string;
  institution: string;
  network: 'Estadual' | 'Municipal' | 'Privada' | '';
  stateUF: string;
  favoriteMethodology: string;
  toneOfVoice: 'Técnico e Formal' | 'Prático e Inspiracional';
  detailLevel: 'Resumido' | 'Completo';
  theme: 'light' | 'dark';
  // Novos campos para personalização de documentos
  headerText?: string;
  footerText?: string;
  logoBase64?: string;
  // Preferências de Estilo Estendidas
  teachingStyle?: 'Tradicional' | 'Construtivista' | 'Sociointeracionista';
  assessmentFocus?: 'Somativa' | 'Formativa' | 'Diagnóstica';
}

export enum ToolMode {
  PLANNING = 'planning',
  QUARTERLY_PLANNING = 'quarterly', // NOVO
  ACTIVITIES = 'activities',
  INCLUSION = 'inclusion',
  SIMULATION = 'simulation',
  ENEM_BANK = 'enem',
  PRESENTATIONS = 'presentations', // NOVO
  AUDITOR = 'auditor',
  CHAT = 'chat',
  ADMIN = 'admin',
  FILES = 'files',
  HISTORY = 'history',
  CLASSES = 'classes',
  ASSESSMENT = 'assessment',
  SPECIALIST = 'specialist' // Action 5
}

// Assessment Types (Ciclo de Feedback Fechado)
export interface AssessmentQuestion {
  id: string;
  type: 'objective' | 'dissertative';
  question: string;
  options?: string[]; // [A, B, C, D, E] para objetivas
  correctAnswer?: string; // Letra correta (A-E)
  rubric?: string; // Critérios de correção para dissertativas
  maxPoints: number;
  difficulty?: 'Fácil' | 'Médio' | 'Difícil';
}

export interface Assessment {
  id: string;
  title: string;
  classId?: string;
  className?: string;
  subject: string;
  questions: AssessmentQuestion[];
  createdAt: string;
  totalPoints: number;
  academicPeriod?: string;
  difficulty?: 'Fácil' | 'Médio' | 'Difícil';
  numEnem?: number;
}

export interface GradingResult {
  questionId: string;
  studentAnswer: string; // Texto extraído via OCR
  score: number;
  maxScore: number;
  feedback: string;
}

// REMOVIDO: Interfaces para Google Drive
/*
export interface DriveFolder {
  id: string;
  name: string;
  files: DriveFile[];
}

export interface DriveFile {
  id: string;
  name: string;
  type: 'DOC' | 'PDF' | 'IMAGE';
  createdAt: Date;
  size: string;
}
*/

export interface Student {
  id: string;
  name: string;
  class_id?: string;
  needs_adaptation: boolean;
  deficiencies: string[];
  pedagogical_observations: string;
}

export interface Class {
  id: string;
  name: string;
  subject: string;
  created_at: string;
  students?: Student[];
}

export interface PdiLog {
  id: string;
  student_id: string;
  class_id: string;
  lesson_id?: string;
  teacher_id: string;
  created_at: string;
  content: string;
  status: string;
}

export interface StudentAdaptation {
  studentId: string;
  studentName: string;
  originalContent: string;
  adaptedContent: string;
  status: 'pending' | 'generating' | 'completed' | 'validated';
}

export interface EnemQuestion {
  id: number;
  similarity?: number;
  // NÃO use o campo 'content' para exibição visual. Use o metadata.
  metadata: {
    id_original: number;
    year: number;
    discipline: string;
    // O texto da questão é dividido em duas partes:
    context: string; // O texto base, a história ou cenário.
    alternativesIntroduction: string; // A pergunta final (comando).

    // Array de alternativas
    alternatives: Array<{
      letter: string; // "A", "B", "C"...
      text: string;   // O texto da resposta
      isCorrect: boolean; // Se é a correta
    }>;

    bncc: string[];
    tags: string[];
  };
}

export interface TermPlan {
  id: string; // Made mandatory for list keying
  period: number;
  regime: 'Bimestre' | 'Trimestre';
  subject: string;
  grade: string;
  level: 'Ensino Fundamental' | 'Ensino Médio';
  workloadWeekly: number;
  reserves: {
    monthlyExam: boolean;
    bimonthlyExam: boolean;
    recovery: boolean;
  };
  totalClasses: number;
  gradingGrid: {
    vistos: number;
    trabalhos: number;
    monthlyExam: number;
    bimonthlyExam: number;
    others: number;
  };
  stateBase?: string;
  educationSphere?: string;
  generatedText: string; // Made mandatory
  created_at: string;
}
