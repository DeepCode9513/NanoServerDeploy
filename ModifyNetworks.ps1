#Create Cluster
#Validate cluster
Test-Cluster -Node "745-clus-1", "745-clus-2" -Include "Storage Spaces Direct", Inventory,Network,"System Configuration"
New-Cluster –Name 745-TestCluster –Node 745-clus-1, 745-clus-2 –NoStorage –StaticAddress 192.168.10.184 -ignoreNetwork 10.0.1.0/24,10.0.2.0/24,10.0.3.0/24
(Get-ClusterNetwork -Cluster 745-TestCluster -Name "Cluster Network 1").Name="Management"
(Get-ClusterNetwork -Cluster 745-TestCluster -Name "Cluster Network 1").Name="Storage"
(Get-ClusterNetwork -Cluster 745-TestCluster -Name "Cluster Network 3").Name="Cluster"
(Get-ClusterNetwork -Cluster 745-TestCluster -Name "Cluster Network 4").Name="Live-Migration"
(Get-ClusterNetwork -Cluster 745-TestCluster -Name "Storage").Role="ClusterAndClient"


#Configure FileShare Witness
Set-ClusterQuorum -Cluster 745-TestCluster -NodeAndFileShareMajority \\745-vmm-dc\witness

#Enable Storage Spaces Direct
$ServerNodes = @("745-clus-1","745-clus-2")
Enable-ClusterStorageSpacesDirect -Autoconfig $false -SkipEligibilityChecks -CimSession $ServerNodes[0] -Confirm:$false

#Create the Storage Pool
New-StoragePool -StorageSubSystemName 745-TestCluster.exam745.net -FriendlyName "S2DPool" -WriteCacheSizeDefault 0 -ProvisioningTypeDefault Fixed -ResiliencySettingNameDefault Mirror -PhysicalDisk (Get-StorageSubSystem -Name 745-TestCluster.exam745.net | Get-PhysicalDisk | where size -eq 16106127360)
New-StoragePool -StorageSubSystemName 745-TestCluster.exam745.net -FriendlyName "S2DPool-2" -WriteCacheSizeDefault 0 -ProvisioningTypeDefault Fixed -ResiliencySettingNameDefault Mirror -PhysicalDisk (Get-StorageSubSystem -Name 745-TestCluster.exam745.net | Get-PhysicalDisk | where size -eq 37580963840)

New-Volume -StoragePoolFriendlyName "S2DPool" -FriendlyName VMStorage02 -NumberOfColumns 1 -PhysicalDiskRedundancy 1 -FileSystem CSVFS_REFS -UseMaximumSize
New-Volume -StoragePoolFriendlyName "S2DPool-2" -FriendlyName VMStorage02 -NumberOfColumns 1 -PhysicalDiskRedundancy 1 -FileSystem CSVFS_REFS -UseMaximumSize