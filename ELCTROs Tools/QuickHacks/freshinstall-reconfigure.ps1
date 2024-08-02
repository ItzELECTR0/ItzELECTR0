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

# Run predefined scripts
if (Get-UserConfirmation "Do you confirm that you are on a fresh install of Windows 10/11 and would like to apply a preset configuration? (Y/N)") {
    if (Get-UserConfirmation "Do you want to use existing redistributable installers on your machine? (Y/N)") {
        V:\WindowsThings\QuickHacks\Redists.ps1
    } else {
        Write-Output "Not using any pre-existing driver/redist installers. Continuing."
    }

    if (Get-UserConfirmation "Do you want to use existing installers on your machine? (Y/N)") {
        V:\WindowsThings\QuickHacks\Installers.ps1
    } else {
        Write-Output "Not using any pre-existing installers. Continuing."
    }

    if (Get-UserConfirmation "Do you have any backed up files you'd like to move? (Y/N)") {
        $moveFrom = Get-UserInput "Where is your backup directory?" "V:\WindowsThings\Backup\C"
        $moveDestination = Get-UserInput "Where would you like to move your backed up files?" "C:\"
    
        if ($moveDestination -eq "C:\") {
            Write-Host "Warning: Moving files to C:\ can overwrite critical system files. Ensure this action is safe."
            if (-not (Get-UserConfirmation "Do you want to proceed? (Y/N)")) {
                Write-Host "Operation aborted."
                return
            }
        }
    
        if (Test-Path $moveFrom) {
            if (-not (Test-Path $moveDestination)) {
                New-Item -Path $moveDestination -ItemType Directory
            }

            $items = Get-ChildItem -Path $moveFrom -Recurse
            
            foreach ($item in $items) {
                $destPath = $item.FullName.Replace($moveFrom, $moveDestination)
                
                if ($item.PSIsContainer) {
                    if (-not (Test-Path $destPath)) {
                        New-Item -Path $destPath -ItemType Directory
                    }
                } else {
                    if (Get-UserConfirmation "Use Forced mode? Will replace existing files. (Y/N)") {
                        if (Test-Path $destPath) {
                            Remove-Item -Path $destPath -Force
                        }
                        Move-Item -Path $item.FullName -Destination $destPath -Force
                    } else {
                        Move-Item -Path $item.FullName -Destination $destPath
                    }
                }
            }
    
            Write-Host "All items moved from $moveFrom to $moveDestination."
        } else {
            Write-Host "Source path $moveFrom does not exist."
        }
    }
    

    if (Get-UserConfirmation "Do you want to create symlinks for preinstalled apps? (Y/N)") {
        V:\WindowsThings\QuickHacks\Symlinks.ps1
    } else {
        Write-Output "Not creating any symlinks. Continuing."
    }
}

Write-Output "Configuration successfully applied. Have a nice day."