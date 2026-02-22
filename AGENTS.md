# AGENTS.md

Repository-wide operating rules for autonomous coding agents.

## Scope
- Applies to this repository unless a deeper `AGENTS.md` overrides it.

## Project Constraints
- Framework: Ruby on Rails.
- Database: PostgreSQL.
- Test framework: RSpec.
- CI system: GitHub Actions.
- Deployment target: Render.

## Required Workflow
1. Restate goal, assumptions, and constraints.
2. Read relevant files before editing.
3. Make a short plan for non-trivial tasks.
4. Implement smallest viable diff.
5. Run required checks locally.
6. Report changed files, commands run, and risks.

## Rails Guardrails
- Follow Rails conventions over custom architecture.
- Prefer generators for standard artifacts.
- Keep business logic in models/services, not controllers/views.
- Keep migrations reversible and production-safe.
- Do not bypass validations/callbacks without explicit reason.

## Runtime and Dependency Policy
- Prefer upgrading runtimes/tooling to current stable versions over downgrading app dependencies to match outdated local environments.
- If local runtime is outdated, stop and upgrade runtime first, then continue implementation.
- Do not pin old framework/library versions solely to satisfy an old machine state unless explicitly requested by the user.
- Record runtime/framework version decisions in repository docs so future agents can reproduce setup.

## Safety Rules
- Never commit secrets/credentials/private keys.
- Use environment variables for runtime config.
- Do not run destructive commands unless explicitly requested.
- Ask before breaking API/DB changes.

## Required Checks Before Completion
- `bin/brakeman --no-pager`
- `bin/bundler-audit --update`
- `bin/rubocop`
- `bundle exec rspec`

If a check cannot run, explain exactly why and what remains unverified.

## Definition of Done
- Acceptance criteria satisfied.
- Required checks pass or blockers documented.
- Docs updated for workflow/behavior changes.
- Final report includes:
  - files changed
  - verification commands and outcomes
  - follow-up risks/actions

## Task Prompt Format
Prefer tasks with:
- Goal
- Context
- Constraints
- Acceptance Criteria
- Out of Scope
