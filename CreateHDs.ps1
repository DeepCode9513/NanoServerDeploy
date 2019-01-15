$ServerNodes = @("745-clus-1","745-clus-2")
#Create VHDX
Foreach ($s in $ServerNodes)
{
    New-VHD -Path "f:\LocalVMs\$s\ssd1.vhdx" -SizeBytes 15GB -Dynamic
    New-VHD -Path "f:\LocalVMs\$s\ssd2.vhdx" -SizeBytes 15GB -Dynamic
    New-VHD -Path "f:\LocalVMs\$s\HDD1.vhdx" -SizeBytes 15GB -Dynamic
    New-VHD -Path "f:\LocalVMs\$s\HDD2.vhdx" -SizeBytes 15GB -Dynamic
    New-VHD -Path "f:\LocalVMs\$s\HDD3.vhdx" -SizeBytes 15GB -Dynamic
    New-VHD -Path "f:\LocalVMs\$s\HDD4.vhdx" -SizeBytes 15GB -Dynamic
    New-VHD -Path "e:\LocalVMs\$s\vDD1.vhdx" -SizeBytes 35GB -Dynamic
    New-VHD -Path "e:\LocalVMs\$s\vDD2.vhdx" -SizeBytes 35GB -Dynamic
    New-VHD -Path "e:\LocalVMs\$s\vDD3.vhdx" -SizeBytes 35GB -Dynamic
    New-VHD -Path "e:\LocalVMs\$s\vDD4.vhdx" -SizeBytes 35GB -Dynamic
}


#Attach VHDX
Foreach ($s in $ServerNodes)
{
    add-VMHardDiskDrive -VMName $s -Path "f:\LocalVMs\$s\ssd1.vhdx" -ControllerType SCSI
    Add-VMHardDiskDrive -VMName $s -Path "f:\LocalVMs\$s\ssd2.vhdx" -ControllerType SCSI   
    Add-VMHardDiskDrive -VMName $s -Path "f:\LocalVMs\$s\HDD1.vhdx" -ControllerType SCSI
    Add-VMHardDiskDrive -VMName $s -Path "f:\LocalVMs\$s\HDD2.vhdx" -ControllerType SCSI
    Add-VMHardDiskDrive -VMName $s -Path "f:\LocalVMs\$s\HDD3.vhdx" -ControllerType SCSI
    Add-VMHardDiskDrive -VMName $s -Path "f:\LocalVMs\$s\HDD4.vhdx" -ControllerType SCSI
    Add-VMHardDiskDrive -VMName $s -Path "e:\LocalVMs\$s\vDD1.vhdx" -ControllerType SCSI
    Add-VMHardDiskDrive -VMName $s -Path "e:\LocalVMs\$s\vDD2.vhdx" -ControllerType SCSI
    Add-VMHardDiskDrive -VMName $s -Path "e:\LocalVMs\$s\vDD3.vhdx" -ControllerType SCSI
    Add-VMHardDiskDrive -VMName $s -Path "e:\LocalVMs\$s\vDD4.vhdx" -ControllerType SCSI
}