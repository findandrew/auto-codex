#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   GITHUB_TOKEN=... ./scripts/lockdown_github.sh [owner] [repo]
# Defaults:
#   owner=findandrew repo=auto-codex

OWNER="${1:-findandrew}"
REPO="${2:-auto-codex}"
: "${GITHUB_TOKEN:?Set GITHUB_TOKEN with repo admin scope}"

API="https://api.github.com/repos/${OWNER}/${REPO}"
AUTH=(-H "Authorization: Bearer ${GITHUB_TOKEN}" -H "Accept: application/vnd.github+json")

echo "Configuring branch protection for ${OWNER}/${REPO}: main"

curl -sS -X PUT "${API}/branches/main/protection" \
  "${AUTH[@]}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["security", "lint", "test"]
    },
    "enforce_admins": true,
    "required_pull_request_reviews": {
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": true,
      "required_approving_review_count": 1,
      "require_last_push_approval": false
    },
    "restrictions": null,
    "required_linear_history": true,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "block_creations": false,
    "required_conversation_resolution": true,
    "lock_branch": false,
    "allow_fork_syncing": true
  }' >/tmp/branch_protection_response.json

echo "Enabling security-and-analysis features"
curl -sS -X PATCH "${API}" "${AUTH[@]}" -H "X-GitHub-Api-Version: 2022-11-28" \
  -d '{"security_and_analysis":{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}}' >/tmp/repo_security_response.json || true

echo "Done. Branch protection response: /tmp/branch_protection_response.json"
