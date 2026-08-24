#!/bin/bash

set -e

DESKTOP_DIR="$HOME/Desktop"
MT5_EXE="$HOME/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe"
SHORTCUT="$DESKTOP_DIR/MetaTrader5.desktop"

echo "========================================="
echo " MetaTrader 5 Desktop Shortcut"
echo "========================================="

if [ ! -f "$MT5_EXE" ]; then
    echo
    echo "ERROR: MetaTrader 5 tidak ditemukan."
    echo
    echo "Lokasi yang dicari:"
    echo "$MT5_EXE"
    echo
    echo "Pastikan MT5 sudah terinstall."
    exit 1
fi

mkdir -p "$DESKTOP_DIR"

cat > "$SHORTCUT" <<EOF
[Desktop Entry]
Type=Application
Name=MetaTrader 5
Comment=MetaTrader 5 via Hangover
Exec=wine "$MT5_EXE"
Path=$(dirname "$MT5_EXE")
Terminal=false
Categories=Finance;
StartupNotify=true
EOF

chmod +x "$SHORTCUT"

echo
echo "Shortcut berhasil dibuat!"
echo
echo "Lokasi:"
echo "$SHORTCUT"
echo
echo "Silakan buka Desktop dan jalankan:"
echo "MetaTrader 5"
echo
