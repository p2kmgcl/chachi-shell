#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
hook="$repo_root/home/.config/git/global-hooks/prepare-commit-msg"
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT

mkdir -p "$fixture/bin" "$fixture/calls"
export PI_TEST_CALLS="$fixture/calls"
export PI_TEST_RESPONSE='feat: add staged example'
export PI_TEST_STATUS=0

cat > "$fixture/bin/pi" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$PI_TEST_CALLS/args"
printf '%s\n' "$PWD" > "$PI_TEST_CALLS/cwd"
previous=''
for arg in "$@"; do
  if [[ "$previous" == '--tools' ]]; then
    printf '%s\n' "$arg" > "$PI_TEST_CALLS/tools"
  fi
  previous=$arg
done
printf '%s\n' "$previous" > "$PI_TEST_CALLS/prompt"
cat > "$PI_TEST_CALLS/stdin"
printf '%s' "$PI_TEST_RESPONSE"
if [ "$PI_TEST_STATUS" -ne 0 ]; then
  printf 'Pi request failed\n' >&2
fi
exit "$PI_TEST_STATUS"
STUB
printf '#!/usr/bin/env bash\nexit 99\n' > "$fixture/bin/claude"
chmod +x "$fixture/bin/pi" "$fixture/bin/claude"
export PATH="$fixture/bin:$PATH"
export GIT_CONFIG_GLOBAL=/dev/null
export GIT_CONFIG_NOSYSTEM=1
unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

git init -q "$fixture/repo"
cd "$fixture/repo"
git config core.hooksPath /dev/null
git config user.name Test
git config user.email test+user@example.com
for number in 1 2 3 4 5 6; do
  printf 'historical-content-not-for-the-prompt\n' > "history-$number.txt"
  git add "history-$number.txt"
  git -c commit.gpgsign=false commit -qm "Update history item $number" -m "Explain history item $number."
done
printf 'other author content\n' > other-author.txt
git add other-author.txt
git -c user.email=other-test+user@example.com -c commit.gpgsign=false commit -qm 'Exclude this other author'

printf 'staged-content-not-for-the-prompt\n' > example.txt
git add example.txt
printf 'unstaged-content\n' > example.txt
message="$fixture/message"

bash "$hook" "$message"
if [[ $(<"$message") != "$PI_TEST_RESPONSE" ]] || [[ $(<"$PI_TEST_CALLS/cwd") != "$PWD" ]]; then
  echo 'Expected Pi to generate the message in the current repository' >&2
  exit 1
fi
if ! grep -Fqx $'  A\texample.txt' "$PI_TEST_CALLS/prompt"; then
  echo 'Expected the prompt to list staged files with their Git status' >&2
  exit 1
fi
expected_messages=$'    Update history item 6\n    Update history item 5\n    Update history item 4\n    Update history item 3\n    Update history item 2'
actual_messages=$(grep -E '^    Update history item [0-9]+$' "$PI_TEST_CALLS/prompt")
if [[ "$actual_messages" != "$expected_messages" ]] || [[ $(grep -c '^<recent-commit>$' "$PI_TEST_CALLS/prompt") -ne 5 ]]; then
  echo 'Expected the five most recent commits by the current author, newest first' >&2
  exit 1
fi
if ! grep -Fqx '    Explain history item 6.' "$PI_TEST_CALLS/prompt"; then
  echo 'Expected recent commit examples to include their message bodies' >&2
  exit 1
fi
for number in 6 5 4 3 2; do
  if ! grep -Fqx $'    A\thistory-'"$number.txt" "$PI_TEST_CALLS/prompt"; then
    echo 'Expected historical commit examples to include indented changed-file lists' >&2
    exit 1
  fi
done
if [[ -s "$PI_TEST_CALLS/stdin" ]] || grep -Eq 'historical-content|staged-content|unstaged-content|Exclude this other author|history-1.txt|other-author.txt' "$PI_TEST_CALLS/prompt"; then
  echo 'Expected file lists without contents, diffs, or unrelated commit examples' >&2
  exit 1
fi
if grep -Eq '^--(provider|model|thinking)(=|$)' "$PI_TEST_CALLS/args"; then
  echo 'Expected Pi to inherit the default model and thinking level' >&2
  exit 1
fi
if grep -Fqx -- '--no-extensions' "$PI_TEST_CALLS/args" || ! grep -Fqx -- '--no-mcp' "$PI_TEST_CALLS/args"; then
  echo 'Expected configured provider extensions to load while MCP stays disabled' >&2
  exit 1
fi
IFS=, read -r -a tools < "$PI_TEST_CALLS/tools"
for tool in "${tools[@]}"; do
  case "$tool" in
    read|grep|find|ls) ;;
    *) echo "Expected read-only tools, got $tool" >&2; exit 1 ;;
  esac
done
if [[ $(git show :example.txt) != 'staged-content-not-for-the-prompt' ]] || [[ $(<example.txt) != 'unstaged-content' ]]; then
  echo 'Expected generation to preserve staged and unstaged changes' >&2
  exit 1
fi

export PI_TEST_RESPONSE=$'Update staged example\n\nExplain why the staged example is needed.\n\n- Preserve staged content\n- Keep existing behavior'
bash "$hook" "$message"
if [[ $(<"$message") != "$PI_TEST_RESPONSE" ]]; then
  echo 'Expected author-style messages to preserve their subject, body, and formatting' >&2
  exit 1
fi

printf 'existing message\n' > "$message"
export PI_TEST_STATUS=42
export PI_TEST_RESPONSE='Incomplete response'
if bash "$hook" "$message" 2> "$fixture/error"; then
  echo 'Expected a failed Pi request to stop commit preparation' >&2
  exit 1
else
  status=$?
fi
if [[ "$status" -ne 42 ]] || [[ $(<"$message") != 'existing message' ]] || ! grep -Fq 'Pi request failed' "$fixture/error"; then
  echo 'Expected Pi failures to preserve the message and report the error' >&2
  exit 1
fi

export PI_TEST_STATUS=0
for response in '' '   ' $'\n \t\n' $'Update example\r' '```Update example```'; do
  export PI_TEST_RESPONSE="$response"
  if bash "$hook" "$message" 2> "$fixture/error"; then
    echo 'Expected an empty or malformed message to stop commit preparation' >&2
    exit 1
  fi
  if [[ $(<"$message") != 'existing message' ]] || [[ ! -s "$fixture/error" ]]; then
    echo 'Expected invalid output to preserve the message and report an error' >&2
    exit 1
  fi
done

rm "$PI_TEST_CALLS/args"
for source in message commit merge squash; do
  bash "$hook" "$message" "$source"
done
git reset -q HEAD -- example.txt
bash "$hook" "$message"
if [[ -e "$PI_TEST_CALLS/args" ]] || [[ $(<"$message") != 'existing message' ]]; then
  echo 'Expected existing commit sources and an empty index to skip generation' >&2
  exit 1
fi

git init -q "$fixture/unborn"
cd "$fixture/unborn"
git config user.name Test
git config user.email test+user@example.com
printf 'first file\n' > first.txt
git add first.txt
export PI_TEST_RESPONSE='Add first file'
bash "$hook" "$message"
if [[ $(<"$message") != "$PI_TEST_RESPONSE" ]] || grep -Fq '<recent-commit>' "$PI_TEST_CALLS/prompt"; then
  echo 'Expected an initial commit to work without historical examples' >&2
  exit 1
fi

echo 'prepare-commit-msg tests passed'
