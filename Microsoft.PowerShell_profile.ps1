$env:path = "C:\Program Files\OpenSSL-Win64\bin;" + $env:path

$packages = @(
    @{ Name = 'choco';         InstallScript = { iwr -UseBasicParsing -Uri 'https://chocolatey.org/install.ps1' | iex } },
    @{ Name = 'kubectl';       ChocolateyPackage = 'kubernetes-cli' },
    @{ Name = 'az';            ChocolateyPackage = 'azure-cli' },
    @{ Name = 'helm';          ChocolateyPackage = 'kubernetes-helm' },
    @{ Name = 'k9s';           ChocolateyPackage = 'k9s' },
    @{ Name = 'git';           ChocolateyPackage = 'git.install' },
    @{ Name = 'jq';            ChocolateyPackage = 'jq' },
    @{ Name = 'base64';        ChocolateyPackage = 'base64' },
    @{ Name = 'node';          ChocolateyPackage = 'nodejs-lts' },
    @{ Name = 'python';        ChocolateyPackage = 'python3' },
    @{ Name = 'yarn';          ChocolateyPackage = 'yarn' },
    @{ Name = 'make';          ChocolateyPackage = 'make' },
    @{ Name = 'ssh';           ChocolateyPackage = 'openssh' },
    @{ Name = 'winscp';        ChocolateyPackage = 'winscp' },
    @{ Name = 'grep';          ChocolateyPackage = 'grep' },
    @{ Name = 'openssl';       CheckCommand = 'openssl.exe'; ChocolateyPackage = 'openssl' },
    @{ Name = 'docker';        ChocolateyPackage = 'docker-desktop' },
    @{ Name = 'terraform';     ChocolateyPackage = 'terraform' }
)

function Install-PackageIfNeeded {
    param (
        $package
    )
    $ExecutableName = if ($package.ContainsKey('CheckCommand')) { $package.CheckCommand } else { $package.Name }
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

foreach ($package in $packages) {
    Install-PackageIfNeeded $package
}

# Modules section
###############################################
function Install-ModuleIfNeeded {
    param (
        [string]$ModuleName
    )

    if ((Get-Module $ModuleName -ErrorAction SilentlyContinue -ListAvailable) -eq $null) {
        Install-Module $ModuleName -Force -Scope CurrentUser
    }
}

# posh-git
Install-ModuleIfNeeded -ModuleName 'Posh-Git'
Import-Module Posh-Git

# PSKubectlCompletion
Install-ModuleIfNeeded -ModuleName 'PSKubectlCompletion'
Import-Module PSKubectlCompletion
Set-Alias k -Value kubectl
Register-KubectlCompletion

# PSKubeContext
Install-ModuleIfNeeded -ModuleName 'PSKubeContext'
Import-Module PSKubeContext
Set-Alias kubens -Value Select-KubeNamespace
Set-Alias kubectx -Value Select-KubeContext
Register-PSKubeContextComplete

# azure modules
Install-ModuleIfNeeded -ModuleName 'az'

# AzureAD
Install-ModuleIfNeeded -ModuleName 'AzureAD'

# dbatools
Install-ModuleIfNeeded -ModuleName 'dbatools'

# DockerCompletion
Install-ModuleIfNeeded -ModuleName 'DockerCompletion'
Import-Module DockerCompletion


#aliases
###############################################
New-Alias npp -Value "C:\Program Files\Notepad++\notepad++.exe" -Force;

#run at startup
###############################################
Clear-Host

# Functions
###############################################
function hist {
    param (
        [string]$find
    )
    Write-Host "Finding in full history using {`$_ -like `"*$find*`"}";
    Get-Content (Get-PSReadlineOption).HistorySavePath |
        Where-Object { $_ -like "*$find*" } |
        Select-Object -Unique
}

Function myip {
    (Invoke-WebRequest ifconfig.me/ip).Content.Trim()
}

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



