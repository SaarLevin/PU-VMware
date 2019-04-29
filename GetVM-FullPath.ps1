<#     
    .NOTES 
    =========================================================================== 
     Created on:   29.4.2019       
     Created by:   Saar Levin        
     Organization:     
    =========================================================================== 
    .DESCRIPTION 
        This script will get full vm folder path
    .EXAMPLE
        Get-VM "SUP-vCenter-60" | Get-FolderPath   
#> 

function Get-FolderPath { 
    param ([Parameter(Mandatory=$true, 
                      ValueFromPipelineByPropertyName=$true)]
        [string]$folderid,
        [switch]$moref)
    
    $parent = get-view $folderid
    if ($parent.name -ne 'vm') {
        if ($moref){
            $path=$parent.moref.toString()+'\'+$path
        } else {
            $path=$parent.name+'\'+$path
        }

        if ($parent.parent){
            if($moref){
                get-vmfolderpath $parent.parent.tostring() -moref
            } else {
                get-vmfolderpath($parent.parent.tostring())
            }
        }
    } else {
        if ($moref) {
            return ( get-view $parent.parent ).moref.tostring()+"\"+$parent.moref.tostring()+"\"+$path
        } else { return $path }
    }
}