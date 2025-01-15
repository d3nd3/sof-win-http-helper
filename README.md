# Soldier Of Fortune 1 windows http map auto-downloader
This branch works natively on linux because powershell runs natively on linux.  
requirements: powershell, wine  

**Extract this to your sof folder.**  
**Open the SoF_HTTP.cmd file to launch SoF.**  
**Make a desktop shortcut of it etc.**  

Uses powershell to download a map zip and extract it.  
SoF_HTTP.sh *launches* http_listener.ps1.  
http_listener.ps1 *starts* wine SoF.exe.  

Put user/sofplus/addons/http2.func into SoF_Install/User/sofplus/addons dir.  

It *downloads* zip files from https://github.com/plowsof/sof1maps.  
*Extracts* them.
Only downloads if .bsp does not exist already.  
Test by deleting your maps folder if you dare.  

Feedback welcome.

