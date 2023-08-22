#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { runGradleInModules } from './util/runGradleInModules.ts';

await runGradleInModules(Deno.args, [
  'clean',
  'deploy',
  '-Dbuild=portal',
  '-Dnodejs.node.env=development',
]);
