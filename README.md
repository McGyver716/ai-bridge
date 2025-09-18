# AI Ops Hardening Kit

Turn your AI prototype into production-grade infrastructure.

## What This Gives You
- **Source of truth** repo structure and checklists
- **GitHub Actions CI** with lint, health checks, artifact upload
- **Branch/Tag workflow** with `gold` branch for last known-good
- **Health + Smoke scripts** (systemd, HTTP, GitHub token validation)
- **Systemd units** to keep services running on boot
- **Pre-commit hooks** to prevent bad commits
- **Release + rollback** commands via Makefile

## Quickstart
```bash
# 1. Extract into your repo root
unzip ai-ops-hardening-kit.zip -d .

# 2. Setup
make setup
cp .env.example .env  # Edit with your values

# 3. First release
make release VERSION=0.1.0
make promote-gold TAG=v0.1.0

# 4. Daily operations
make health    # Check all services
make smoke     # Verify GitHub integration
make rollback  # Emergency rollback to gold
```

## File Structure
```
├── Makefile                     # Core operations
├── .github/workflows/ci.yml     # Continuous integration
├── scripts/
│   ├── health_check.sh         # System health validation
│   ├── smoke_github_pr.sh      # GitHub PR capability test
│   └── promote_to_gold.sh      # Release promotion
├── ops/systemd/                # Service definitions
├── CHECKLISTS/                 # Release & DR procedures
└── .env.example               # Environment template
```
