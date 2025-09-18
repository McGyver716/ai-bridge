# Release Checklist

## Pre-Release (Development)
- [ ] All tests passing locally
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] `make health` passes
- [ ] `make smoke` passes
- [ ] No critical security issues
- [ ] Performance acceptable

## Release Process
- [ ] Create release branch: `git checkout -b release/vX.Y.Z`
- [ ] Update version numbers in relevant files
- [ ] Run full test suite: `make health && make smoke`
- [ ] Create release: `make release VERSION=X.Y.Z`
- [ ] Verify release artifacts
- [ ] Test deployment in staging environment

## Post-Release
- [ ] Monitor system health for 24 hours
- [ ] Check error logs and metrics
- [ ] Verify all services running correctly
- [ ] Update monitoring dashboards
- [ ] Promote to gold if stable: `make promote-gold TAG=vX.Y.Z`

## Rollback Plan (if issues arise)
- [ ] Identify issue and impact
- [ ] Execute rollback: `make rollback`
- [ ] Verify system stability
- [ ] Investigate root cause
- [ ] Plan hotfix if needed

## Communication
- [ ] Notify stakeholders of release
- [ ] Update status pages/dashboards
- [ ] Document any known issues
- [ ] Schedule post-release review
