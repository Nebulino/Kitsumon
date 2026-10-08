Write-Host "Getting dependencies."
dart pub get
Write-Host "Starting building .g.dart build objects."
dart run build_runner build
Write-Host "Finished building."