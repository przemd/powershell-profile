## Setting Up the PowerShell Profile

1. Check if a PowerShell profile exists by running the following command in your PowerShell session:

   Test-Path $PROFILE
   
2. Create a new PowerShell profile by running the following command:

   New-Item -Path $PROFILE -ItemType File -Force

   This command will create a new profile file if one doesn't exist, or overwrite the existing profile file if one does exist. 
   If you don't want to overwrite the existing file, remove the -Force flag.
   
3. Open the PowerShell profile file in your preferred text editor (e.g., Notepad):

   notepad $PROFILE

4. Copy the PowerShell profile code and paste it into the opened profile file. 
   Before saving the file, make sure to update the pathToFunctions variable in the Runf function to point to the desired folder containing your script files:
   
   function Runf {
    param (
        [string]$FunctionName
    )
    $pathToFunctions = 'C:\path\to\your\folder'
    ...
}

5. Restart your PowerShell session.

# PowerShell Profile

## Overview

This PowerShell profile ensures that various software tools are installed on the system, imports PowerShell modules, sets up custom aliases, defines custom functions, and customizes the PowerShell prompt.

## Sections

### Other Software

This section ensures that various software tools are installed on the system. If a specific tool is not installed, it will be installed using Chocolatey.

- Chocolatey
- kubectl
- Azure CLI
- Helm
- K9s
- Git
- jq
- Base64
- Node.js
- Python
- Yarn
- Make
- OpenSSH
- WinSCP
- Grep
- OpenSSL

### Modules

This section imports PowerShell modules if they are not already installed. If a module is missing, it will be installed for the current user.

- Posh-Git
- PSKubectlCompletion
- PSKubeContext
- Azure modules (az)

### Aliases

This section sets up custom aliases for convenience.

- `npp`: Opens Notepad++.

### Run at Startup

This section clears the console when a new PowerShell session is started.

## Functions
This section defines custom functions.

### back
The `back` function allows you to navigate backward through the directory structure.

- `back mark`: Set the current path as the "back path" to return to later.
  - Usage: `back mark`
- `back`: Go back to the saved "back path."
  - Usage: `back`
- `back 1`: Go back one level from the current path (like `cd ..`).
  - Usage: `back 1`
- `back <number>`: Go back `<number>` levels from the current path.
  - Usage: `back <number>`
  - Example: `back 3`

### hist
The `hist` function allows you to search your command history for unique instances of a specified search term. It removes duplicates and returns a list of commands you've used in the past that match the search term.
- Usage: `hist <search_term>`
- Example: `hist kubectl`

### myip
Retrieves your public IP address.
- Usage: `myip`

### Runf
Dot-sources and runs functions from scripts located in a specified folder. If no function name is provided, it lists the available script files in the folder.
- Usage: `runf <function_name>`
- Example: `runf Connect-ServicePrincipal.ps1`

### Prompt

This section customizes the PowerShell prompt to display the current Kubernetes context and Git status.
