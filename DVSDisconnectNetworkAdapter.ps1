<#     
    .NOTES 
    =========================================================================== 
     Created on:      12.12.18      
     Created by:      Saar Levin 
     Organization:    ForeScout  
    =========================================================================== 
    .DESCRIPTION 
        This script will disconnect all the vm network adapter related to port group
#> 


$dvsName = Read-Host "Please Enter DVS Name"
$dvsPortName = Read-Host "Please Enter DVS Port Group"
$log = @()

$vms = Get-VDSwitch -Name $dvsName | Get-VDPortgroup -Name $dvsPortName | Get-VM
Write-Host $vms.Count "Found under this DVS "

$vms.Name | Out-File "$env:TEMP\$($pid)-vms.txt"
notepad "$env:TEMP\$($pid)-vms.txt"

Read-Host "Press enter to continue (Ctrl+c to cancel)"


foreach ($vm in $vms) {
    try {
        Get-VM -Name $vms.Name |  Get-NetworkAdapter | 
            Set-NetworkAdapter -Connected:$false -Confirm:$false -StartConnected:$false -ErrorAction Stop
        Write-Host "$($vms.Name) - Network adapter disconnected succseed" -BackgroundColor Green -ForegroundColor Black
        $log += "$($vms.Name) - Network adapter disconnected succseed"
    } catch {
        Write-Host "$($vms.Name) - Network adapter disconnected failed" -BackgroundColor Red -ForegroundColor Black
        $log += "$($vms.Name) - Network adapter disconnected failed"
    }    
}
$log | Out-File "$env:TEMP\$($pid)-log.txt"
notepad "$env:TEMP\$($pid)-log.txt"