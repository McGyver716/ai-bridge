# Disaster Recovery Runbook

## Emergency Contacts
- Primary: [Your Contact]
- Secondary: [Backup Contact]
- Escalation: [Manager/Team Lead]

## Quick Recovery Commands

### Immediate System Rollback
```bash
cd /path/to/repo
make rollback
sudo systemctl restart igor-voiceops
sudo systemctl restart ai-github-manager
```

### Check System Status
```bash
make health
make smoke
sudo systemctl status igor-voiceops
sudo systemctl status ai-github-manager
```

### View Recent Logs
```bash
sudo journalctl -u igor-voiceops -f
tail -f /home/aaron/github_manager.log
```

## Common Issues & Solutions

### Service Won't Start
1. Check systemd status: `sudo systemctl status <service>`
2. Check logs: `sudo journalctl -u <service> -n 50`
3. Verify configuration files exist
4. Check file permissions
5. Restart: `sudo systemctl restart <service>`

### GitHub Integration Broken (422 Errors)
1. Verify token: `curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user`
2. Check repository permissions
3. Verify branch exists on GitHub
4. Check for existing PRs with same head/base

### Database Issues
1. Check disk space: `df -h`
2. Verify database files exist and are readable
3. Check for lock files
4. Backup and restore if needed

### Network/API Issues
1. Check internet connectivity: `ping 8.8.8.8`
2. Test GitHub API: `curl https://api.github.com`
3. Verify DNS resolution
4. Check firewall rules

## Recovery Scenarios

### Complete System Failure
1. Access backup system/environment
2. Clone repository: `git clone <repo-url>`
3. Checkout gold branch: `git checkout gold`
4. Run setup: `make setup`
5. Configure environment: `cp .env.example .env` (edit values)
6. Deploy services: Install systemd units and start

### Data Loss
1. Stop all services immediately
2. Assess extent of data loss
3. Restore from most recent backup
4. Verify data integrity
5. Restart services gradually
6. Monitor for consistency issues

### Security Incident
1. Immediately rotate all tokens/keys
2. Stop affected services
3. Assess scope of compromise
4. Update credentials in all systems
5. Deploy security patches
6. Monitor for unusual activity

## Prevention & Monitoring
- [ ] Daily health checks scheduled
- [ ] Backup verification weekly  
- [ ] Security updates monthly
- [ ] DR drill quarterly
- [ ] Documentation review bi-annually

## Post-Incident
- [ ] Document timeline of events
- [ ] Identify root cause
- [ ] Implement preventive measures
- [ ] Update runbook based on lessons learned
- [ ] Conduct post-mortem review
