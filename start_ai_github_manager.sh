#!/usr/bin/env bash
set -euo pipefail
cd /home/aaron/code/ai-bridge   # repo with your manager scripts
source .env 2>/dev/null || true  # supplies GITHUB_TOKEN, etc.
source .venv/bin/activate        # activate virtual environment
exec python3 ai_github_code_manager.py \
  --tick-seconds 300 \
  --repos "McGyver716/ai-bridge" \
  --models "mistral,llama3" \
  --log-file /var/log/ai-github-manager.log
