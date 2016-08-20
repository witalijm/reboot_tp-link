Reboot TP-LINK er6120 router when your Internet connection drops.

My router seems to lock up and requires a reboot.
I cannot use telnet
http://1000pytan.pl/informatyka/tp-link-tl-r480t-command-line-interface/ </br>
or Web Management </br>
http://www.jfwhome.com/2012/06/18/reboot-tp-link-router-remotely-or-automatically/

I wrote script for powershell to ping the external addr (8.8.8.8) and reboot router if it doesn't ping.
  
<code>
$loop=0
Do
{
if (Test-Connection 8.8.8.8 -Count 3 -Delay 2 -BufferSize 256 -Quiet)
 {
 $action2 = "Internet Connected $((Get-Date).ToString())" 
 $action2 | Out-File C:\tplink\logs.txt -Append
 }
  ELSE
{
$action1 = "Reboot Router $((Get-Date).ToString())" 
$action1 | Out-File C:\tplink\logs.txt -Append
$port= new-Object System.IO.Ports.SerialPort COM1,115200,None,8,one
$port.Open()
Start-Sleep -m 2000
$port.WriteLine("enable")
Start-Sleep -m 500
$port.WriteLine("admin")
Start-Sleep -m 500
$port.WriteLine("ip get lan")
Start-Sleep -m 500
$port.WriteLine("disable")
Start-Sleep -m 500
$port.ReadExisting() | Out-File C:\tplink\logs.txt -Append
Start-Sleep -m 500
$port.Close()
 }
 Start-Sleep 5
}
While ($loop=1)

</code>

I use next Sorlov.PowerShell Library to run script as Windows Service.

https://www.youtube.com/watch?v=CJXf4proZD8
http://sorlov.azurewebsites.net/page/PowerShell-Projects.aspx

New-SelfHostedPS .\router.serial.ps1 -Service -ServiceName ChkRouter -ServiceDisplayName "Check Router" -ServiceDescription "Check Internet connection and reboot router if it is no connection."

.\router.serial.exe /install

Author Witalij Metelski
