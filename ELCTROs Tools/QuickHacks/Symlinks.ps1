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

# Ask user for their Windows Username
$userName = Read-Host "Enter your Windows username (The name of the folder in C:\Users)"

# Discord Canary
if (Get-UserConfirmation "Would you like to relink Discord? (Y/N)") {
    if (Get-UserConfirmation "There are three paths you need to relocate for Discord Canary. Continue? (Y/N)") {
        $discordCanaryLocal = Get-UserInput "Where is your new 'Local/DiscordCanary' folder location?" "V:\Windows Things\Discord\DiscordCanary"
        $discordRoaming = Get-UserInput "Where is your new 'Roaming/discord' folder location?" "V:\Windows Things\Discord\DiscordData\discord"
        $discordCanaryRoaming = Get-UserInput "Where is your new 'Roaming/discordcanary' folder location?" "V:\Windows Things\Discord\DiscordData\discordcanary"

        $symlinks = @(
            @{Source="C:\Users\$userName\AppData\Local\DiscordCanary"; Target=$discordCanaryLocal},
            @{Source="C:\Users\$userName\AppData\Roaming\discord"; Target=$discordRoaming},
            @{Source="C:\Users\$userName\AppData\Roaming\discordcanary"; Target=$discordCanaryRoaming}
        )

        foreach ($link in $symlinks) {
            if (Test-Path $link.Source) {
                if ((Get-Item $link.Source).LinkType -eq "SymbolicLink") {
                    Write-Output "Symlink already exists: $($link.Source)"
                } else {
                    Remove-Item -Path $link.Source -Recurse -Force
                    New-Item -ItemType SymbolicLink -Path $link.Source -Target $link.Target
                    Write-Output "Created symlink: $($link.Source) -> $($link.Target)"
                }
            } else {
                New-Item -ItemType SymbolicLink -Path $link.Source -Target $link.Target
                Write-Output "Created symlink: $($link.Source) -> $($link.Target)"
            }
        }

        # Check for Vencord
        $vencordPath = Join-Path (Split-Path $discordCanaryLocal -Parent) "Vencord"
        if (Test-Path $vencordPath) {
            if (Get-UserConfirmation "There is a preconfiguration of Vencord present in '$vencordPath'. Would you like to create a symlink for it too? (Y/N)") {
                $vencordSymlink = @{Source="C:\Users\$userName\AppData\Roaming\Vencord"; Target=$vencordPath}
                if (Test-Path $vencordSymlink.Source) {
                    if ((Get-Item $vencordSymlink.Source).LinkType -eq "SymbolicLink") {
                        Write-Output "Symlink already exists: $($vencordSymlink.Source)"
                    } else {
                        Remove-Item -Path $vencordSymlink.Source -Recurse -Force
                        New-Item -ItemType SymbolicLink -Path $vencordSymlink.Source -Target $vencordSymlink.Target
                        Write-Output "Created symlink: $($vencordSymlink.Source) -> $($vencordSymlink.Target)"
                    }
                } else {
                    New-Item -ItemType SymbolicLink -Path $vencordSymlink.Source -Target $vencordSymlink.Target
                    Write-Output "Created symlink: $($vencordSymlink.Source) -> $($vencordSymlink.Target)"
                }
            } else {
                Write-Output "Not relinking Vencord. Continuing."
            }

            # Discord Canary Shortcut
        if (Get-UserConfirmation "Do you want to create Discord's shortcut? (Y/N)") {
            $appFolder = Get-ChildItem -Path $discordCanaryLocal -Directory | Where-Object { $_.Name -match "^app-\d+\.\d+\.\d+$" } | Select-Object -First 1
            if ($appFolder) {
                $appVersion = $appFolder.Name.Substring(4) # Extract the version numbers from the folder name
                $shortcutPath = Get-UserInput "Where do you want to create the Discord shortcut?" "V:\Windows Things\Desktop\Discord Canary.lnk"
                $targetPath = "C:\Users\$userName\AppData\Local\DiscordCanary\Update.exe"
                $arguments = "--processStart DiscordCanary.exe"
                $startInPath = "C:\Users\$userName\AppData\Local\DiscordCanary\app-$appVersion"
                $iconPath = Get-UserInput "Where is the Discord icon located?" "V:\Icons\Discord Icon.ico"

                $WScriptShell = New-Object -ComObject WScript.Shell
                $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
                $shortcut.TargetPath = $targetPath
                $shortcut.Arguments = $arguments
                $shortcut.WorkingDirectory = $startInPath
                $shortcut.WindowStyle = 1
                $shortcut.IconLocation = $iconPath
                $shortcut.Description = "Discord Canary"
                $shortcut.Save()
                Write-Output "Created Discord shortcut."
            } else {
                Write-Output "No 'app-x.x.xxx' folder found in Discord Canary path '$discordCanaryLocal'."
            }
} else {
    Write-Output "Did not create a Discord shortcut."
}

        }
    } else {
        Write-Output "Cancelled Discord relink. Continuing."
    }
} else {
    Write-Output "Not relinking Discord. Continuing."
}

# Firefox
if (Test-Path "C:\Users\$userName\AppData\Roaming\Mozilla") {
    if (Get-UserConfirmation "Would you like to relink your Firefox Profile? (Y/N)") {
        $firefoxProfile = Read-Host "What is the name of your Firefox Profile? (Enter folder name here)"
        $firefoxTarget = Get-UserInput "Where is the new path for your Firefox Profile?" "V:\Windows Things\Firefox Profile"
        
        $firefoxSymlink = @{Source="C:\Users\$userName\AppData\Roaming\Mozilla\Firefox\Profiles\$firefoxProfile"; Target=$firefoxTarget}
        if (Test-Path $firefoxSymlink.Source) {
            if ((Get-Item $firefoxSymlink.Source).LinkType -eq "SymbolicLink") {
                Write-Output "Symlink already exists: $($firefoxSymlink.Source)"
            } else {
                Remove-Item -Path $firefoxSymlink.Source -Recurse -Force
                New-Item -ItemType SymbolicLink -Path $firefoxSymlink.Source -Target $firefoxSymlink.Target
                Write-Output "Created symlink: $($firefoxSymlink.Source) -> $($firefoxSymlink.Target)"
            }
        } else {
            New-Item -ItemType SymbolicLink -Path $firefoxSymlink.Source -Target $firefoxSymlink.Target
            Write-Output "Created symlink: $($firefoxSymlink.Source) -> $($firefoxSymlink.Target)"
        }
    } else {
        Write-Output "Not relinking Firefox. Continuing"
    }
} else {
    Write-Output "Firefox Not Installed. Skipping."
}

Write-Output "Script Process Complete."
pause