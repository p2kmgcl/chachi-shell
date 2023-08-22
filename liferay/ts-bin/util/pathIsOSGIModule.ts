import { resolvePath } from './resolvePath.ts';

const NOT_OSGI_MODULES_NAMES = ['portal-impl', 'portal-kernel'];

export async function pathIsOSGIModule(maybeModulePath: string) {
  const modulePath = resolvePath(maybeModulePath);

  for (const notOSGIModuleName of NOT_OSGI_MODULES_NAMES) {
    const notOSGIModulePath = resolvePath(notOSGIModuleName);

    if (notOSGIModulePath === modulePath) {
      return false;
    }
  }

  try {
    for await (const child of Deno.readDir(modulePath)) {
      if (child.isFile && child.name === 'bnd.bnd') {
        return true;
      }
    }
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) {
      return false;
    }

    throw error;
  }

  return false;
}
