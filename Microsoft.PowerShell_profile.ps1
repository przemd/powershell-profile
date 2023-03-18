$openssl = "C:\Program Files\OpenSSL-Win64\bin;"
$env:path = $openssl + $env:path
$packages = @(
    @{ Name = 'choco';         InstallScript = { iwr -UseBasicParsing -Uri 'https://chocolatey.org/install.ps1' | iex } },
    @{ Name = 'kubectl';       ChocolateyPackage = 'kubernetes-cli' },
    @{ Name = 'az';            ChocolateyPackage = 'azure-cli' },
    @{ Name = 'helm';          ChocolateyPackage = 'kubernetes-helm' },
    @{ Name = 'k9s';           ChocolateyPackage = 'k9s' },
    @{ Name = 'git';           ChocolateyPackage = 'git.install' },
    @{ Name = 'jq';            ChocolateyPackage = 'jq' },
    @{ Name = 'base64';        ChocolateyPackage = 'base64' },
    @{ Name = 'node';          ChocolateyPackage = 'nodejs.install'; Version = '8.9.4' },
    @{ Name = 'python';        ChocolateyPackage = 'python';          Version = '3.5.4' },
    @{ Name = 'yarn';          ChocolateyPackage = 'yarn' },
    @{ Name = 'make';          ChocolateyPackage = 'make' },
    @{ Name = 'ssh';           ChocolateyPackage = 'openssh' },
    @{ Name = 'winscp';        ChocolateyPackage = 'winscp' },
    @{ Name = 'grep';          ChocolateyPackage = 'grep' },
    @{ Name = 'openssl';       ChocolateyPackage = 'openssl' }
)

foreach ($package in $packages) {
    $ExecutableName = $package.Name
    if (![string]::IsNullOrEmpty($ExecutableName) -and !(Get-Command $ExecutableName -ErrorAction SilentlyContinue)) {
        Write-Host "$ExecutableName is not installed. Installing..."

        if ($package.ContainsKey('InstallScript')) {
            & $package.InstallScript
        } else {
            $chocoParams = @('install', $package.ChocolateyPackage, '-y')
            if ($package.ContainsKey('Version')) {
                $chocoParams += '--version'
                $chocoParams += $package.Version
            }
            choco @chocoParams
        }
    }
}

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

Function myip {(Invoke-WebRequest ifconfig.me/ip).Content}

function Runf {
    param (
        [string]$FunctionName
    )

    $pathToFunctions = 'C:\Users\example\devops-utils'

    if (![string]::IsNullOrEmpty($FunctionName) -and (Test-Path $pathToFunctions)) {
        Get-ChildItem -Path $pathToFunctions -Filter *.ps1 | ForEach-Object {
            . $_.FullName
            if (Get-Command $FunctionName -ErrorAction SilentlyContinue) {
                & $FunctionName
            }
        }
    } elseif ([string]::IsNullOrEmpty($FunctionName) -and (Test-Path $pathToFunctions)) {
        Write-Host "Script files in the folder '$pathToFunctions':"
        Get-ChildItem -Path $pathToFunctions -Filter *.ps1 | ForEach-Object {
            Write-Host $_.Name
        }
    } else {
        Write-Host "The folder '$pathToFunctions' does not exist."
    }
}

# Prompt
################################################
function Prompt {
    $prompt = "[$(kubectl config current-context)]" + (& $GitPromptScriptBlock)
    return $prompt
}
