import React, { useEffect, useRef } from 'react';
import {
  Accessibility,
  BookOpen,
  CalendarRange,
  ChevronLeft,
  ChevronRight,
  ClipboardCheck,
  Crown,
  FileText,
  FolderClosed,
  Home,
  LayoutDashboard,
  LibraryBig,
  LogOut,
  MessageSquare,
  Projector,
  Settings,
  ShieldCheck,
  Users,
  X,
} from 'lucide-react';
import { ToolMode, UserRole, UserProfile } from '../types';
import { isAdmin } from '../services/ProfileService';
import { isHardcodedAdmin } from '../constants';
import { IconButton } from './ui';

interface SidebarProps {
  activeMode: ToolMode;
  setActiveMode: (mode: ToolMode) => void;
  onOpenSettings: () => void;
  isOpen: boolean;
  onClose: () => void;
  userRole?: UserRole;
  isDesktopExpanded?: boolean;
  onToggleDesktopExpand?: () => void;
  userProfile?: UserProfile | null;
  onOpenSubscription: () => void;
  onLogout: () => void;
}

interface MenuItem {
  id: ToolMode;
  icon: React.ElementType;
  label: string;
  group: 'start' | 'planning' | 'content' | 'management';
}

const menuItems: MenuItem[] = [
  { id: ToolMode.HOME, icon: Home, label: 'Início', group: 'start' },
  { id: ToolMode.CHAT, icon: MessageSquare, label: 'Assistente pedagógico', group: 'start' },
  { id: ToolMode.PLANNING, icon: LayoutDashboard, label: 'Planos de aula', group: 'planning' },
  {
    id: ToolMode.QUARTERLY_PLANNING,
    icon: CalendarRange,
    label: 'Planejamento trimestral',
    group: 'planning',
  },
  {
    id: ToolMode.INCLUSION,
    icon: Accessibility,
    label: 'Adaptações PDI e DUA',
    group: 'content',
  },
  { id: ToolMode.ASSESSMENT, icon: ClipboardCheck, label: 'Avaliações', group: 'content' },
  { id: ToolMode.SIMULATION, icon: FileText, label: 'Simulados ENEM e Saeb', group: 'content' },
  { id: ToolMode.PRESENTATIONS, icon: Projector, label: 'Apresentações', group: 'content' },
  { id: ToolMode.FILES, icon: FolderClosed, label: 'Meus arquivos', group: 'management' },
  { id: ToolMode.CLASSES, icon: BookOpen, label: 'Minhas turmas', group: 'management' },
  { id: ToolMode.MY_DOCUMENTS, icon: LibraryBig, label: 'Meus documentos', group: 'management' },
];

const groupLabels: Array<{ id: MenuItem['group']; label: string }> = [
  { id: 'start', label: 'Principal' },
  { id: 'planning', label: 'Planejamento' },
  { id: 'content', label: 'Conteúdo e avaliação' },
  { id: 'management', label: 'Organização' },
];

const Sidebar: React.FC<SidebarProps> = ({
  activeMode,
  setActiveMode,
  onOpenSettings,
  isOpen,
  onClose,
  userRole,
  isDesktopExpanded = true,
  onToggleDesktopExpand,
  userProfile,
  onOpenSubscription,
  onLogout,
}) => {
  const closeButtonRef = useRef<HTMLButtonElement>(null);

  const isAdminOrManager =
    isHardcodedAdmin(userProfile?.email) ||
    userProfile?.is_admin ||
    userProfile?.role === 'admin' ||
    userProfile?.role === 'manager' ||
    userRole === 'SCHOOL_MANAGER' ||
    activeMode === ToolMode.SCHOOL_MANAGER;

  const items: MenuItem[] = isAdminOrManager
    ? [
        ...menuItems,
        {
          id: ToolMode.SCHOOL_MANAGER,
          icon: Users,
          label: 'Gestão escolar',
          group: 'management',
        },
      ]
    : menuItems;

  useEffect(() => {
    if (!isOpen) return undefined;
    closeButtonRef.current?.focus();
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose();
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, onClose]);

  const handleModeSelection = (mode: ToolMode) => {
    setActiveMode(mode);
    onClose();
  };

  const renderItem = (item: MenuItem) => {
    const active = activeMode === item.id;
    const ItemIcon = item.icon;
    return (
      <button
        key={item.id}
        type="button"
        onClick={() => handleModeSelection(item.id)}
        aria-current={active ? 'page' : undefined}
        aria-label={!isDesktopExpanded ? item.label : undefined}
        title={!isDesktopExpanded ? item.label : undefined}
        className={`ui-focus-ring ui-reduce-motion flex min-h-11 w-full items-center gap-3 rounded-lg px-3 py-2.5 text-left text-sm font-medium transition-colors ${
          active ? 'bg-blue-600 text-white' : 'text-slate-300 hover:bg-slate-800 hover:text-white'
        }`}
      >
        <ItemIcon aria-hidden="true" className="h-5 w-5 shrink-0" />
        <span className={`truncate ${isDesktopExpanded ? 'lg:block' : 'lg:hidden'}`}>
          {item.label}
        </span>
      </button>
    );
  };

  return (
    <>
      {isOpen && (
        <button
          type="button"
          className="fixed inset-0 z-[9998] bg-slate-950/55 lg:hidden"
          onClick={onClose}
          aria-label="Fechar menu principal"
        />
      )}

      <aside
        aria-label="Menu principal"
        className={`fixed left-0 top-0 z-[9999] flex h-screen flex-col border-r border-slate-800 bg-slate-950 text-slate-200 transition-[transform,width] duration-200 ui-reduce-motion ${
          isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
        } w-[min(20rem,88vw)] ${isDesktopExpanded ? 'lg:w-64' : 'lg:w-20'}`}
      >
        <div className="flex min-h-16 items-center justify-between gap-2 border-b border-slate-800 px-4">
          <button
            type="button"
            onClick={() => handleModeSelection(ToolMode.HOME)}
            className="ui-focus-ring flex min-w-0 items-center gap-3 rounded-lg text-left"
            aria-label="Ir para o início do ProfePlan"
          >
            <img src="/logo-profeplan.png" alt="" className="h-9 w-9 shrink-0 object-contain" />
            <span
              className={`truncate text-lg font-semibold text-white ${isDesktopExpanded ? 'lg:block' : 'lg:hidden'}`}
            >
              ProfePlan
            </span>
          </button>
          <IconButton
            ref={closeButtonRef}
            label="Fechar menu"
            icon={<X aria-hidden="true" className="h-5 w-5" />}
            onClick={onClose}
            className="border-slate-700 text-slate-200 hover:bg-slate-800 lg:hidden"
          />
          <IconButton
            label={isDesktopExpanded ? 'Recolher menu' : 'Expandir menu'}
            icon={
              isDesktopExpanded ? (
                <ChevronLeft aria-hidden="true" className="h-5 w-5" />
              ) : (
                <ChevronRight aria-hidden="true" className="h-5 w-5" />
              )
            }
            onClick={onToggleDesktopExpand}
            className="hidden border-slate-700 text-slate-300 hover:bg-slate-800 lg:inline-flex"
          />
        </div>

        <nav className="flex-1 overflow-y-auto px-3 py-4" aria-label="Funcionalidades">
          {groupLabels.map((group, index) => {
            const groupItems = items.filter((item) => item.group === group.id);
            return (
              <div key={group.id} className={index === 0 ? '' : 'mt-5'}>
                <p
                  className={`mb-1 px-3 text-xs font-semibold text-slate-500 ${
                    isDesktopExpanded ? 'lg:block' : 'lg:sr-only'
                  }`}
                >
                  {group.label}
                </p>
                <div className="space-y-1">{groupItems.map(renderItem)}</div>
              </div>
            );
          })}

          {(isAdmin(userProfile) || userRole === 'ADMIN') && (
            <div className="mt-5 border-t border-slate-800 pt-4">
              {renderItem({
                id: ToolMode.ADMIN,
                icon: ShieldCheck,
                label: 'Painel administrativo',
                group: 'management',
              })}
            </div>
          )}
        </nav>

        <div className="border-t border-slate-800 p-3">
          <button
            type="button"
            onClick={onOpenSubscription}
            className="ui-focus-ring mb-2 flex min-h-11 w-full items-center gap-3 rounded-lg border border-slate-700 px-3 py-2 text-left text-sm text-slate-200 hover:bg-slate-800"
            aria-label={
              userProfile?.tier === 'GOLD' || userProfile?.is_unlimited
                ? 'Plano Gold ilimitado. Gerenciar plano'
                : `${userProfile?.credits || 0} créditos. Gerenciar plano`
            }
          >
            <Crown aria-hidden="true" className="h-5 w-5 shrink-0 text-amber-400" />
            <span className={`min-w-0 ${isDesktopExpanded ? 'lg:block' : 'lg:hidden'}`}>
              <span className="block font-semibold text-white">
                {userProfile?.tier === 'GOLD' || userProfile?.is_unlimited
                  ? 'Plano Gold'
                  : `${userProfile?.credits || 0} créditos`}
              </span>
              <span className="block text-xs text-slate-400">Gerenciar plano</span>
            </span>
          </button>

          <button
            type="button"
            onClick={() => {
              onOpenSettings();
              onClose();
            }}
            aria-label={!isDesktopExpanded ? 'Configurações' : undefined}
            className="ui-focus-ring flex min-h-11 w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-slate-300 hover:bg-slate-800 hover:text-white"
          >
            <Settings aria-hidden="true" className="h-5 w-5 shrink-0" />
            <span className={isDesktopExpanded ? 'lg:block' : 'lg:hidden'}>Configurações</span>
          </button>
          <button
            type="button"
            onClick={onLogout}
            aria-label={!isDesktopExpanded ? 'Sair do sistema' : undefined}
            className="ui-focus-ring flex min-h-11 w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-slate-300 hover:bg-red-950 hover:text-red-200"
          >
            <LogOut aria-hidden="true" className="h-5 w-5 shrink-0" />
            <span className={isDesktopExpanded ? 'lg:block' : 'lg:hidden'}>Sair do sistema</span>
          </button>
        </div>
      </aside>
    </>
  );
};

export default Sidebar;
