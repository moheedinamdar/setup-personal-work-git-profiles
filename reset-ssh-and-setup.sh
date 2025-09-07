#!/usr/bin/env bash

echo "==============================="
echo " Git + SSH Reset & Setup Wizard"
echo "==============================="

# --- Ask for names/emails ---
read -p "👉 Work Name (default identity): " WORK_NAME
read -p "👉 Work Email: " WORK_EMAIL
read -p "👉 Personal Name: " PERSONAL_NAME
read -p "👉 Personal Email: " PERSONAL_EMAIL

SSH_DIR="$HOME/.ssh"
BACKUP_DIR="$HOME/.ssh-backup-$(date +%Y%m%d-%H%M%S).zip"

# --- Step 1: Backup existing .ssh ---
if [[ -d "$SSH_DIR" ]]; then
    echo "📦 Backing up existing $SSH_DIR to $BACKUP_DIR ..."
    zip -r "$BACKUP_DIR" "$SSH_DIR" >/dev/null
    rm -rf "$SSH_DIR"
else
    echo "ℹ️ No existing ~/.ssh found, nothing to backup."
fi

# --- Step 2: Create fresh .ssh ---
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
echo "✅ Fresh $SSH_DIR created"

# --- Step 3: Generate new SSH key ---
echo "🔑 Generating new SSH keypair..."
ssh-keygen -t ed25519 -C "$WORK_EMAIL" -f "$SSH_DIR/id_ed25519" -N ""

# --- Step 4: Create SSH Config ---
SSH_CONFIG="$SSH_DIR/config"
cat <<EOF > "$SSH_CONFIG"
# --- Work GitLab (default) ---
Host code.roche.com
  HostName code.roche.com
  User git
  IdentityFile $SSH_DIR/id_ed25519

# --- Personal GitHub ---
Host github.com
  HostName github.com
  User git
  IdentityFile $SSH_DIR/id_ed25519
EOF

chmod 600 "$SSH_CONFIG"
echo "✅ SSH config written"

# --- Step 5: Configure Git Identities ---
echo "⚙️ Setting Work as default Git identity..."
git config --global user.name "$WORK_NAME"
git config --global user.email "$WORK_EMAIL"

echo "⚙️ Setting Personal identity for ~/personal repos..."
mkdir -p ~/personal

cat <<EOF > ~/.gitconfig-personal
[user]
    name = $PERSONAL_NAME
    email = $PERSONAL_EMAIL
EOF

if ! grep -q "includeIf.*personal" ~/.gitconfig 2>/dev/null; then
cat <<EOF >> ~/.gitconfig

[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
EOF
fi

# --- Step 6: Show Public Key ---
echo
echo "==============================="
echo " Next Steps"
echo "==============================="
echo "1️⃣ Copy the following SSH public key and add it to BOTH accounts:"
echo "   - GitHub (personal)"
echo "   - GitLab (work)"
echo
cat $SSH_DIR/id_ed25519.pub
echo
echo "2️⃣ Clone normally:"
echo "   - Work:     git clone git@code.roche.com:group/repo.git"
echo "   - Personal: git clone git@github.com:username/repo.git"
echo
echo "📦 Backup saved at: $BACKUP_DIR"
echo "🎉 Setup complete!"
echo "==============================="
