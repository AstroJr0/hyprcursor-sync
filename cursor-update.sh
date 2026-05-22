#!/usr/bin/env bash
set -e

# --- Configuration --
CURSOR_CONF="$HOME/.config/hypr/cursors.conf"
SETTINGS="$HOME/.config/gtk-4.0/settings.ini"

# --- Logic --
get_theme() {
    if [[ -f "$SETTINGS" ]]; then
        # Extract theme name, handling spaces/tabs safely
        grep "gtk-cursor-theme-name" $SETTINGS | cut -d '=' -f2
    else
        echo "Bibata-Modern-Ice"
    fi
}
get_size() { grep "gtk-cursor-theme-size" "$SETTINGS" 2>/dev/null | cut -d'=' -f2 || echo "24"; }

# Ensure config dir exists
mkdir -p "$(dirname "$CURSOR_CONF")"

# Change this in your cursor-update.sh
THEME=$(get_theme || echo "Bibata-Modern-Ice")
SIZE=$(get_size || echo "24")

# 1. Update Persistent Config
cat > "$CURSOR_CONF" <<EOF
env = HYPRCURSOR_THEME,$THEME
env = HYPRCURSOR_SIZE,$SIZE
env = XCURSOR_THEME,$THEME
env = XCURSOR_SIZE,$SIZE
EOF

# 2. Update Active Session
# Were forcing the computer to change cursor.

hyprctl setenv XCURSOR_SIZE "$SIZE"
hyprctl setenv HYPRCURSOR_SIZE "$SIZE"

gsettings set org.gnome.desktop.interface cursor-theme '$THEME'
gsettings set org.gnome.desktop.interface cursor-size $SIZE
echo "Cursor updated to: $THEME, $SIZE"
