#!/bin/bash
# ~/.config/hypr/scripts/backup.sh
# Auto backup selected configs to GitHub

CONFIG_FOLDERS=(kitty spicetify wal hypr waybar wofi)

cd ~/dotfiles || exit

# Ensure correct remote
git remote set-url origin git@github.com:danielhaggeman/dotfiles-laptop.git

# Copy configs
mkdir -p .config
for folder in "${CONFIG_FOLDERS[@]}"; do
    cp -r ~/.config/"$folder" .config/ 2>/dev/null
done

# Copy SDDM configs (system-level)
mkdir -p sddm
cp /etc/sddm.conf sddm/ 2>/dev/null
cp -r /etc/sddm.conf.d/* sddm/ 2>/dev/null

# Copy .zshrc
cp ~/.zshrc . 2>/dev/null

# Only commit if there are changes
if ! git diff-index --quiet HEAD --; then
    git add .
    git commit -m "Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')"
    GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git push origin main --force
fi

