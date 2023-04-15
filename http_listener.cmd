@echo off
setlocal enabledelayedexpansion
mode con: cols=67 lines=36


echo "Welcome to httpv2 downloader."
echo "Keep this window open so that it can detect map change."
echo "And handle downloads for you..."
rem start "SoF HTTPv2" "SoF.exe"

SET TRIGGER=0
SET http_file=
SET afile=user\sofplus\data\http_tmp
SET http_server=https://raw.githubusercontent.com/plowsof/sof1maps/main/

IF EXIST %afile% (
    del %afile%
)

:loop
IF EXIST %afile% (
    SET TRIGGER=1
    echo %afile% exists
) ELSE ( 
    rem echo %afile% NOT exists
    SET TRIGGER=0
    SET http_file=
)

IF "!TRIGGER!"=="1" GOTO trigger

:sleep
ping -n 2 127.0.0.1 >nul
GOTO loop

:trigger
rem read contents...

for /f "usebackq tokens=*" %%a in ("%afile%") do (
    set "line=%%a"
    set "line=!line:*"=!"
    set "line=!line:*"=!"
    set "http_file=!line:~2,-1!"
)
set "http_file=!http_file:.bsp=.zip!"

echo !http_file!

SET errorlevel=
echo starting download "user/maps/!http_file!" "%http_server%!http_file!"

curl -gk -f -sS -o "user/maps/!http_file!" "%http_server%!http_file!"
IF "!errorlevel!"=="0" (
    echo file "%http_file%" downloaded nicely
    powershell -command "Expand-Archive -LiteralPath './user/maps/!http_file!' -DestinationPath ./user -Force"
    echo "hmmm"
    set "http_file=!http_file:/=\!"
    echo "!http_file!"
    del ".\user\maps\!http_file!"
    del "%afile%"
) ELSE (
    echo Curl failed with error !errorlevel!
    GOTO theend
)
GOTO sleep
:theend
SET http_server=
SET http_file=
SET afile=
SET TRIGGER=
EXIT /b !errorlevel!
endlocal