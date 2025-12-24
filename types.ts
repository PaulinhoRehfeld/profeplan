


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
export type AccessLevel = 'BASICO' | 'PRO' | 'ADMIN';

export interface UserSession {
  email: string;
  role: UserRole;
  accessLevel: AccessLevel;
  isLoggedIn: boolean;
  driveConnected: boolean;
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
}

export enum ToolMode {
  PLANNING = 'planning',
  ACTIVITIES = 'activities',
  INCLUSION = 'inclusion',
  SIMULATION = 'simulation',
  AUDITOR = 'auditor',
  CHAT = 'chat',
  ADMIN = 'admin',
  FILES = 'files'
}

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

// Fix: Define the AIStudio interface to satisfy the expected named type
// and resolve the "subsequent property declarations" and "identical modifiers" errors.
interface AIStudio {
  hasSelectedApiKey: () => Promise<boolean>;
  openSelectKey: () => Promise<void>;
}

// In a module, directly declaring `interface Window` augments the global Window interface.
// This is the correct pattern and often resolves "subsequent property declarations" errors.
interface Window {
  aistudio: AIStudio;
}