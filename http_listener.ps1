
if ( $args -contains "disappear" ) {

$arguments = $args[1..($args.Length - 1)]
$ErrorActionPreference = 'Stop'
# $ErrorActionPreference = 'Continue'

$HttpFile = ''
$AFile = 'user\sofplus\data\http_tmp'
$HttpServer = 'https://raw.githubusercontent.com/plowsof/sof1maps/main/'

# Delete existing http file if it exists
If (Test-Path "$AFile") {
    Remove-Item "$AFile"
    Write-Host 'Deleting existing http file.'
}

Write-Host 'Welcome to SoF1 HTTP Auto Map Downloader.'
Write-Host 'Keep this window open so that it can detect map change.'
Write-Host 'SoF should open automatically now.'

# Launch SoF - PassThru required to kill later.
$gameProcess = Start-Process -PassThru -FilePath './SoF.exe' -ArgumentList $arguments

While ($true) {
    If (Test-Path $AFile) {
        # Read the last line of the mapname file
        $HttpFile = Get-Content "$AFile" | Select-Object -Last 1
        
        $HttpFile = $HttpFile.Split('"')[3]
        Write-Host "Map name: $HttpFile"
        
        # Remove .bsp extension and add .zip extension
        $HttpFile = "$HttpFile" -replace '\.bsp$', '.zip'

        # Download the file from the http server
        $DestFile = Join-Path 'user\maps' $HttpFile
        
        # Create the directory if it doesn't exist
        $directory = Split-Path -LiteralPath "$DestFile"
        if (!(Test-Path -LiteralPath "$directory" -PathType Container)) {
            New-Item -Path "$directory" -ItemType Directory | Out-Null
        }

        # Download the file using Invoke-WebRequest
        Write-Host "NEUTRAL: Trying to download ""$HttpServer$HttpFile"" to ""$DestFile""."
        try {
            $encodedUri = [System.Uri]::EscapeUriString("$HttpServer$HttpFile")
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile("$encodedUri", "$DestFile")
            Write-Host "SUCCESS: ""$HttpFile"" downloaded to ""$DestFile""."

            # Extract the zip file
            Expand-Archive -LiteralPath "$DestFile" -DestinationPath 'user' -Force

            # Delete the zip file
            Remove-Item -LiteralPath "$DestFile"
            
        } catch {
            # 404 error catch
            Write-Host "ERROR: $($_.Exception.Message)"
        }
        # Delete the http file
        Remove-Item -LiteralPath "$AFile"
    }
    # Wait for 2 seconds and check again
    Start-Sleep -Seconds 2

    if ($gameProcess.HasExited) {
        exit
    }
}
} else {
    # $arguments = "-ExecutionPolicy Bypass", "-File `"$PSCommandPath`"", "disappear"
    $arguments = "-WindowStyle Hidden","-ExecutionPolicy Bypass", "-File `"$PSCommandPath`"", "disappear"

    if ($args -ne $null) {
        $arguments += $args
    }
    Start-Process "powershell.exe" -ArgumentList $arguments
}
