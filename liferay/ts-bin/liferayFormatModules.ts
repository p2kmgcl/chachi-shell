#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { runCommandInModules } from './util/runCommandInModules.ts';

await runCommandInModules(Deno.args, 'gw', ['formatSource']);
