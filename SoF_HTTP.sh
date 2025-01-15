SOF_OPTIONS='+set console 1'
powershell -NonInteractive -ExecutionPolicy Bypass -File http_listener.ps1 "$SOF_OPTIONS"
