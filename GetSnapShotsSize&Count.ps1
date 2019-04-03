
$vms = Get-View -ViewType VirtualMachine -Property Name,Snapshot -Filter @{'Snapshot' = ''}
foreach ($vm in $vms) {
    $snapShots = Get-VM -Name $vm.Name | Get-Snapshot
    $i = 1
    foreach ($snapShot in $snapShots) {
        [PSCustomObject]@{
            VM          = $vm.Name
            SnapSizeGB  = "{0:N0}" -f $snapShot.SizeGB
            SnapNum     = $i
            SnapTotal   = $snapShots.Count
    }
        $i++    
    }
}