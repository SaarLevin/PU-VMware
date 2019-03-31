<#
    .NOTES
    ===========================================================================
     Created on:       31.3.2019
     Created by:       Saar Levin
     Organization:
    ===========================================================================
    .DESCRIPTION
        This script will find all orphand vm's in the VCenter and re-registered them .
#>

#region orphend vm
$orphanedVMs = Get-VM * | ? {$_.ExtensionData.Summary.Runtime.ConnectionState -eq "orphaned"}

foreach ($obj in $orphanedVMs)
{
    Remove-VM -VM $obj -Confirm:$false
    #$resourcePool = Get-ResourcePool -VM $obj
    $folder = Get-Folder -id $obj.FolderId
    New-VM -VMFilePath $($obj.ExtensionData.Summary.Config.VmPathName) -VMHost $($obj.VMHost.name) -Location $folder
    Get-vm  $obj |  Start-VM -ErrorAction Ignore
    Get-VM -Name $obj| Get-VMQuestion | Set-VMQuestion –Option "button.uuid.movedTheVM" -Confirm:$false
}
#endregion