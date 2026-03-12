<#
Version: 1.0
Author: 
- Jordi Koenderink
Script: Detect-FileExplorerLaunchTo.ps1
Description: Detects whether the default File Explorer launch location is correctly configured
             by checking if the LaunchTo registry value is set to 4 under 
             HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced.
             A value of 4 sets File Explorer to open to a specific location (e.g. OneDrive).
             Returns 'Compliant' with exit code 0 if correctly set, otherwise 'Not Compliant' with exit code 1.
Release notes:
Version 1.0: Init
Run as: Admin/User
Context: 64 Bit
#> 

##Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

##Enter the name of the registry key for example EnableLUA
$regname = "LaunchTo"

##Enter the value of the registry key we are checking for, for example 0
$regvalue = "4"


Try {
    $Registry = Get-ItemProperty -Path $regpath -Name $regname -ErrorAction Stop | Select-Object -ExpandProperty $regname
    If ($Registry -eq $regvalue){
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}