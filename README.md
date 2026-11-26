# ArmoniaPlay — Lucio Ardito 🎵

[![Support on Ko-fi](https://img.shields.io/badge/Ko--fi-Supporta%20%2F%20Donate-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/lucio54341)

**🇮🇹 Italiano** | **[🇬🇧 English below](#-english-documentation)**

Player musicale locale (**zero installazioni, 100% offline, privacy totale**) ideato da **Lucio Ardito** per generare e riprodurre playlist intelligenti direttamente sul proprio computer applicando **cinque regole musicali combinate**, con interfaccia bilingue **Italiano / English (`IT / EN`)**.

- 🌐 **Demo Live (GitHub Pages):** [Apri ArmoniaPlay nel browser](https://luciolibero.github.io/ArmoniaPlay/) *(dopo aver attivato GitHub Pages su branch `main`)*
- 📦 **Download pronti all'uso:** [Sezione Releases](../../releases)
- ☕ **Supporta il progetto:** [Offri un caffè su Ko-fi](https://ko-fi.com/lucio54341)

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

### 🔍 Analisi Audio Locale, Livellamento Volume & Bilingue (`IT / EN`)
- **Livellamento Volume Automatico (Auto-Loudness + Limiter)**: misura il volume integrato RMS (stile EBU R128 con gating su silenzi) e il picco di ogni brano, applicando automaticamente la compensazione in dB (`-16 dB Radio`, `-14 dB Standard`, `-12 dB Club`) insieme a un compressore/limiter broadcast anti-clipping per eliminare gli sbalzi improvvisi di volume tra un brano e l'altro.
- **Tag ID3v2 e copertine integrate**: legge `TIT2`, `TPE1`, `TKEY`, `TBPM`, copertine `APIC` (MP3), FLAC, M4A/MP4 e immagini `cover.jpg`/`folder.jpg` nella cartella.
- **Tag opzionali nel nome file**: es. `Artista - Titolo [F] [8A] [112bpm] [E4].mp3`.
- **Analizzatore locale 100% offline**: rileva automaticamente tonalità (Goertzel + Krumhansl-Schmuckler), BPM, energia RMS e loudness se assenti nei metadati.
- **Interfaccia bilingue `IT / EN`**: selettore istantaneo nell'intestazione (salvato in `localStorage`) che aggiorna UI, badge delle transizioni, notazione tonale (`La min` ↔ `A min`) ed esportazione `.m3u` senza interrompere la riproduzione.
- **Persistenza & Export**: tag e misure loudness salvati in `localStorage`, backup/ripristino `.json` ed esportazione playlist `.m3u`.

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

### 4. Versione Windows (Windows 10 / 11)
Scarica **`ArmoniaPlay-Windows-Kit.zip`** dalle [Releases](../../releases) (oppure usa la cartella [`windows/`](windows/)):
- **Avvio immediato senza installazioni (zero Python)**: fai doppio clic su **`Avvia-ArmoniaPlay-Silenzioso.vbs`** (senza finestra nera) o **`Avvia-ArmoniaPlay.bat`** per aprire ArmoniaPlay in finestra app dedicata con Edge, Chrome o Brave.
- **Compilare un singolo `.exe` con icona**: fai doppio clic su **`Compila-ArmoniaPlay-Windows.bat`** (richiede Python 3) per generare **`ArmoniaPlay.exe`** con icona `armoniaplay.ico`.

### 5. Versione Linux (Ubuntu, Debian, Mint, Fedora, Arch, Manjaro...)
Scarica **`ArmoniaPlay-Linux-Kit.zip`** dalle [Releases](../../releases) (oppure usa la cartella [`linux/`](linux/)):
- **Ubuntu / Debian / Mint (`.deb`, x86_64 & ARM64)**:
  ```bash
  sudo apt install ./armoniaplay_2.2.0_all.deb
  armoniaplay
  ```
- **Qualsiasi distro Linux (senza root, voce nel menu Applicazioni + icona)**:
  ```bash
  cd linux
  chmod +x armoniaplay.sh install-desktop.sh uninstall-desktop.sh
  ./install-desktop.sh
  ```
- **Avvio portatile diretto** o build binario PyInstaller (`./build-linux.sh --binary`):
  ```bash
  ./armoniaplay.sh
  ./armoniaplay.sh /percorso/alla/tua/musica
  ```

---

## 📂 Struttura del Repository

```text
ArmoniaPlay/
├── index.html                    # Versione pronta per GitHub Pages (demo live)
├── ArmoniaPlay-standalone.html   # Singolo file HTML5 100% offline (IT / EN)
├── armoniaplay_desktop.py        # Launcher desktop Python 3 (zero dipendenze)
├── ArmoniaPlay-macOS-Kit.zip     # Pacchetto macOS pronto (QuickLaunch + sorgenti nativi)
├── ArmoniaPlay-Windows-Kit.zip   # Pacchetto Windows pronto (.vbs/.bat + build .exe + .ico)
├── ArmoniaPlay-Linux-Kit.zip     # Pacchetto Linux pronto (.deb + installer desktop + launcher)
├── macos/
│   ├── ArmoniaPlayApp.swift                # App nativa macOS Cocoa + WKWebView (IT / EN)
│   ├── Compila-ArmoniaPlay-Nativo.command  # Script build Universal (.app + .dmg)
│   ├── icon_512.png                        # Icona ad alta risoluzione
│   └── LEGGIMI-macOS.txt                   # Guida rapida macOS (IT / EN)
├── windows/
│   ├── Avvia-ArmoniaPlay-Silenzioso.vbs    # Avvio silenzioso finestra app (zero Python)
│   ├── Avvia-ArmoniaPlay.bat               # Launcher Windows + drag&drop cartelle
│   ├── Compila-ArmoniaPlay-Windows.bat     # Script build ArmoniaPlay.exe (PyInstaller)
│   ├── armoniaplay.ico                     # Icona Windows multi-risoluzione (16–256px)
│   └── LEGGIMI-Windows.txt                 # Guida rapida Windows (IT / EN)
├── linux/
│   ├── armoniaplay.sh                      # Launcher Linux (finestra app / cartella locale)
│   ├── install-desktop.sh                  # Installazione menu Applicazioni + icona (no root)
│   ├── uninstall-desktop.sh                # Rimozione pulita installazione utente
│   ├── build-linux.sh                      # Build pacchetto .deb o binario PyInstaller
│   └── LEGGIMI-Linux.txt                   # Guida rapida Linux (IT / EN)
└── README.md
```

---

# 🇬🇧 English Documentation

A 100% offline, zero-installation local music player created by **Lucio Ardito** that builds and plays intelligent playlists on your computer using **five combined musical rules**, featuring **Auto Volume Leveling (Loudness + Limiter)** and an instant **Italian / English (`IT / EN`)** interface.

- 🌐 **Live Demo (GitHub Pages):** [Open ArmoniaPlay in your browser](https://luciolibero.github.io/ArmoniaPlay/)
- 📦 **Ready-to-use Packages:** [Releases](../../releases)

## ✨ The 5 Combined Rules (EN)

1. **No Track Repeats (`No-Repeat`)**: every track plays once per cycle (with options to stop at the end or start a new cycle without back-to-back repeats).
2. **Male / Female Voice Alternation (`M ↔ F`)**: alternates male and female vocals while treating *Duet* (`D`) and *Instrumental* (`I`) tracks as neutral bridges, with a quick voice-confirmation modal on file/folder import.
3. **Harmonic Key Logic (Camelot Wheel / Circle of Fifths)**: ensures smooth harmonic transitions (`±1`, same key, or relative `A↔B`, plus *Camelot Extended +2/Diagonal*, *Energy Progression*, and *Same-Mode Fifths*) with equal-power crossfade (`0s`–`8s`).
4. **BPM / Energy Rules**: controls maximum BPM jumps (`±8`, `±12`, `±18`, `±25 BPM`, including `½/2x` half/double-time compatibility) and energy progression curves (**Smooth**, **Ramp Up**, **Cool Down**, **Energy Wave** peaking around 65%).
5. **Minimum Same-Artist Separation**: enforces at least *N* tracks by other artists between tracks by the same artist (`≥1` to `≥5`), automatically normalizing credits such as `feat.`, `ft.`, and `with`.

### 🔍 Local Audio Analysis, Auto Volume Leveling & Bilingual UI (`IT / EN`)
- **Auto Volume Leveling (Loudness + Broadcast Limiter)**: analyzes gated integrated RMS loudness (EBU R128-style) and peak level for every track, applying automatic dB gain compensation (`-16 dB Radio`, `-14 dB Standard`, `-12 dB Club`) plus a real-time broadcast compressor & anti-clipping safety limiter to prevent sudden volume jumps.
- Reads **ID3v2** tags (`TIT2`, `TPE1`, `TKEY`, `TBPM`), embedded artwork (MP3/FLAC/M4A), and folder covers (`cover.jpg`, `folder.jpg`).
- Supports optional filename tags: `Artist - Title [F] [8A] [112bpm] [E4].mp3`.
- Built-in offline audio analyzer (Goertzel + Krumhansl-Schmuckler key detection, onset autocorrelation BPM/RMS energy, and gated loudness).
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
- **Windows 10 / 11:** Download `ArmoniaPlay-Windows-Kit.zip` and double-click `Avvia-ArmoniaPlay-Silenzioso.vbs` (zero dependencies), or run `Compila-ArmoniaPlay-Windows.bat` to build a standalone `ArmoniaPlay.exe`.
- **Linux (Ubuntu/Debian/Fedora/Arch):** Download `ArmoniaPlay-Linux-Kit.zip` and either install the included `.deb` (`sudo apt install ./armoniaplay_2.2.0_all.deb`), run `./install-desktop.sh` (any distro, no root), or run `./armoniaplay.sh`.

## ☕ Supporta il progetto / Support ArmoniaPlay

Se ArmoniaPlay ti è utile, puoi offrire un caffè o supportare lo sviluppo su **Ko-fi** / *If you find ArmoniaPlay useful, you can support its development on **Ko-fi**:*

[![Support on Ko-fi](https://img.shields.io/badge/Ko--fi-Supporta%20%2F%20Donate-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/lucio54341)

## 📄 License

MIT License — Copyright © 2026 **Lucio Ardito**.
