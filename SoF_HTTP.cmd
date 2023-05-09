REM Define the SOF_OPTIONS variable
SET "SOF_OPTIONS=+set console 1 +set nope lol"
powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File http_listener.ps1 %SOF_OPTIONS%