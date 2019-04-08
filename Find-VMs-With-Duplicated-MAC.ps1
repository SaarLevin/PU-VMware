<#
    .NOTES
    ===========================================================================
     Created on:    8.4.2019
     Created by:    Saar Levin
     Organization:
    ===========================================================================
    .DESCRIPTION
        This script will search vms with duplicate mac address
#>

#region collect vm's configuration
$input = Read-Host "Please enter cluster name"
$getAllVms = Get-Cluster $input | Get-VM
$col = @()
$duplicate = @()
foreach ($vm in $getAllVms)
{
    $netCard = Get-VM -Name $vm | Get-NetworkAdapter
    foreach ($net in $netCard)
    {
        $col += [PSCustomObject] @{
            VM = $vm.Name
            NetworkName = $net.NetworkName
            MacAddress = $net.MacAddress
        }
    }
}
#endregion

#region find duplicate
foreach ($obj in $col)
{
    $match = $col | ? { $obj.MacAddress -contains $_.MacAddress }
    #$match = $obj | ? { $col.MacAddress -contains $_.MacAddress }
    if ( ($match | Measure-Object).count -gt 1)
    {
        $duplicate += $match
    }
}

$duplicate | select -Unique
#endregion