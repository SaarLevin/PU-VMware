<#     
    .NOTES 
    =========================================================================== 
     Created on:   19.3.2019       
     Created by:   Saar Levin    
     Organization:      
    =========================================================================== 
    .DESCRIPTION 
        This script will export esxi network configuration
#> 

foreach ($esx in Get-VMHost){
    $vNicTab = @{}
    $esx.ExtensionData.Config.Network.Vnic | %{
        $vNicTab.Add($_.Portgroup,$_)
    }
    $col = foreach($vsw in (Get-VirtualSwitch -VMHost $esx)){
        foreach($pg in (Get-VirtualPortGroup -VirtualSwitch $vsw)){
            Select -InputObject $pg -Property @{N="ESX";E={$esx.name}},
                @{N="vSwitch";E={$vsw.Name}},
                @{N="Active NIC";E={[string]::Join(',',$vsw.ExtensionData.Spec.Policy.NicTeaming.NicOrder.ActiveNic)}},
                @{N="Standby NIC";E={[string]::Join(',',$vsw.ExtensionData.Spec.Policy.NicTeaming.NicOrder.StandbyNic)}},
                @{N="Portgroup";E={$pg.Name}},
                @{N="VLAN";E={$pg.VLanId}},
                @{N="Device";E={if($vNicTab.ContainsKey($pg.Name)){$vNicTab[$pg.Name].Device}}},
                @{N="IP";E={if($vNicTab.ContainsKey($pg.Name)){$vNicTab[$pg.Name].Spec.Ip.IpAddress}}}
        }
    }
    $name = $esx.name.split(".")[0]
    $col | Export-Csv "C:\temp\ESXi-Net-Config\$name.csv" -NoTypeInformation
}

