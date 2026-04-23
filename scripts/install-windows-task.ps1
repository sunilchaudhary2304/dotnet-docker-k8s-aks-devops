# Install Scheduled Task for persistent kubectl port-forwards (Windows)
Param()

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path "$scriptDir\..").Path
$taskName = 'K8sPortForwardShopping'
$scriptPath = Join-Path $repoRoot 'scripts\portforward-windows.ps1'

Write-Output "Installing Scheduled Task '$taskName' to run: $scriptPath"

try {
    $action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Force | Out-Null
    Write-Output "Scheduled Task '$taskName' registered."
} catch {
    Write-Error "Failed to register Scheduled Task: $_"
    exit 1
}
