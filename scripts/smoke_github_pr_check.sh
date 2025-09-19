#!/bin/bash
set -euo pipefail

# GitHub PR Capability Smoke Test
echo "💨 GitHub Integration Smoke Test"
echo "================================="

# Check required environment variables
if [[ -z "${GITHUB_TOKEN:-}" ]] || [[ -z "${GH_OWNER:-}" ]] || [[ -z "${GH_REPO:-}" ]]; then
    echo "❌ Required environment variables not set:"
    echo "   GITHUB_TOKEN, GH_OWNER, GH_REPO"
    exit 1
fi

SMOKE_REPORT="reports/smoke-$(date +%Y%m%d-%H%M%S).json"
mkdir -p reports

# Test 1: GitHub API authentication
echo "🔐 Testing GitHub authentication..."
response=$(curl -s -w "%{http_code}" -H "Authorization: token $GITHUB_TOKEN"     "https://api.github.com/user" -o /tmp/gh_user.json)

if [[ "$response" == "200" ]]; then
    username=$(jq -r '.login' /tmp/gh_user.json)
    echo "✅ Authenticated as: $username"
    auth_status="OK"
    auth_details="Authenticated as $username"
else
    echo "❌ Authentication failed (HTTP $response)"
    auth_status="ERROR"
    auth_details="HTTP $response"
fi

# Test 2: Repository access
echo "📁 Testing repository access..."
response=$(curl -s -w "%{http_code}" -H "Authorization: token $GITHUB_TOKEN"     "https://api.github.com/repos/$GH_OWNER/$GH_REPO" -o /tmp/gh_repo.json)

if [[ "$response" == "200" ]]; then
    repo_name=$(jq -r '.name' /tmp/gh_repo.json)
    echo "✅ Repository access: $repo_name"
    repo_status="OK"
    repo_details="Access confirmed to $repo_name"
else
    echo "❌ Repository access failed (HTTP $response)"
    repo_status="ERROR"
    repo_details="HTTP $response"
fi

# Test 3: Branch listing
echo "🌿 Testing branch access..."
response=$(curl -s -w "%{http_code}" -H "Authorization: token $GITHUB_TOKEN"     "https://api.github.com/repos/$GH_OWNER/$GH_REPO/branches" -o /tmp/gh_branches.json)

if [[ "$response" == "200" ]]; then
    branch_count=$(jq '. | length' /tmp/gh_branches.json)
    echo "✅ Found $branch_count branches"
    branch_status="OK"
    branch_details="$branch_count branches accessible"
else
    echo "❌ Branch listing failed (HTTP $response)"
    branch_status="ERROR"
    branch_details="HTTP $response"
fi

# Test 4: Check for existing gold branch
echo "🥇 Checking for gold branch..."
if jq -e '.[] | select(.name == "gold")' /tmp/gh_branches.json >/dev/null; then
    echo "✅ Gold branch exists"
    gold_status="OK"
    gold_details="Gold branch found"
else
    echo "⚠️  Gold branch not found (will be created on first promotion)"
    gold_status="WARNING"
    gold_details="Gold branch missing"
fi

# Generate smoke report
cat > "$SMOKE_REPORT" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "tests": {
    "github_auth": {
      "status": "$auth_status",
      "details": "$auth_details"
    },
    "repository_access": {
      "status": "$repo_status",
      "details": "$repo_details"
    },
    "branch_access": {
      "status": "$branch_status",
      "details": "$branch_details"
    },
    "gold_branch": {
      "status": "$gold_status",
      "details": "$gold_details"
    }
  }
}
EOF

echo "📊 Smoke test report saved: $SMOKE_REPORT"

# Cleanup
rm -f /tmp/gh_user.json /tmp/gh_repo.json /tmp/gh_branches.json

echo "================================="
