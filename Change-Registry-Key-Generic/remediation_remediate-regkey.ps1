<#
Version: 1.0
Author: 
- Jordi Koenderink
Script: Remediate-TaskbarEndTask.ps1
Description: Enables TaskbarEndTask by setting registry value to 1
Release notes:
Version 1.0: Init
Run as: Admin/User
Context: 64 Bit
#> 

##Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"

##Enter the name of the registry key for example EnableLUA
$regname = "TaskbarEndTask"

##Enter the value of the registry key for example 0
$regvalue = "1"

##Enter the type of the registry key for example DWord
$regtype = "DWord"

New-ItemProperty -LiteralPath $regpath -Name $regname -Value $regvalue -PropertyType $regtype -Force -ea SilentlyContinue;