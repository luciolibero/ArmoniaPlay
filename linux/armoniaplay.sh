#!/usr/bin/env bash
set -euo pipefail

# ArmoniaPlay — Lucio Ardito (Launcher Linux)
# Avvia in finestra app dedicata (Chrome/Chromium/Edge/Brave) oppure carica una cartella locale con Python 3.

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

find_asset() {
  local name="$1"
  for candidate in \
    "${SCRIPT_DIR}/${name}" \
    "${SCRIPT_DIR}/../${name}" \
    "/usr/share/armoniaplay/${name}"; do
    if [ -f "${candidate}" ]; then
      echo "${candidate}"
      return 0
    fi
  done
  return 1
}

HTML_SRC="$(find_asset ArmoniaPlay-standalone.html || true)"
PY_SRC="$(find_asset armoniaplay_desktop.py || true)"

# Se l'utente passa argomenti (cartella musicale, --lang en, --port ...), usa il launcher desktop Python
if [ "$#" -gt 0 ] && [ -n "${PY_SRC}" ] && command -v python3 >/dev/null 2>&1; then
  exec python3 "${PY_SRC}" "$@"
fi

if [ -z "${HTML_SRC}" ]; then
  echo "Errore: ArmoniaPlay-standalone.html non trovato." >&2
  exit 1
fi

if command -v python3 >/dev/null 2>&1; then
  FILE_URI="$(python3 -c 'import pathlib, sys; print(pathlib.Path(sys.argv[1]).resolve().as_uri())' "${HTML_SRC}")"
else
  FILE_URI="file://${HTML_SRC}"
fi

for BROWSER in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge microsoft-edge-stable brave-browser; do
  if command -v "${BROWSER}" >/dev/null 2>&1; then
    nohup "${BROWSER}" --app="${FILE_URI}" --window-size=1280,860 --class=ArmoniaPlay >/dev/null 2>&1 &
    exit 0
  fi
done

if command -v xdg-open >/dev/null 2>&1; then
  nohup xdg-open "${HTML_SRC}" >/dev/null 2>&1 &
  exit 0
fi

echo "Apri manualmente nel browser: ${HTML_SRC}"
