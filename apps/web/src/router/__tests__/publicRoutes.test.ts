import { describe, expect, it } from 'vitest';
import {
  isPublicPath,
  PUBLIC_LEGAL_LINKS,
  PUBLIC_LEGACY_ROUTE_PATHS,
  PUBLIC_ROUTE_PATHS,
} from '../publicRoutes';

describe('contrato das rotas públicas e legais', () => {
  it('mantém todas as páginas legais acessíveis sem autenticação', () => {
    expect(PUBLIC_LEGAL_LINKS).toHaveLength(8);

    for (const { href } of PUBLIC_LEGAL_LINKS) {
      expect(isPublicPath(href), `${href} deveria ser pública`).toBe(true);
      expect(PUBLIC_ROUTE_PATHS).toContain(href);
    }
  });

  it('preserva os endereços legais antigos como rotas públicas', () => {
    for (const path of PUBLIC_LEGACY_ROUTE_PATHS) {
      expect(isPublicPath(path), `${path} deveria ser pública`).toBe(true);
    }
  });

  it('não libera rotas do aplicativo autenticado', () => {
    expect(isPublicPath('/app')).toBe(false);
    expect(isPublicPath('/profile-setup')).toBe(false);
    expect(isPublicPath('/select-school')).toBe(false);
    expect(isPublicPath('/admin')).toBe(false);
  });
});
