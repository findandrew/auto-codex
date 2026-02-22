# Branch Protection Baseline

Configure these settings on your default branch (`main`) in GitHub.

## Required settings
- Require a pull request before merging.
- Require at least 1 approval.
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

## Recommended security features
- Secret scanning + push protection.
- Dependabot alerts and security updates.
- CodeQL default setup.
