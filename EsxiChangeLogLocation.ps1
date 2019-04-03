<#     
    .NOTES 
    =========================================================================== 
     Created on:      29.8.2018       
     Created by:      Saar Levin  
     Organization:    ForeScout   
    =========================================================================== 
    .DESCRIPTION 
        This script will create and move logs folder location
		
		$cluster = Get-Cluster -Name "il-mng-cluster" | Get-VMHost
		foreach ($esx in $cluster) {
			Change-Log-Location -EsxiName $esx.Name -DSForLog "LAB-ESXI-LOGS"
		}		
#> 

#region Function
Function Create-Folder {
    [CmdletBinding()]
    param ( 
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$DSName , 
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Folder )

    $datastore = Get-Datastore -Name $DSName
    New-PSDrive -Location $datastore -Name DS -PSProvider VimDatastore -Root "\"
    New-Item -Path DS:\$Folder -ItemType Directory
    Remove-PSDrive -Name DS -Confirm:$false
}

Function Change-Log-Location {
     [CmdletBinding()]
     param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$EsxiName ,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$DSForLog
     )
     Begin {
        $sysLog = "[$DSForLog] Logs/$EsxiName"
        $logInfo  = Get-AdvancedSetting -Entity $EsxiName -Name 'Syslog.global.logDir'
     }
     Process { 
        if ($logInfo.Value -ne $sysLog) {
            Write-Host "Log folder missing on '$EsxiName'" -BackgroundColor Yellow
            try {
                Create-Folder -DSName "$DSForLog" -Folder "Logs/$EsxiName" -ErrorAction Stop | Out-Null
                Write-Host "Log folder created on '$EsxiName'" -BackgroundColor Green
                Get-AdvancedSetting -Entity $EsxiName -Name 'Syslog.global.logDir' | Set-AdvancedSetting -Value $sysLog -Confirm:$false -ErrorAction Stop
                Write-Host "'$EsxiName' move to new location" -BackgroundColor Green
            } catch {
                Write-Host "Log folder not created '$EsxiName'" -BackgroundColor Red    
            }
        } else {
            Write-Host "'$EsxiName' --  Folder created Error OR Log folder already configured"    
        }
     }
     End { }    
}
#endregion

#region Script (NEED TO MODIFIED)
