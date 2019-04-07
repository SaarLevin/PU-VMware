<#     
    .NOTES 
    =========================================================================== 
     Created on:    30.1.19     
     Created by:    Saar Levin
     Organization:      
    =========================================================================== 
    .DESCRIPTION 
        This script will get ClusterName & PortGroup & DRS Rule 
        if VM's on port group not found in drs it will add
#> 

#region param 
param ($clusterName,$portGroupName,$drsRule)
#endregion

#region search and add to drs
$buildVMTable = @()
$vmInPG = Get-Cluster $clusterName | Get-VM | ? { $_ | Get-NetworkAdapter | ? {$_.NetworkName -eq $portGroupName} }
$drsRule  = Get-Cluster $clusterName | Get-DrsRule -Name $drsRule

$drsRule.VMIds | % {
    $obj = $_
    $matchVM = Get-View -Id $_
    $buildVMTable += [PSCustomObject]@{
        VMName = $matchVM.Name
        VMId   = $obj
    }
}

$findVMnotInPG = $vmInPG | ? { $buildVMTable.VMName -notcontains $_.Name }

if ($findVMnotInPG) {
    Write-Output "VMs that needed DRS Rule found"
    $vmToAdd = $buildVMTable.VMName + $findVMnotInPG.Name
    try {
        Set-DrsRule -Rule $drsRule -VM $vmToAdd -Enabled:$true -ErrorAction Stop
        Write-Output "VMs add to DRS Rule"
    } catch {
        Write-Output "Failed to add VMs to DRS Rule"
    }       
} else {
    Write-Output "all the vm is part of DRS rule"
}
#endregion