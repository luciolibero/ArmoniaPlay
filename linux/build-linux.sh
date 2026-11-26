#!/usr/bin/env bash
set -euo pipefail

# ArmoniaPlay — Lucio Ardito (Build binario standalone Linux + pacchetto .deb)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HTML_SRC="${SCRIPT_DIR}/ArmoniaPlay-standalone.html"
[ -f "${HTML_SRC}" ] || HTML_SRC="${SCRIPT_DIR}/../ArmoniaPlay-standalone.html"

PY_SRC="${SCRIPT_DIR}/armoniaplay_desktop.py"
[ -f "${PY_SRC}" ] || PY_SRC="${SCRIPT_DIR}/../armoniaplay_desktop.py"

ICON_SRC="${SCRIPT_DIR}/icon_512.png"
[ -f "${ICON_SRC}" ] || ICON_SRC="${SCRIPT_DIR}/../macos/icon_512.png"

MODE="${1:-deb}"

if [ "${MODE}" = "--binary" ] || [ "${MODE}" = "binary" ]; then
  if [ ! -f "${PY_SRC}" ]; then
    echo "Errore: armoniaplay_desktop.py non trovato." >&2
    exit 1
  fi
  if ! python3 -m PyInstaller --version >/dev/null 2>&1; then
    echo "Installazione PyInstaller..."
    python3 -m pip install --user --upgrade pyinstaller
  fi
  python3 -m PyInstaller --noconfirm --clean --onefile --windowed \
    --name ArmoniaPlay \
    --distpath "${SCRIPT_DIR}/dist" \
    --workpath "${SCRIPT_DIR}/build" \
    --specpath "${SCRIPT_DIR}/build" \
    "${PY_SRC}"
  cp "${SCRIPT_DIR}/dist/ArmoniaPlay" "${SCRIPT_DIR}/ArmoniaPlay"
  chmod +x "${SCRIPT_DIR}/ArmoniaPlay"
  rm -rf "${SCRIPT_DIR}/build" "${SCRIPT_DIR}/dist"
  echo "Binario Linux pronto: ${SCRIPT_DIR}/ArmoniaPlay"
  exit 0
fi

# Modalita predefinita: crea pacchetto .deb universale (amd64 + arm64) per Ubuntu/Debian/Mint
if ! command -v dpkg-deb >/dev/null 2>&1; then
  echo "Errore: 'dpkg-deb' non trovato. Usa './build-linux.sh --binary' oppure './install-desktop.sh'." >&2
  exit 1
fi

VERSION="2.2.0"
PKG_ROOT="${SCRIPT_DIR}/.deb_stage/armoniaplay_${VERSION}_all"
OUT_DEB="${SCRIPT_DIR}/armoniaplay_${VERSION}_all.deb"

rm -rf "${SCRIPT_DIR}/.deb_stage"
mkdir -p \
  "${PKG_ROOT}/DEBIAN" \
  "${PKG_ROOT}/usr/bin" \
  "${PKG_ROOT}/usr/share/armoniaplay" \
  "${PKG_ROOT}/usr/share/applications" \
  "${PKG_ROOT}/usr/share/icons/hicolor/512x512/apps"

cp "${HTML_SRC}" "${PKG_ROOT}/usr/share/armoniaplay/ArmoniaPlay-standalone.html"
cp "${PY_SRC}" "${PKG_ROOT}/usr/share/armoniaplay/armoniaplay_desktop.py"
chmod 0755 "${PKG_ROOT}/usr/share/armoniaplay/armoniaplay_desktop.py"
cp "${SCRIPT_DIR}/armoniaplay.sh" "${PKG_ROOT}/usr/bin/armoniaplay"
chmod 0755 "${PKG_ROOT}/usr/bin/armoniaplay"
[ -f "${ICON_SRC}" ] && cp "${ICON_SRC}" "${PKG_ROOT}/usr/share/icons/hicolor/512x512/apps/armoniaplay.png"

cat > "${PKG_ROOT}/usr/share/applications/armoniaplay.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Version=1.0
Name=ArmoniaPlay
GenericName=Harmonic Music Player
GenericName[it]=Player Musicale Armonico
Comment=100% offline local music player with 5 smart rules (IT / EN)
Comment[it]=Player musicale locale 100% offline con 5 regole armoniche (IT / EN)
Exec=/usr/bin/armoniaplay %F
Icon=armoniaplay
Terminal=false
Categories=AudioVideo;Audio;Player;Music;
StartupNotify=true
StartupWMClass=ArmoniaPlay
EOF

cat > "${PKG_ROOT}/DEBIAN/control" <<EOF
Package: armoniaplay
Version: ${VERSION}
Section: sound
Priority: optional
Architecture: all
Depends: python3
Maintainer: Lucio Ardito <luciolibero@users.noreply.github.com>
Description: ArmoniaPlay — Offline harmonic local music player (IT / EN)
 Local 100% offline music player by Lucio Ardito combining 5 smart rules:
 No-Repeat, Male/Female voice alternation, Camelot harmonic transitions,
 BPM/Energy curves, and minimum same-artist separation.
EOF

dpkg-deb --root-owner-group --build "${PKG_ROOT}" "${OUT_DEB}" >/dev/null
rm -rf "${SCRIPT_DIR}/.deb_stage"
echo "Pacchetto .deb pronto: ${OUT_DEB}"
