# Playwright QA Baseline

Use Playwright CLI for browser-level validation whenever a change affects UI routes, auth flows, navigation, or Render preview behavior.

## Prerequisites
- Node/npm installed (`npx` available).
- Playwright skill installed at `$CODEX_HOME/skills/playwright`.
- Wrapper script executable:
  - `chmod +x $CODEX_HOME/skills/playwright/scripts/playwright_cli.sh`

## Repository configuration
- Default Playwright CLI config: `/Users/andrew/Git/auto-codex/playwright-cli.json`
- Reusable preview smoke script: `/Users/andrew/Git/auto-codex/scripts/qa_preview_playwright.sh`
- Artifact directory: `/Users/andrew/Git/auto-codex/output/playwright`

## When agents must run Playwright
- PR includes view/template/layout changes.
- PR includes auth/session/registration flow changes.
- PR includes preview/deployment changes where browser behavior matters.
- Human reviewer reports "works in CI but broken in browser" behavior.

## Canonical command
```bash
scripts/qa_preview_playwright.sh <render-preview-url>
```

Example:
```bash
scripts/qa_preview_playwright.sh https://auto-codex-web-pr-9.onrender.com
```

## What the smoke script validates
- `/registration/new` eventually renders `Create account` (handles Render cold-start/loading page).
- `/projects` enforces auth guard (redirect/sign-in state).
- Saves screenshot artifact to `output/playwright/preview-registration-new.png`.

## Reviewer note
This script complements request specs and curl smoke checks; it does not replace model/request tests in RSpec.
