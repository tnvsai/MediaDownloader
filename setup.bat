@echo off
setlocal EnableDelayedExpansion
title MediaDownloader Setup

echo =========================================
echo   MediaDownloader - Setup
echo =========================================
echo.

cd /d "%~dp0"

REM -------- curl check --------
where curl >nul 2>&1
if errorlevel 1 (
    echo ERROR: curl not found.
    echo Please use Windows 10/11.
    pause
    exit /b 1
)

REM -------- yt-dlp --------
if not exist yt-dlp.exe (
    echo Downloading yt-dlp...
    curl -L -o yt-dlp.exe https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
    if errorlevel 1 goto FAIL
) else (
    echo yt-dlp.exe already exists.
)

REM -------- ffmpeg --------
if not exist ffmpeg.exe (
    echo Downloading FFmpeg...
    curl -L -o ffmpeg.zip https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
    if errorlevel 1 goto FAIL

    echo Extracting FFmpeg...
    powershell -Command ^
     "Expand-Archive -Force ffmpeg.zip ffmpeg_tmp"

    for /r ffmpeg_tmp %%f in (ffmpeg.exe) do copy "%%f" .
    for /r ffmpeg_tmp %%f in (ffprobe.exe) do copy "%%f" .

    rmdir /s /q ffmpeg_tmp
    del ffmpeg.zip
) else (
    echo ffmpeg already exists.
)

REM -------- deno --------
if not exist deno.exe (
    echo Downloading Deno...
    curl -L -o deno.zip https://github.com/denoland/deno/releases/latest/download/deno-x86_64-pc-windows-msvc.zip
    if errorlevel 1 goto FAIL

    powershell -Command "Expand-Archive -Force deno.zip ."
    del deno.zip
) else (
    echo deno.exe already exists.
)

echo.
echo =========================================
echo   Setup completed successfully
echo =========================================
pause
exit /b 0

:FAIL
echo.
echo SETUP FAILED.
pause
exit /b 1
