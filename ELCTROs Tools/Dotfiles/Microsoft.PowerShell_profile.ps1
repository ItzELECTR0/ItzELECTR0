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
# POWERTOYS CommandNotFound MODULE
# -------------------------------------------

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# -------------------------------------------
# DEFINE VARIABLES
# -------------------------------------------

# If not running interactively, don't do anything
if ($Host.Name -ne "ConsoleHost") { return }

# Define Editor
$env:EDITOR = "code-insiders"

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
Set-Alias matrix cmatrix
Set-Alias wifi ipconfig
Set-Alias vencord 'V:\Windows Things\Installers\VencordInstallerCli.exe'
Set-Alias open explorer
Set-Alias symlinks 'V:\Windows Things\QuickHacks\Symlinks.ps1'
Set-Alias activate "V:\Windows Things\QuickHacks\MAS\All-In-One-Version\MAS_AIO.cmd"
Set-Alias takeown 'V:\Windows Things\QuickHacks\Add Take Ownership to Context menu.reg'
Set-Alias tweakreg "V:\Windows Things\QuickHacks\ELECTRO's Reg Tweaks.reg"
Set-Alias rmarrow 'V:\Windows Things\QuickHacks\RemoveShortcutArrow.reg'
Set-Alias watermark 'V:\Windows Things\QuickHacks\uwd.exe'
Set-Alias switchtoarch 'V:\Windows Things\QuickHacks\SwitchToArch.ps1'

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