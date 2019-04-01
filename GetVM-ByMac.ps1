<#
    .NOTES
    ===========================================================================
     Created on:       31.3.2019
     Created by:       Saar Levin
     Organization:
    ===========================================================================
    .DESCRIPTION
        This script will find VM by mac address
#>

$input = Read-Host "Please enter mac address (Example:'00:50:56:b6:fd:ad')"
Get-VM | Get-NetworkAdapter | Where {$_.MacAddress -eq $input} | Select-Object Parent,MacAddress