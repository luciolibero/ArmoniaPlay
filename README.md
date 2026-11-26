# ArmoniaPlay — Lucio Ardito 🎵

**🇮🇹 Italiano** | **[🇬🇧 English below](#-english-documentation)**

Player musicale locale (**zero installazioni, 100% offline, privacy totale**) ideato da **Lucio Ardito** per generare e riprodurre playlist intelligenti direttamente sul proprio computer applicando **cinque regole musicali combinate**, con interfaccia bilingue **Italiano / English (`IT / EN`)**.

- 🌐 **Demo Live (GitHub Pages):** [Apri ArmoniaPlay nel browser](https://luciolibero.github.io/ArmoniaPlay/) *(dopo aver attivato GitHub Pages su branch `main`)*
- 📦 **Download pronti all'uso:** [Sezione Releases](../../releases)

---

## ✨ Le 5 Regole Combinate (IT)

1. **Nessuna ripetizione del brano (`No-Repeat`)**: ogni brano viene eseguito una sola volta nel ciclo (con opzioni per fermarsi a fine lista o avviare un nuovo ciclo evitando ripetizioni consecutive).
2. **Alternanza voci Maschili / Femminili (`M ↔ F`)**: alterna voci maschili e femminili, gestendo *Duetto* (`D`) e *Strumentale* (`I`) come ponti neutri, con finestra di conferma rapida per file e sottocartelle al caricamento.
3. **Logica di tonalità (Ruota di Camelot / Circolo delle Quinte)**: garantisce transizioni armoniche coerenti (`±1`, stessa tonalità o relativa `A↔B`, più *Camelot Estesa +2/Diagonale*, *Progressione Energetica* e *Circolo Quinte stesso modo*) + crossfade equal-power (`0s`–`8s`).
4. **Regole BPM / Energia**: controlla la tolleranza massima del salto BPM (`±8`, `±12`, `±18`, `±25 BPM`, includendo compatibilità mezzo/doppio tempo `½/2x`) e la curva energetica desiderata:
   - **Fluida**: continuità di tempo senza sbalzi bruschi.
   - **Crescendo (Warm-up)**: sale gradualmente di BPM ed energia.
   - **Decrescendo (Cool-down)**: scende gradualmente per fasi rilassanti o chiusura.
   - **Onda Energetica**: sale fino al picco intorno al 65% della playlist e poi decresce dolcemente.
5. **Distanza minima tra brani dello stesso artista**: impone almeno *N* brani di altri artisti tra due brani dello stesso artista (da `≥1` fino a `≥5`), normalizzando automaticamente anche crediti come `feat.`, `ft.`, `with`, `con`.

### 🔍 Analisi Audio Locale, Copertine & Bilingue (`IT / EN`)
- **Tag ID3v2 e copertine integrate**: legge `TIT2`, `TPE1`, `TKEY`, `TBPM`, copertine `APIC` (MP3), FLAC, M4A/MP4 e immagini `cover.jpg`/`folder.jpg` nella cartella.
- **Tag opzionali nel nome file**: es. `Artista - Titolo [F] [8A] [112bpm] [E4].mp3`.
- **Analizzatore locale 100% offline**: rileva automaticamente tonalità (Goertzel + Krumhansl-Schmuckler), BPM ed energia RMS se assenti nei metadati.
- **Interfaccia bilingue `IT / EN`**: selettore istantaneo nell'intestazione (salvato in `localStorage`) che aggiorna UI, badge delle transizioni, notazione tonale (`La min` ↔ `A min`) ed esportazione `.m3u` senza interrompere la riproduzione.
- **Persistenza & Export**: tag salvati in `localStorage`, backup/ripristino `.json` ed esportazione playlist `.m3u`.

---

## 📥 Download & Utilizzo

### 1. HTML Standalone (Windows, macOS, Linux — zero installazioni)
Scarica **`ArmoniaPlay-standalone.html`** dalle [Releases](../../releases) (o dal repository) e aprilo con doppio clic in Chrome, Safari, Edge o Firefox. Funziona 100% offline anche da chiavetta USB.

### 2. App Desktop Python (solo standard library)
Apre ArmoniaPlay in una finestra app dedicata e carica direttamente una cartella musicale locale:
```bash
python3 armoniaplay_desktop.py
python3 armoniaplay_desktop.py /percorso/alla/tua/musica
python3 armoniaplay_desktop.py --lang en /path/to/your/music
```

### 3. App Nativa macOS (Apple Silicon M1–M4 + Intel)
Scarica **`ArmoniaPlay-macOS-Kit.zip`** dalle [Releases](../../releases), oppure compila direttamente dalla cartella [`macos/`](macos/) di questo repository (richiede solo i Command Line Tools: `xcode-select --install`):
```zsh
git clone https://github.com/luciolibero/ArmoniaPlay.git
cd ArmoniaPlay/macos
chmod +x Compila-ArmoniaPlay-Nativo.command
./Compila-ArmoniaPlay-Nativo.command
```
Genera automaticamente **`ArmoniaPlay.app`** (binario Universale Swift/Cocoa/WKWebView con menu nativi IT/EN) e l'immagine installabile **`ArmoniaPlay-macOS-universal.dmg`**.

---

## 📂 Struttura del Repository

```text
ArmoniaPlay/
├── index.html                    # Versione pronta per GitHub Pages (demo live)
├── ArmoniaPlay-standalone.html   # Singolo file HTML5 100% offline (IT / EN)
├── armoniaplay_desktop.py        # Launcher desktop Python 3 (zero dipendenze)
├── ArmoniaPlay-macOS-Kit.zip     # Pacchetto macOS pronto (QuickLaunch + sorgenti nativi)
├── macos/
│   ├── ArmoniaPlayApp.swift                # App nativa macOS Cocoa + WKWebView (IT / EN)
│   ├── Compila-ArmoniaPlay-Nativo.command  # Script build Universal (.app + .dmg)
│   ├── icon_512.png                        # Icona ad alta risoluzione
│   └── LEGGIMI-macOS.txt                   # Guida rapida macOS (IT / EN)
└── README.md
```

---

# 🇬🇧 English Documentation

A 100% offline, zero-installation local music player created by **Lucio Ardito** that builds and plays intelligent playlists on your computer using **five combined musical rules**, featuring an instant **Italian / English (`IT / EN`)** interface.

- 🌐 **Live Demo (GitHub Pages):** [Open ArmoniaPlay in your browser](https://luciolibero.github.io/ArmoniaPlay/)
- 📦 **Ready-to-use Packages:** [Releases](../../releases)

## ✨ The 5 Combined Rules (EN)

1. **No Track Repeats (`No-Repeat`)**: every track plays once per cycle (with options to stop at the end or start a new cycle without back-to-back repeats).
2. **Male / Female Voice Alternation (`M ↔ F`)**: alternates male and female vocals while treating *Duet* (`D`) and *Instrumental* (`I`) tracks as neutral bridges, with a quick voice-confirmation modal on file/folder import.
3. **Harmonic Key Logic (Camelot Wheel / Circle of Fifths)**: ensures smooth harmonic transitions (`±1`, same key, or relative `A↔B`, plus *Camelot Extended +2/Diagonal*, *Energy Progression*, and *Same-Mode Fifths*) with equal-power crossfade (`0s`–`8s`).
4. **BPM / Energy Rules**: controls maximum BPM jumps (`±8`, `±12`, `±18`, `±25 BPM`, including `½/2x` half/double-time compatibility) and energy progression curves (**Smooth**, **Ramp Up**, **Cool Down**, **Energy Wave** peaking around 65%).
5. **Minimum Same-Artist Separation**: enforces at least *N* tracks by other artists between tracks by the same artist (`≥1` to `≥5`), automatically normalizing credits such as `feat.`, `ft.`, and `with`.

### 🔍 Local Audio Analysis, Cover Art & Bilingual UI (`IT / EN`)
- Reads **ID3v2** tags (`TIT2`, `TPE1`, `TKEY`, `TBPM`), embedded artwork (MP3/FLAC/M4A), and folder covers (`cover.jpg`, `folder.jpg`).
- Supports optional filename tags: `Artist - Title [F] [8A] [112bpm] [E4].mp3`.
- Built-in offline audio analyzer (Goertzel + Krumhansl-Schmuckler key detection & onset autocorrelation BPM/RMS energy).
- Instant **`IT / EN`** toggle in the header (persisted in `localStorage`) switching all UI strings, transition badges, key notation (`A min` ↔ `La min`), and `.m3u` export live without interrupting playback.

## 📥 Quick Start (EN)

- **Standalone HTML:** Download `ArmoniaPlay-standalone.html` from [Releases](../../releases) and double-click to run offline in any modern browser.
- **Python Desktop Launcher** (standard library only):
  ```bash
  python3 armoniaplay_desktop.py --lang en /path/to/your/music
  ```
- **Native macOS App (Apple Silicon & Intel):** Download `ArmoniaPlay-macOS-Kit.zip` from [Releases](../../releases), or build from [`macos/`](macos/):
  ```zsh
  cd macos
  chmod +x Compila-ArmoniaPlay-Nativo.command
  ./Compila-ArmoniaPlay-Nativo.command
  ```

## 📄 License

MIT License — Copyright © 2026 **Lucio Ardito**.
