#modules
###############################################
#posh-git
if ((Get-Module Posh-Git -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module Posh-Git -Force -scope currentUser
}
Import-Module Posh-Git

#PSKubectlCompletion
if ((Get-Module PSKubectlCompletion -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module PSKubectlCompletion -Force -scope currentUser
}
Import-Module PSKubectlCompletion
Set-Alias k -Value kubectl
Register-KubectlCompletion

#PSKubeContext
if ((Get-Module PSKubeContext -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module PSKubeContext -Force -scope currentUser
}
Import-Module PSKubeContext
Set-Alias kubens -Value Select-KubeNamespace
Set-Alias kubectx -Value Select-KubeContext
Register-PSKubeContextComplete

#azure modules
if ((Get-Module az -ErrorAction SilentlyContinue -ListAvailable) -eq $null)
{
	Install-Module az -Force -scope currentUser
}

#aliases
###############################################
New-Alias npp -Value "C:\Program Files\Notepad++\notepad++.exe" -Force;

#run at startup
###############################################
Clear-Host

#functions
###############################################
function hist { $find = $args; Write-Host "Finding in full history using {`$_ -like `"*$find*`"}"; 
               Get-Content (Get-PSReadlineOption).HistorySavePath | ? {$_-like "*$find*"} | select -Unique}
	
#other software
###############################################
# Check if Chocolatey is installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Host "Chocolatey is not installed. Installing..."
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
# Check if kubectl is installed
if (!(Get-Command kubectl -ErrorAction SilentlyContinue)) {
  Write-Host "kubectl is not installed. Installing..."
  choco install kubernetes-cli -y
}
# Check if the Azure CLI is installed
if (!(Get-Command az -ErrorAction SilentlyContinue)) {
  Write-Host "The Azure CLI is not installed. Installing..."
  choco install azure-cli -y
}
# Check if Helm is installed
if (!(Get-Command helm -ErrorAction SilentlyContinue)) {
  Write-Host "Helm is not installed. Installing..."
  choco install kubernetes-helm -y
}
# Check if K9s is installed
if (!(Get-Command k9s -ErrorAction SilentlyContinue)) {
  Write-Host "K9s is not installed. Installing..."
  choco install k9s -y
}

#Prompt
################################################
function Prompt {
	$prompt = "[$(kubectl config current-context)]" + (& $GitPromptScriptBlock)
	return $prompt
	}
