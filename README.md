# Git Profile Management Scripts

This repository contains scripts to streamline the management of multiple Git identities (e.g., personal and work) on a single machine. It simplifies handling different user names, emails, and SSH keys across various Git hosting providers like GitHub and GitLab.

## Scripts Overview

There are two scripts in this repository. The recommended script for most users is `reset-ssh-and-setup.sh`.

---

### 🚀 `reset-ssh-and-setup.sh` (Recommended)

This script provides a "clean slate" approach to configuring your Git environment. It backs up your existing SSH configuration, removes it, and creates a fresh, simplified setup using a single SSH key for all your accounts. This is the easiest and most reliable method.

#### What It Does:
1.  **Backs Up SSH:** Your entire `~/.ssh` directory is safely backed up into a timestamped `.zip` file in your home directory.
2.  **Resets SSH:** Deletes the `~/.ssh` directory to start fresh.
3.  **Generates a Single SSH Key:** Creates one new `ed25519` SSH keypair, which you will use for both your work and personal accounts.
4.  **Configures SSH:** Sets up the `~/.ssh/config` file to use this single key for different hosts (e.g., `github.com` for personal, `code.roche.com` for work).
5.  **Sets Git Identities:**
    *   Configures your **work identity** as the global default.
    *   Uses a conditional `includeIf` rule in your `.gitconfig`. Any repository located inside the `~/personal/` directory will automatically use your **personal Git identity**.
6.  **Guides Next Steps:** Instructs you to add the single public key to all your Git accounts (GitHub, GitLab, etc.) and shows how to clone repositories normally.

#### Usage:
```bash
bash reset-ssh-and-setup.sh
```
Follow the interactive prompts. The script will guide you through the rest.

---

### ⚠️ `depricated-setup-git-profiles.sh` (Deprecated)

This is the older script and is **not recommended** for new setups. It uses a more complex approach by creating separate SSH keys for each profile and requires using special host aliases when cloning repositories. It is kept here for historical purposes.

#### What It Does:
1.  **Generates Multiple SSH Keys:** Creates two separate `ed25519` keypairs: one for personal (`id_ed25519_personal`) and one for work (`id_ed25519_work`).
2.  **Configures SSH Aliases:** Modifies the `~/.ssh/config` file to create host aliases (e.g., `github.com-personal`, `github.com-work`).
3.  **Sets Git Identities:**
    *   Configures your **personal identity** as the global default.
    *   Uses conditional `includeIf` rules to switch to your work identity for repos inside `~/work/`.
4.  **Requires Alias for Cloning:** To use the correct SSH key, you must remember to use the correct alias when cloning a repository (e.g., `git clone git@github.com-personal:user/repo.git`). This is easy to forget and can lead to errors.

---

## Key Differences

| Feature | `reset-ssh-and-setup.sh` (Recommended) | `depricated-setup-git-profiles.sh` (Deprecated) |
| :--- | :--- | :--- |
| **Strategy** | Clean slate, single SSH key for simplicity. | Additive setup, multiple SSH keys. |
| **SSH Keys** | **One key** for all accounts. | **Separate keys** for each profile. |
| **Cloning** | Normal `git clone` command. | Requires special aliases (e.g., `github.com-personal`). |
| **Default Git ID**| Work | Personal |
| **Complexity** | Low | High |

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
