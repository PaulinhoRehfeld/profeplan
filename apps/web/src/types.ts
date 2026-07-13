export enum MessageRole {
  USER = 'user',
  ASSISTANT = 'assistant',
  SYSTEM = 'system',
}

import type { Block9AdaptationEntry } from './types/pdi';

export interface Message {
  id: string;
  role: MessageRole;
  content: string;
  timestamp: Date;
  drivePath?: string;
}

export type UserRole = 'ADMIN' | 'TEACHER' | 'SCHOOL_MANAGER';
export type AccessLevel = 'BASICO' | 'PRO' | 'ADMIN' | 'SILVER' | 'GOLD';

// Consolidated UserProfile
export interface UserProfile {
  id: string;
  email: string;
  role?: 'teacher' | 'manager' | 'admin'; // Database role
  school_id?: string;
  school_name?: string; // Fetched via join
  school?: {
    // Joined school object
    id: string;
    name: string;
    city?: string;
    sre?: string;
  };
  city?: string; // Specific city field
  tier: 'SILVER' | 'GOLD';
  credits: number;
  is_unlimited: boolean;
  is_admin: boolean; // Legacy flag, now used primarily for System Admin
  allowed_features: string[];
  phone?: string;
  full_name?: string;
  masp?: string;
  created_at?: string;
  active_school_id?: string;
  // Configuracoes Pedagogicas
  favorite_methodology?: string;
  teaching_style?: string;
  assessment_focus?: string;
  tone_of_voice?: string;
  // Personalizacao de Documentos
  header_text?: string;
  footer_text?: string;
  logo_base64?: string;
}

export interface UserSession {
  id: string;
  email: string;
  role: UserRole; // App-level role (ADMIN | TEACHER | SCHOOL_MANAGER)
  accessLevel: AccessLevel;
  isLoggedIn: boolean;
  isEmailConfirmed?: boolean;
}

export interface UserSettings {
  userName: string;
  institution: string;
  schoolCode?: string; // Novo: Código INEP da escola
  city?: string; // Novo: Cidade onde atua
  institutionalEmail?: string; // Novo: Email institucional
  masp?: string; // Novo: MASP formatado
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
  HOME = 'home',
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
  SPECIALIST = 'specialist', // Action 5
  SCHOOL_MANAGER = 'school_manager', // NOVO: Painel de Gestão Escolar (Renomeado)
  MY_DOCUMENTS = 'my_documents',
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
  student_code?: string;
  call_number?: number;
  current_school_id?: string;
  // FK/mapeamento oficial para a tabela `school_students` (PDI usa esse id como referência)
  school_student_id?: string;
  school_id?: string; // Alias for compatibility
  class_id?: string;
  current_class_id?: string; // Alias for compatibility
  state_unique_id?: string; // For state-level tracking
  serie?: string; // Legacy support
  pdi_needs?: string[];
  observations?: string;
  deficiencies?: string[]; // Extended field support
  pedagogical_observations?: string; // Extended field support
  needs_adaptation?: boolean;
  created_at?: string;
}

export interface Class {
  id: string;
  name: string;
  subject: string;
  grade?: string;
  shift?: string;
  year?: number;
  room?: string;
  school_id?: string;
  user_id?: string;
  created_at: string;
  updated_at?: string;
  students?: Student[];
}

export interface ClassItem {
  id: string;
  name: string;
  year: number;
  grade?: string;
  shift?: string;
  room?: string;
  student_count?: number;
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
  /**
   * Payload estruturado do Bloco 9 (persistido em pdi_documents.block_9_content ao validar).
   * Opcional porque algumas telas/fluxos ainda só possuem o markdown final.
   */
  block9Payload?: Omit<Block9AdaptationEntry, 'generated_at' | 'generated_by_ai'>;
}

export interface EnemQuestion {
  id: number;
  similarity?: number;
  // NÃO use o campo 'content' para exibição visual. Use o metadata.
  metadata: {
    id_original: number;
    year: number;
    discipline: string;
    disciplina?: string; // Legacy/Portuguese field support
    // O texto da questão é dividido em duas partes:
    context: string; // O texto base, a história ou cenário.
    alternativesIntroduction: string; // A pergunta final (comando).

    // Array de alternativas
    alternatives: Array<{
      letter: string; // "A", "B", "C"...
      text: string; // O texto da resposta
      isCorrect: boolean; // Se é a correta
    }>;

    bncc: string[];
    tags: string[];
  };
}

export interface Lesson {
  number: number;
  title: string;
  description: string;
  objectives: string[];
  bncc: string[];
  content?: string;
}

export interface TermPlan {
  id: string; // Made mandatory for list keying
  title?: string;
  userId?: string;
  period: number;
  regime: 'Trimestre';
  subject: string;
  grade: string;
  level: 'Ensino Fundamental' | 'Ensino Médio';
  workloadWeekly: number;
  reserves: {
    monthlyExam: boolean;
    termExam: boolean; // Alterado de bimonthly
    recovery: boolean;
  };
  totalClasses: number;
  gradingGrid: {
    vistos: number;
    trabalhos: number;
    monthlyExam: number;
    termExam: number; // Alterado de bimonthly
    others: number;
  };
  stateBase?: string;
  educationSphere?: string;
  generatedText: string; // Made mandatory
  lessons?: Lesson[]; // Structured data
  created_at: string;
  pnld_book_id?: string;
}

export interface PnldBook {
  id: string;
  title: string;
  author?: string;
  discipline?: string;
  grade?: string;
  cover_url?: string;
  created_at?: string;
}

// ====== SCHOOL TYPES ======
export interface School {
  id: string;
  name: string;
  inep_code?: string;
  city?: string;
  state?: string;
  sre?: string;
  created_at?: string;
}

export interface SchoolStats {
  totalStudents: number;
  totalTeachers: number;
  totalClasses: number;
  pdiCount?: number;
  schoolName?: string;
}

// ====== TEACHER TYPES ======
export interface Teacher {
  id: string;
  email: string;
  full_name: string;
  masp?: string;
  school_id?: string;
  role?: string;
  created_at?: string;
}

export interface TeacherSchoolLink {
  id: string;
  teacher_id: string;
  school_id: string;
  school_name?: string;
  school_inep?: string;
  role: 'teacher' | 'coordinator' | 'principal';
  disciplines?: string[];
  started_at: string;
  ended_at?: string;
}

// ====== DTO TYPES ======
export interface InviteTeacherDTO {
  email: string;
  full_name: string;
  masp?: string;
  school_id: string;
}

// PDI Types - Export all PDI-related types
export * from './types/pdi';
