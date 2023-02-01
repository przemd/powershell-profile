#modules
if ((Get-Module Posh-Git -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module Posh-Git -Force -scope currentUser
}
Import-Module Posh-Git

#aliases
New-Alias npp -Value "C:\Program Files\Notepad++\notepad++.exe" -Force

#functions
Function Get-ExternalIp {(Invoke-WebRequest ifconfig.me/ip).Content}
Set-Alias -Name myip -Value Get-ExternalIp -Description "Return external IP"

#run at startup
Clear-Host
