@echo off
setlocal EnableDelayedExpansion
title Portable YouTube Downloader
cd /d "%~dp0"

REM Ensure output folder exists
if not exist "output" mkdir "output"

REM Detect JS runtime
set JS_OPT=
if exist "deno.exe" (
    set JS_OPT=--js-runtimes deno
) else (
    where node >nul 2>&1
    if not errorlevel 1 set JS_OPT=--js-runtimes node
)

:START
cls
echo =========================================
echo   Portable YouTube Downloader
echo =========================================
echo.

set /p YT_URL=Enter YouTube URL (or Q to quit): 
if /I "%YT_URL%"=="Q" goto EXIT
if "%YT_URL%"=="" goto START

echo.
echo Choose mode:
echo [1] Video download (MP4 with audio - automatic)
echo [2] Audio only (MP3 - listening)
echo [3] Audio only (WAV - Premiere Pro)
echo [4] Video download (Choose format manually)
echo.

set /p MODE=Select option (1 / 2 / 3 / 4): 

REM ---- DISPATCH (IMPORTANT) ----
if "%MODE%"=="1" goto VIDEO_AUTO
if "%MODE%"=="2" goto AUDIO_MP3
if "%MODE%"=="3" goto AUDIO_WAV
if "%MODE%"=="4" goto VIDEO_MANUAL

echo Invalid option.
pause
goto START

:VIDEO_AUTO
echo.
echo Video Mode - Automatic
echo Downloading...

yt-dlp ^
  %JS_OPT% ^
  --no-playlist ^
  --remote-components ejs:github ^
  --merge-output-format mp4 ^
  -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" ^
  -o "output\%%(title).200B [%%(id)s].%%(ext)s" ^
  "%YT_URL%"

goto DONE

:AUDIO_MP3
echo.
echo Audio Mode - MP3
echo Downloading...

yt-dlp ^
  %JS_OPT% ^
  --no-playlist ^
  --remote-components ejs:github ^
  -x --audio-format mp3 --audio-quality 0 ^
  -o "output\%%(title).200B [%%(id)s].mp3" ^
  "%YT_URL%"

goto DONE

:AUDIO_WAV
echo.
echo Audio Mode - WAV (Premiere Pro)
echo Downloading...

yt-dlp ^
  %JS_OPT% ^
  --no-playlist ^
  --remote-components ejs:github ^
  -x --audio-format wav ^
  --postprocessor-args "FFmpegExtractAudio:-ar 48000 -ac 2" ^
  -o "output\%%(title).200B [%%(id)s].wav" ^
  "%YT_URL%"

goto DONE

:VIDEO_MANUAL
echo.
echo Video Mode - Manual Format Selection
echo Fetching available formats...
echo.

yt-dlp ^
  %JS_OPT% ^
  --no-playlist ^
  --remote-components ejs:github ^
  -F "%YT_URL%"

echo.
set /p FORMAT_RULE=Enter format ID (example: 137+140): 

if "%FORMAT_RULE%"=="" (
    echo No format entered.
    pause
    goto START
)

echo.
echo Downloading selected format...

yt-dlp ^
  %JS_OPT% ^
  --no-playlist ^
  --remote-components ejs:github ^
  --merge-output-format mp4 ^
  -f "%FORMAT_RULE%" ^
  -o "output\%%(title).200B [%%(id)s].%%(ext)s" ^
  "%YT_URL%"

goto DONE

:DONE
echo.
if errorlevel 1 (
    echo Download failed.
) else (
    echo Download complete.
    echo Files saved in output\
)

pause
goto START

:EXIT
echo.
echo Exiting downloader.
pause
exit
