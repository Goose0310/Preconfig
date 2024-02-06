# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    exit }


# Bypass execution policy so scripts are allowed to run
Set-ExecutionPolicy Bypass CurrentUser -Force


# Install Chocolatey, Google Chrome, Adobe Reader, Eset endpoint security/Eset manageble agent
Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install googlechrome -y --force --ignore-checksums
choco install adobereader -y --force --ignore-checksums
Start-Process -FilePath "D:\ESMC_Installer_x64_nl_NL.exe" -ArgumentList "/silent /quiet EULA_ACCEPT=YES" -Verb RunAs



# Disable FastBoot in Control Panel
New-ItemProperty -Path "HKLM:SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -PropertyType DWord -Value 0 -Force



# Disable Hibernation/standby/sleep functions (AC=plugged in power - DC=on battery)
powercfg.exe -x -monitor-timeout-ac 0
powercfg.exe -x -monitor-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0



# Set UAC to the lowest setting, so it doenst notify you
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0



# Disabling OOBE Experience for all new users
New-Item -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows\OOBE"
New-ItemProperty -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows\OOBE" -Name DisablePrivacyExperience -PropertyType DWord -Value 1 -Force



# Password set to never expire
$username = "service.percom"

## Retrieve the user account
$user = $env:UserName

## Check if the user account exists and set password to never expire
if ($user -ne $null) {
    # Set the "PasswordNeverExpires" attribute to $true
    Set-LocalUser -Name $env:UserName -PasswordNeverExpires $true
}


# Makes service.percom account hidden
$reghiddenaccountpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"
New-Item $reghiddenaccountpath -Force | New-ItemProperty -Name service.percom -Value 0 -PropertyType DWord -Force


# Reboot to finish installation
write-host "++ Windows will reboot in 1 minutes!. ++" -ForegroundColor Cyan
Start-Sleep -Seconds 60 ; Restart-Computer -Force

