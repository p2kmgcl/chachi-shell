#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { resolvePath } from './util/resolvePath.ts';
import { runCommandInModules } from './util/runCommandInModules.ts';

await runCommandInModules(Deno.args, resolvePath('gradlew'), [
  'clean',
  'deploy',
  '-Dbuild=portal',
  '-Dnodejs.node.env=development',
]);
