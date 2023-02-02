#modules
if ((Get-Module Posh-Git -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module Posh-Git -Force -scope currentUser
}
Import-Module Posh-Git

if ((Get-Module PSKubectlCompletion -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module PSKubectlCompletion -Force -scope currentUser
}
Import-Module PSKubectlCompletion
Set-Alias k -Value kubectl
Register-KubectlCompletion

if ((Get-Module PSKubeContext -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module PSKubeContext -Force -scope currentUser
}
Import-Module PSKubeContext
Set-Alias kubens -Value Select-KubeNamespace
Set-Alias kubectx -Value Select-KubeContext
Register-PSKubeContextComplet

if ((Get-Module az -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module az -Force -scope currentUser
}

#aliases
New-Alias npp -Value "C:\Program Files\Notepad++\notepad++.exe" -Force
Set-Alias -Name myip -Value Get-ExternalIp -Description "Return external IP"

#functions
Function Get-ExternalIp {(Invoke-WebRequest ifconfig.me/ip).Content}
Function Set-Dev { az account set --subscription "ce2905a7-07f9-410e-b377-2b4b998a5ddc"
                   Set-AzContext -Subscription "ce2905a7-07f9-410e-b377-2b4b998a5ddc" }

#run at startup
Clear-Host

