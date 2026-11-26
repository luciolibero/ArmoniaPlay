#!/bin/bash
set -euo pipefail

# ArmoniaPlay — Lucio Ardito
# Compilatore nativo macOS (Swift + Cocoa + WKWebView)
# Genera ArmoniaPlay.app nativo (Apple Silicon / Intel) + ArmoniaPlay-macOS.dmg

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="ArmoniaPlay"
APP_BUNDLE="${SCRIPT_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RES_DIR="${CONTENTS_DIR}/Resources"

echo "=================================================="
echo "  ArmoniaPlay — Lucio Ardito (Build Nativo macOS)"
echo "=================================================="

if ! command -v swiftc >/dev/null 2>&1; then
  echo ""
  echo "Errore: 'swiftc' non trovato."
  echo "Installa gli strumenti da riga di comando di Apple eseguendo:"
  echo "  xcode-select --install"
  echo "Poi rilancia questo script."
  exit 1
fi

HTML_SRC="${SCRIPT_DIR}/ArmoniaPlay-standalone.html"
if [ ! -f "${HTML_SRC}" ] && [ -f "${SCRIPT_DIR}/../ArmoniaPlay-standalone.html" ]; then
  HTML_SRC="${SCRIPT_DIR}/../ArmoniaPlay-standalone.html"
elif [ ! -f "${HTML_SRC}" ] && [ -f "${SCRIPT_DIR}/../dist/ArmoniaPlay-standalone.html" ]; then
  HTML_SRC="${SCRIPT_DIR}/../dist/ArmoniaPlay-standalone.html"
fi

if [ ! -f "${HTML_SRC}" ]; then
  echo "Errore: ArmoniaPlay-standalone.html non trovato."
  exit 1
fi

SWIFT_SRC="${SCRIPT_DIR}/ArmoniaPlayApp.swift"
if [ ! -f "${SWIFT_SRC}" ]; then
  echo "Errore: ArmoniaPlayApp.swift non trovato."
  exit 1
fi

echo "1/5 Preparazione bundle ${APP_NAME}.app..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${MACOS_DIR}" "${RES_DIR}"
cp "${HTML_SRC}" "${RES_DIR}/ArmoniaPlay-standalone.html"

echo "2/5 Compilazione binario nativo Swift per macOS (Universale: Apple Silicon ARM64 + Intel x86_64)..."
BUILD_MODE="${1:-universal}"
HOST_ARCH="$(uname -m)"

if [ "${BUILD_MODE}" = "--arm64" ] || [ "${BUILD_MODE}" = "arm64" ]; then
  swiftc -O -target arm64-apple-macos11.3 -framework Cocoa -framework WebKit "${SWIFT_SRC}" -o "${MACOS_DIR}/${APP_NAME}"
  DMG_SUFFIX="arm64"
elif [ "${BUILD_MODE}" = "--intel" ] || [ "${BUILD_MODE}" = "x86_64" ]; then
  swiftc -O -target x86_64-apple-macos11.3 -framework Cocoa -framework WebKit "${SWIFT_SRC}" -o "${MACOS_DIR}/${APP_NAME}"
  DMG_SUFFIX="intel"
else
  # Prova build Universale (ARM64 + Intel x86_64) così la stessa app gira nativa su tutti i Mac
  if swiftc -O -target arm64-apple-macos11.3 -framework Cocoa -framework WebKit "${SWIFT_SRC}" -o "${MACOS_DIR}/${APP_NAME}_arm64" 2>/dev/null \
     && swiftc -O -target x86_64-apple-macos11.3 -framework Cocoa -framework WebKit "${SWIFT_SRC}" -o "${MACOS_DIR}/${APP_NAME}_x86_64" 2>/dev/null \
     && command -v lipo >/dev/null 2>&1; then
    lipo -create -output "${MACOS_DIR}/${APP_NAME}" "${MACOS_DIR}/${APP_NAME}_arm64" "${MACOS_DIR}/${APP_NAME}_x86_64"
    rm -f "${MACOS_DIR}/${APP_NAME}_arm64" "${MACOS_DIR}/${APP_NAME}_x86_64"
    DMG_SUFFIX="universal"
  else
    rm -f "${MACOS_DIR}/${APP_NAME}_arm64" "${MACOS_DIR}/${APP_NAME}_x86_64"
    swiftc -O -target "${HOST_ARCH}-apple-macos11.3" -framework Cocoa -framework WebKit "${SWIFT_SRC}" -o "${MACOS_DIR}/${APP_NAME}"
    DMG_SUFFIX="${HOST_ARCH}"
  fi
fi
chmod +x "${MACOS_DIR}/${APP_NAME}"
echo "    Architettura binario: $(file -b "${MACOS_DIR}/${APP_NAME}")"

echo "3/5 Creazione icona macOS (.icns)..."
ICON_PNG="${SCRIPT_DIR}/icon_512.png"
ICON_KEY=""
if [ -f "${ICON_PNG}" ] && command -v sips >/dev/null 2>&1 && command -v iconutil >/dev/null 2>&1; then
  ICONSET="${SCRIPT_DIR}/.ArmoniaPlay.iconset"
  rm -rf "${ICONSET}"
  mkdir -p "${ICONSET}"
  sips -z 16 16     "${ICON_PNG}" --out "${ICONSET}/icon_16x16.png" >/dev/null
  sips -z 32 32     "${ICON_PNG}" --out "${ICONSET}/icon_16x16@2x.png" >/dev/null
  sips -z 32 32     "${ICON_PNG}" --out "${ICONSET}/icon_32x32.png" >/dev/null
  sips -z 64 64     "${ICON_PNG}" --out "${ICONSET}/icon_32x32@2x.png" >/dev/null
  sips -z 128 128   "${ICON_PNG}" --out "${ICONSET}/icon_128x128.png" >/dev/null
  sips -z 256 256   "${ICON_PNG}" --out "${ICONSET}/icon_128x128@2x.png" >/dev/null
  sips -z 256 256   "${ICON_PNG}" --out "${ICONSET}/icon_256x256.png" >/dev/null
  sips -z 512 512   "${ICON_PNG}" --out "${ICONSET}/icon_256x256@2x.png" >/dev/null
  cp "${ICON_PNG}"  "${ICONSET}/icon_512x512.png"
  iconutil -c icns "${ICONSET}" -o "${RES_DIR}/AppIcon.icns"
  rm -rf "${ICONSET}"
  ICON_KEY="<key>CFBundleIconFile</key><string>AppIcon</string>"
fi

echo "4/5 Scrittura Info.plist e firma ad-hoc locale..."
cat > "${CONTENTS_DIR}/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>ArmoniaPlay</string>
  <key>CFBundleDisplayName</key>
  <string>ArmoniaPlay — Lucio Ardito</string>
  <key>CFBundleIdentifier</key>
  <string>it.lucioardito.armoniaplay</string>
  <key>CFBundleVersion</key>
  <string>2.2.0</string>
  <key>CFBundleShortVersionString</key>
  <string>2.2</string>
  <key>CFBundleExecutable</key>
  <string>ArmoniaPlay</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>LSMinimumSystemVersion</key>
  <string>11.3</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSHumanReadableCopyright</key>
  <string>Lucio Ardito</string>
  ${ICON_KEY}
</dict>
</plist>
EOF

if command -v codesign >/dev/null 2>&1; then
  codesign --force --deep --sign - "${APP_BUNDLE}" >/dev/null 2>&1 || true
fi

echo "5/5 Creazione immagine disco installabile (ArmoniaPlay-macOS-${DMG_SUFFIX}.dmg)..."
DMG_PATH="${SCRIPT_DIR}/ArmoniaPlay-macOS-${DMG_SUFFIX}.dmg"
if command -v hdiutil >/dev/null 2>&1; then
  rm -f "${DMG_PATH}"
  STAGE="${SCRIPT_DIR}/.dmg_stage"
  rm -rf "${STAGE}"
  mkdir -p "${STAGE}"
  cp -R "${APP_BUNDLE}" "${STAGE}/"
  ln -s /Applications "${STAGE}/Applications"
  hdiutil create -volname "ArmoniaPlay" -srcfolder "${STAGE}" -ov -format UDZO "${DMG_PATH}" >/dev/null
  rm -rf "${STAGE}"
  echo "    Creato installer DMG: ${DMG_PATH}"
fi

echo ""
echo "COMPILAZIONE COMPLETATA!"
echo "App pronta: ${APP_BUNDLE}"
echo "Puoi trascinare ArmoniaPlay.app nella cartella Applicazioni del Mac."
echo ""
open -R "${APP_BUNDLE}" 2>/dev/null || true
