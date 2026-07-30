export const PUBLIC_LEGAL_LINKS = [
  { label: 'Política de Privacidade', href: '/politica-de-privacidade' },
  { label: 'Termos de Uso', href: '/termos-de-uso' },
  { label: 'Política de Cookies', href: '/politica-de-cookies' },
  { label: 'Direitos do Titular', href: '/direitos-do-titular' },
  { label: 'Dados Educacionais', href: '/dados-educacionais' },
  { label: 'Cancelamento e Reembolso', href: '/cancelamento-e-reembolso' },
  { label: 'Transparência em IA', href: '/transparencia-em-ia' },
  { label: 'Segurança e LGPD', href: '/seguranca-e-lgpd' },
] as const;

export const PUBLIC_ROUTE_PATHS = [
  '/landing',
  '/login',
  '/signup',
  '/verify-email',
  '/road',
  '/cancelamento/formulario',
  ...PUBLIC_LEGAL_LINKS.map(({ href }) => href),
] as const;

export const PUBLIC_LEGACY_ROUTE_PATHS = [
  '/privacy',
  '/terms',
  '/privacidade',
  '/termos',
  '/cookies',
  '/lgpd',
  '/politica-privacidade',
  '/termos-uso',
] as const;

const publicPaths = new Set<string>([...PUBLIC_ROUTE_PATHS, ...PUBLIC_LEGACY_ROUTE_PATHS]);

export const isPublicPath = (pathname: string): boolean => publicPaths.has(pathname);
