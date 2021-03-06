Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'

# Most of the file is just trying to replicate this file copy functionality
#.\dsfi.exe .\convert\Hackazon-disk1.vmdk 512 1024 .\descriptor.txt
#.\dsfo.exe .\convert\Hackazon-disk1.vmdk 512 1024 descriptor.txt

$path = $args[0]

$workingDir = Split-Path $path

$descriptor = "$workingDir\descriptor.txt"

$reader = [System.IO.File]::OpenRead($path)
$buffer = New-Object Byte[] 1024
$reader.Seek(512, [System.IO.SeekOrigin]::Begin)
$bytesRead = $reader.Read($buffer, 0, $buffer.Length)
[System.IO.File]::WriteAllBytes($descriptor,$buffer)
$reader.Close()

(Get-Content $descriptor).replace('ddb.toolsInstallType','#ddbtoolsInstallType') | Set-Content $descriptor

$reader = [System.IO.File]::OpenRead($descriptor)
$bytesRead = $reader.Read($buffer, 0, $buffer.Length)
$reader.Close()

$reader = [System.IO.File]::OpenWrite($path)
$reader.Seek(512, [System.IO.SeekOrigin]::Begin)
$reader.Write($buffer, 0, $buffer.Length)
$reader.Close()

ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath $path -vhdtype DynamicHardDisk -VhdFormat vhdx -DestinationLiteralPath $workingDir


