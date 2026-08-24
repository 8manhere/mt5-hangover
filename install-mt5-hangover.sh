#!/bin/bash

set -e

echo "========================================="
echo " Hangover 11.9 + MetaTrader 5 Installer"
echo " Debian 13 Trixie ARM64"
echo "========================================="

HANGOVER_URL="https://github.com/AndreRH/Hangover/releases/download/hangover-11.9/hangover_11.9_debian13_trixie_arm64.tar"
WORKDIR="$HOME/hangover-install"
TARFILE="$WORKDIR/hangover.tar"

echo
echo "[1/8] Cek arsitektur..."

ARCH=$(dpkg --print-architecture)
echo "Arsitektur: $ARCH"

if [ "$ARCH" != "arm64" ]; then
    echo "ERROR: Sistem bukan ARM64."
    exit 1
fi

echo
echo "[2/8] Install dependency dasar..."

sudo apt update
sudo apt install -y wget tar ca-certificates

echo
echo "[3/8] Download Hangover 11.9..."

mkdir -p "$WORKDIR"

if [ ! -f "$TARFILE" ]; then
    wget -O "$TARFILE" "$HANGOVER_URL"
else
    echo "File Hangover sudah ada, skip download."
fi

echo
echo "[4/8] Ekstrak Hangover..."

rm -rf "$WORKDIR/extracted"
mkdir -p "$WORKDIR/extracted"

tar -xf "$TARFILE" -C "$WORKDIR/extracted"

echo
echo "Isi paket:"

find "$WORKDIR/extracted" \
    -maxdepth 1 \
    -type f \
    -name "*.deb" \
    -printf "  %f\n"

echo
echo "[5/8] Install Hangover..."

sudo apt install -y "$WORKDIR/extracted"/*.deb

echo
echo "Cek Wine..."

wine --version

echo
echo "[6/8] Cari installer MetaTrader 5..."

MT5_INSTALLER=$(find "$HOME/Downloads" \
    -maxdepth 1 \
    -type f \
    \( -iname "mt5setup*.exe" -o -iname "mt5*.exe" \) \
    | head -n 1)

if [ -z "$MT5_INSTALLER" ]; then
    echo
    echo "Installer MT5 tidak ditemukan."
    echo
    echo "Taruh file MT5 .exe di:"
    echo "$HOME/Downloads"
    echo
    echo "Contoh:"
    echo "$HOME/Downloads/mt5setup(1).exe"
    exit 0
fi

echo
echo "Installer ditemukan:"
echo "$MT5_INSTALLER"

echo
echo "[7/8] Install MetaTrader 5..."

wine "$MT5_INSTALLER"

echo
echo "========================================="
echo " Mencari MetaTrader 5..."
echo "========================================="

MT5_EXE="$HOME/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe"
METAEDITOR_EXE="$HOME/.wine/drive_c/Program Files/MetaTrader 5/metaeditor64.exe"

if [ ! -f "$MT5_EXE" ]; then
    echo
    echo "MT5 tidak ditemukan di lokasi default."
    echo
    echo "Mencari terminal64.exe..."

    MT5_EXE=$(find "$HOME/.wine" \
        -iname "terminal64.exe" \
        -type f \
        2>/dev/null \
        | head -n 1)
fi

if [ ! -f "$METAEDITOR_EXE" ]; then
    echo
    echo "Mencari metaeditor64.exe..."

    METAEDITOR_EXE=$(find "$HOME/.wine" \
        -iname "metaeditor64.exe" \
        -type f \
        2>/dev/null \
        | head -n 1)
fi

if [ -z "$MT5_EXE" ] || [ ! -f "$MT5_EXE" ]; then
    echo
    echo "ERROR: terminal64.exe tidak ditemukan."
    echo
    echo "Coba cari manual:"
    echo 'find ~/.wine -iname "terminal64.exe" 2>/dev/null'
    exit 1
fi

echo
echo "MT5 ditemukan:"
echo "$MT5_EXE"

echo
if [ -f "$METAEDITOR_EXE" ]; then
    echo "MetaEditor ditemukan:"
    echo "$METAEDITOR_EXE"
else
    echo "MetaEditor tidak ditemukan."
    echo "Shortcut MetaEditor tidak akan dibuat."
fi

echo
echo "[8/8] Membuat shortcut Desktop..."

DESKTOP_DIR="$HOME/Desktop"

mkdir -p "$DESKTOP_DIR"

# Shortcut MetaTrader 5
cat > "$DESKTOP_DIR/MetaTrader5.desktop" <<EOF
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

chmod +x "$DESKTOP_DIR/MetaTrader5.desktop"

# Shortcut MetaEditor
if [ -f "$METAEDITOR_EXE" ]; then

    cat > "$DESKTOP_DIR/MetaEditor5.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=MetaEditor 5
Comment=MetaEditor 5 via Hangover
Exec=wine "$METAEDITOR_EXE"
Path=$(dirname "$METAEDITOR_EXE")
Terminal=false
Categories=Development;
StartupNotify=true
EOF

    chmod +x "$DESKTOP_DIR/MetaEditor5.desktop"

fi

echo
echo "========================================="
echo " INSTALASI SELESAI!"
echo "========================================="

echo
echo "Shortcut dibuat:"

echo "  MetaTrader 5"
echo "  $DESKTOP_DIR/MetaTrader5.desktop"

if [ -f "$METAEDITOR_EXE" ]; then
    echo
    echo "  MetaEditor 5"
    echo "  $DESKTOP_DIR/MetaEditor5.desktop"
fi

echo
echo "Wine:"
wine --version

echo
echo "========================================="
echo " MetaTrader 5 siap digunakan."
echo "========================================="

echo
echo "Menjalankan MetaTrader 5..."

wine "$MT5_EXE"
