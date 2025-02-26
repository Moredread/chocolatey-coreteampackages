﻿$ErrorActionPreference = 'Stop'
$scriptDir=$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
. (Join-Path $scriptDir 'helper.ps1')

$version = "78.0.3869.0-snapshots"
$hive = "hkcu"
$chromium_string = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Chromium"
$Chromium = $hive + ":" + $chromium_string

if (Test-Path $Chromium) {
  $silentArgs = '--do-not-launch-chrome'
} else {
  $silentArgs = '--system-level --do-not-launch-chrome'
}

$packageArgs = @{
  packageName   = 'chromium'
  file          = "$toolsdir\chromium_x32.exe"
  file64        = "$toolsdir\chromium_x64.exe"
  fileType      = 'exe'
  silentArgs    = $silentArgs
  validExitCodes= @(0)
  softwareName  = 'Chromium'
}
if ( Get-CompareVersion -version $version -notation "-snapshots" -package "chromium" ) {
Install-ChocolateyInstallPackage @packageArgs 
} else {
Write-Host "Chromium $version is already installed."
}
Remove-Item $toolsDir\*.exe -ea 0 -force
