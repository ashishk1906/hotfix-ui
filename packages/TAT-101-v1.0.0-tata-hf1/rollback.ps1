param(
    [string]$TargetRoot = (Resolve-Path ".").Path
)

$ErrorActionPreference = "Stop"
$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RollbackFile = Join-Path $PackageRoot "rollback\app.py"
$DestinationFile = Join-Path $TargetRoot "app.py"

if (-not (Test-Path $RollbackFile)) {
    throw "Rollback file missing: $RollbackFile"
}

if (-not (Test-Path $TargetRoot)) {
    throw "Target root does not exist: $TargetRoot"
}

Copy-Item -LiteralPath $RollbackFile -Destination $DestinationFile -Force
Write-Output "Rolled back TAT-101 hotfix file: $DestinationFile"
