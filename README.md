# 🔫 sof-win-http-helper: Soldier of Fortune 1 Map Auto-Downloader

Tired of manually downloading missing maps when joining a server? This utility is for you! It uses **PowerShell** to automatically download, unzip, and install maps for **Soldier of Fortune 1** (SoF1) as you connect to a game.

## 🚀 Quick Start & Installation

1.  **Extract:** Download the contents of this repository and extract all the files directly into your main **SoF installation folder** (where `SoF.exe` is located).
2.  **Addon File:** Copy the provided `http2.func` file into your SoFPlus addon directory: `[SoF_Install]/User/sofplus/addons/`.
3.  **Launch:** Use the new **`SoF_HTTP.cmd`** file to launch the game instead of your usual shortcut.
    * *Pro Tip:* Create a **desktop shortcut** to `SoF_HTTP.cmd` for easy access!

## ✨ How It Works

This helper seamlessly manages map downloads in the background:

1.  **`SoF_HTTP.cmd`** launches the hidden **`http_listener.ps1`** PowerShell script.
2.  The **`http_listener.ps1`** script then starts **`SoF.exe`**.
3.  When you connect to a server that requires a map you don't have, the game tells the script what to download.
4.  The script downloads the map's **ZIP file** from the official map repository: `https://github.com/plowsof/sof1maps`.
5.  It automatically **extracts** the map files.
6.  It **only downloads** if the map's `.bsp` file is missing, saving bandwidth and time! ⏳

## ⚙️ Custom Launch Options

You can easily add your usual launch options (like your desired resolution, bind settings, etc.) directly into the **`SoF_HTTP.cmd`** file.

The `SoF_HTTP.cmd` file uses this structure:

```cmd
REM Define the SOF_OPTIONS variable
SET "SOF_OPTIONS=+set console 1"
powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File http_listener.ps1 %SOF_OPTIONS%
```
To add more options, simply modify the SET "SOF_OPTIONS=..." line.  The PowerShell script then passes the %SOF_OPTIONS% variable to SoF.exe when launching the game.

---

Got a bug report or a feature idea? Feedback is welcome! Feel free to open an issue or submit a pull request.
