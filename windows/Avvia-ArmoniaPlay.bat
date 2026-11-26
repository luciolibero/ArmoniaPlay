@echo off
setlocal EnableExtensions

rem ArmoniaPlay — Lucio Ardito (QuickLaunch Windows)
rem Doppio clic per avviare in finestra app dedicata (Edge/Chrome/Brave) senza installazioni.
rem Puoi anche trascinare una cartella musicale sopra questo file (richiede Python 3).

set "SCRIPT_DIR=%~dp0"
set "AP_HTML=%SCRIPT_DIR%ArmoniaPlay-standalone.html"
if not exist "%AP_HTML%" set "AP_HTML=%SCRIPT_DIR%..\ArmoniaPlay-standalone.html"

set "AP_PY=%SCRIPT_DIR%armoniaplay_desktop.py"
if not exist "%AP_PY%" set "AP_PY=%SCRIPT_DIR%..\armoniaplay_desktop.py"

if not "%~1"=="" (
  if exist "%AP_PY%" (
    where py >nul 2>&1
    if not errorlevel 1 (
      py -3 "%AP_PY%" %*
      exit /b %errorlevel%
    )
    where python >nul 2>&1
    if not errorlevel 1 (
      python "%AP_PY%" %*
      exit /b %errorlevel%
    )
  )
)

if not exist "%AP_HTML%" (
  echo Errore: ArmoniaPlay-standalone.html non trovato.
  echo Error: ArmoniaPlay-standalone.html not found.
  pause
  exit /b 1
)

rem Converte il percorso locale in file:/// URI compatibile con spazi e caratteri accentati
set "HTML_URL="
for /f "usebackq delims=" %%U in (`powershell -NoProfile -Command "[System.Uri]::new($env:AP_HTML).AbsoluteUri" 2^>nul`) do set "HTML_URL=%%U"
if "%HTML_URL%"=="" (
  set "HTML_URL=file:///%AP_HTML:\=/%"
)

rem Cerca Microsoft Edge, Google Chrome o Brave per aprire la finestra app dedicata
set "BROWSER="
for %%B in (
  "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
  "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
  "%LocalAppData%\Microsoft\Edge\Application\msedge.exe"
  "%ProgramFiles%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
  "%LocalAppData%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles%\BraveSoftware\Brave-Browser\Application\brave.exe"
  "%LocalAppData%\BraveSoftware\Brave-Browser\Application\brave.exe"
) do (
  if not defined BROWSER (
    if exist %%~B set "BROWSER=%%~B"
  )
)

if defined BROWSER (
  start "" "%BROWSER%" --app="%HTML_URL%" --window-size=1280,860
  exit /b 0
)

rem Fallback: browser predefinito di Windows
start "" "%AP_HTML%"
exit /b 0
