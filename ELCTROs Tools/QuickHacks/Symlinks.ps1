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

# Identify Windows Username
$userName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split("\")[1]

# Spotify
if (Get-UserConfirmation "Would you like to relink Spotify? (Y/N)") {
    if (Get-UserConfirmation "There are two paths you need to relocate for Spotify. Continue? (Y/N)") {
        $spotifyLocal = Get-UserInput "Where is your new 'Local/Spotify' location" "V:\WindowsThings\Spotify\SpotifyData"
        $spotifyRoaming = Get-UserInput "Where is your new 'Roaming/Spotify' location" "V:\WindowsThings\Spotify"

        $spotifySymlinks = @(
            @{Source="C:\Users\$userName\AppData\Local\Spotify"; Target=$spotifyLocal},
            @{Source="C:\Users\$userName\AppData\Roaming\Spotify"; Target=$spotifyRoaming}
        )

        foreach ($link in $spotifySymlinks) {
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

        # Check for Spicetify
        $spicetifyLocal = "$spotifyRoaming\Spicetify"
        $spicetifyRoaming = "$spotifyRoaming\Spicetify\SpicetifyData"
        if (Test-Path $spicetifyLocal) {
            if (Get-UserConfirmation "There is a preconfiguration of Spicetify present in '$spicetifyLocal' & '$spicetifyRoaming'. Would you like to create symlinks for it too? (Y/N)") {
                $spicetifySymlinks = @(
                    @{Source="C:\Users\$userName\AppData\Roaming\spicetify"; Target=$spicetifyRoaming},
                    @{Source="C:\Users\$userName\AppData\Local\spicetify"; Target=$spicetifyLocal}
                )

                foreach ($link in $spicetifySymlinks) {
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
            } else {
                Write-Output "Not relinking Spicetify. Continuing."
            }
        }

        # Spotify Shortcut
        if (Get-UserConfirmation "Do you want to create Spotify's shortcut? (Y/N)") {
            $shortcutPath = Get-UserInput "Where do you want to create the Spotfy shortcut?" "V:\WindowsThings\Desktop\Spotify.lnk"
            $targetPath = "C:\Users\$userName\AppData\Roaming\Spotify\Spotify.exe"
            $arguments = ""
            $startInPath = "C:\Users\$userName\AppData\Roaming\Spotify"
            $iconPath = Get-UserInput "Where is the Spotify icon located?" "C:\Users\$userName\AppData\Roaming\Spotify\Spotify.exe"

            $WScriptShell = New-Object -ComObject WScript.Shell
            $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
            $shortcut.TargetPath = $targetPath
            $shortcut.Arguments = $arguments
            $shortcut.WorkingDirectory = $startInPath
            $shortcut.WindowStyle = 1
            $shortcut.IconLocation = $iconPath
            $shortcut.Description = "Spotify"
            $shortcut.Save()
            Write-Output "Created Spotify shortcut."
        }else {
            Write-Output "Did not create a Sptofy shortcut."
        }
    } else {
    Write-Output "Cancelled Spotify relink. Continuing."
    }
} else {
    Write-Output "Not relinking Spotify. Continuing."
}

# Discord Canary
if (Get-UserConfirmation "Would you like to relink Discord Canary? (Y/N)") {
    if (Get-UserConfirmation "There are three paths you need to relocate for Discord Canary. Continue? (Y/N)") {
        $discordCanaryLocal = Get-UserInput "Where is your new 'Local/DiscordCanary' folder location?" "V:\WindowsThings\Discord\DiscordCanary"
        $discordRoaming = Get-UserInput "Where is your new 'Roaming/discord' folder location?" "V:\WindowsThings\Discord\DiscordData\discord"
        $discordCanaryRoaming = Get-UserInput "Where is your new 'Roaming/discordcanary' folder location?" "V:\WindowsThings\Discord\DiscordData\discordcanary"

        $discordCanarySymlinks = @(
            @{Source="C:\Users\$userName\AppData\Local\DiscordCanary"; Target=$discordCanaryLocal},
            @{Source="C:\Users\$userName\AppData\Roaming\discord"; Target=$discordRoaming},
            @{Source="C:\Users\$userName\AppData\Roaming\discordcanary"; Target=$discordCanaryRoaming}
        )

        foreach ($link in $discordCanarySymlinks) {
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
                $relinkedVencord
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
        }

        # Discord Canary Shortcut
        if (Get-UserConfirmation "Do you want to create Discord's shortcut? (Y/N)") {
            $appFolder = Get-ChildItem -Path $discordCanaryLocal -Directory | Where-Object { $_.Name -match "^app-\d+\.\d+\.\d+$" } | Select-Object -First 1
            if ($appFolder) {
                $appVersion = $appFolder.Name.Substring(4) # Extract the version numbers from the folder name
                $shortcutPath = Get-UserInput "Where do you want to create the Discord shortcut?" "V:\WindowsThings\Desktop\Discord Canary.lnk"
                $targetPath = "C:\Users\$userName\AppData\Local\DiscordCanary\Update.exe"
                $arguments = "--processStart DiscordCanary.exe"
                $startInPath = "C:\Users\$userName\AppData\Local\DiscordCanary\app-$appVersion"
                $iconPath = Get-UserInput "Where is the Discord icon located?" "C:\Users\$userName\AppData\Local\DiscordCanary\app-$appVersion\DiscordCanary.exe"

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
                Write-Output "No 'app-x.x.xxx' folder found in '$discordCanaryLocal'."
            }
        } else {
            Write-Output "Did not create a Discord shortcut."
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
        $firefoxTarget = Get-UserInput "Where is the new path for your Firefox Profile?" "V:\WindowsThings\Firefox Profile"
        
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

# Powershell Profile Relinking
if (Get-UserConfirmation "Do you have and want to relink a PowerShell profile? (Y/N)") {
    if (Get-UserConfirmation "WARNING: This will delete the file in the Source location. Be sure to move or copy your profile to its new location before moving on. Continue? (Y/N)") {
        $profileLocation = Get-UserInput "Where is your current PowerShell profile?" "V:\Library\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
        $profileDestination = Get-UserInput "Where would you like to relocate your PowerShell profile?" "V:\WindowsThings\Powershell\PWRShellProfile.ps1"
        
        if (Test-Path $profileLocation) {
            if ((Get-Item $profileLocation).LinkType -eq "SymbolicLink") {
                Write-Output "Symlink already exists: $($profileLocation)"
            } else {
                Remove-Item -Path $profileLocation -Force
                New-Item -ItemType SymbolicLink -Path $profileLocation -Target $profileDestination
                Write-Output "Created symlink: $($profileLocation) -> $($profileDestination)"
            }
        } else {
            New-Item -ItemType SymbolicLink -Path $profileLocation -Target $profileDestination
            Write-Output "Created symlink: $($profileLocation) -> $($profileDestination)"
        }
    }
}

Write-Output "Script Process Complete. Have a nice day."
pause