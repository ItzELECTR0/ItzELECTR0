# ---------------------------------------------------ELECTRO----------------------------------------------------------
#                                                                                                                     
#    o__ __o     o              o    o__ __o         o__ __o      o         o    o__ __o__/_   o            o         
#   <|     v\   <|>            <|>  <|     v\       /v     v\    <|>       <|>  <|    v       <|>          <|>        
#   / \     <\  / \            / \  / \     <\     />       <\   < >       < >  < >           / \          / \        
#   \o/     o/  \o/            \o/  \o/     o/    _\o____         |         |    |            \o/          \o/        
#    |__  _<|/   |              |    |__  _<|          \_\__o__   o__/_ _\__o    o__/_         |            |         
#    |          < >            < >   |       \               \    |         |    |            / \          / \        
#   <o>          \o    o/\o    o/   <o>       \o   \         /   <o>       <o>  <o>           \o/          \o/        
#    |            v\  /v  v\  /v     |         v\   o       o     |         |    |             |            |         
#   / \            <\/>    <\/>     / \         <\  <\__ __/>    / \       / \  / \  _\o__/_  / \ _\o__/_  / \ _\o__/_
#                                                                                                                     
# ---------------------------------------------------ELECTRO----------------------------------------------------------

# -------------------------------------------
# CUSTOM MENU
# -------------------------------------------

# Menu options
$menuOptions = @(
    @{ Label = "1. Create Symlinks"; Action = { Start-Symlinks } },
    @{ Label = "2. QuickInstall"; Action = { Start-QuickInstall } },
    @{ Label = "3. Work on TWAOS"; Action = { Start-TWAOS } },
    @{ Label = "Exit"; Action = { Exit } }
)

# Function to display menu and capture user input
function Show-Menu {
    $currentSelection = 0
    $key = $null
    do {
        Clear-Host
        Write-Output "PowerShell $($PSVersionTable.PSVersion)"
        neofetch
        Write-Output ""
        Write-Output "This is an experimental feature. It might not work properly."
        Write-Output ""
        for ($i = 0; $i -lt $menuOptions.Count; $i++) {
            if ($i -eq $currentSelection) {
                Write-Host " > $($menuOptions[$i].Label)" -ForegroundColor Cyan
            } else {
                Write-Host "   $($menuOptions[$i].Label)"
            }
        }

        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

        switch ($key.VirtualKeyCode) {
            38 { # Up arrow
                if ($currentSelection -gt 0) { $currentSelection-- }
            }
            40 { # Down arrow
                if ($currentSelection -lt ($menuOptions.Count - 1)) { $currentSelection++ }
            }
            13 { # Enter key
                & $menuOptions[$currentSelection].Action
            }
        }
    } while ($key.VirtualKeyCode -ne 13 -or $currentSelection -ne ($menuOptions.Count - 1))
}

# -------------------------------------------
# GENERAL FUNCTIONS
# -------------------------------------------

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

# Checks if a symlink already exists and creates on if it doesn't
function Ensure-Symlink {
    param (
        [string]$Source,
        [string]$Target
    )
    if (Test-Path $Source) {
        if ((Get-Item $Source).LinkType -eq "SymbolicLink") {
            Write-Output "Symlink already exists: $Source"
        } else {
            Remove-Item -Path $Source -Recurse -Force
            New-Item -ItemType SymbolicLink -Path $Source -Target $Target
            Write-Output "Replaced directory with symlink: $Source -> $Target"
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $Source -Target $Target
        Write-Output "Created symlink: $Source -> $Target"
    }
}

# -------------------------------------------
# CLEAR EVERYTHING BEFORE TAKING ACTION
# -------------------------------------------

Clear-Host

# -------------------------------------------
# LIST POWERSHELL VERSION
# -------------------------------------------

Write-Output "PowerShell $($PSVersionTable.PSVersion)"

# -------------------------------------------
# DEFINE VARIABLES
# -------------------------------------------

# If not running interactively, don't do anything
if ($Host.Name -ne "ConsoleHost") { return }

# Define Username
$username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split("\")[1]

# Define System/Host Name
$systemname = $(hostname)

# Define Module Directory
$env:PSModulePath = "V:\Library\Documents\PowerShell\Modules;C:\Program Files\PowerShell\Modules;c:\program files\windowsapps\microsoft.powershellpreview_7.5.3.0_x64__8wekyb3d8bbwe\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules;V:\WindowsThings\Powershell\PSModules"

# Define Editor
$env:EDITOR = "code-insiders"

# -------------------------------------------
# MODULES
# -------------------------------------------

# PowerToys CommandNotFounds
Import-Module -Name Microsoft.WinGet.CommandNotFound

# Cmatrix
Import-Module TheTempest.Elect.Cmatrix

# Chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# -------------------------------------------
# DEFINE PROMPT
# -------------------------------------------

function prompt {
    $path = $(Get-Location)
    "$username@$systemname $path> "
}

# -------------------------------------------
# ALIASES
# -------------------------------------------

Set-Alias adb.exe .\adb.exe
Set-Alias gusrconf Get-UserConfirmation
Set-Alias gusrinpt Get-UserInput
Set-Alias menu Show-Menu
Set-Alias quickinstall Start-QuickInstall
Set-Alias choco-inst Get-Chocolatey
Set-Alias ffmpeg-inst Get-FFMpeg
Set-Alias ytdlp-inst Get-YTDLP
Set-Alias afterburner-inst Get-Afterburner
Set-Alias buildtools-inst Get-BuildTools22
Set-Alias freshconfig Start-FreshConfig
Set-Alias clear-all Clear-Host
Set-Alias nf neofetch
Set-Alias shutdown Stop-Computer
Set-Alias flatline Stop-Computer -Force
Set-Alias freboot Restart-Computer -Force
Set-Alias code $env:EDITOR
Set-Alias wifi ipconfig
Set-Alias vencord 'V:\WindowsThings\Installers\VencordInstallerCli.exe'
Set-Alias open Open-Directory
Set-Alias symlinks Start-Symlinks
Set-Alias activate "V:\WindowsThings\QuickHacks\MAS\All-In-One-Version\MAS_AIO.cmd"
Set-Alias takeown 'V:\WindowsThings\QuickHacks\TakeOwnershipContextMenu.reg'
Set-Alias tweakreg "V:\WindowsThings\QuickHacks\ELECTRO'sRegTweaks.reg"
Set-Alias rmarrow 'V:\WindowsThings\QuickHacks\RemoveShortcutArrow.reg'
Set-Alias rmwatermark 'V:\WindowsThings\QuickHacks\uwd.exe'
Set-Alias switchtoarch Switch-ArchLinux
Set-Alias badapple Start-BadApple
Set-Alias clear Start-CustomClear
Set-Alias twaos Start-TWAOS
Set-Alias ctt Start-CTT
Set-Alias rufus "V:\WindowsThings\Installers\rufus-4.5.exe"
Set-Alias rufus.com .\rufus.com
Set-Alias passwd Get-Passwd
Set-Alias notes Edit-Notes

# -------------------------------------------
# NEOFETCH if on wm
# -------------------------------------------
Write-Host ""
if ($Host.UI.RawUI.KeyAvailable -eq $false) {
    nf
}
Write-Host ""

# -------------------------------------------
# CUSTOM FUNCTIONS
# -------------------------------------------

function Start-CustomClear {
    V:\WindowsThings\Powershell\PWRShellProfile.ps1
}

function Open-Directory {
    explorer .
}

function Get-BuildTools22 {
    if (Get-UserConfirmation "Would you like to install Visual Studio Build Tools 2022? (Y/N)") {
        winget install --id=Microsoft.VisualStudio.2022.BuildTools -e
    }
}

function Get-Chocolatey {
    if (Get-UserConfirmation "Would you like to install Chocolatey? (Y/N)") {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
}

function Get-FFMpeg {
    if (Get-UserConfirmation "Would you like to install FFMpeg? (Y/N)") {
        Invoke-Expression (Invoke-RestMethod ffmpeg.tc.ht)
    }
}

function Get-YTDLP {
    if (Get-UserConfirmation "Would you like to install YT-DLP? (Y/N)") {
        winget install yt-dlp.yt-dlp.nightly
    }
}

function Get-Afterburner {
    if (Get-UserConfirmation "Would you like to install MSI Afterburner? (Y/N)") {
        winget install Guru3D.Afterburner.Beta
    }
}

function Start-Symlinks {
    
    # Spotify
    if (Get-UserConfirmation "Would you like to relink Spotify? (Y/N)") {
        if (Get-UserConfirmation "There are two paths you need to relocate for Spotify. Continue? (Y/N)") {
            $spotifyLocal = Get-UserInput "Where is your new 'Local/Spotify' location" "V:\WindowsThings\Spotify\SpotifyData"
            $spotifyRoaming = Get-UserInput "Where is your new 'Roaming/Spotify' location" "V:\WindowsThings\Spotify"
    
            $spotifySymlinks = @(
                @{Source="C:\Users\$username\AppData\Local\Spotify"; Target=$spotifyLocal},
                @{Source="C:\Users\$username\AppData\Roaming\Spotify"; Target=$spotifyRoaming}
            )
    
            foreach ($link in $spotifySymlinks) {
                Ensure-Symlink $link.Source $link.Target
            }
    
            # Check for Spicetify
            $spicetifyLocal = "$spotifyRoaming\Spicetify"
            $spicetifyRoaming = "$spotifyRoaming\Spicetify\SpicetifyData"
            if (Test-Path $spicetifyLocal) {
                if (Get-UserConfirmation "There is a preconfiguration of Spicetify present in '$spicetifyLocal' & '$spicetifyRoaming'. Would you like to create symlinks for it too? (Y/N)") {
                    $spicetifySymlinks = @(
                        @{Source="C:\Users\$username\AppData\Roaming\spicetify"; Target=$spicetifyRoaming},
                        @{Source="C:\Users\$username\AppData\Local\spicetify"; Target=$spicetifyLocal}
                    )
    
                    foreach ($link in $spicetifySymlinks) {
                        Ensure-Symlink $link.Source $link.Target
                    }
                } else {
                    Write-Output "Not relinking Spicetify. Continuing."
                }
            }
    
            # Spotify Shortcut
            if (Get-UserConfirmation "Do you want to create Spotify's shortcut? (Y/N)") {
                $shortcutPath = Get-UserInput "Where do you want to create the Spotfy shortcut?" "V:\WindowsThings\Desktop\Spotify.lnk"
                $targetPath = "C:\Users\$username\AppData\Roaming\Spotify\Spotify.exe"
                $arguments = ""
                $startInPath = "C:\Users\$username\AppData\Roaming\Spotify"
                $iconPath = Get-UserInput "Where is the Spotify icon located?" "C:\Users\$username\AppData\Roaming\Spotify\Spotify.exe"
    
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
                @{Source="C:\Users\$username\AppData\Local\DiscordCanary"; Target=$discordCanaryLocal},
                @{Source="C:\Users\$username\AppData\Roaming\discord"; Target=$discordRoaming},
                @{Source="C:\Users\$username\AppData\Roaming\discordcanary"; Target=$discordCanaryRoaming}
            )
    
            foreach ($link in $discordCanarySymlinks) {
                Ensure-Symlink $link.Source $link.Target
            }
    
            # Check for Vencord
            $vencordPath = Join-Path (Split-Path $discordCanaryLocal -Parent) "Vencord"
            if (Test-Path $vencordPath) {
                if (Get-UserConfirmation "There is a preconfiguration of Vencord present in '$vencordPath'. Would you like to create a symlink for it too? (Y/N)") {
                    $relinkedVencord
                    $vencordSymlink = @{Source="C:\Users\$username\AppData\Roaming\Vencord"; Target=$vencordPath}
                    Ensure-Symlink $vencordSymlink.Source $vencordSymlink.Target
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
                    $startInPath = "C:\Users\$username\AppData\Local\DiscordCanary\app-$appVersion"
                    $iconPath = Get-UserInput "Where is the Discord icon located?" "C:\Users\$username\AppData\Local\DiscordCanary\app-$appVersion\DiscordCanary.exe"
    
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
    if (Test-Path "C:\Users\$username\AppData\Roaming\Mozilla") {
        if (Get-UserConfirmation "Would you like to relink your Firefox Profile? (Y/N)") {
            $firefoxProfile = Read-Host "What is the name of your Firefox Profile? (Enter folder name here)"
            $firefoxTarget = Get-UserInput "Where is the new path for your Firefox Profile?" "V:\WindowsThings\Firefox Profile"
            
            $firefoxSymlink = @{Source="C:\Users\$username\AppData\Roaming\Mozilla\Firefox\Profiles\$firefoxProfile"; Target=$firefoxTarget}
            Ensure-Symlink $firefoxSymlink.Source $firefoxSymlink.Target
        } else {
            Write-Output "Not relinking Firefox. Continuing"
        }
    } else {
        Write-Output "Firefox Not Installed. Skipping."
    }

    # Game Shortcuts Folder
    if (Get-UserConfirmation "Do you want to link a folder for game shortcuts to your start menu? (Y/N)") {
        $startMenuGamesLocation = Get-UserInput "What do you want to name your games folder?" "Games"
        $gamesFolderLocation = Get-UserInput "Where do you want to keep your game shortcuts?" "V:\WindowsThings\Desktop\Stuff\Games"

        $gameSymlink = @{Source="C:\Users\$userName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\$startMenuGamesLocation"; Target=$gamesFolderLocation}
        Ensure-Symlink $gameSymlink.Source $gameSymlink.Target

        Write-Output "Folders are linked. Add shortcuts to your folder and pin them to your start menu!"
    }else {
        Write-Output "Not linking a Games folder. Continuing."
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
}

function Switch-ArchLinux {
    # Check if running as Administrator
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
        Write-Error "You need to run this script as an Administrator!"
        exit
    }

    # Import necessary module
    Import-Module SecureBoot

    # Check if Secure Boot is enabled
    if (Get-SecureBootPolicy | Select-Object -ExpandProperty SecureBootEnabled)
    {
        Write-Output "Secure Boot is enabled. Disabling Secure Boot..."
        Disable-SecureBoot
        Write-Output "Secure Boot has been disabled."
    }
    else
    {
        Write-Output "Secure Boot is already disabled."
    }

    # Get current boot order
    $bootOrder = bcdedit /enum firmware

    # Find the identifier for the Windows Boot Manager
    $windowsBootManager = ($bootOrder | Select-String "description\s+Windows Boot Manager" -Context 0,1).Context.PostContext | Select-String "identifier" | ForEach-Object { $_.ToString().Split()[1] }

    # Find the identifier for the UEFI OS (e.g., Arch Linux)
    $uefiOS = ($bootOrder | Select-String "description\s+EFI\ BlackArch\ Grub" -Context 0,1).Context.PostContext | Select-String "identifier" | ForEach-Object { $_.ToString().Split()[1] }

    if ($uefiOS)
    {
        Write-Output "Found UEFI OS. Updating boot order to prioritize UEFI OS over Windows Boot Manager..."
        bcdedit /set {fwbootmgr} bootsequence $uefiOS,$windowsBootManager
        Write-Output "Boot order updated."
    }
    else
    {
        Write-Error "UEFI OS not found. Please ensure BlackArch Linux is installed and properly recognized by the UEFI firmware."
    }

    Write-Output "Execution completed."
}

function Start-BadApple {
    Set-Location "V:\Windows Things\QuickHacks\BadApple"
    npm start   
}

function Start-CTT {
    Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression
}

function Start-FreshConfig {
    if (Get-UserConfirmation "Would you like to install this script's packages? (Y/N)") {
        if (Get-UserConfirmation "There are five 5 to install. Continue? (Y/N)") {
            winget install nepnep.neofetch-win
            winget install Microsoft.DotNet.SDK.9
            winget install Microsoft.DotNet.SDK.8
            winget install Microsoft.DotNet.SDK.6
            winget install CharlesMilette.TranslucentTB
            winget install Microsoft.PowerToys
            winget install M2Team.NanaZip.Preview
            winget install 9NBLGGH5FV99
            winget install Microsoft.PowerShell.Preview
            winget install 9MZNMNKSM73X
        }else {
            Write-Output "Installation aborted."
        }
    }else {
        Write-Output "Not installing packages."
    } 
}

function Start-QuickInstall {
    Start-FreshConfig
    Get-BuildTools22
    Get-Chocolatey
    Get-FFMpeg
    Get-YTDLP
    Get-Afterburner
}

function Edit-Notes {
    code-insiders C:\Users\$username\notes.txt
}

function Get-Passwd {
    Get-Content "V:\passwd.txt"
}

function Start-TWAOS {
    Set-Location "D:\Projects\TWAOS"
    clear
}
