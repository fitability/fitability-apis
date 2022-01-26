# Builds Java app using Maven build
Param(
    [string]
    [Parameter(Mandatory=$false, Position=0)]
    $AppName = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This build Java app using the Maven build

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-AppName] <app name> ``
            [-Help]

    Options:
        -AppName:   App name
        -Help:      Show this message.
"

    Exit 0
}

# Show usage
$needHelp = ($AppName -eq "") -or ($Help -eq $true)
if ($needHelp -eq $true) {
    Show-Usage
    Exit 0
}

$repositoryRoot = $(git rev-parse --show-toplevel)
if (($env:GITHUB_WORKSPACE -ne "") -and ($env:GITHUB_WORKSPACE -ne $null)) {
    $repositoryRoot = $env:GITHUB_WORKSPACE
}

cd $repositoryRoot/$AppName

mvn clean package

cd $repositoryRoot
