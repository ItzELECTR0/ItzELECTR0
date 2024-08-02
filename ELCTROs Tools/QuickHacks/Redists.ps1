# Function to get user confirmation
function Get-UserConfirmation {
    param (
        [string]$promptMessage
    )
    while ($true) {
        $confirmation = Read-Host $promptMessage
        if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
            return $true
        } elseif ($confirmation -eq 'N' -or $confirmation -eq 'n') {
            return $false
        } else {
            Write-Output "Invalid input. Please enter 'Y' or 'N'"
        }
    }
}

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

# Function to install redists from a specified folder
function Install-Redists {
    param (
        [string]$folderPath
    )
    # Get all .inf .exe and .msi files in the folder
    $redistFiles = Get-ChildItem -Path $folderPath -Recurse -Include *.exe, *.msi, *.inf
    
    # Run each redist installer found one by one
    foreach ($redist in $redistFiles) {
        Write-Host "Starting installation of $($redist.Name)..."
        
        $process = Start-Process -FilePath $redist.FullName -Wait -PassThru

        $process.WaitForExit()

        Write-Host "$($redist.Name) installation completed with exit code $($process.ExitCode)."
    }
}

$redistFolder = Get-UserInput "Where are your redists located?" "V:\WindowsThings\Drivers&Redists"

Install-Redists -folderPath $redistFolder

Write-Host "All driver and redist installations completed. Have a nice day."
