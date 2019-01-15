$ServerNodes = @("745-clus-2")
$vSwitchName = "vs-hst-f0-0"
$IP = 21

cd e:\NanoServer
Import-Module e:\NanoServer\NanoServerImageGenerator\NanoServerImageGenerator.psm1 -verbose

$Adminpw = ConvertTo-SecureString -String 'war49jik#' -AsPlainText -Force
$BlobPath = "e:\NanoServer"

#Create Nano Nodes

$ServerNodes | % {
    
    #Create Nano Server Image
    New-NanoServerImage -MediaPath g:\ -BasePath "e:\NanoServerTemp\$_" -TargetPath "f:clusterVM\$_\$_.vhdx" -InterfaceNameOrIndex Ethernet -Ipv4Address 192.168.10.$IP -Ipv4SubnetMask 255.255.255.0 -Ipv4Gateway 192.168.10.1  -Ipv4DNS 192.168.10.2 -Clustering -Compute -Storage -Package Microsoft-NanoServer-SCVMM-Package,Microsoft-NanoServer-SCVMM-Compute-Package -AdministratorPassword $adminpw -DeploymentType Guest -Edition Datacenter -DomainBlobPath "$BlobPath\$_"  -ReuseDomainNode -EnableRemoteManagementPort
    
    #Create new VM with Nano Image as base disk
    New-VM -Name $_ -MemoryStartupBytes 4096MB -BootDevice VHD -VHDPath "F:\clusterVM\$_\$_.vhdx" -SwitchName $vSwitchName -Path "f:\clusterVM\$_" -Generation 2
    Set-VM -Name $_ -ProcessorCount 4

    #Enable nested virtualization
    Set-VMProcessor -VMName $_ -ExposeVirtualizationExtensions $true

    #Add network Interfaces
    Add-VMNetworkAdapter -VMName $_ -SwitchName $vSwitchName -DeviceNaming On
    
	#Enable MAC Spoofing
    Get-VMNetworkAdapter -VMName $_ | Set-VMNetworkAdapter -MacAddressSpoofing On -AllowTeaming On
	

    #Start VM
    Start-VM -Name $_ 
    
    #Remove temp files
    Remove-Item "e:\NanoServerTemp\$_" -Force -recurse
	$IP++
}