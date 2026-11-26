#!/usr/bin/env bash
set -euo pipefail

# ArmoniaPlay — Lucio Ardito (Installazione Desktop Linux senza root)
# Aggiunge ArmoniaPlay al menu Applicazioni, icona hicolor e comando terminale 'armoniaplay'.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
APP_DIR="${DATA_HOME}/armoniaplay"
BIN_DIR="${HOME}/.local/bin"
ICON_DIR="${DATA_HOME}/icons/hicolor/512x512/apps"
DESKTOP_DIR="${DATA_HOME}/applications"

HTML_SRC="${SCRIPT_DIR}/ArmoniaPlay-standalone.html"
[ -f "${HTML_SRC}" ] || HTML_SRC="${SCRIPT_DIR}/../ArmoniaPlay-standalone.html"

PY_SRC="${SCRIPT_DIR}/armoniaplay_desktop.py"
[ -f "${PY_SRC}" ] || PY_SRC="${SCRIPT_DIR}/../armoniaplay_desktop.py"

ICON_SRC="${SCRIPT_DIR}/icon_512.png"
[ -f "${ICON_SRC}" ] || ICON_SRC="${SCRIPT_DIR}/../macos/icon_512.png"

if [ ! -f "${HTML_SRC}" ]; then
  echo "Errore: ArmoniaPlay-standalone.html non trovato." >&2
  exit 1
fi

echo "Installazione ArmoniaPlay in ${APP_DIR}..."
mkdir -p "${APP_DIR}" "${BIN_DIR}" "${ICON_DIR}" "${DESKTOP_DIR}"

cp "${HTML_SRC}" "${APP_DIR}/ArmoniaPlay-standalone.html"
[ -f "${PY_SRC}" ] && cp "${PY_SRC}" "${APP_DIR}/armoniaplay_desktop.py" && chmod +x "${APP_DIR}/armoniaplay_desktop.py"
cp "${SCRIPT_DIR}/armoniaplay.sh" "${APP_DIR}/armoniaplay.sh"
chmod +x "${APP_DIR}/armoniaplay.sh"

ln -sf "${APP_DIR}/armoniaplay.sh" "${BIN_DIR}/armoniaplay"

if [ -f "${ICON_SRC}" ]; then
  cp "${ICON_SRC}" "${ICON_DIR}/armoniaplay.png"
fi

cat > "${DESKTOP_DIR}/armoniaplay.desktop" <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=ArmoniaPlay
GenericName=Harmonic Music Player
GenericName[it]=Player Musicale Armonico
Comment=100% offline local music player with 5 smart rules (IT / EN)
Comment[it]=Player musicale locale 100% offline con 5 regole armoniche (IT / EN)
Exec=${APP_DIR}/armoniaplay.sh %F
Icon=armoniaplay
Terminal=false
Categories=AudioVideo;Audio;Player;Music;
StartupNotify=true
StartupWMClass=ArmoniaPlay
EOF

command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "${DESKTOP_DIR}" >/dev/null 2>&1 || true
command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -f -t "${DATA_HOME}/icons/hicolor" >/dev/null 2>&1 || true

echo ""
echo "Installazione completata!"
echo "- Voce menu: ArmoniaPlay (categoria Audio / Musica)"
echo "- Comando terminale: armoniaplay  (assicurati che ~/.local/bin sia nel PATH)"
echo "- Esempio cartella locale: armoniaplay /percorso/alla/tua/musica"
