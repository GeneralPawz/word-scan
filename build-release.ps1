<#
.SYNOPSIS
    Builds the add-in and installer, and optionally publishes a GitHub release.

.DESCRIPTION
    Releases are built here rather than in CI because the add-in references Microsoft's
    Extensibility.dll and office.dll, which ship with Office and are absent on GitHub runners.

    Requires: .NET SDK, Office (for the interop assemblies), Inno Setup 6, and — for -Publish —
    the GitHub CLI, authenticated.

.PARAMETER Version
    Semantic version to release, without a leading "v" (e.g. 0.3.0).

.PARAMETER Publish
    Also tag the release and upload the installer to GitHub.

.EXAMPLE
    .\build-release.ps1 -Version 0.3.0
    .\build-release.ps1 -Version 0.3.0 -Publish
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version,

    [switch]$Publish
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot

if (Get-Process WINWORD -ErrorAction SilentlyContinue) {
    throw "Word is running and holds a lock on the add-in DLL. Close Word and try again."
}

Write-Host "==> Building add-in $Version" -ForegroundColor Cyan
$publishDir = Join-Path $root 'publish'
Remove-Item $publishDir -Recurse -Force -ErrorAction SilentlyContinue
dotnet build (Join-Path $root 'com-addin\WordScanAddin.csproj') -c Release `
    -p:Version=$Version -o $publishDir
if ($LASTEXITCODE -ne 0) { throw "dotnet build failed." }

Write-Host "==> Building installer" -ForegroundColor Cyan
$inputDir = Join-Path $root 'installer\input'
New-Item -ItemType Directory -Force -Path $inputDir | Out-Null
Copy-Item (Join-Path $publishDir 'WordScanAddin.dll') $inputDir -Force

$iscc = (Get-Command ISCC.exe -ErrorAction SilentlyContinue).Source
if (-not $iscc) { $iscc = "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe" }
if (-not (Test-Path $iscc)) {
    throw "Inno Setup 6 not found. Install it from https://jrsoftware.org/isdl.php"
}

& $iscc (Join-Path $root 'installer\word-scan.iss') "/DMyAppVersion=$Version"
if ($LASTEXITCODE -ne 0) { throw "Installer build failed." }

$setup = Join-Path $root "dist\word-scan-setup-$Version.exe"
if (-not (Test-Path $setup)) { throw "Expected installer not found at $setup" }
Write-Host "==> Built $setup" -ForegroundColor Green

if ($Publish) {
    Write-Host "==> Publishing release v$Version" -ForegroundColor Cyan

    # git and gh write progress to stderr, which Windows PowerShell turns into error records
    # under $ErrorActionPreference='Stop'. Check the exit code explicitly instead.
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        git tag -a "v$Version" -m "v$Version" 2>&1 | Write-Host
        git push origin "v$Version" 2>&1 | Write-Host
        if ($LASTEXITCODE -ne 0) { throw "git push of tag v$Version failed." }

        gh release create "v$Version" $setup --title "v$Version" --generate-notes 2>&1 | Write-Host
        if ($LASTEXITCODE -ne 0) { throw "gh release create failed." }
    } finally {
        $ErrorActionPreference = $prev
    }

    Write-Host "==> Published v$Version" -ForegroundColor Green
} else {
    Write-Host "Run again with -Publish to tag and upload this build." -ForegroundColor Yellow
}
