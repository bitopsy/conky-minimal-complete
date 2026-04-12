#!/usr/bin/env bash
set -e
THEME="$HOME/.config/conky/minimal"

echo "// installing Minimal Complete theme..."

mkdir -p "$THEME/helpers"
cp conkyrc "$HOME/.conkyrc"
cp helpers/helpers.lua "$THEME/helpers/"

sed -i "s|\$HOME/.config/conky/minimal/helpers.lua|$THEME/helpers/helpers.lua|g" "$HOME/.conkyrc"

echo "// detecting network interface..."
IFACE=$(ip -o -4 route show default 2>/dev/null | awk '{print $5}' | head -1)
if [ -n "$IFACE" ]; then
    echo "  Default interface: $IFACE"
    echo "  (auto-detected at runtime via helpers.lua)"
else
    echo "  No default route found. Will fall back to eth0."
    echo "  Set IFACE environment variable to override:"
    echo "    IFACE=wlan0 conky -c ~/.conkyrc"
fi
echo ""

echo "// GPU detection..."
if command -v nvidia-smi &>/dev/null && nvidia-smi &>/dev/null; then
    echo "  NVIDIA GPU detected — full stats enabled"
elif [ -d /sys/class/drm ]; then
    echo "  AMD/Intel GPU detected — temperature-only mode"
else
    echo "  No GPU detected — section will show N/A"
fi
echo ""

echo "// launching..."
pkill conky 2>/dev/null || true
sleep 1
conky -c "$HOME/.conkyrc" &
echo "// Minimal Complete is running."