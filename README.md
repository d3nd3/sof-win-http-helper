# Soldier Of Fortune 1 windows http map auto-downloader

Uses powershell to download a map zip and extract it. Extract this to your sof folder.  http_listener.cmd launches http_listener.ps1.

Put http2.func in User/sofplus/addons dir.

Use the SoF HTTP Launcher. It will launch SoF.exe. And handle downloads in background.

It downloads zip files from https://github.com/plowsof/sof1maps.

Extracts them and then deletes them.

If mapfile.bsp already is present in your directory, it does not download the map.

Test by deleting your maps folder if you dare.

Feedback welcome.

