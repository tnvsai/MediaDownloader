# 📥 MediaDownloader (Portable Media Downloader for Windows)

A **100% portable**, **no-install**, **copy-paste-run** media downloader for Windows, built using **yt-dlp**, **FFmpeg**, and **Deno**.

This tool works primarily with **YouTube**, but also supports **many other sites supported by yt-dlp**.

---

## ✅ What This Tool Can Do

- Paste a video URL (YouTube & many supported sites)
- Download **best-quality MP4 with audio merged**
- Download **audio only** (MP3 or WAV for editing)
- View available formats and choose manually (optional)
- Automatically save everything to an `output/` folder
- Loop mode → download multiple files without restarting
- Run on **any Windows PC** after one-time setup

---

## ⭐ Key Features

- ✅ Fully portable (no system PATH required)
- ✅ No admin rights needed
- ✅ One-file MP4 output (video + audio merged)
- ✅ Audio-only modes (MP3 & Premiere-Pro-ready WAV)
- ✅ Uses **Deno (portable JS runtime)** instead of Node.js
- ✅ Clean interactive menu
- ✅ Same behavior on every Windows PC

---

## 📁 Folder Structure (After Setup)

```
MediaDownloader/
├── youtube_download.bat
├── setup.bat
├── yt-dlp.exe
├── ffmpeg.exe
├── ffprobe.exe
├── deno.exe
├── README.md
├── .gitignore
└── output/
```

---

## ⬇️ One-Time Setup

```text
git clone https://github.com/tnvsai/MediaDownloader
cd MediaDownloader
setup.bat
```

---

## ▶️ How to Use

1. Run `youtube_download.bat`
2. Paste video URL
3. Choose a mode
4. Files saved in `output/`

---

## 🔒 Legal Notice

Use only for content you own or have permission to download.
