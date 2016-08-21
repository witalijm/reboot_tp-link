$loop=0
Do
{
if (Test-Connection 8.8.8.8 -Count 3 -Delay 2 -BufferSize 256 -Quiet)
 {
 $action2 = "Last Internet connection checked on $((Get-Date).ToString())" 
 $action2 | Out-File C:\tplink\checklogs.txt
 }
  ELSE
{
$action1 = "Router rebooted on $((Get-Date).ToString())" 
$action1 | Out-File C:\tplink\rebootlogs.txt -Append
$port= new-Object System.IO.Ports.SerialPort COM1,115200,None,8,one
$port.Open()
Start-Sleep -m 2000
$port.WriteLine("enable")
Start-Sleep -m 500
$port.WriteLine("admin")
Start-Sleep -m 500
$port.WriteLine("sys reboot")
Start-Sleep -m 500
$port.WriteLine("disable")
Start-Sleep -m 500
$port.ReadExisting() | Out-File C:\tplink\rebootlogs.txt -Append
Start-Sleep -m 500
$port.Close()
 }
 Start-Sleep -s 600
}
While ($loop=1)