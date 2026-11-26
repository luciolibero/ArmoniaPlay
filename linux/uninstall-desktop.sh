#!/usr/bin/env bash
set -euo pipefail

# ArmoniaPlay — Lucio Ardito (Rimozione installazione desktop Linux utente)

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
rm -rf "${DATA_HOME}/armoniaplay"
rm -f "${HOME}/.local/bin/armoniaplay"
rm -f "${DATA_HOME}/icons/hicolor/512x512/apps/armoniaplay.png"
rm -f "${DATA_HOME}/applications/armoniaplay.desktop"

command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "${DATA_HOME}/applications" >/dev/null 2>&1 || true
command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -f -t "${DATA_HOME}/icons/hicolor" >/dev/null 2>&1 || true

echo "ArmoniaPlay rimosso dal desktop utente."
