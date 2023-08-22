import { join } from 'https://deno.land/std@0.199.0/path/join.ts';
import { Option } from './Option.ts';
import { pathIsOSGIModule } from './pathIsOSGIModule.ts';
import { resolvePath } from './resolvePath.ts';

type AbsoluteEntry = { name: string; path: string };

function isValidEntry(entry: Deno.DirEntry) {
  return entry.isDirectory && !entry.name.startsWith('.');
}

function resolveEntry(basePath: string, entry: Deno.DirEntry): AbsoluteEntry {
  return { name: entry.name, path: join(basePath, entry.name) };
}

async function getDir(basePath: string) {
  const entries: AbsoluteEntry[] = [];

  for await (const entry of Deno.readDir(basePath)) {
    if (isValidEntry(entry)) {
      entries.push(resolveEntry(basePath, entry));
    }
  }

  return entries;
}

export async function resolveModule(moduleName: string) {
  if (await pathIsOSGIModule(moduleName)) {
    return Option.some(moduleName);
  }

  let entryList = await getDir(resolvePath('modules'));

  while (entryList.length) {
    const nextEntryList: AbsoluteEntry[] = [];

    for (const entry of entryList) {
      if (entry.name === moduleName && (await pathIsOSGIModule(entry.path))) {
        return Option.some(entry.path);
      }

      nextEntryList.push(...(await getDir(entry.path)));
    }

    entryList = nextEntryList;
  }

  return Option.none;
}
