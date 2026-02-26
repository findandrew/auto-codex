# Agentic Development Workflow

## Principles
- Small tasks, fast feedback, strict gates.
- Autonomy for implementation, human control for scope and release.
- Every change should be reproducible from repo docs and scripts.

## Recommended loop
1. Intake
- Write a task using `docs/TASK_TEMPLATE.md`.
- Keep scope to one outcome (single feature/fix/refactor).

2. Plan
- Agent lists assumptions and a short execution plan.
- Human confirms or adjusts scope.

3. Execute
- Agent edits only required files.
- Agent runs checks and reports results.
- For UI/auth/preview-sensitive changes, agent runs Playwright smoke validation and shares artifact(s).

4. Review
- Use PR template checklist.
- Validate acceptance criteria first, style second.

5. Merge and Learn
- Merge only when checks pass.
- Add lessons to docs if recurring.

## Branching and PR model
- Agents should implement work on feature branches (`codex/<task-name>`), not `main`.
- Agents should open pull requests to `main`.
- Reviews should happen in GitHub PRs (human reviewer and/or designated review agent).
- Merge only after required checks pass and required approvals are satisfied.
- For solo-maintainer repositories, set required approvals to `0` while keeping PR-required and status checks enforced.
- PR descriptions should include a Render preview link for reviewer validation (automated by workflow).
- PRs should pass preview smoke checks (`pr-preview-smoke`) so reviewer-facing routes do not return 5xx on Render previews.
- Dependency updates should be validated by the `dependency-review` workflow on every PR.

## Multi-agent operating model
- Build agent: writes code and tests in a PR.
- Review agent: performs PR review focused on bugs, regressions, and test adequacy.
- Merge/deploy gate: branch protection + required CI checks enforce safe promotion to `main`.

## Task sizing guidelines
- Good: "Add endpoint X with tests and docs."
- Too large: "Build full auth system + billing + admin UI."

## Failure handling
- If agent gets stuck twice, narrow scope and restate constraints.
- If outputs drift, update `AGENTS.md` with explicit rules.

## Environment drift rule
- When tooling/runtime versions are out of date, upgrade the environment first (for example Ruby, Node, package manager).
- Avoid selecting legacy framework or gem versions as a workaround for an outdated runtime unless explicitly directed.
- After environment upgrades, document final versions and bootstrap steps in the setup record.

## Baseline maintenance rule
- For infrastructure/scaffolding/governance/CI/CD/security-process changes, update `docs/PROJECT_SETUP_BASELINE.md` in the same PR.
- Keep that file final-state oriented: include decisions and resulting configuration, not trial-and-error history.
- Always include a concise \"Docs Update Summary\" section in handoff notes whenever documentation files change.
