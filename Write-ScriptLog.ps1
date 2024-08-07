function Write-ScriptLog {
    <#
    .SYNOPSIS
        Writes a log for the script.
    .DESCRIPTION
        Creates a logfile under the specified path with the default name SCRIPTLOG.LOG. 
        If the directory does not exist, it creates it. 
        Information level can be Information, Warning, or ERROR.
    .PARAMETER Message
        The message that should be appended to the log.
    .PARAMETER Level
        Information level can be Information, Warning, or ERROR.
    .PARAMETER Path
        The path where the log should be created.            
    .NOTES
    Version:        1.0
    Author:         victor.storsjo@crayon.com
    Creation Date:  2024/08/07
    Purpose/Change: Initial script development
    Other info:     Some bits improved by ChatGPT 
    
    .EXAMPLE
    Write-ScriptLog -Message "Information Text" -Level Information
    Write-ScriptLog -Message "Warning Text" -Level Warning
    Write-ScriptLog -Message "Error Text" -Level Error
    #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
 
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Error","Warning","Information")]
        [string]$Level = "Information",

        [Parameter(Mandatory=$false)]
        [Alias('LogPath')]
        [string]$Path = "c:\temp\SCRIPTLOG.log"
    )

    Begin {
        $directory = [System.IO.Path]::GetDirectoryName($Path)
        if (-not (Test-Path $directory)) {
            New-Item -Path $directory -ItemType Directory | Out-Null
        }
          
        # Set VerbosePreference to Continue so that verbose messages are displayed.
        $VerbosePreference = 'Continue'
    }

    Process {
        $formattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        # Write message to error, warning, or verbose pipeline and specify $LevelText
        switch ($Level) {
            'Error' {
                Write-Error $Message
                $levelText = 'ERROR:'
            }
            'Warning' {
                Write-Warning $Message
                $levelText = 'WARNING:'
            }
            'Information' {
                Write-Verbose $Message
                $levelText = 'INFORMATION:'
            }
        }
        # Write log entry to $Path
        "$formattedDate $levelText $Message" | Out-File -FilePath $Path -Append
    }
}
