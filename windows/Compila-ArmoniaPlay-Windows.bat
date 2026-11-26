@echo off
setlocal EnableExtensions

echo ====================================================
echo   ArmoniaPlay — Lucio Ardito (Build Nativo Windows)
echo ====================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "AP_PY=%SCRIPT_DIR%armoniaplay_desktop.py"
if not exist "%AP_PY%" set "AP_PY=%SCRIPT_DIR%..\armoniaplay_desktop.py"

if not exist "%AP_PY%" (
  echo Errore: armoniaplay_desktop.py non trovato.
  echo Error: armoniaplay_desktop.py not found.
  pause
  exit /b 1
)

set "PY_CMD="
where py >nul 2>&1
if not errorlevel 1 set "PY_CMD=py -3"
if not defined PY_CMD (
  where python >nul 2>&1
  if not errorlevel 1 set "PY_CMD=python"
)

if not defined PY_CMD (
  echo Errore: Python 3 non trovato sul sistema.
  echo Scaricalo da https://www.python.org/downloads/ (spunta "Add Python to PATH")
  echo oppure usa subito Avvia-ArmoniaPlay.bat che NON richiede Python.
  echo.
  pause
  exit /b 1
)

echo 1/3 Verifica PyInstaller...
%PY_CMD% -m PyInstaller --version >nul 2>&1
if errorlevel 1 (
  echo     Installazione PyInstaller in corso...
  %PY_CMD% -m pip install --upgrade pyinstaller
  if errorlevel 1 (
    echo Errore durante l'installazione di PyInstaller.
    pause
    exit /b 1
  )
)

set "ICON_ARG="
if exist "%SCRIPT_DIR%armoniaplay.ico" (
  set "ICON_ARG=--icon "%SCRIPT_DIR%armoniaplay.ico""
)

echo 2/3 Compilazione ArmoniaPlay.exe standalone...
%PY_CMD% -m PyInstaller --noconfirm --clean --onefile --windowed --name ArmoniaPlay %ICON_ARG% --distpath "%SCRIPT_DIR%dist" --workpath "%SCRIPT_DIR%build" --specpath "%SCRIPT_DIR%build" "%AP_PY%"
if errorlevel 1 (
  echo Errore durante la compilazione di ArmoniaPlay.exe.
  pause
  exit /b 1
)

echo 3/3 Finalizzazione...
copy /y "%SCRIPT_DIR%dist\ArmoniaPlay.exe" "%SCRIPT_DIR%ArmoniaPlay.exe" >nul
rmdir /s /q "%SCRIPT_DIR%build" >nul 2>&1
rmdir /s /q "%SCRIPT_DIR%dist" >nul 2>&1

echo.
echo COMPILAZIONE COMPLETATA!
echo Eseguibile pronto: %SCRIPT_DIR%ArmoniaPlay.exe
echo Puoi copiarlo sul Desktop o aggiungerlo al menu Start.
echo.
explorer /select,"%SCRIPT_DIR%ArmoniaPlay.exe"
pause
exit /b 0
