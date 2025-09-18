#!/bin/bash
set -euo pipefail

# Promote a tag to gold branch
TAG="$1"

if [[ -z "$TAG" ]]; then
    echo "❌ Usage: $0 <tag>"
    echo "   Example: $0 v1.0.0"
    exit 1
fi

echo "🥇 Promoting $TAG to gold..."

# Verify tag exists
if ! git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "❌ Tag $TAG does not exist"
    exit 1
fi

# Create or update gold branch
git fetch origin
git checkout -B gold "$TAG"
git push origin gold --force-with-lease

echo "✅ $TAG promoted to gold branch"
echo "💡 To rollback later: make rollback"
