
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
  id: string; 
  email: string;
  role: UserRole;
  accessLevel: AccessLevel;
  isLoggedIn: boolean;
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
