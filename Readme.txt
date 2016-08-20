Reboot TP-LINK er6120 router when your Internet connection drops.

My router seems to lock up and requires a reboot.
I cannot use telnet
http://1000pytan.pl/informatyka/tp-link-tl-r480t-command-line-interface/ </br>
or Web Management </br>
http://www.jfwhome.com/2012/06/18/reboot-tp-link-router-remotely-or-automatically/

I wrote script for powershell to ping the external addr (8.8.8.8) and reboot router if it doesn't ping.

<code>

$loop=0 # start loop
Do
{
if (Test-Connection 8.8.8.8 -Count 3 -Delay 2 -BufferSize 256 -Quiet) # ping adr 8.8.8.8
 {
 # If it's true then rewrite checklogs.txt to proof that script is running.
 $action2 = "Last Internet connection checked on $((Get-Date).ToString())" 
 $action2 | Out-File C:\tplink\checklogs.txt
 }
  ELSE
{
# If it's false then add new line for evidence that router is reboot.
$action1 = "Router rebooted on $((Get-Date).ToString())" 
$action1 | Out-File C:\tplink\rebootlogs.txt -Append
$port= new-Object System.IO.Ports.SerialPort COM1,115200,None,8,one
$port.Open() # open serial port COM1
Start-Sleep -m 2000
$port.WriteLine("enable")
Start-Sleep -m 500
$port.WriteLine("admin")
Start-Sleep -m 500
$port.WriteLine("sys reboot")
Start-Sleep -m 500
$port.WriteLine("disable") # This is not needed if router reboots.
Start-Sleep -m 500
$port.ReadExisting() | Out-File C:\tplink\rebootlogs.txt -Append
Start-Sleep -m 500
$port.Close()
 }
 Start-Sleep -s 600 # wait for 10 minutes to do next ping
}
While ($loop=1) # end loop

</code>

I used Sorlov.PowerShell Library to run script as Windows Service.

https://www.youtube.com/watch?v=CJXf4proZD8
http://sorlov.azurewebsites.net/page/PowerShell-Projects.aspx

Copy the file router.serial.ps1 to folder c:\tplink and run in powershell

<code>

New-SelfHostedPS .\router.serial.ps1 -Service -ServiceName ChkRouter -ServiceDisplayName "Check Router" -ServiceDescription "Check Internet connection and reboot router if it doesn't ping."

.\router.serial.exe /install

</code>

Author Witalij Metelski
