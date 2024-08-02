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

# Define Editor
$env:EDITOR = "code-insiders"

# Define Module Directory
$env:PSModulePath = "V:\Library\Documents\PowerShell\Modules;C:\Program Files\PowerShell\Modules;c:\program files\windowsapps\microsoft.powershellpreview_7.5.3.0_x64__8wekyb3d8bbwe\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules;V:\WindowsThings\Powershell\PSModules"

# -------------------------------------------
# MODULES
# -------------------------------------------

# PowerToys CommandNotFounds
Import-Module -Name Microsoft.WinGet.CommandNotFound

# Cmatrix
Import-Module TheTempest.Elect.Cmatrix

# -------------------------------------------
# DEFINE PROMPT
# -------------------------------------------

function prompt {
    $username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split("\")[1]
    $systemname = $(hostname)
    $path = $(Get-Location)
    "$username@$systemname $path> "
}

# -------------------------------------------
# ALIASES
# -------------------------------------------

Set-Alias c Clear-Host
Set-Alias nf neofetch
Set-Alias shutdown Stop-Computer
Set-Alias flatline Stop-Computer -Force
Set-Alias freboot Restart-Computer -Force
Set-Alias code $env:EDITOR
Set-Alias wifi ipconfig
Set-Alias vencord 'V:\WindowsThings\Installers\VencordInstallerCli.exe'
Set-Alias open explorer
Set-Alias symlinks 'V:\WindowsThings\QuickHacks\Symlinks.ps1'
Set-Alias activate "V:\WindowsThings\QuickHacks\MAS\All-In-One-Version\MAS_AIO.cmd"
Set-Alias takeown 'V:\WindowsThings\QuickHacks\Add Take Ownership to Context menu.reg'
Set-Alias tweakreg "V:\WindowsThings\QuickHacks\ELECTRO's Reg Tweaks.reg"
Set-Alias rmarrow 'V:\WindowsThings\QuickHacks\RemoveShortcutArrow.reg'
Set-Alias rmwatermark 'V:\WindowsThings\QuickHacks\uwd.exe'
Set-Alias switchtoarch 'V:\WindowsThings\QuickHacks\SwitchToArch.ps1'
Set-Alias badapple 'V:\WindowsThings\QuickHacks\BadApple.ps1'
Set-Alias upsc "V:\WindowsThings\QuickHacks\UnityProjectShortcutCreatorV1.ps1"
Set-Alias clear "V:\WindowsThings\QuickHacks\PWRShellProfile.ps1"

# -------------------------------------------
# EDIT NOTES
# -------------------------------------------

Set-Alias notes "$env:EDITOR C:\Users\elect\notes.txt"

# -------------------------------------------
# NEOFETCH if on wm
# -------------------------------------------
Write-Host ""
if ($Host.UI.RawUI.KeyAvailable -eq $false) {
    nf
}
Write-Host ""