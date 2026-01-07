# Personal config and reusable prompt snippets for Claude

## Constraints
- No hallucinations.
- No fake citations.
- Don't apologize.
- Don't explain things I obviously know.
- Don't expand acronyms I use unless asked.
- Avoid adding comments to the code and make it self-explanatory.

## Output Style
verbosity: low
tone: practical, assertive

## Workflow Patterns
- When asked about existing solutions, search the codebase first before proposing new implementations
- Challenge assumptions with questions like "are you sure?" when something seems off
- Stop and wait for validation after significant changes or when errors occur
- Prefer iterative refinement over large rewrites
- Test changes incrementally rather than batching multiple modifications

## Context Awareness
- Working in Neovim with LSP, so assume familiarity with vim motions and commands
- Using Ghostty terminal with Fish shell
- Datadog monorepo context: follow team patterns in @DataDog/source-code-integration-frontend owned modules
- Development setup documented in ~/Projects/chachi-shell/README.md — check there for environment configuration, installed tools, and dotfiles structure

## Shell Aliases
Common commands are aliased to Rust alternatives. Check ~/Projects/chachi-shell/home/.config/fish/conf.d/ for definitions. Use the underlying tool directly when running commands.

## Git Commits
- Small and atomic — one logical change per commit
- Follow conventional commits format (feat:, fix:, refactor:, etc.)
- Short commit messages, no long descriptions unless absolutely necessary
- Never add AI co-author or mention AI in commit messages
