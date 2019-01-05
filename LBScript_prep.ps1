

$SettingsExcel = "c:\VMWARE-Downloads\NSX_LB_script.xlsx"

$Excel = New-Object -COM "Excel.Application"

$Excel.Visible = $False

$WorkBook = $Excel.Workbooks.Open($SettingsExcel)





# Don't Modify below this line ##


$NSX_MGR_IP        = "172.29.1.51"
$NSX_VC_Username = "admin"
$NSX_VC_Password  = "default"

$connection = Connect-NSXServer -NsxServer $NSX_MGR_IP -Username $NSX_VC_Username -Password $NSX_VC_Password



$WorkSheet = $WorkBook.Sheets.Item(1)

$TsEdgeName =  $WorkSheet.Cells.Item(2, 3).Value() ; if ($TsEdgeName -eq $null) { Write-Host "Edge Name shouldn't be Empty ; fix it and re-try" ; break } 
$AppProf_Name =  $WorkSheet.Cells.Item(2, 5).Value() ; if ($AppProf_Name -eq $null) { Write-Host "AppProfile Name shouldn't be Empty ; fix it and re-try" ; break } 
$AppProf_type =  $WorkSheet.Cells.Item(2, 6).Value() ; if ($AppProf_type -eq $null) { Write-Host "AppProfile Type shouldn't be Empty ; fix it and re-try" ; break } 
$APProf_passthrough = $WorkSheet.Cells.Item(2, 7).Value() ; if ($APProf_passthrough -eq "TRUE") { if ($AppProf_type -ne "https")   { Write-Host "AppProfile pass-through applies to AppProfile type: HTTPS only ; fix it and re-try" ; break } }
$APProf_Persistence = $WorkSheet.Cells.Item(2, 9).Value() 
$APProf_cookie_Name = $WorkSheet.Cells.Item(2, 10).Value()
$APProf_Enable_Pool_side_SSL = $WorkSheet.Cells.Item(2, 14).Value(); if ($AppProf_type -ne "https")   { Write-Host "PoolSide SSL applies to APPProfile type: HTTPS only ; fix it and re-try" ; break } 


#$WebAppProfile = Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | New-NsxLoadBalancerApplicationProfile -Name $AppProf_Name -Type $AppProf_type -Parameter(Mandatory=$false)][string]$arg2

if ($APProf_passthrough -eq "TRUE") { $WebAppProfile = Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | New-NsxLoadBalancerApplicationProfile -Name $AppProf_Name -Type $AppProf_type -SslPassthrough }

if ($APProf_passthrough -ne "TRUE") { $WebAppProfile = Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | New-NsxLoadBalancerApplicationProfile -Name $AppProf_Name -Type $AppProf_type    }






$WorkSheet = $WorkBook.Sheets.Item(2)
$ServiceMonitoring_Name =  $WorkSheet.Cells.Item(5, 5).Value() ; if ($ServiceMonitoring_Name -eq $null) { Write-Host "ServiceMonitor Name shouldn't be Empty ; fix it and re-try" ; break } 
$ServiceMonitoring_type =  $WorkSheet.Cells.Item(5, 9).Value() ; if ($ServiceMonitoring_type -eq $null) { $ServiceMonitoring_type = "TCP" } 

Write-Host $ServiceMonitoring_type

if ( $ServiceMonitoring_type -eq "HTTP" -or $ServiceMonitoring_type -eq "HTTPS" -or $ServiceMonitoring_type -eq "TCP" ) {

$ServiceMonitoring_Method = $WorkSheet.Cells.Item(5, 10).Value() 
$ServiceMonitoring_URL =  $WorkSheet.Cells.Item(5, 11).Value()
$ServiceMonitoring_Send =  $WorkSheet.Cells.Item(5, 12).Value()
$ServiceMonitoring_Receive =  $WorkSheet.Cells.Item(5, 13).Value()

if ($ServiceMonitoring_type -eq "HTTP") {
$monitor = Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | New-NsxLoadBalancerMonitor -Name $ServiceMonitoring_Name  -TypeHttp -Url $ServiceMonitoring_URL -Send $ServiceMonitoring_Send -Interval 5 -Timeout 15 -MaxRetries 3 -Method GET
}
if ($ServiceMonitoring_type -eq "HTTPS") {
write-host "here"

$monitor = Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | New-NsxLoadBalancerMonitor -Name $ServiceMonitoring_Name  -Url $ServiceMonitoring_URL -Send $ServiceMonitoring_Send  -TypeHttps -Interval 5 -Timeout 15 -MaxRetries 3 -Method GET
}

if ($ServiceMonitoring_type -eq "TCP") {


$monitor = Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | New-NsxLoadBalancerMonitor -Name $ServiceMonitoring_Name  -TypeTcp -Interval 5 -Timeout 15 -MaxRetries 3

}

}







$WorkSheet = $WorkBook.Sheets.Item(3)
$Pool_Name =  $WorkSheet.Cells.Item(2, 5).Value()
$Pool_Desc =  $WorkSheet.Cells.Item(2, 6).Value()
$Pool_Algorithm =  $WorkSheet.Cells.Item(2, 7).Value()
$Pool_Monitor =  $WorkSheet.Cells.Item(2, 8).Value()


$WorkSheet = $WorkBook.Sheets.Item(4)
$PoolMembers_1_Name =  $WorkSheet.Cells.Item(2, 7).Value()
$PoolMembers_1_IP =  $WorkSheet.Cells.Item(2, 8).Value()
$PoolMembers_1_Port =  $WorkSheet.Cells.Item(2, 9).Value()
$PoolMembers_1_Monitor =  $WorkSheet.Cells.Item(2, 10).Value()

$PoolMembers_2_Name =  $WorkSheet.Cells.Item(3, 7).Value()
$PoolMembers_2_IP =  $WorkSheet.Cells.Item(4, 8).Value()
$PoolMembers_2_Port =  $WorkSheet.Cells.Item(5, 9).Value()
$PoolMembers_2_Monitor =  $WorkSheet.Cells.Item(6, 10).Value()


$WorkSheet = $WorkBook.Sheets.Item(5)
$VS_APP =  $WorkSheet.Cells.Item(2, 7).Value()
$VS_Name =  $WorkSheet.Cells.Item(2, 8).Value()
$VS_Desc =  $WorkSheet.Cells.Item(2, 9).Value()
$VS_IP =  $WorkSheet.Cells.Item(2, 10).Value()
$VS_Protocol =  $WorkSheet.Cells.Item(2, 11).Value()
$VS_Port =  $WorkSheet.Cells.Item(2, 12).Value()
$VS_Pool =  $WorkSheet.Cells.Item(2, 13).Value()


Write-Host "APP Profile Info -- "


Write-Host $AppProf_Name
Write-Host $AppProf_type
Write-Host $APProf_passthrough
Write-Host $APProf_Persistence
Write-Host $APProf_cookie_Name
Write-Host $APProf_Enable_Pool_side_SSL


Write-Host "Service Monitoring Info -- "

Write-Host $ServiceMonitoring_Name
Write-Host $ServiceMonitoring_type
Write-Host $ServiceMonitoring_Method
Write-Host $ServiceMonitoring_URL
Write-Host $ServiceMonitoring_Send
Write-Host $ServiceMonitoring_Receive

<#
Write-Host "Pool Info -- "


Write-Host $Pool_Name
Write-Host $Pool_Desc
Write-Host $Pool_Algorithm
Write-Host $Pool_Monitor


Write-Host "PoolMember Info -- "

Write-Host $PoolMembers_1_Name
Write-Host $PoolMembers_1_IP
Write-Host $PoolMembers_1_Port
Write-Host $PoolMembers_1_Monitor

Write-Host $PoolMembers_2_Name
Write-Host $PoolMembers_2_IP
Write-Host $PoolMembers_2_Port
Write-Host $PoolMembers_2_Monitor



#>


$WorkSheet = $WorkBook.Sheets.Item(2)
$ServiceMonitoring_Method =  if ($WorkSheet.Cells.Item(5, 9).Value() -eq $null) { $ServiceMonitoring_type = "TCP" } Write-Host $ServiceMonitoring_type





$WorkSheet = $WorkBook.Sheets.Item(4)
$Pool_Name =  $WorkSheet.Cells.Item(2, 5).Value() ; if ($Pool_Name -eq $null) { Write-Host "Pool Name shouldn't be Empty ; fix it and re-try" ; break } 
$Pool_Members1 =  $WorkSheet.Cells.Item(2, 7).Value() ; 
$Pool_Members1_ip =  $WorkSheet.Cells.Item(2, 8).Value() ; 
$Pool_Members1_port =  $WorkSheet.Cells.Item(2, 9).Value() ; 

$Pool_Members2 =  $WorkSheet.Cells.Item(3, 7).Value() ; 
$Pool_Members2_ip =  $WorkSheet.Cells.Item(3, 8).Value() ; 
$Pool_Members2_port =  $WorkSheet.Cells.Item(3, 9).Value() ; 


Write-Host $Pool_Name


$webpoolmember1 = New-NsxLoadBalancerMemberSpec -name $Pool_Members1 -IpAddress $Pool_Members1_ip -Port $Pool_Members1_port
$webpoolmember2 = New-NsxLoadBalancerMemberSpec -name $Pool_Members2 -IpAddress $Pool_Members2_ip -Port $Pool_Members2_port


$WebPool = Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | New-NsxLoadBalancerPool -name $Pool_Name -Description "Web Tier Pool" -Transparent:$false -Algorithm round-robin -Memberspec $webpoolmember1,$webpoolmember2




Write-Host "POOL Info -- "
Write-Host $Pool_Name
Write-Host $Pool_Members1
Write-Host $Pool_Members2


$WorkSheet = $WorkBook.Sheets.Item(5)
$VS_APP  = $WorkSheet.Cells.Item(2, 7).Value() ; 
$VS_Name = $WorkSheet.Cells.Item(2, 8).Value() ; 
$VS_Desc = $WorkSheet.Cells.Item(2, 9).Value() ; 
$VS_IP = $WorkSheet.Cells.Item(2, 10).Value() ; 
$VS_Protocol = $WorkSheet.Cells.Item(2, 11).Value() ; 
$VS_Port = $WorkSheet.Cells.Item(2, 12).Value() ; 
$VS_Pool = $WorkSheet.Cells.Item(2, 13).Value() ; 




Write-Host "VirtualServer Info -- "

Write-Host $VS_APP
Write-Host $VS_Name
Write-Host $VS_Desc
Write-Host $VS_IP
Write-Host $VS_Protocol
Write-Host $VS_Port
Write-Host $VS_Pool



Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | Add-NsxLoadBalancerVip -name $VS_Name -Description $VS_Desc -ipaddress $VS_IP `
    -Protocol $VS_Protocol -Port $VS_Port -ApplicationProfile $WebAppProfile -DefaultPool $WebPool -AccelerationEnabled | out-null






<# Script to delete NSX components added as part of this script

# Remove NSX LB VIP
Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | Get-NsxLoadBalancerVip -name $VS_Name | Remove-NsxLoadBalancerVip

 
#Remove NSX LB AppProfile
Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | Get-NsxLoadBalancerApplicationProfile -Name $AppProf_Name | Remove-NsxLoadBalancerApplicationProfile



# Delete Monitor

Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | Get-NsxLoadBalancerMonitor -Name $ServiceMonitoring_Name | Remove-NsxLoadBalancerMonitor 


# Delete Pool Members

$poolname = @(get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | Get-NsxLoadBalancerPool -Name $VS_Pool | Get-NsxLoadBalancerPoolMember | Select name)

foreach ($poolvar in $poolname)
{
write-host $poolvar.name
get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | Get-NsxLoadBalancerPool -Name $VS_Pool | Get-NsxLoadBalancerPoolMember $poolvar.name | Remove-NsxLoadBalancerPoolMember
}


#Delete PoolName

Get-NsxEdge $TsEdgeName | Get-NsxLoadBalancer | Get-NsxLoadBalancerPool -name $VS_Pool | Remove-NsxLoadBalancerPool


#>

