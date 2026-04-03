# Server Setup

One-time setup to enable GitOps deployment. After this, pushing to
`master` triggers GitHub Actions, which SSHes into the server through
your Cloudflare tunnel and runs Ansible.

## Prerequisites

- Arch Linux server with `sudo` access
- Cloudflare tunnel with SSH exposed (already configured at `server.0001608.xyz`)

## 1. Install Ansible

```bash
sudo pacman -S ansible python rsync
```

## 2. Clone the repo

```bash
sudo mkdir -p /opt/homelab
sudo chown $(whoami):$(whoami) /opt/homelab
git clone https://github.com/YOUR_USER/homelab-docker.git /opt/homelab
```

If the repo is private, use an SSH clone URL or a personal access token.

## 3. Extract and configure secrets

```bash
cd /opt/homelab

# Extract existing API keys and secrets from running services
./scripts/extract-secrets.sh

# Paste the output into the vault file
vim ansible/vars/vault.yml

# Set a vault password and encrypt
cd ansible
echo 'your-strong-password' > .vault_password
chmod 600 .vault_password
ansible-vault encrypt vars/vault.yml
```

The `.vault_password` file stays on the server (gitignored). Ansible
reads it automatically via `ansible.cfg`.

## 4. Test locally

```bash
cd /opt/homelab/ansible

# Dry run -- shows what would change, changes nothing
ansible-playbook playbook.yml --check --diff

# Real run
ansible-playbook playbook.yml
```

## 5. Set up SSH access for GitHub Actions

Generate a dedicated deploy key:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/github-deploy -N "" -C "github-actions-deploy"
cat ~/.ssh/github-deploy.pub >> ~/.ssh/authorized_keys
```

Copy the **private** key (`~/.ssh/github-deploy`) -- you'll paste it
into GitHub in the next step.

## 6. Configure GitHub secrets

In **GitHub repo > Settings > Secrets and variables > Actions**, add:

| Secret | Value |
|--------|-------|
| `SSH_PRIVATE_KEY` | Contents of `~/.ssh/github-deploy` (the private key) |

If your SSH endpoint has a Cloudflare Access policy (Zero Trust), also add:

| Secret | Value |
|--------|-------|
| `CF_ACCESS_CLIENT_ID` | Service token client ID from Cloudflare Zero Trust |
| `CF_ACCESS_CLIENT_SECRET` | Service token client secret |

These are optional -- only needed if Cloudflare Access protects SSH.
Create a service token in Cloudflare Zero Trust > Access > Service Auth.

## 7. Verify

Push a commit to `master` and check the Actions tab. The workflow will:
1. SSH into your server through the Cloudflare tunnel
2. `git pull` the latest changes
3. Run `ansible-playbook playbook.yml`

## How it works

```
git push → GitHub Actions (ubuntu runner) → SSH through cloudflared
  → server: git pull → ansible-playbook (runs locally)
```

No software is installed on the server beyond Ansible and standard
tools. GitHub Actions is just a remote trigger over SSH.
