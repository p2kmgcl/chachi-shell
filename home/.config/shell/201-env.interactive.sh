# $SHELL reflects the user's preferred login shell, not the shell currently running this script.
# Re-detecting on every interactive start ensures non-login shells get the correct value
# rather than inheriting the wrong one from the parent process.
if [ -n "$BASH_VERSION" ]; then
  export CURRENT_SHELL=bash
elif [ -n "$ZSH_VERSION" ]; then
  export CURRENT_SHELL=zsh
else
  export CURRENT_SHELL=$(ps -p $$ -o comm= | sed 's/^-//')
fi
