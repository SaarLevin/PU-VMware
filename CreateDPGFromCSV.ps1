<#     
    .NOTES 
    =========================================================================== 
     Created on:       20.8.1018
     Created by:       Saar Levin
     Organization:      
    =========================================================================== 
    .DESCRIPTION 
        This script will read from csv , need to get 3 columns
			1. dvsSwitch
			2. Name
			3. VlanID
#> 

$csv = Read-Host "Please enter csv location"

try {
    $importCSV = Import-Csv $csv -ErrorAction Stop
    foreach ( $line in $importCSV ) 
    {
        if ( $line.VlanID.Length -lt 4 ) {
            try {
                Get-VDSwitch -Name $line.dvsSwitch | New-VDPortgroup -Name $line.Name -NumPorts 8 -VLanId "$($line.Vlanid)" -ErrorAction Stop
                Write-Host $line.Vlanid " - created" -BackgroundColor Green
            } catch {
                Write-Host $line.Vlanid " - not created" -BackgroundColor Red
            }
        } else {
            try {
                Get-VDSwitch -Name $line.dvsSwitch | New-VDPortgroup -Name $line.Name -NumPorts 8 -VlanTrunkRange "$($line.Vlanid)" -ErrorAction Stop
                Write-Host $line.Vlanid " - created" -BackgroundColor Green
            } catch {
                Write-Host $line.Vlanid " - not created" -BackgroundColor Red   
            }
        }
    }
} catch {
    Write-Host "Can't import csv , please check the location" -BackgroundColor Red
}




