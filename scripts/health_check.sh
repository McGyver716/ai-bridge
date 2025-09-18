#!/bin/bash
set -euo pipefail

# AI Ops Health Check Script
echo "🏥 AI Operations Health Check"
echo "================================"

HEALTH_REPORT="reports/health-$(date +%Y%m%d-%H%M%S).json"
mkdir -p reports

# Initialize health report
cat > "$HEALTH_REPORT" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "checks": {}
}
EOF

add_check() {
    local name="$1"
    local status="$2"
    local details="$3"
    
    python3 -c "
import json
with open('$HEALTH_REPORT', 'r') as f:
    data = json.load(f)
data['checks']['$name'] = {'status': '$status', 'details': '$details'}
with open('$HEALTH_REPORT', 'w') as f:
    json.dump(data, f, indent=2)
"
}

# Check 1: Git repository status
echo "📋 Checking Git repository..."
if git status --porcelain | grep -q .; then
    add_check "git_status" "WARNING" "Uncommitted changes detected"
    echo "⚠️  Uncommitted changes detected"
else
    add_check "git_status" "OK" "Repository clean"
    echo "✅ Repository clean"
fi

# Check 2: Environment variables
echo "📋 Checking environment variables..."
required_vars=("GITHUB_TOKEN" "GH_OWNER" "GH_REPO")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        missing_vars+=("$var")
    fi
done

if [[ ${#missing_vars[@]} -eq 0 ]]; then
    add_check "environment" "OK" "All required variables set"
    echo "✅ All required environment variables set"
else
    add_check "environment" "ERROR" "Missing: ${missing_vars[*]}"
    echo "❌ Missing environment variables: ${missing_vars[*]}"
fi

# Check 3: Python environment
echo "📋 Checking Python environment..."
if python3 --version >/dev/null 2>&1; then
    python_version=$(python3 --version)
    add_check "python" "OK" "$python_version"
    echo "✅ $python_version"
else
    add_check "python" "ERROR" "Python3 not found"
    echo "❌ Python3 not found"
fi

# Check 4: Required packages
echo "📋 Checking Python packages..."
missing_packages=()
for package in requests; do
    if ! python3 -c "import $package" >/dev/null 2>&1; then
        missing_packages+=("$package")
    fi
done

if [[ ${#missing_packages[@]} -eq 0 ]]; then
    add_check "python_packages" "OK" "All required packages available"
    echo "✅ All required packages available"
else
    add_check "python_packages" "ERROR" "Missing: ${missing_packages[*]}"
    echo "❌ Missing packages: ${missing_packages[*]}"
fi

# Check 5: Systemd services (if applicable)
if systemctl --version >/dev/null 2>&1; then
    echo "📋 Checking systemd services..."
    services=("igor-voiceops" "ai-github-manager")
    service_status=""
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            service_status+="$service:active "
        elif systemctl list-unit-files | grep -q "$service"; then
            service_status+="$service:inactive "
        else
            service_status+="$service:not-found "
        fi
    done
    
    add_check "systemd_services" "INFO" "$service_status"
    echo "ℹ️  Services: $service_status"
fi

# Check 6: Network connectivity
echo "📋 Checking network connectivity..."
if curl -s https://api.github.com >/dev/null; then
    add_check "network" "OK" "GitHub API reachable"
    echo "✅ GitHub API reachable"
else
    add_check "network" "ERROR" "Cannot reach GitHub API"
    echo "❌ Cannot reach GitHub API"
fi

echo "📊 Health report saved: $HEALTH_REPORT"
echo "================================"
