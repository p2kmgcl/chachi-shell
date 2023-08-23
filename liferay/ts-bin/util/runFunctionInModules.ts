import { basename } from 'https://deno.land/std@0.199.0/path/basename.ts';
import { forPromise } from 'https://deno.land/x/kia@0.4.1/mod.ts';
import { resolveModule } from './resolveModule.ts';

export async function runFunctionInModules(
  modules: string[],
  fn: (modulePath: string) => unknown,
  { exitOnError = true, text = '' } = {},
) {
  let hasErrors = false;

  for (const module of modules) {
    try {
      const modulePath = (await resolveModule(module)).unwrap(
        `"${module}" is not an OSGI module`,
      );

      const moduleName = basename(modulePath);

      await forPromise(async () => await fn(modulePath), {
        text: `[${moduleName}] ${text}`,
      });
    } catch (error) {
      console.error(error);
      hasErrors = true;
    }
  }

  if (hasErrors && exitOnError) {
    Deno.exit(1);
  }
}
