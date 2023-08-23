import { runFunctionInModules } from './runFunctionInModules.ts';

export async function runCommandInModules(
  modules: string[],
  commandName: string,
  commandArgs: string[],
  { exitOnError = true } = {},
) {
  await runFunctionInModules(
    modules,
    (modulePath) => {
      const command = new Deno.Command(commandName, {
        cwd: modulePath,
        args: commandArgs,
        stdout: 'inherit',
        stderr: 'inherit',
        stdin: 'inherit',
      });

      return command.spawn().output();
    },
    {
      exitOnError,
      text: commandArgs.join(' '),
    },
  );
}
