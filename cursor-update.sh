#!/usr/bin/env bash
set -e

# --- Configuration ---
CURSOR_CONF="$HOME/.config/hypr/cursors.conf"
SETTINGS="$HOME/.config/gtk-4.0/settings.ini"

# --- Logic ---
get_theme() {
    if [[ -f "$SETTINGS" ]]; then
        # Extract theme name, handling spaces/tabs safely
        grep "gtk-cursor-theme-name" $SETTINGS | cut -d '=' -f2
    else
        echo "Bibata-Modern-Ice"
    fi
}
get_size () {
    grep "gtk-cursor-theme-size" $SETTINGS | cut -d'=' -f2
}

# Ensure config dir exists
mkdir -p "$(dirname "$CURSOR_CONF")"

THEME=$(get_theme)
SIZE=$(get_size)
SIZE="${SIZE:-24}"

# 1. Update Persistent Config
cat > "$CURSOR_CONF" <<EOF
env = HYPRCURSOR_THEME,$THEME
env = HYPRCURSOR_SIZE,$SIZE
env = XCURSOR_THEME,$THEME
env = XCURSOR_SIZE,$SIZE
EOF

# 2. Update Active Session
hyprctl setcursor "$THEME" "$SIZE" >/dev/null 2>&1
hyprctl setenv XCURSOR_SIZE "$SIZE"
hyprctl setenv HYPRCURSOR_SIZE "$SIZE"

gsettings set org.gnome.desktop.interface cursor-theme '$THEME'
gsettings set org.gnome.desktop.interface cursor-size $SIZE
echo "Cursor updated to: $THEME, $SIZE"
