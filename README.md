# Soldier Of Fortune 1 windows http map auto-downloader

**Extract this to your sof folder.**  
**Open the SoF_HTTP.cmd file to launch SoF.**  
**Make a desktop shortcut of it etc.**  

Uses powershell to download a map zip and extract it.  
SoF_HTTP.cmd *launches* http_listener.ps1.  
http_listener.ps1 *starts* SoF.exe.  

Put user/sofplus/addons/http2.func into SoF_Install/User/sofplus/addons dir.  

It *downloads* zip files from https://github.com/plowsof/sof1maps.  
*Extracts* them.
Only downloads if .bsp does not exist already.  
Test by deleting your maps folder if you dare.  

Feedback welcome.

