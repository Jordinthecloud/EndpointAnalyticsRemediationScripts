<#
Version: 1.0
Author: 
- Jordi Koenderink
Script: Detect-WindowsAppStartMenu.ps1
Description: Detects whether the Windows App Start menu integration is correctly configured
             by checking two registry values under HKLM:\SOFTWARE\Microsoft\WindowsApp:
             - SyncToStartMenuUnavailable set to 0 (feature available, toggle can appear)
             - SyncToStartMenuConfig set to 17 (toggle locked and on, sync active)
             Returns 'Compliant' with exit code 0 if both values are correctly set,
             otherwise 'Not Compliant' with exit code 1.
Release notes:
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#>

#region Define registry keys to validate here
$RegistrySettingsToValidate = @(
    [pscustomobject]@{
        Hive  = 'HKLM:\'
        Key   = 'SOFTWARE\Microsoft\WindowsApp'
        Name  = 'SyncToStartMenuUnavailable'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKLM:\'
        Key   = 'SOFTWARE\Microsoft\WindowsApp'
        Name  = 'SyncToStartMenuConfig'
        Type  = 'REG_DWORD'
        Value = 17
    }
)
#endregion

#region helper functions, enums and maps
$RegTypeMap = @{
    REG_DWORD     = [Microsoft.Win32.RegistryValueKind]::DWord
    REG_SZ        = [Microsoft.Win32.RegistryValueKind]::String
    REG_QWORD     = [Microsoft.Win32.RegistryValueKind]::QWord
    REG_BINARY    = [Microsoft.Win32.RegistryValueKind]::Binary
    REG_MULTI_SZ  = [Microsoft.Win32.RegistryValueKind]::MultiString
    REG_EXPAND_SZ = [Microsoft.Win32.RegistryValueKind]::ExpandString
}
[Flags()] enum RegKeyError {
    None  = 0
    Path  = 1
    Name  = 2
    Type  = 4
    Value = 8
}
#endregion

#region Check if registry keys are set correctly
$KeyErrors = @()
Foreach ($reg in $RegistrySettingsToValidate) {
    [RegKeyError]$CurrentKeyError = 15

    $DesiredPath  = "$($reg.Hive)$($reg.Key)"
    $DesiredName  = $reg.Name
    $DesiredType  = $RegTypeMap[$reg.Type]
    $DesiredValue = $reg.Value

    If (Test-Path -Path $DesiredPath) {
        $CurrentKeyError -= [RegKeyError]::Path
        If ($null -ne (Get-ItemProperty -Path $DesiredPath -Name $DesiredName -ErrorAction SilentlyContinue)) {
            $CurrentKeyError -= [RegKeyError]::Name
            If ($(Get-Item -Path $DesiredPath).GetValueKind($DesiredName) -eq $DesiredType) {
                $CurrentKeyError -= [RegKeyError]::Type
                If ([int]$((Get-ItemProperty -Path $DesiredPath -Name $DesiredName).$DesiredName) -eq [int]$DesiredValue) {
                    $CurrentKeyError -= [RegKeyError]::Value
                } 
            }
        }
    }
    $KeyErrors += $CurrentKeyError
}
#endregion

#region Check if all registry keys are correct
if (($KeyErrors.value__ | Measure-Object -Sum).Sum -eq 0) {
    Write-Output "Compliant"
    Exit 0
} else {
    Write-Warning "Not Compliant"
    Exit 1
}
#endregion