#!/usr/bin/env bash

echo "==============================="
echo " Git Multi-Profile Setup Wizard"
echo "==============================="
echo
echo "This script will help you configure separate Personal and Work Git profiles"
echo "with SSH keys and Git identity management."
echo

# --- Ask for Personal Info ---
read -p "👉 Enter your Personal Name (e.g., John Doe): " PERSONAL_NAME
read -p "👉 Enter your Personal Email (e.g., john@example.com): " PERSONAL_EMAIL

# --- Ask for Work Info ---
read -p "👉 Enter your Work Name (e.g., John W. Doe): " WORK_NAME
read -p "👉 Enter your Work Email (e.g., john@company.com): " WORK_EMAIL

# --- Confirm SSH Key Generation ---
echo
read -p "Do you want me to generate new SSH keys for both profiles? (y/n): " GEN_KEYS

SSH_DIR="$HOME/.ssh"
mkdir -p "$SSH_DIR"

if [[ "$GEN_KEYS" == "y" || "$GEN_KEYS" == "Y" ]]; then
    echo "🔑 Generating SSH keys..."
    ssh-keygen -t ed25519 -C "$PERSONAL_EMAIL" -f "$SSH_DIR/id_ed25519_personal" -N ""
    ssh-keygen -t ed25519 -C "$WORK_EMAIL" -f "$SSH_DIR/id_ed25519_work" -N ""
else
    echo "⚠️ Skipping key generation. Make sure you already have SSH keys created!"
fi

# --- Update SSH Config ---
echo
echo "⚙️ Updating your SSH config (~/.ssh/config)..."
SSH_CONFIG="$SSH_DIR/config"

# Backup existing config
if [[ -f "$SSH_CONFIG" ]]; then
    cp "$SSH_CONFIG" "$SSH_CONFIG.backup.$(date +%s)"
    echo "📂 Backup of existing config created: $SSH_CONFIG.backup"
fi

cat <<EOF > "$SSH_CONFIG"
# --- Personal GitHub ---
Host github.com-personal
  HostName github.com
  User git
  IdentityFile $SSH_DIR/id_ed25519_personal

# --- Work GitHub ---
Host github.com-work
  HostName github.com
  User git
  IdentityFile $SSH_DIR/id_ed25519_work

# --- Work GitLab (optional) ---
Host gitlab.com-work
  HostName gitlab.com
  User git
  IdentityFile $SSH_DIR/id_ed25519_work
EOF

chmod 600 "$SSH_CONFIG"
echo "✅ SSH config updated!"

# --- Configure Global Git Identity ---
echo
echo "Setting your global Git identity to PERSONAL by default..."
git config --global user.name "$PERSONAL_NAME"
git config --global user.email "$PERSONAL_EMAIL"

# --- Setup IncludeIf configs ---
echo
echo "📂 Creating Git config rules for work vs personal projects..."
GITCONFIG="$HOME/.gitconfig"
GITCONFIG_WORK="$HOME/.gitconfig-work"
GITCONFIG_PERSONAL="$HOME/.gitconfig-personal"

cat <<EOF > "$GITCONFIG_PERSONAL"
[user]
    name = $PERSONAL_NAME
    email = $PERSONAL_EMAIL
EOF

cat <<EOF > "$GITCONFIG_WORK"
[user]
    name = $WORK_NAME
    email = $WORK_EMAIL
EOF

cat <<EOF >> "$GITCONFIG"

[includeIf "gitdir:~/work/"]
    path = $GITCONFIG_WORK

[includeIf "gitdir:~/personal/"]
    path = $GITCONFIG_PERSONAL
EOF

echo "✅ Conditional Git configs created!"
echo
echo "==============================="
echo " Next Steps:"
echo "==============================="
echo "1. Add the following SSH public keys to your GitHub/GitLab accounts:"
echo
echo "   Personal Key:"
echo "   $(cat $SSH_DIR/id_ed25519_personal.pub)"
echo
echo "   Work Key:"
echo "   $(cat $SSH_DIR/id_ed25519_work.pub)"
echo
echo "2. Clone repos using the proper aliases:"
echo "   - Personal: git clone git@github.com-personal:username/repo.git"
echo "   - Work:     git clone git@github.com-work:company/repo.git"
echo
echo "🎉 Done! Your laptop is now ready to handle both Personal and Work Git profiles."
