<#
Version: 1.0
Author: 
- Jordi Koenderink
Script: Remediate-WindowsAppStartMenu.ps1
Description: Enables Windows App Start menu integration by setting two registry values
             under HKLM:\SOFTWARE\Microsoft\WindowsApp:
             - SyncToStartMenuUnavailable set to 0 (feature available, toggle can appear)
             - SyncToStartMenuConfig set to 17 (toggle locked and on, sync active)
             If the registry path does not exist, it will be created automatically.
Release notes:
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#>

$regpath = "HKLM:\SOFTWARE\Microsoft\WindowsApp"

$RegistrySettingsToApply = @(
    [pscustomobject]@{
        Name  = 'SyncToStartMenuUnavailable'
        Value = 0
        Type  = 'DWord'
    },
    [pscustomobject]@{
        Name  = 'SyncToStartMenuConfig'
        Value = 17
        Type  = 'DWord'
    }
)

# Create the registry path if it doesn't exist
if (-not (Test-Path $regpath)) {
    New-Item -Path $regpath -Force | Out-Null
}

# Create or update each registry property
foreach ($reg in $RegistrySettingsToApply) {
    New-ItemProperty -LiteralPath $regpath -Name $reg.Name -Value $reg.Value -PropertyType $reg.Type -Force -ea SilentlyContinue
}