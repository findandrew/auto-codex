# Auto Codex Rails Starter

Opinionated baseline for highly autonomous development with:
- Ruby on Rails + PostgreSQL
- GitHub Actions CI (Brakeman, Bundler Audit, RuboCop, RSpec)
- Render blueprint deployment
- Agent constraints in `AGENTS.md`

## Stack
- Ruby `3.4.8` (pinned in `.ruby-version`)
- Rails `8.1.x`
- PostgreSQL
- RSpec

## Local setup
1. Install Ruby `3.4.8` with your preferred version manager (`rbenv`, `asdf`, `mise`).
2. Install dependencies:
   - `bundle install`
3. Create and migrate DB:
   - `bin/rails db:prepare`
4. Run app:
   - `bin/rails server`
5. Open:
   - [http://localhost:3000](http://localhost:3000)

The root route `/` and `/hello` return a simple hello world page.

## Quality checks
- Security scan: `bin/brakeman --no-pager`
- Gem vulnerability scan: `bin/bundler-audit --update`
- Lint: `bin/rubocop`
- Tests: `bundle exec rspec`

## CI
GitHub Actions workflow: `.github/workflows/ci.yml`
- `security` job: Brakeman + Bundler Audit
- `lint` job: RuboCop
- `test` job: PostgreSQL-backed RSpec
- `deploy-render` job: triggers Render deploy on `push` to `main` after checks pass
- PR preview workflow: `.github/workflows/pr-render-preview-link.yml` updates PR descriptions with Render preview links

## Release Gate
- `main` must pass all required checks before deployment:
  - `security`
  - `lint`
  - `test`
- `deploy-render` is CI-gated behind those checks and is the canonical production deployment path.
- Any change that modifies behavior should include or update automated tests so CI can validate it.

## Deployment (Render)
Blueprint file: `render.yaml`
- Web service build: `bundle install && bundle exec rails assets:precompile`
- Start: `bundle exec puma -C config/puma.rb`
- Pre-deploy migration: `bundle exec rails db:migrate`
- Health check: `/up`
- GitHub Actions deploy inputs:
  - Repository secret: `RENDER_API_KEY`
  - Repository variable: `RENDER_SERVICE_ID`
- Render PR previews:
  - Service setting: `previews.generation=automatic`
  - PR descriptions include preview URL via automation markers in PR template (or an explicit unavailable status if Render has not emitted a preview URL yet)

## Governance
- Agent operating rules: `AGENTS.md`
- Setup baseline record: `docs/PROJECT_SETUP_BASELINE.md`
- PR template: `.github/pull_request_template.md`
- Code ownership: `.github/CODEOWNERS` (replace placeholder)
- Branch protection checklist: `docs/BRANCH_PROTECTION.md`
- Security policy: `SECURITY.md`
