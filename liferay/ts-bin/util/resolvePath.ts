import { join } from 'https://deno.land/std@0.199.0/path/mod.ts';

import { Option } from './Option.ts';

export function resolvePath(itemPath: string) {
  const portalPath = Option.fromNullable(
    Deno.env.get('LIFERAY_PORTAL_PATH'),
  ).unwrap();

  if (!itemPath) {
    return portalPath;
  }

  if (itemPath.startsWith(portalPath)) {
    return itemPath;
  }

  return join(portalPath, itemPath);
}
