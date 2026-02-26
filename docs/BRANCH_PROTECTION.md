# Branch Protection Baseline

Configure these settings on your default branch (`main`) in GitHub.

## Required settings
- Require a pull request before merging.
- Require approvals:
  - Solo-maintainer mode: `0` (self-review in PR + required checks)
  - Multi-maintainer mode: at least `1`
- Require review from Code Owners.
- Dismiss stale approvals when new commits are pushed.
- Require status checks to pass before merging.
- Require branches to be up to date before merging.
- Block force pushes.
- Block branch deletion.
- Apply rules to administrators.

## Required status checks
- `security`
- `lint`
- `test`
- `dependency-review`
- `smoke` (from `pr-preview-smoke` workflow)

## Fast apply (API)
If you have a GitHub token with repo admin scope:
- `GITHUB_TOKEN=... /Users/andrew/Git/auto-codex/scripts/lockdown_github.sh findandrew auto-codex`

## Recommended security features
- Secret scanning + push protection.
- Dependabot alerts and security updates.
- CodeQL default setup.
