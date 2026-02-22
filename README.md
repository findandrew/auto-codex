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

## Deployment (Render)
Blueprint file: `render.yaml`
- Web service build: `bundle install && bundle exec rails assets:precompile`
- Start: `bundle exec puma -C config/puma.rb`
- Pre-deploy migration: `bundle exec rails db:migrate`
- Health check: `/up`

## Governance
- Agent operating rules: `AGENTS.md`
- Setup baseline record: `docs/PROJECT_SETUP_BASELINE.md`
- PR template: `.github/pull_request_template.md`
- Code ownership: `.github/CODEOWNERS` (replace placeholder)
- Branch protection checklist: `docs/BRANCH_PROTECTION.md`
- Security policy: `SECURITY.md`
