@echo off
setlocal EnableDelayedExpansion
title MediaDownloader Setup
cd /d "%~dp0"

echo =========================================
echo   MediaDownloader - Setup / Update
echo =========================================
echo.

REM ══════════════════════════════════════════
REM  1. CHECK: Windows version / curl
REM ══════════════════════════════════════════
where curl >nul 2>&1
if errorlevel 1 (
    echo [ERROR] curl not found. Please use Windows 10 or Windows 11.
    pause & exit /b 1
)

REM ══════════════════════════════════════════
REM  2. CHECK: Internet connectivity
REM ══════════════════════════════════════════
echo [*] Checking internet connection...
curl -s --max-time 8 --head "https://github.com" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No internet connection detected. Please connect and try again.
    pause & exit /b 1
)
echo [OK] Internet is reachable.
echo.

REM ══════════════════════════════════════════
REM  3. DETECT CPU architecture
REM ══════════════════════════════════════════
set ARCH=x86_64
echo %PROCESSOR_ARCHITECTURE% | findstr /i "ARM64" >nul 2>&1
if not errorlevel 1 set ARCH=aarch64

REM ══════════════════════════════════════════
REM  4. INSTALL / UPDATE: yt-dlp
REM ══════════════════════════════════════════
echo [*] Checking yt-dlp...

set YT_URL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
set NEEDS_YTDLP=0

if not exist yt-dlp.exe (
    set NEEDS_YTDLP=1
    echo [!] yt-dlp.exe not found. Will download.
) else (
    REM Get installed version
    for /f "tokens=*" %%v in ('yt-dlp.exe --version 2^>nul') do set YT_LOCAL=%%v

    REM Get latest version tag from GitHub API
    for /f "tokens=*" %%r in ('curl -s --max-time 10 "https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest" ^| findstr /i "\"tag_name\""') do (
        set RAW_TAG=%%r
    )
    REM Extract version string (format: "tag_name": "2026.03.17")
    for /f "tokens=2 delims=:, " %%t in ("!RAW_TAG!") do set YT_LATEST=%%~t

    if "!YT_LOCAL!"=="!YT_LATEST!" (
        echo [OK] yt-dlp is up-to-date ^(!YT_LOCAL!^).
    ) else (
        echo [!] yt-dlp update available: !YT_LOCAL! -^> !YT_LATEST!
        set NEEDS_YTDLP=1
    )
)

if "!NEEDS_YTDLP!"=="1" (
    echo [*] Downloading yt-dlp...
    set RETRY=0
    :YT_RETRY
    curl -L --max-time 60 --retry 3 --retry-delay 3 -o yt-dlp.exe "%YT_URL%"
    if errorlevel 1 (
        set /a RETRY+=1
        if !RETRY! LSS 3 (
            echo [!] Download failed. Retrying attempt !RETRY!/3...
            timeout /t 5 >nul
            goto YT_RETRY
        )
        echo [ERROR] Failed to download yt-dlp after 3 attempts.
        goto FAIL
    )
    echo [OK] yt-dlp downloaded successfully.
)
echo.

REM ══════════════════════════════════════════
REM  5. INSTALL / UPDATE: FFmpeg suite
REM ══════════════════════════════════════════
echo [*] Checking FFmpeg...

set NEEDS_FFMPEG=0
if not exist ffmpeg.exe set NEEDS_FFMPEG=1
if not exist ffprobe.exe set NEEDS_FFMPEG=1
if not exist ffplay.exe set NEEDS_FFMPEG=1

if "!NEEDS_FFMPEG!"=="1" (
    echo [*] Downloading FFmpeg (this may take a while - ~115 MB)...

    set FFMPEG_URL=https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
    set RETRY=0
    :FF_RETRY
    curl -L --max-time 300 --retry 3 --retry-delay 5 -o ffmpeg_dl.zip "!FFMPEG_URL!"
    if errorlevel 1 (
        set /a RETRY+=1
        if !RETRY! LSS 3 (
            echo [!] Download failed. Retrying attempt !RETRY!/3...
            timeout /t 5 >nul
            goto FF_RETRY
        )
        echo [ERROR] Failed to download FFmpeg after 3 attempts.
        if exist ffmpeg_dl.zip del ffmpeg_dl.zip
        goto FAIL
    )

    REM Verify zip is not empty / corrupted
    for %%Z in (ffmpeg_dl.zip) do if %%~zZ LSS 1000000 (
        echo [ERROR] Downloaded FFmpeg zip appears corrupted ^(too small^).
        del ffmpeg_dl.zip
        goto FAIL
    )

    echo [*] Extracting FFmpeg...
    if exist ffmpeg_tmp rmdir /s /q ffmpeg_tmp
    powershell -NoProfile -Command "Expand-Archive -Force 'ffmpeg_dl.zip' 'ffmpeg_tmp'" 2>nul
    if errorlevel 1 (
        echo [ERROR] Extraction failed. The zip may be corrupted.
        del ffmpeg_dl.zip
        goto FAIL
    )

    REM Copy the three executables
    for /r ffmpeg_tmp %%f in (ffmpeg.exe)  do copy /y "%%f" "." >nul
    for /r ffmpeg_tmp %%f in (ffprobe.exe) do copy /y "%%f" "." >nul
    for /r ffmpeg_tmp %%f in (ffplay.exe)  do copy /y "%%f" "." >nul

    REM Cleanup
    rmdir /s /q ffmpeg_tmp
    del ffmpeg_dl.zip

    REM Confirm all three exist
    if not exist ffmpeg.exe  ( echo [ERROR] ffmpeg.exe missing after extraction. & goto FAIL )
    if not exist ffprobe.exe ( echo [ERROR] ffprobe.exe missing after extraction. & goto FAIL )
    if not exist ffplay.exe  ( echo [ERROR] ffplay.exe missing after extraction. & goto FAIL )

    echo [OK] FFmpeg suite installed ^(ffmpeg, ffprobe, ffplay^).
) else (
    echo [OK] FFmpeg suite already present.
)
echo.

REM ══════════════════════════════════════════
REM  6. INSTALL / UPDATE: Deno
REM ══════════════════════════════════════════
echo [*] Checking Deno...

set NEEDS_DENO=0
if not exist deno.exe (
    set NEEDS_DENO=1
    echo [!] deno.exe not found. Will download.
) else (
    REM Get local Deno version
    for /f "tokens=2" %%v in ('deno.exe --version 2^>nul ^| findstr /i "deno "') do set DENO_LOCAL=%%v

    REM Get latest Deno version from GitHub API
    for /f "tokens=*" %%r in ('curl -s --max-time 10 "https://api.github.com/repos/denoland/deno/releases/latest" ^| findstr /i "\"tag_name\""') do set RAW_DENO=%%r
    for /f "tokens=2 delims=:, " %%t in ("!RAW_DENO!") do set DENO_LATEST=%%~t
    set DENO_LATEST=!DENO_LATEST:v=!

    if "!DENO_LOCAL!"=="!DENO_LATEST!" (
        echo [OK] Deno is up-to-date ^(v!DENO_LOCAL!^).
    ) else (
        echo [!] Deno update available: v!DENO_LOCAL! -^> v!DENO_LATEST!
        set NEEDS_DENO=1
    )
)

if "!NEEDS_DENO!"=="1" (
    echo [*] Downloading Deno...
    set DENO_URL=https://github.com/denoland/deno/releases/latest/download/deno-x86_64-pc-windows-msvc.zip
    if "!ARCH!"=="aarch64" set DENO_URL=https://github.com/denoland/deno/releases/latest/download/deno-aarch64-apple-darwin.zip

    set RETRY=0
    :DENO_RETRY
    curl -L --max-time 120 --retry 3 --retry-delay 3 -o deno_dl.zip "!DENO_URL!"
    if errorlevel 1 (
        set /a RETRY+=1
        if !RETRY! LSS 3 (
            echo [!] Download failed. Retrying attempt !RETRY!/3...
            timeout /t 5 >nul
            goto DENO_RETRY
        )
        echo [ERROR] Failed to download Deno after 3 attempts.
        if exist deno_dl.zip del deno_dl.zip
        goto FAIL
    )

    powershell -NoProfile -Command "Expand-Archive -Force 'deno_dl.zip' '.'" 2>nul
    if errorlevel 1 (
        echo [ERROR] Failed to extract Deno zip.
        del deno_dl.zip
        goto FAIL
    )
    del deno_dl.zip

    if not exist deno.exe (
        echo [ERROR] deno.exe not found after extraction.
        goto FAIL
    )
    echo [OK] Deno installed successfully.
)
echo.

REM ══════════════════════════════════════════
REM  7. FINAL VERIFICATION
REM ══════════════════════════════════════════
echo [*] Verifying all components...
set ALL_OK=1

yt-dlp.exe --version >nul 2>&1
if errorlevel 1 ( echo [FAIL] yt-dlp is not working. & set ALL_OK=0 ) else ( echo [OK]   yt-dlp  : OK )

ffmpeg.exe -version >nul 2>&1
if errorlevel 1 ( echo [FAIL] ffmpeg is not working.  & set ALL_OK=0 ) else ( echo [OK]   ffmpeg  : OK )

ffprobe.exe -version >nul 2>&1
if errorlevel 1 ( echo [FAIL] ffprobe is not working. & set ALL_OK=0 ) else ( echo [OK]   ffprobe : OK )

deno.exe --version >nul 2>&1
if errorlevel 1 ( echo [FAIL] deno is not working.   & set ALL_OK=0 ) else ( echo [OK]   deno    : OK )

echo.
if "!ALL_OK!"=="0" (
    echo [WARNING] One or more components failed verification.
    echo           Try running setup again or check your internet connection.
    pause
    exit /b 1
)

echo =========================================
echo   Setup complete - All components ready!
echo =========================================
echo.
echo You can now run  run.bat  to start downloading.
echo.
pause
exit /b 0

REM ══════════════════════════════════════════
:FAIL
REM ══════════════════════════════════════════
echo.
echo =========================================
echo   SETUP FAILED - See error above
echo =========================================
echo.
echo Tips:
echo   - Check your internet connection
echo   - Disable your antivirus temporarily
echo   - Run this script as Administrator
echo   - Try again in a few minutes
echo.
pause
exit /b 1
