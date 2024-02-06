for %%i in ("%~dp0.") do SET "mypath=%%~fi"
"%windir%\System32\WindowsPowerShell\v1.0\powershell.exe" -noprofile -ExecutionPolicy Bypass %mypath%\New_Client_Preconfig.ps1
Pause
