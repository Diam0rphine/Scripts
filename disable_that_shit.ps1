Write-Host
Write-Host
Write-Host "    .___.__              ___.   .__             __  .__            __           .__    .__  __   "
Write-Host "  __| _/|__| ___________ \_ |__ |  |   ____   _/  |_|  |__ _____ _/  |_    _____|  |__ |__|/  |_ "
Write-Host " / __ | |  |/  ___/\__  \ | __ \|  | _/ __ \  \   __\  |  \\__  \\   __\  /  ___/  |  \|  \   __\"
Write-Host "/ /_/ | |  |\___ \  / __ \| \_\ \  |_\  ___/   |  | |   Y  \/ __ \|  |    \___ \|   Y  \  ||  |  "
Write-Host "\____ | |__/____  >(____  /___  /____/\___  >  |__| |___|  (____  /__|   /____  >___|  /__||__|  "
Write-Host "     \/         \/      \/    \/          \/             \/     \/            \/     \/          "
Write-Host "01/2025"
Write-Host
Write-Host
sleep 2

$services = @(
"AppVClient"         # Microsoft App-V Client                
"wmiApSrv"           # WMI Performance Adapter               
"WManSvc"            # Windows Management Service            
"WinRM"              # Windows Remote Management (WS-Manag...
"WFDSConMgrSvc"      # Wi-Fi Direct Services Connection Manager
"UmRdpService"       # Remote Desktop Services UserMode
"TermService"        # Remote Desktop Services            
"SNMPTrap"           # SNMP Trap
"shpamsvc"           # Shared PC Account Manager
"SessionEnv"         # Remote Desktop Configuration
"WMPNetworkSvc"      # Windows Media Player Network Sharing
"RemoteRegistry"     # Remote Registry
"RasAuto"            # Remote Access Auto Connection Manager 
"NcdAutoSetup"       # Network Connected Devices Auto-Setup
"MSiSCSI"            # Microsoft iSCSI Initiator Service
"RemoteAccess"       # Routing and Remote Access
"workfolderssvc"     # Work Folders
"lmhosts"            # TCP/IP NetBIOS Helper
"Spooler"            # Print Spooler
"SSDPSRV"            # SSDP Discovery
"LanmanWorkstation"  # Workstation
"LanmanServer"       # Server
"iphlpsvc"           # IP Helper
"HvHost"             # HV Host Service
"DiagTrack"          # Connected User Experiences and Telemetry
"CDPSvc"             # Connected Devices Platform Service
)

Write-Host
Write-Host "#### Stoppping Services"
Write-Host
sleep 2

foreach ($service in $services) {
    echo "Stop $service"
    Stop-Service -Name $service
}
sleep 2


Write-Host
Write-Host "#### Disable Services"
Write-Host
sleep 2

foreach ($service in $services) {
    echo "Trying to disable $service"
    Get-Service -Name $service | Set-Service -StartupType Disabled
    echo "$service disabled"
}

Write-Host
Write-Host "#### Get Status"
Write-Host
sleep 2

foreach ($service in $services) {
    echo "Get Status from $service"
    Get-Service -Name $service
}