$MainMenu = {
Write-Host " "
Write-Host "                                                              "                       
Write-Host "     ▄▄▄▄▄    ▄  █ ▄███▄   █    █     ▄  █ ▄███▄   █    █     "
Write-Host "    █     ▀▄ █   █ █▀   ▀  █    █    █   █ █▀   ▀  █    █     "
Write-Host "  ▄  ▀▀▀▀▄   ██▀▀█ ██▄▄    █    █    ██▀▀█ ██▄▄    █    █     "
Write-Host "   ▀▄▄▄▄▀    █   █ █▄   ▄▀ ███▄ ███▄ █   █ █▄   ▄▀ ███▄ ███▄  "
Write-Host "                █  ▀███▀       ▀    ▀   █  ▀███▀       ▀    ▀ "
Write-Host "               ▀                       ▀                      "
Write-Host " 02/2025 "
Write-Host 
Write-Host " ***************************"
Write-Host " *           Menu          *"
Write-Host " ***************************"
Write-Host
Write-Host " 1.) Install WireGuard Offline"
Write-Host " 2.) Install WireGuard Online"
Write-Host " 3.) Set ExecutionPolicy to unrestricted"
Write-Host " 4.) Disable Services"
Write-Host " 5.) Disable Hibernate"
Write-Host " 6.) Disable Intel MM (vPro LMS)"
Write-Host " 7.) Disable Teredo"
Write-Host " 8.) Disable IPv6"
Write-Host " 9.) Run WinUtil"
Write-Host " 10.) Run Run OO Shutup 10"
Write-Host " 11.) Download Ghost Toolbox"
Write-Host " 12.) Install Ghost Toolbox"
Write-Host " 13.) Quit"
Write-Host
Write-Host " Select an option and press Enter: "  -nonewline
}
cls

Do {
cls
Invoke-Command $MainMenu
$Select = Read-Host
Switch ($Select)
    {
1  {
       Write-Host
       Write-Host "Installing Wireguard Offline"
       sleep 2
       cls
       Write-Host
		Start-Process data\wireguard-amd64-0.5.3.msi
       sleep 3
       cls
       }
2  {
       Write-Host
       Write-Host "Installing Wireguard Online"
       sleep 2
       cls
       Write-Host
	   winget install WireGuard.WireGuard -s winget
       sleep 3
       cls
       }
3  {
       Write-Host
       Write-Host "Set ExecutionPolicy to unrestricted"
       Set-ExecutionPolicy unrestricted
       cls
       Write-Host
       Write-Host " ExecutionPolicy is set to:"
       Write-Host "____________________"
       Get-ExecutionPolicy
       Write-Host "____________________"
       sleep 3
       cls
       }
4  {
       Write-Host
       Write-Host " disable_that_shit."
       . .\data\disable_that_shit.ps1
       cls
       Write-Host
       Write-Host " Disabled that shit."
       sleep 3
       cls
       }
5  {
       Write-Host
       Write-Host " Disable Hibernate"
       powercfg.exe /hibernate off
       cls
       Write-Host
       Write-Host " Hibernate off"
       sleep 3
       cls
       }
6  {

       Write-Host
        Write-Host "Kill LMS"
        $serviceName = "LMS"
        Write-Host "Stopping and disabling service: $serviceName"
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue;
        Set-Service -Name $serviceName -StartupType Disabled -ErrorAction SilentlyContinue;

        Write-Host "Removing service: $serviceName";
        sc.exe delete $serviceName;

        Write-Host "Removing LMS driver packages";
        $lmsDriverPackages = Get-ChildItem -Path "C:\Windows\System32\DriverStore\FileRepository" -Recurse -Filter "lms.inf*";
        foreach ($package in $lmsDriverPackages) {
            Write-Host "Removing driver package: $($package.Name)";
            pnputil /delete-driver $($package.Name) /uninstall /force;
        }
        if ($lmsDriverPackages.Count -eq 0) {
            Write-Host "No LMS driver packages found in the driver store.";
        } else {
            Write-Host "All found LMS driver packages have been removed.";
        }

        Write-Host "Searching and deleting LMS executable files";
        $programFilesDirs = @("C:\Program Files", "C:\Program Files (x86)");
        $lmsFiles = @();
        foreach ($dir in $programFilesDirs) {
            $lmsFiles += Get-ChildItem -Path $dir -Recurse -Filter "LMS.exe" -ErrorAction SilentlyContinue;
        }
        foreach ($file in $lmsFiles) {
            Write-Host "Taking ownership of file: $($file.FullName)";
            & icacls $($file.FullName) /grant Administrators:F /T /C /Q;
            & takeown /F $($file.FullName) /A /R /D Y;
            Write-Host "Deleting file: $($file.FullName)";
            Remove-Item $($file.FullName) -Force -ErrorAction SilentlyContinue;
        }
        if ($lmsFiles.Count -eq 0) {
            Write-Host "No LMS.exe files found in Program Files directories.";
        } else {
            Write-Host "All found LMS.exe files have been deleted.";
        }
       Write-Host
       Write-Host 'Intel LMS vPro service has been disabled, removed, and blocked.';
       sleep 3
       }
7 	{
       Write-Host
       Write-Host " Disable Teredo"
	   netsh interface teredo set state disabled
       cls
       Write-Host
       Write-Host "Teredo disabled"
       sleep 3
       cls
		}
8 	{
       Write-Host
       Write-Host " Disable IPv6"
		Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6
       cls
       Write-Host
       Write-Host " IPv6 disabled"
       sleep 3
       cls
       }
9   {
       Write-Host
       Write-Host " Starting WinUtil Online."
		irm "https://christitus.com/windev" | iex
       cls
       Write-Host
       cls
       }
10   {
       Write-Host
       Write-Host " Starting OOSU10."
    try {
        $OOSU_filepath = "$ENV:temp\OOSU10.exe"
        $Initial_ProgressPreference = $ProgressPreference
        $ProgressPreference = "SilentlyContinue" # Disables the Progress Bar to drasticly speed up Invoke-WebRequest
        Invoke-WebRequest -Uri "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -OutFile $OOSU_filepath
        Write-Host "Starting OO Shutup 10 ..."
        Start-Process $OOSU_filepath
    } catch {
        Write-Host "Error Downloading and Running OO Shutup 10" -ForegroundColor Red
    }
    finally {
        $ProgressPreference = $Initial_ProgressPreference
    }
       cls
       Write-Host
       cls
       }
11   {
       Write-Host
       Write-Host " Open Browser  to Download Ghost Toolbox."
	   Start-Process "https://drive.proton.me/urls/DX4C5WTCP4#xrJGjDnJ7559"
       cls
       Write-Host
       cls
       }
12   {
       Write-Host
       Write-Host " Install Ghost Toolbox."
	   Start-Process data\Ghost.Toolbox_setup.x64.exe
       cls
       Write-Host
       cls
       }
       
    }
}

While ($Select -ne 13)
       
