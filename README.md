# setup-personal-work-git-profiles

This repository contains a Bash script to help you set up and manage separate Personal and Work Git profiles on your machine, including SSH key generation and conditional Git configuration.

## Features
- Interactive setup for Personal and Work Git profiles
- SSH key generation for each profile
- Automatic SSH config updates for multiple GitHub/GitLab accounts
- Conditional Git configuration using `includeIf` rules

## Usage
1. **Run the setup script:**
	```bash
	bash setup-git-profiles.sh
	```
2. **Follow the prompts:**
	- Enter your personal and work name/email
	- Choose whether to generate new SSH keys
3. **Add SSH public keys to your GitHub/GitLab accounts:**
	- Personal key: `~/.ssh/id_ed25519_personal.pub`
	- Work key: `~/.ssh/id_ed25519_work.pub`
4. **Clone repositories using the correct SSH alias:**
	- Personal: `git clone git@github.com-personal:username/repo.git`
	- Work: `git clone git@github.com-work:company/repo.git`

## How it works
- Updates your global Git identity to your personal profile by default
- Creates conditional Git configs for work and personal directories
- Backs up your existing SSH config before making changes

## Next Steps
After running the script, your laptop will be ready to handle both Personal and Work Git profiles seamlessly.

---
**Note:** Always back up your SSH and Git config files before running scripts that modify them.