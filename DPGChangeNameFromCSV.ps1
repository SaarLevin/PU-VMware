<#     
    .NOTES 
    =========================================================================== 
     Created on:    20.8.2018  
     Created by:    Saar Levin    
     Organization:      
    =========================================================================== 
    .DESCRIPTION 
        This script will change name for ports group
		CSv needs to contains 2 columns 
			1 - OldName
			2 - NewName
#>

$csv = Read-Host "Please enter csv location"

try {
    $importCSV = Import-Csv $csv -ErrorAction Stop
    foreach ( $line in $importCSV ) 
    {
        if ($line.OldName -ne $line.NewName) {
            try {
                Get-VDPortgroup -Name $line.OldName | Set-VDPortgroup -Name $line.NewName -ErrorAction Stop
                Write-Host $line.OldName " to " $line.NewName " success"
            } catch {
                Write-Host $line.OldName " to " $line.NewName " failed"
            }
        } else {
            Write-Host "old name and new name eq" -BackgroundColor Yellow
        }
    }
} catch {
    Write-Host "Can't import csv , please check the location" -BackgroundColor Red
}
