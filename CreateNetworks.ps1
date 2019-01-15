$username = "exam745\Administrator"
$password = "war49jik#"
$secstr = New-Object -TypeName System.Security.SecureString
$password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr

Enter-PSSession –VMName 745-clus-2 –Credential $cred
New-VMSwitch -Name Management -EnableEmbeddedTeaming $True -AllowManagementOS $True -NetAdapterName "Ethernet", "Ethernet 2"
# Add Virtual NICs for Storage, Cluster and Live-Migration
Add-VMNetworkAdapter -ManagementOS -Name "Storage" -SwitchName Management
Add-VMNetworkAdapter -ManagementOS -Name "Cluster" -SwitchName Management
Add-VMNetworkAdapter -ManagementOS -Name "LiveMigration" -SwitchName Management
	
	
$IPMgmt = 171
$IPSto = 1
$IPLM = 171
$IPClust = 171


Enable-NetAdapterRDMA -Name "vEthernet (Storage)"
Enable-NetAdapterRDMA -Name "vEthernet (LiveMigration)"	
	
netsh interface ip set address "vEthernet (Management)" static 192.168.10.$IPMgmt 255.255.255.0 192.168.10.1
netsh interface ip set dns "vEthernet (Management)" static 192.168.10.2
netsh interface ip set address "vEthernet (Storage)" static 10.0.1.$IPSto 255.255.255.0
netsh interface ip set address "vEthernet (LiveMigration)" static 10.0.3.$IPLM 255.255.255.0
netsh interface ip set address "vEthernet (Cluster)" static 10.0.2.$IPClust 255.255.255.0
netsh interface ip set dns "vEthernet (Management)" static 192.168.10.2
netsh interface ipv4 show interfaces
Exit