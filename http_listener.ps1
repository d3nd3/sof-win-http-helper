
$arguments = $args[1..($args.Length - 1)]
$ErrorActionPreference = 'Stop'
# $ErrorActionPreference = 'Continue'

$folderName = 'user'

# Check if "user" is in the argument list
if ($args -contains 'user') {
    # Get the index of "user" in the argument list
    $userIndex = $args.IndexOf('user')

    # Check if there is an argument after "user"
    if ($userIndex -lt $args.Length - 1) {
        # Use the item to the right of "user" as the new folder name
        $folderName = $args[$userIndex + 1]
        Write-Host "Found 'user' in arguments. Using '$folderName' as folder name."
    } else {
        Write-Host "'user' found in arguments, but no value after it."
    }
} else {
    # If "user" is not in the argument list, proceed with the folder existence check
    #$exists = Get-ChildItem -Path (Split-Path $folderPath -Parent) | Where-Object { $_.Name -ieq 'User' }

    if (Test-Path "./User") {
        Write-Host "Folder 'User' exists."
    $folderName = 'User'
    } else {
        # Folder doesn't exist, change the string to 'user'
        #$folderName = 'user'
        Write-Host "Folder 'User' does not exist. Defaulting to 'user'."
    }
}


$AFile = "$folderName/sofplus/data/http_tmp"
$HttpFile = ''
$HttpServer = 'https://raw.githubusercontent.com/plowsof/sof1maps/main/'


# Delete existing http file if it exists
If (Test-Path "$AFile") {
#If ( Get-ChildItem -Path (Get-Item $AFile).DirectoryName -Filter (Get-Item $AFile).Name -Force |
 #         Where-Object { $_.Name -ieq (Get-Item $AFile).Name } ) {
    Remove-Item "$AFile"
    Write-Host 'Deleting existing http file.'
}

Write-Host 'Welcome to SoF1 HTTP Auto Map Downloader.'
Write-Host 'Keep this window open so that it can detect map change.'
Write-Host 'SoF should open automatically now.'


# can use LD_PRELOAD here eg.
# Currenly forces vsync off
$environmentVariables = @{
    vblank_mode = '0'
}
# Launch SoF - PassThru required to kill later.
$arguments = @('SoF.exe') + $arguments
$gameProcess = Start-Process -PassThru -FilePath 'wine' -ArgumentList $arguments -Environment $environmentVariables
# Without gamemoderun...
#$arguments = @('SoF.exe') + $arguments
#$gameProcess = Start-Process -PassThru -FilePath 'wine' -ArgumentList $arguments

While ($true) {

    If (Test-Path $AFile) {
    #If ( Get-ChildItem -Path (Get-Item $AFile).DirectoryName -Filter (Get-Item $AFile).Name -Force |
    #      Where-Object { $_.Name -ieq (Get-Item $AFile).Name } ) {

        # Read the last line of the mapname file
        $HttpFile = Get-Content "$AFile" | Select-Object -Last 1
        
        $HttpFile = $HttpFile.Split('"')[3]
        Write-Host "Map name: $HttpFile"
        
        # Remove .bsp extension and add .zip extension
        $HttpFile = "$HttpFile" -replace '\.bsp$', '.zip'

        # Download the file from the http server
        $DestFile = Join-Path "$folderName/maps" $HttpFile
        
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
            Expand-Archive -LiteralPath "$DestFile" -DestinationPath "$folderName" -Force

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
