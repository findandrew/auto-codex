# GitHub App Agent Automation

This document defines the GitHub-first agent workflow for this repository.

## Required configuration

### GitHub App
- App name: `auto-codex-bot` (or equivalent)
- Install on repository: `findandrew/auto-codex`
- Required repository permissions:
  - Contents: Read and write
  - Pull requests: Read and write
  - Issues: Read and write
  - Metadata: Read-only
  - Deployments: Read-only
- Required subscribed events:
  - `issue_comment`
  - `pull_request_review_comment`
  - `pull_request`
  - `issues`

### Repository Actions secrets
- `APP_ID`: numeric GitHub App ID
- `APP_PRIVATE_KEY`: full `.pem` private key contents
- `RENDER_API_KEY`: Render API key (already used by deploy workflow)
- Optional: `APP_WEBHOOK_SECRET`

## Active workflows

### 1) PR feedback loop (`agent-pr-feedback`)
- Trigger: PR comments and PR review comments.
- Wake words: `@auto-codex`, `/auto-codex`, `@findandrew-bot`.
- Trusted commenters only: `OWNER`, `MEMBER`, `COLLABORATOR`.
- Behavior:
  - Parses request.
  - Writes execution log to `docs/agent_runs/pr-<number>.md`.
  - Commits log to PR branch (same-repo PRs only).
  - Posts app-authored status comment back to PR.

### 2) Issue proposal drafting (`agent-issue-proposals`)
- Trigger: manual (`workflow_dispatch`) and weekly schedule (Mondays 14:00 UTC).
- Reads backlog sources:
  - `docs/ROADMAP.md` unchecked checklist items.
  - `docs/CUSTOMER_FEEDBACK.md` bullet signals.
- Opens non-duplicate issues with labels:
  - `proposal`
  - `roadmap` or `customer-feedback`

### 3) Preview screenshot capture (`pr-playwright-preview-artifacts`)
- Trigger: PR open/update.
- Resolves Render preview URL from deployment statuses.
- Captures screenshots with Playwright from preview pages.
- Uploads artifact: `playwright-preview-pr-<number>`.
- Comments PR with Actions run URL to retrieve artifacts.

## Verification checklist in GitHub UI
1. Open repository Actions tab.
2. Confirm workflow files are present and enabled:
   - `agent-pr-feedback`
   - `agent-issue-proposals`
   - `pr-playwright-preview-artifacts`
3. Open a PR from a branch in this repo and comment:
   - `@auto-codex status`
4. Confirm in PR timeline:
   - A new commit appears updating `docs/agent_runs/pr-<number>.md`.
   - A bot comment acknowledges execution.
5. In Actions tab, open `pr-playwright-preview-artifacts` run:
   - Confirm artifact `playwright-preview-pr-<number>` exists.
6. Trigger `agent-issue-proposals` manually from Actions:
   - Confirm new issues are opened (if backlog items exist).

## Operational notes
- Fork PRs are intentionally read-only for agent writes.
- If no Render preview URL exists yet, Playwright workflow exits gracefully.
- Keep backlog source files curated to avoid noisy issue creation.

<!-- sync 2026-02-26T03:27:58Z -->
