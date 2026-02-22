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

4. Review
- Use PR template checklist.
- Validate acceptance criteria first, style second.

5. Merge and Learn
- Merge only when checks pass.
- Add lessons to docs if recurring.

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
