<#
Version: 1.0
Author: 
- Jordi Koenderink
Script: Detect-TaskbarEndTask.ps1
Description: Detects if TaskbarEndTask is enabled (value = 1)
Release notes:
Version 1.0: Init
Run as: Admin/User
Context: 64 Bit
#> 

##Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"

##Enter the name of the registry key for example EnableLUA
$regname = "TaskbarEndTask"

##Enter the value of the registry key we are checking for, for example 0
$regvalue = "1"


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