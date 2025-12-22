
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
export type AccessLevel = 'BASICO' | 'PRO' | 'PREMIUM';

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
