# 📥 Portable YouTube Downloader (Windows)

A **100% portable**, **no-install**, **copy‑paste‑run** YouTube downloader for Windows, built using **yt-dlp**, **FFmpeg**, and **Deno**.

This tool allows you to:
- Paste a YouTube URL
- View available formats (optional)
- Download videos **with audio merged**
- Save everything neatly into an `output/` folder
- Run the same folder on **any PC** without re-installing dependencies

---

## ✅ Key Features

- ✅ Fully portable (no system PATH required)
- ✅ No admin rights needed
- ✅ Audio + video always merged into one file
- ✅ Works even when copied to a new PC
- ✅ Uses Deno (portable JS runtime) instead of Node.js
- ✅ Output automatically saved to `output/` folder
- ✅ Loop mode (download multiple videos without restarting)

---

## 📁 Folder Structure (Important)

Your tool folder **must** look like this:

```
YTDownloader/
├── yt-dlp.exe
├── ffmpeg.exe
├── ffprobe.exe
├── deno.exe
├── youtube_download.bat
└── output/
```

> ⚠️ Do NOT rename `yt-dlp.exe`, `ffmpeg.exe`, or `deno.exe`

---

## 🔧 Components Explained

| File | Purpose |
|----|----|
| `yt-dlp.exe` | Core downloader engine |
| `ffmpeg.exe` | Merges video + audio |
| `ffprobe.exe` | Required by FFmpeg |
| `deno.exe` | Portable JavaScript runtime for YouTube decoding |
| `youtube_download.bat` | Main launcher script |
| `output/` | All downloaded files go here |

---

## ⬇️ One-Time Setup (Only Once)

Download the following files and place them **in the same folder**:

### 1️⃣ yt-dlp
https://github.com/yt-dlp/yt-dlp/releases/latest

Download:
```
yt-dlp.exe
```

---

### 2️⃣ FFmpeg (Portable)
https://www.gyan.dev/ffmpeg/builds/

Download **static build**, extract, and copy:
```
ffmpeg.exe
ffprobe.exe
```

---

### 3️⃣ Deno (Portable JS Runtime)
https://github.com/denoland/deno/releases/latest

Download:
```
deno-x86_64-pc-windows-msvc.zip
```

Extract and copy:
```
deno.exe
```

---

## ▶️ How to Use

1. Double-click `youtube_download.bat`
2. Paste YouTube URL
3. Choose:
   - **Press ENTER** → Best MP4 with audio (recommended)
   - **Option 2** → Manually select format ID
4. Download starts
5. File appears in `output/`
6. Script loops for next download

---

## 🎯 Recommended Usage

### Best quality MP4 (automatic)
Just press **ENTER** when asked for format.

### Manual format selection
Choose formats like:
- `18` → 360p MP4 (video + audio in one file)
- `137+140` → 1080p video + audio (merged)
- `401+251` → 4K video + audio (merged)

---

## ⚠️ Notes & Tips

- YouTube high-quality videos store **video and audio separately**
- FFmpeg merges them automatically in this tool
- If a title is very long, filenames are safely trimmed
- Internet connection is required

---

## ❓ Troubleshooting

### ❌ Video downloads without audio
✔ FFmpeg is already bundled — this should not happen
✔ Ensure `ffmpeg.exe` is in the same folder as `yt-dlp.exe`

### ❌ Formats not showing
✔ Ensure `deno.exe` exists in the folder

### ❌ Script closes immediately
✔ Run by double-clicking, not via drag-drop

---

## 🔒 Legal Notice

This tool is provided for **educational and personal use only**.

Downloading copyrighted content may violate:
- YouTube Terms of Service
- Local copyright laws

Use this tool **only for content you own or have permission to download**.

---

## 🧠 Why This Tool Is Reliable

- No PATH dependencies
- No registry changes
- No installers
- Same behavior on every Windows PC

This is the **professional, portable way** to use yt-dlp on Windows.

---

## Required Tools (Portable)

Download and place these files next to the script:

- yt-dlp.exe  
  https://github.com/yt-dlp/yt-dlp/releases

- ffmpeg.exe, ffprobe.exe  
  https://www.gyan.dev/ffmpeg/builds/

- deno.exe  
  https://github.com/denoland/deno/releases


