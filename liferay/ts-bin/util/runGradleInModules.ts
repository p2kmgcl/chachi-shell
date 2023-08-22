import { basename } from 'https://deno.land/std@0.199.0/path/basename.ts';
import { forPromise } from 'https://deno.land/x/kia@0.4.1/mod.ts';
import { resolveModule } from './resolveModule.ts';

export async function runGradleInModules(
  modules: string[],
  commandArgs: string[],
) {
  for (const module of modules) {
    try {
      const modulePath = (await resolveModule(module)).unwrap();
      const moduleName = basename(modulePath);

      const command = new Deno.Command('gw', {
        cwd: modulePath,
        args: commandArgs,
        stdout: 'inherit',
        stderr: 'inherit',
        stdin: 'inherit',
      });

      await forPromise(() => command.spawn().output(), {
        text: `[${moduleName}] ${commandArgs.join(' ')}`,
      });
    } catch (error) {
      console.error(error);
    }
  }
}
