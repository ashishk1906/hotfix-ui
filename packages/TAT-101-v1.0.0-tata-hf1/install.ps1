param(
    [string]$TargetRoot = (Resolve-Path ".").Path
)

$ErrorActionPreference = "Stop"
$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceFile = Join-Path $PackageRoot "files\app.py"
$DestinationFile = Join-Path $TargetRoot "app.py"

if (-not (Test-Path $SourceFile)) {
    throw "Package file missing: $SourceFile"
}

if (-not (Test-Path $TargetRoot)) {
    throw "Target root does not exist: $TargetRoot"
}

Copy-Item -LiteralPath $SourceFile -Destination $DestinationFile -Force
Write-Output "Installed TAT-101 hotfix file: $DestinationFile"
