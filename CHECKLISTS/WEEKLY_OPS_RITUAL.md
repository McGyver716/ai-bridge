# Weekly Ops Ritual (15 minutes)

## Purpose
Prevent system drift and ensure continuous operational excellence

## Every Wednesday @ 10:00 AM

### 🔍 **Health Verification** (5 minutes)
- [ ] `make smoke` - verify token scopes & PR permissions
- [ ] `make health` - check system components
- [ ] `journalctl -u ai-github-manager -n 200` - scan for errors
- [ ] `systemctl --user status ops-reset.timer` - verify midnight automation

### 📊 **Evidence Review** (5 minutes)
- [ ] Review `reports/DEPLOY_LOG.md` - ensure recent changes documented
- [ ] Check CI status at https://github.com/McGyver716/ai-bridge/actions
- [ ] Verify `gold` branch points to stable release
- [ ] Review any open AI-generated PRs for quality

### 🚀 **Release Management** (5 minutes)
- [ ] If healthy, tag point release: `make release VERSION=X.Y.Z`
- [ ] Promote to gold if stable: `make promote-gold TAG=vX.Y.Z`
- [ ] Update `reports/DEPLOY_LOG.md` with new deployment evidence
- [ ] Open 1 canary PR from AI to verify template & policy gates

### 🛡️ **Safety Verification**
- [ ] Branch protection active on `main`
- [ ] CODEOWNERS enforcing human review for critical paths
- [ ] AI PR policy blocking oversized/risky changes
- [ ] Smoke tests preventing 422-class regressions

### 📱 **OBS & Media Pipeline**
- [ ] Test screen capture: launch OBS, verify PipeWire working
- [ ] Check `/home/aaron/media/` directory structure intact
- [ ] Verify Kdenlive accessible: `flatpak run org.kde.kdenlive`
- [ ] Test end-to-end: record 10s clip → edit → export

## Emergency Procedures

### If Any Check Fails:
1. **Document** the failure in `reports/DEPLOY_LOG.md`
2. **Rollback** if needed: `make rollback`
3. **Restart services**: `sudo systemctl restart ai-github-manager`
4. **Re-run checks** to verify recovery

### Escalation
- If rollback fails: Contact @McGyver716
- If AI generates risky PRs: Review CODEOWNERS and AI PR policy
- If midnight reset fails: Check systemd timer status

## Success Criteria
✅ All health checks green
✅ Evidence trail up-to-date
✅ Release tagged and promoted
✅ OBS operational for social media clipping
✅ No drift detected in any system
