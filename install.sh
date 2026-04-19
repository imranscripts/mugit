#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
MUGIT_URL="https://raw.githubusercontent.com/imranscripts/mugit/main/mugit"

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

echo "Installing mugit..."

mkdir -p "$INSTALL_DIR"
curl -fsSL "$MUGIT_URL" -o "$INSTALL_DIR/mugit"
chmod +x "$INSTALL_DIR/mugit"

echo "✓ Installed to $INSTALL_DIR/mugit"

if echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    echo "✓ $INSTALL_DIR is already in your PATH"
else
    SHELL_CONFIG="$(detect_shell_config)"
    PATH_LINE="export PATH=\"\$HOME/.local/bin:\$PATH\""

    if ! grep -qF '.local/bin' "$SHELL_CONFIG" 2>/dev/null; then
        printf '\n# mugit\n%s\n' "$PATH_LINE" >> "$SHELL_CONFIG"
        echo "✓ Added $INSTALL_DIR to PATH in $SHELL_CONFIG"
    fi

    echo ""
    echo "  Reload your shell to start using mugit:"
    echo "    source $SHELL_CONFIG"
fi

echo ""
echo "☕ mugit is ready. Run: mugit --version"
