# ArmoniaPlay — Lucio Ardito

Software locale (zero installazioni, 100% offline, privacy totale) per riprodurre playlist di brani musicali sul proprio computer applicando **cinque regole combinate**:

1. **Nessuna ripetizione del brano (`No-Repeat`)**: ogni brano viene eseguito una sola volta nel ciclo (con opzione per fermarsi a fine lista o avviare un nuovo ciclo evitando ripetizioni consecutive).
2. **Alternanza voci Maschili / Femminili (`M ↔ F`)**: alterna voci maschili e femminili, gestendo *Duetto* e *Strumentale* come ponti neutri.
3. **Logica di tonalità (Ruota di Camelot / Circolo delle Quinte)**: garantisce transizioni armoniche coerenti (`±1`, stessa tonalità o relativa `A↔B`, più *Estesa +2/Diagonale* e *Progressione Energetica*).
4. **Regole BPM / Energia**: controlla la tolleranza massima del salto BPM (`±8`, `±12`, `±18`, `±25 BPM`, includendo compatibilità mezzo/doppio tempo `½/2x`) e la curva energetica desiderata:
   - **Fluida**: mantiene continuità di tempo senza sbalzi bruschi.
   - **Crescendo (Warm-up)**: sale gradualmente di BPM ed energia.
   - **Decrescendo (Cool-down)**: scende gradualmente per fasi rilassanti o chiusura.
   - **Onda Energetica**: sale fino al picco intorno al 65% della playlist e poi decresce dolcemente.
5. **Distanza minima tra brani dello stesso artista**: impone almeno *N* brani di altri artisti tra due brani dello stesso artista (da `≥1` fino a `≥5`), normalizzando automaticamente anche crediti come `feat.`, `ft.` e `with`.

## Come usarlo in locale

Apri `index.html` con doppio clic nel browser (Chrome, Edge, Firefox, Safari).

### Riconoscimento automatico metadati & analisi audio locale
- Legge i tag **ID3v2** (`TIT2`, `TPE1`, `TKEY`, `TBPM`).
- Riconosce tag opzionali nel nome file, ad esempio:
  `Artista - Titolo [F] [8A] [112bpm] [E4].mp3`
- Se tonalità o BPM non sono presenti nei metadati, l'**analizzatore locale** (Goertzel/Krumhansl-Schmuckler + autocorrelazione onset BPM/RMS) li rileva automaticamente dal file audio.
- I tag modificati vengono salvati in `localStorage` ed esportabili/importabili in `.json`; la playlist pianificata è esportabile in `.m3u`.

### Lingua Italiano / Inglese (`IT / EN`)
- Interfaccia bilingue completa (**Italiano / English**) con selettore `IT / EN` nell'intestazione (salvato in `localStorage`, senza interrompere la riproduzione o rigenerare la coda).
- Adatta automaticamente tutte le etichette, i badge delle transizioni armoniche/vocali/BPM/artista, la notazione delle tonalità (`La min` ↔ `A min`) e l'esportazione `.m3u`.

## Versioni Standalone (pronte all'uso in `dist/`)

Per rigenerare entrambi i pacchetti standalone dopo eventuali modifiche:

```bash
node build-standalone.js
```

1. **`dist/ArmoniaPlay-standalone.html`** (singolo file HTML5 100% offline, zero dipendenze):
   - Copiabile ovunque (anche su chiavetta USB) e apribile con doppio clic su Windows, macOS e Linux senza connessione né installazioni.
2. **`dist/armoniaplay_desktop.py`** (singolo file Python 3 desktop, solo standard library):
   - Apre ArmoniaPlay in una **finestra app dedicata** e permette di caricare subito una cartella musicale locale da disco (e scegliere opzionalmente la lingua con `--lang it|en`):
     ```bash
     python3 dist/armoniaplay_desktop.py
     python3 dist/armoniaplay_desktop.py /percorso/alla/tua/musica
     python3 dist/armoniaplay_desktop.py --lang en /path/to/your/music
     ```
   - Per creare un eseguibile nativo `.exe` (Windows) / `.app` (macOS) / binario Linux:
     ```bash
     pip install pyinstaller
     pyinstaller --onefile --windowed --name ArmoniaPlay dist/armoniaplay_desktop.py
     ```

## Test automatici

```bash
node --test engine.test.js
```
