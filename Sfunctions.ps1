function Show-MenuMain
{	
        param ( 
		[string]$Title = '===== Powershell script by Quentin====='
	      )
	Do
	{	
                Write-Host "$Title"
		Write-Host @" 

   ---------- Main Menu ---------- 
1 = User Settings
2 = System information
     ---------------------------
"@
		$Choice = read-host -prompt "Select number & press enter"
	}
	until ($Choice -eq "1" -or $Choice -eq "2")
	Switch ($Choice)
	{
		"1" { Show-UserSettings }
		"2" { Show-SystemInfo }
	}
}

function Show-UserSettings
{
	Do
	{
		Write-Host "$Title"
		Write-Host @"
---------- User Settings ---------- 
1 = Dispaly current users
2 = Add a new user
3 = Remove a user
4 = Back
---------------------------
"@
		$Choice = read-host -prompt "Select number & press enter"
	}
	until ($Choice -eq "1" -or $Choice -eq "2" -or $Choice -eq "3" -or $Choice -eq "4")
	Switch ($Choice)
	{
		"1" { Show-DisplayUsers }
		"2" { Show-AddUser }
		"3" { Show-RemoveUser }
		"4" { Show-Back }
	}
}

function Show-SystemInfo
{
	Do
	{
		Write-Host @"
---------- Show System Info ---------- 
1 = Display Computer Info
2 = Display Computer Usage
3 = Back
---------------------------
"@
		$Choice = read-host -prompt "Select number & press enter"
	}
	until ($Choice -eq "1" -or $Choice -eq "2" -or $Choice -eq "3")
	Switch ($Choice)
	{
		"1" { Show-ComputerInfo }
		"2" { Show-ComputerUsage }
		"3" { Show-MenuMain }
	}
}

function Show-DisplayUsers
{
	Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'"
	Show-UserSettings
}

function Show-AddUser
{
	Do
	{
		Write-Host @"
---------- Add User ---------- 
1 = Add Manually
2 = Add from a file
---------------------------
"@
		$Choice = read-host -prompt "Select number & press enter"
	}
	until ($Choice -eq "1" -or $Choice -eq "2" -or $Choice -eq "3")
	Switch ($Choice)
	{
		"1" { Show-AddManually }
		"2" { Show-AddFromFile }
	}
}
function Show-AddManually
{
	$username = Read-Host -Prompt 'Imput your user name'
	$description = Read-Host -Prompt 'Imput account description'
	$password = Read-Host -Prompt 'Imput password:' -AsSecureString

	New-LocalUser -Name $username -Password $password -Description $description 
	Write-Host "Sucessfully created new user $username" 
	Show-UserSettings
}
function Show-AddFromFile
{	
	$filepath = Read-Host -Prompt "Enter path to .CSV file"

	$users = Import-Csv $filepath

	ForEach ($user in $users) {

    	$username = $user.'Username'
    	$userdesc = $user.'Description'
    	$userpass = $user.'Password'
    	$secureString = convertto-securestring $userpass -asplaintext -force
    	New-LocalUser -Name $username -Password $secureString -Description $userdesc
    	Show-UserSettings
   }
}
function Show-RemoveUser
{
	Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'"
	$name = Read-Host -Prompt 'Write the username you want to remove: '
	Remove-LocalUser -Name $name
	Write-Host "Sucessfully removed user $name"
	Show-UserSettings
}

function Show-ComputerInfo
{
	Get-ComputerInfo
	Show-ComputerUsage
}
function Show-CPULoad
{	
	Write-Host "CPU" 
	Get-WmiObject win32_processor | select LoadPercentage  |fl
	Show-ComputerUsage
}
function Show-Back
{
	Show-MenuMain
}
function Show-ComputerUsage
{
	Do
	{
		Write-Host @"
---------- Show Computer Usage ---------- 
1 = Display CPU Load
2 = Display Disk Usage
3 = Display Memory Usage
4 = Back
---------------------------
"@
		$Choice = read-host -prompt "Select number & press enter"
	}
	until ($Choice -eq "1" -or $Choice -eq "2" -or $Choice -eq "3" -or $Choice -eq "4")
	Switch ($Choice)
	{
		"1" { Show-CPULoad }
		"2" { Show-DiskUsage }
		"3" { Show-MemoryUsage }
		"4" { Show-Back }
	}
}
function Show-DiskUsage
{
	Get-WMIObject Win32_LogicalDisk | Format-Table Name, {$_.Size/1GB}, {$_.FreeSpace/1GB} -autosize
	Show-ComputerUsage
}
function Show-MemoryUsage
{
	$Memory = Get-WmiObject Win32_OperatingSystem
	Write-Host "Available Memory: " ($Memory.FreePhysicalMemory/1MB)GB
	Write-Host "Total Memory: "($Memory.TotalVisibleMemorySize/1MB)GB
	Show-ComputerUsage
}
Show-MenuMain

