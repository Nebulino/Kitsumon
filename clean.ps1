Write-Host "Cleaning .g.dart build objects."
Remove-Item -Path "lib\src\kitsu.g.dart" -ErrorAction SilentlyContinue
Write-Host "Remember to run at least once build.ps1."