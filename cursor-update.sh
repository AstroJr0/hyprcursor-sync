#!/usr/bin/env bash
set -e

# config
CURSOR_CONF="$HOME/.config/hypr/cursors.lua"
SETTINGS="$HOME/.config/gtk-4.0/settings.ini"

# logic
get_theme() {
    if [[ -f "$SETTINGS" ]]; then
        # extract theme name
        grep "gtk-cursor-theme-name" $SETTINGS | cut -d '=' -f2
    else
        echo "Bibata-Modern-Ice"
    fi
}
get_size() { grep "gtk-cursor-theme-size" "$SETTINGS" 2>/dev/null | cut -d'=' -f2 || echo "24"; }

# ensure config dirs exist
mkdir -p "$(dirname "$CURSOR_CONF")"

THEME=$(get_theme || echo "Bibata-Modern-Ice")
SIZE=$(get_size || echo "24")

# update persistent config
cat > "$CURSOR_CONF" <<EOF
hl.env("HYPRCURSOR_THEME", "$THEME")
hl.env("HYPRCURSOR_SIZE", $SIZE)
hl.env("XCURSOR_THEME", "$THEME")
hl.env("XCURSOR_SIZE", $SIZE)
EOF

# update the active session
hyprctl setcursor "$THEME" "$SIZE" >/dev/null 2>&1
hyprctl setenv XCURSOR_SIZE "$SIZE"
hyprctl setenv HYPRCURSOR_SIZE "$SIZE"

gsettings set org.gnome.desktop.interface cursor-theme "$THEME"
gsettings set org.gnome.desktop.interface cursor-size $SIZE
echo "Cursor updated to: $THEME, $SIZE"
