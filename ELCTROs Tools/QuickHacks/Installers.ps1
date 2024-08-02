# Function to get user input with default value
function Get-UserInput {
    param (
        [string]$promptMessage,
        [string]$defaultValue
    )
    $userInput = Read-Host "$promptMessage (Default: '$defaultValue')"
    if ([string]::IsNullOrWhiteSpace($userInput)) {
        return $defaultValue
    }
    return $userInput
}

# Define the folder containing the installers
$installersFolder = Get-UserInput "Where are your installers located?" "V:\WindowsThings\Installers"

# Get all .exe and .msi files in the folder
$installerFiles = Get-ChildItem -Path $installersFolder -Filter *.exe, *.msi

# Iterate over each installer file and run it
foreach ($installer in $installerFiles) {
    Write-Host "Starting installation of $($installer.Name)..."
    
    # Start the installer process
    $process = Start-Process -FilePath $installer.FullName -Wait -PassThru

    # Wait for the process to complete
    $process.WaitForExit()

    Write-Host "$($installer.Name) installation completed with exit code $($process.ExitCode)."
}

Write-Host "All program installations completed. Have a nice day."
