# homelab-docker

GitOps-managed home server configuration. Push to `master` to deploy.

## Architecture

- **Ansible** manages the full server: system packages, Docker, and the compose stack
- **GitHub Actions** SSHes into the server through the Cloudflare tunnel and runs Ansible
- **Watchtower** automatically updates container images daily at 4am
- **Cloudflare Tunnel** (managed in server-infra) provides remote access

```
git push → GitHub Actions → SSH through cloudflared → server: git pull + ansible-playbook
```

## Repository structure

```
ansible/          Ansible playbooks and roles
  inventory/      Localhost connection config
  vars/           Variables and vault-encrypted secrets
  roles/
    system/       OS packages, SSH, firewall, sysctl
    docker/       Docker engine, daemon config, prune timer
    services/     Compose sync, config templating, deployment
compose/          Docker Compose stack
  docker-compose.yml
  jellyfin/
  sonarr/
  ...
scripts/          Helper scripts
docs/             Setup guides
```

## First-time setup

See [docs/setup.md](docs/setup.md) for the full walkthrough. Summary:

1. Install Ansible on the server: `sudo pacman -S ansible python rsync`
2. Clone this repo to `/opt/homelab`
3. Run `./scripts/extract-secrets.sh` to pull existing API keys from running services
4. Fill in and encrypt `ansible/vars/vault.yml`
5. Set `SSH_PRIVATE_KEY` in GitHub repo secrets
6. Push -- deployment runs automatically

## Usage

### Automatic (GitOps)

Push to `master`. GitHub Actions SSHes into the server, pulls, and runs Ansible.

### Manual deploy (on the server)

```bash
cd /opt/homelab/ansible
ansible-playbook playbook.yml
```

### Dry run

```bash
ansible-playbook playbook.yml --check --diff
```

### Deploy only services

```bash
ansible-playbook playbook.yml --tags services
```

## Secrets

Secrets live in `ansible/vars/vault.yml`, encrypted with Ansible Vault.
The vault password file stays on the server (`ansible/.vault_password`, gitignored).

If vault secrets still have placeholder values (`CHANGEME`), Ansible skips
templating configs -- existing server files stay untouched.

To edit secrets:

```bash
cd /opt/homelab/ansible
ansible-vault edit vars/vault.yml
```
