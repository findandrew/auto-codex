#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <preview-url>" >&2
  exit 1
fi

PREVIEW_URL="${1%/}"
SESSION="${PLAYWRIGHT_CLI_SESSION:-preview-smoke}"

if ! command -v npx >/dev/null 2>&1; then
  echo "npx is required. Install Node.js/npm first." >&2
  exit 1
fi

export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PWCLI="$CODEX_HOME/skills/playwright/scripts/playwright_cli.sh"

if [ ! -x "$PWCLI" ]; then
  chmod +x "$PWCLI" 2>/dev/null || true
fi

if [ ! -x "$PWCLI" ]; then
  echo "Playwright wrapper not found or not executable at $PWCLI" >&2
  echo "Install skill: python3 $CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py --repo openai/skills --path skills/.curated/playwright" >&2
  exit 1
fi

mkdir -p output/playwright

extract_json() {
  python3 -c 'import json,re,sys; t=sys.stdin.read(); m=re.search(r"### Result\s*\n(\{[\s\S]*?\})\s*\n###", t, re.S); sys.exit(2) if not m else None; print(json.dumps(json.loads(m.group(1))))'
}

extract_screenshot_path() {
  python3 -c 'import re,sys; t=sys.stdin.read(); m=re.search(r"\((\.playwright-cli/[^)]+\.png)\)", t); sys.exit(2) if not m else None; print(m.group(1))'
}

pw() {
  "$PWCLI" --session "$SESSION" "$@"
}

cleanup() {
  pw close >/dev/null 2>&1 || true
}
trap cleanup EXIT

pw open "$PREVIEW_URL/registration/new" >/dev/null

ok=false
for _ in {1..18}; do
  pw goto "$PREVIEW_URL/registration/new" >/dev/null
  raw="$(pw eval '() => ({title: document.title, hasCreateAccount: document.body.innerText.includes("Create account"), url: document.location.pathname})')"
  result="$(printf '%s' "$raw" | extract_json || true)"
  if [ -z "$result" ]; then
    echo "playwright-smoke: empty eval parse, retrying..." >&2
    sleep 5
    continue
  fi
  title="$(printf '%s' "$result" | python3 -c 'import json,sys; print(json.loads(sys.stdin.read()).get("title",""))' 2>/dev/null || true)"
  has_create="$(printf '%s' "$result" | python3 -c 'import json,sys; print(str(json.loads(sys.stdin.read()).get("hasCreateAccount",False)).lower())' 2>/dev/null || true)"
  echo "playwright-smoke: title='$title' hasCreateAccount=$has_create" >&2

  if [ "$has_create" = "true" ]; then
    ok=true
    break
  fi

  sleep 5
done

if [ "$ok" != "true" ]; then
  echo "Playwright smoke failed: /registration/new did not render Create account" >&2
  exit 1
fi

shot_raw="$(pw screenshot)"
shot_path="$(printf '%s' "$shot_raw" | extract_screenshot_path || true)"
if [ -n "$shot_path" ] && [ -f "$shot_path" ]; then
  cp "$shot_path" output/playwright/preview-registration-new.png
fi

pw goto "$PREVIEW_URL/projects" >/dev/null

raw="$(pw eval '() => ({path: document.location.pathname, hasSignIn: document.body.innerText.includes("Sign in")})')"
result="$(printf '%s' "$raw" | extract_json)"
path_val="$(printf '%s' "$result" | python3 -c 'import json,sys; print(json.loads(sys.stdin.read()).get("path",""))')"
has_signin="$(printf '%s' "$result" | python3 -c 'import json,sys; print(str(json.loads(sys.stdin.read()).get("hasSignIn",False)).lower())')"

if [ "$path_val" != "/session/new" ] && [ "$has_signin" != "true" ]; then
  echo "Playwright smoke failed: expected auth redirect when opening /projects, got path=$path_val" >&2
  exit 1
fi

echo "Playwright preview smoke passed for $PREVIEW_URL"
