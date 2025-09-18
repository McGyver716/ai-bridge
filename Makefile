.PHONY: setup health smoke release promote-gold rollback clean

# Load environment variables
include .env
export

# Default target
help:
	@echo "AI Ops Hardening Kit Commands:"
	@echo "  make setup         - Initial setup (deps, git hooks)"
	@echo "  make health        - Check all services and dependencies"
	@echo "  make smoke         - Test GitHub integration and PR capability"
	@echo "  make release       - Create new version tag (use VERSION=x.x.x)"
	@echo "  make promote-gold  - Promote tag to gold branch (use TAG=vx.x.x)"
	@echo "  make rollback      - Rollback to gold version"
	@echo "  make clean         - Clean temporary files"

setup:
	@echo "🔧 Setting up AI Ops environment..."
	pip install pre-commit black isort flake8
	pre-commit install
	git config advice.addIgnoredFile false
	chmod +x scripts/*.sh
	@echo "✅ Setup complete"

health:
	@echo "🏥 Running health checks..."
	./scripts/health_check.sh
	@echo "✅ Health check complete"

smoke:
	@echo "💨 Running smoke tests..."
	./scripts/smoke_github_pr.sh
	@echo "✅ Smoke tests complete"

release:
ifndef VERSION
	$(error VERSION is required. Use: make release VERSION=1.0.0)
endif
	@echo "🚀 Creating release $(VERSION)..."
	git tag -a v$(VERSION) -m "Release v$(VERSION)"
	git push origin v$(VERSION)
	@echo "✅ Release v$(VERSION) created"

promote-gold:
ifndef TAG
	$(error TAG is required. Use: make promote-gold TAG=v1.0.0)
endif
	@echo "🥇 Promoting $(TAG) to gold..."
	./scripts/promote_to_gold.sh $(TAG)
	@echo "✅ $(TAG) promoted to gold"

rollback:
	@echo "⚠️  Rolling back to gold version..."
	git fetch origin
	git checkout -B main origin/gold
	git push origin main --force-with-lease
	@echo "✅ Rollback complete"

clean:
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete
	rm -rf .pytest_cache/
	rm -rf reports/*.tmp
