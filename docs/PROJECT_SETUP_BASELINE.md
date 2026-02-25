# Project Setup Baseline

Canonical setup record for this repository. This is the source of truth for future agent bootstraps.

## Why this file exists
- Human-scannable summary of final setup decisions.
- Agent-friendly, reproducible sequence for creating a new project with the same baseline.
- Final state only; excludes intermediate trial/error.

## Final decisions
- Language/runtime: Ruby `3.4.x` (repo pin `.ruby-version` is `3.4.4`, local install includes `3.4.8`)
- Framework: Rails `8.1.x`
- Database: PostgreSQL
- Test framework: RSpec
- Security/lint tooling: Brakeman, Bundler Audit, RuboCop, pre-commit
- CI: GitHub Actions
- Deployment target: Render (Blueprint + PostgreSQL)
- Governance: CODEOWNERS + strict branch protection + PR template + security policy + agent rules

## Canonical setup steps
1. Initialize repository and baseline governance files.
2. Install Ruby `3.4.8` with `rbenv`, set shell init, and pin with `.ruby-version`.
3. Install Rails and generate app in repo root:
   - `rails new . --database=postgresql --skip-git --force`
4. Add RSpec:
   - `bundle add rspec-rails --group 'development,test'`
   - `bin/rails generate rspec:install`
5. Add hello-world endpoint:
   - Root and `/hello` route to `PagesController#hello`
   - View renders `Hello, world!`
   - Request spec asserts 200 and response text
6. Configure CI pipeline with required quality/security gates:
   - `security`: Brakeman + Bundler Audit
   - `lint`: RuboCop
   - `test`: PostgreSQL-backed RSpec
   - `dependency-review`: GitHub dependency diff policy check on PRs
   - `deploy-render`: on `push` to `main`, trigger Render deploy after checks pass
   - `pr-render-preview-link`: on PR updates, inject Render preview URL into PR description
7. Add Render deployment blueprint:
   - `render.yaml` with web service + managed PostgreSQL
   - pre-deploy migrations and `/up` health check
8. Enforce guardrails and branch governance docs.
9. Run validation checks and resolve all failures.
10. Push `main` to GitHub remote and verify Actions run succeeds.
11. Provision Render PostgreSQL and web service, set required env vars, and verify public URL.

## Current implementation map
- Agent policy: `/Users/andrew/Git/auto-codex/AGENTS.md`
- Workflow guidance: `/Users/andrew/Git/auto-codex/docs/AGENT_WORKFLOW.md`
- CI workflow: `/Users/andrew/Git/auto-codex/.github/workflows/ci.yml`
- Dependency review workflow: `/Users/andrew/Git/auto-codex/.github/workflows/dependency-review.yml`
- Deploy blueprint: `/Users/andrew/Git/auto-codex/render.yaml`
- Ownership policy: `/Users/andrew/Git/auto-codex/.github/CODEOWNERS`
- Branch protection checklist: `/Users/andrew/Git/auto-codex/docs/BRANCH_PROTECTION.md`
- Security policy: `/Users/andrew/Git/auto-codex/SECURITY.md`
- App entry route: `/Users/andrew/Git/auto-codex/config/routes.rb`
- Hello controller: `/Users/andrew/Git/auto-codex/app/controllers/pages_controller.rb`
- Hello view: `/Users/andrew/Git/auto-codex/app/views/pages/hello.html.erb`
- Request spec: `/Users/andrew/Git/auto-codex/spec/requests/pages_spec.rb`

## Required verification commands
- `bin/brakeman --no-pager`
- `bin/bundler-audit --update`
- `bin/rubocop`
- `bundle exec rspec`
- `python3 -m pre_commit run --files $(rg --files)`
- Verify GitHub Actions run for `.github/workflows/ci.yml` is green.
- Verify hosted Render URLs:
  - `/` returns `Hello, world!`
  - `/up` returns healthy status page

## CI/CD gate requirements
- CI jobs `security`, `lint`, and `test` are required branch-protection checks for `main`.
- PR job `dependency-review` is required for merge to protect against risky dependency changes.
- Production deploy must happen through CI `deploy-render` job after those checks succeed.
- Direct manual production deploys should be treated as emergency fallback only.
- Behavior changes must ship with automated tests so release gating remains meaningful.

## GitHub integration state
- Remote: `git@github.com:findandrew/auto-codex.git`
- Default branch used in this bootstrap: `main`
- CI workflow in use: `/Users/andrew/Git/auto-codex/.github/workflows/ci.yml`
- Render deploy from CI is configured in `deploy-render` job.
- Render preview integration requirement:
  - Install Render GitHub App and grant repository access to `findandrew/auto-codex`.
- Required GitHub Actions configuration:
  - Secret: `RENDER_API_KEY`
  - Variable: `RENDER_SERVICE_ID` = `srv-d6dmaa14tr6s73culd80`
- Example successful run URL:
  - `https://github.com/findandrew/auto-codex/actions/runs/22284656064`
- Branch protection state on `main`:
  - PR required for merge
  - required checks: `security`, `lint`, `test`
  - required checks also include `dependency-review`
  - branch up-to-date required (`strict` checks)
  - required approvals set to `0` for solo-maintainer mode
  - code owner review required
  - stale reviews dismissed on new commits
  - enforce for admins enabled
  - force push disabled
  - branch deletion disabled
  - linear history required
  - conversation resolution required

## Render integration state
- Web service: `auto-codex-web`
- Public URL: `https://auto-codex-web.onrender.com`
- PR previews: enabled (`previews.generation=automatic`)
- Database: `auto-codex-db` (Postgres 16, free plan for initial bootstrap)
- Required env vars on Render service:
  - `RAILS_ENV=production`
  - `RAILS_LOG_TO_STDOUT=enabled`
  - `WEB_CONCURRENCY=2`
  - `DATABASE_URL` (from Render Postgres connection string)
  - `SECRET_KEY_BASE` (generated in Render env vars)

## Known deployment gotchas
- If Render build fails with missing `secret_key_base`, add `SECRET_KEY_BASE` env var and redeploy.
- Patch-level Ruby pins can fail on hosted builders; prefer a supported `3.4.x` strategy and keep Gemfile Ruby range compatible (`>= 3.4.4`, `< 3.5`).
- If Render auto-deploy webhooks are inconsistent, CI-triggered deploy via `deploy-render` is the canonical release path.
- PR preview URL may take a few minutes after PR open/sync; preview-link workflow polls GitHub deployments for Render environment URL.
- If no Render preview URL is emitted for a PR, the PR description is updated with an explicit unavailable message instead of a broken link.
- If preview URL is unavailable, PR description includes Render Previews dashboard link for the service.
- If previews are still not generated, re-check Render GitHub App installation/repo access first.

## New-project reuse checklist
- Copy `AGENTS.md`, `docs/PROJECT_SETUP_BASELINE.md`, and `.github` governance files first.
- Upgrade/install current stable runtime before generating app code.
- Generate Rails app and apply the same CI/deploy/governance pattern.
- Replace placeholders:
  - `.github/CODEOWNERS`
  - `SECURITY.md`
  - Render service/database names in `render.yaml`

## Notes
- Policy for future agents: upgrade runtime first; do not downgrade framework to fit old runtimes unless explicitly requested.
- Policy for collaboration: agents should work on `codex/*` branches and open PRs to `main`; direct pushes to `main` are reserved for explicit emergency/admin instruction.
- Policy for baseline docs: whenever infra/scaffolding/governance/CI/CD setup changes, update this file in the same PR.
- Solo repository policy: keep PR-required + required checks, but use `0` required approvals so a single maintainer can merge after self-review.
- Review policy: preview links in PR description are the default reviewer entrypoint for branch validation.
- GitHub Actions policy: workflows should use least-privilege `permissions` and `concurrency` cancellation to reduce token blast radius and stale-run noise.
