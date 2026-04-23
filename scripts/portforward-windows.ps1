# Persistent kubectl port-forwards (Windows)
# Run this script at logon (Scheduled Task) to keep kubectl port-forwards running.

$ErrorActionPreference = 'Continue'

function Start-PortForwardJob($args) {
    Start-Job -ScriptBlock {
        param($a)
        while ($true) {
            Write-Output "$(Get-Date) starting: kubectl $a"
            kubectl $a
            Write-Output "$(Get-Date) kubectl $a exited — restarting in 2s"
            Start-Sleep -Seconds 2
        }
    } -ArgumentList $args
}

Start-PortForwardJob 'port-forward deployment/shoppingapi-deployment 31000:80'
Start-PortForwardJob 'port-forward deployment/shoppingclient-deployment 30000:80'

Write-Output "Started port-forward jobs. Use Get-Job to view jobs."
Write-Output "To stop: Get-Job | Stop-Job ; Get-Job | Remove-Job"
