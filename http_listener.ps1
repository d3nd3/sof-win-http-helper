$ErrorActionPreference = 'Stop'

$HttpFile = ''
$AFile = 'user\sofplus\data\http_tmp'
$HttpServer = 'https://raw.githubusercontent.com/plowsof/sof1maps/main/'

# Delete existing http file if it exists
If (Test-Path $AFile) {
	Remove-Item $AFile
	Write-Host 'Deleting existing http file.'
}

Write-Host 'Welcome to SoF1 HTTP Auto Map Downloader.'
Write-Host 'Keep this window open so that it can detect map change.'
Write-Host 'SoF should open automatically now.'

# Launch SoF
$gameProcess = Start-Process -PassThru -FilePath 'SoF.exe' -ArgumentList "+set console 1"

While ($true) {
	If (Test-Path $AFile) {
		# Read the last line of the mapname file
		$HttpFile = Get-Content $AFile | Select-Object -Last 1
		
		$HttpFile = $HttpFile.Split('"')[3]
		Write-Host "Map name: $HttpFile"
		
		# Remove .bsp extension and add .zip extension
		$HttpFile = $HttpFile -replace '\.bsp$', '.zip'

		# Download the file from the http server
		$DestFile = Join-Path 'user\maps' $HttpFile

		# Create the directory if it doesn't exist
		$directory = Split-Path -Path $DestFile -Parent
		if (!(Test-Path -Path $directory -PathType Container)) {
			New-Item -Path $directory -ItemType Directory | Out-Null
		}
		# Download the file using Invoke-WebRequest
		Write-Host "NEUTRAL: Trying to download ""$HttpServer$HttpFile"" to ""$DestFile""."

		try {
			$ProgressPreference = 'SilentlyContinue'
			Invoke-WebRequest -Uri "$HttpServer$HttpFile" -OutFile $DestFile -ErrorAction Stop
			Write-Host "SUCCESS: ""$HttpFile"" downloaded to ""$DestFile""."

			# Read-Host -Prompt "Press Enter to continue..."

			# Extract the zip file
			Expand-Archive -LiteralPath $DestFile -DestinationPath 'user' -Force

			# Delete the zip file
			Remove-Item $DestFile
			
		} catch {
			# 404 error catch
			Write-Host "ERROR: $($_.Exception.Message)"
		}
		# Delete the http file
		Remove-Item $AFile
	}
	# Wait for 2 seconds and check again
	Start-Sleep -Seconds 2

	if ($gameProcess.HasExited) {
		exit
	}

}
