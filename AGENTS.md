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
4. Create a feature branch (`codex/<task-name>`), never commit directly to `main`.
5. Implement smallest viable diff.
6. Add or update tests for every behavior change.
7. Run required checks locally.
8. Report changed files, commands run, and risks.

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
- Do not push directly to `main` unless explicitly requested by the user for emergency/admin operations.

## Review and Merge Policy
- Open PRs for all non-emergency changes.
- In solo-maintainer mode, self-review in the PR is acceptable when required checks pass.
- In multi-maintainer mode, require at least one external approving review.

## Required Checks Before Completion
- `bin/brakeman --no-pager`
- `bin/bundler-audit --update`
- `bin/rubocop`
- `bundle exec rspec`
- For deploy pipeline changes, confirm `.github/workflows/ci.yml` still gates `deploy-render` behind `security`, `lint`, and `test`.

If a check cannot run, explain exactly why and what remains unverified.

## Testing Policy
- Every functional change must include automated test coverage (request/model/service/system spec as appropriate).
- If adding tests is impossible for a specific change, explicitly document why and propose a follow-up test task.

## Definition of Done
- Acceptance criteria satisfied.
- Required checks pass or blockers documented.
- Docs updated for workflow/behavior changes.
- For infrastructure/scaffolding/governance/CI/CD changes, update `docs/PROJECT_SETUP_BASELINE.md` in the same change.
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
