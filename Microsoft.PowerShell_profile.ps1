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
Register-PSKubeContextComplete

if ((Get-Module az -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module az -Force -scope currentUser
}

#aliases
New-Alias npp -Value "C:\Program Files\Notepad++\notepad++.exe" -Force

#functions

#run at startup
Clear-Host
Set-Location c:\
function Prompt {
# Print the current context:
  Write-Host ("[") -nonewline 
  $name=(Get-AzContext).name
  Write-Host ($name.Substring(0, $name.IndexOf(' '))) -nonewline 
  Write-Host ("]") -nonewline 
  # Print the working directory:
  Write-Host ($PWD) -nonewline 
  # Print the promot symbol:
  return "> ";
}

