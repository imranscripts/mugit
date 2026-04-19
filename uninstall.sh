#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/mugit"

detect_shell_config() {
    local shell
    shell="$(basename "${SHELL:-bash}")"
    case "$shell" in
        zsh)  echo "$HOME/.zshrc" ;;
        bash) [[ -f "$HOME/.bash_profile" ]] && echo "$HOME/.bash_profile" || echo "$HOME/.bashrc" ;;
        fish) echo "$HOME/.config/fish/config.fish" ;;
        *)    echo "$HOME/.profile" ;;
    esac
}

echo "Uninstalling mugit..."

if [[ -f "$INSTALL_DIR/mugit" ]]; then
    rm "$INSTALL_DIR/mugit"
    echo "✓ Removed $INSTALL_DIR/mugit"
else
    echo "  mugit binary not found at $INSTALL_DIR/mugit, skipping"
fi

if [[ -d "$CONFIG_DIR" ]]; then
    rm -rf "$CONFIG_DIR"
    echo "✓ Removed config directory $CONFIG_DIR"
fi

SHELL_CONFIG="$(detect_shell_config)"
if grep -qF '# mugit' "$SHELL_CONFIG" 2>/dev/null; then
    # Remove the '# mugit' comment line and the PATH export line that follows it
    grep -v '# mugit' "$SHELL_CONFIG" | grep -v 'local/bin.*PATH\|PATH.*local/bin' > "$SHELL_CONFIG.tmp"
    mv "$SHELL_CONFIG.tmp" "$SHELL_CONFIG"
    echo "✓ Removed PATH entry from $SHELL_CONFIG"
fi

echo ""
echo "mugit has been uninstalled."
