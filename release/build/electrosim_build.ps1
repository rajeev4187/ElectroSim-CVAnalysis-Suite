#!/usr/bin/env pwsh
# Build the ElectroSim-DunnECASA Suite Windows executables.
#
# Usage:
#   .\electrosim_build.ps1                       # build both targets
#   .\electrosim_build.ps1 -Target streamlit     # only the Streamlit/PyWebView exe
#   .\electrosim_build.ps1 -Target tkinter       # only the Tkinter exe
#   .\electrosim_build.ps1 -Clean                # delete previous build/ and dist/ first

param(
    [ValidateSet("all", "streamlit", "tkinter")]
    [string]$Target = "all",

    [switch]$Clean
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$specs = @{
    streamlit = "ElectroSim-DunnECASA-Suite.spec"
    tkinter   = "ElectroSim-DunnECASA-Suite-Tkinter.spec"
}

# Prefer the project venv if present. Try .venv first (active layout
# on this machine), then venv as a fallback.
$venvCandidates = @(".venv\Scripts\python.exe", "venv\Scripts\python.exe")
$python = $null
foreach ($cand in $venvCandidates) {
    $p = Join-Path $root $cand
    if (Test-Path $p) {
        $python = $p
        Write-Output "Using venv python: $python"
        break
    }
}
if (-not $python) {
    $python = "python"
    Write-Output "Using system python (no venv found in $($venvCandidates -join ' or '))"
}

if ($Clean) {
    foreach ($d in @("build", "dist")) {
        $target = Join-Path $root $d
        if (Test-Path $target) {
            Write-Output "Cleaning $target"
            Remove-Item -Recurse -Force $target
        }
    }
}

# Ensure PyInstaller is installed in the active environment.
& $python -m pip show pyinstaller > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Output "Installing PyInstaller..."
    & $python -m pip install pyinstaller
}

$targets = if ($Target -eq "all") { @("streamlit", "tkinter") } else { @($Target) }
$built = @()

foreach ($t in $targets) {
    $spec = Join-Path $root $specs[$t]
    if (-not (Test-Path $spec)) {
        throw "Spec file not found for target '$t': $spec"
    }

    Write-Output ""
    Write-Output "=== Building $t ==="
    & $python -m PyInstaller $spec --noconfirm
    if ($LASTEXITCODE -ne 0) {
        throw "PyInstaller build failed for '$t' with exit code $LASTEXITCODE"
    }

    $exeName = [System.IO.Path]::GetFileNameWithoutExtension($specs[$t])
    $exePath = Join-Path $root "dist\$exeName\$exeName.exe"
    if (Test-Path $exePath) {
        $built += $exePath
    } else {
        Write-Output "Warning: expected exe not found at $exePath"
    }
}

Write-Output ""
Write-Output "=== Build summary ==="
if ($built.Count -eq 0) {
    Write-Output "No exes were produced."
} else {
    foreach ($p in $built) {
        Write-Output "  $p"
    }
}
