#!/usr/bin/env pwsh
# Build the ElectroSim-CV Analysis Suite Windows executables.
#
# The Streamlit/PyWebView app (streamlined_app.py) exposes seven scan-rate CV
# analyses: Dunn's Method, Trasatti, ECASA, Areal Capacitance, Randles-Sevcik,
# Peak Area / Charge, and Electron-Transfer Kinetics (Nicholson & Laviron).
# These rely on scipy (peak detection), plotly + kaleido (figures / PNG export)
# and openpyxl (Excel parsing) -- all pinned in requirements.txt. The frozen
# exe is named ElectroSim-CVAnalysis-Suite.exe (the Tkinter target is
# ElectroSim-CVAnalysis-Suite-Tkinter.exe). The git repository and hosted-demo
# URL keep their historical ElectroSim-CVAnalysis-Suite identifier.
#
# Usage:
#   .\electrosim_build.ps1                       # build both targets
#   .\electrosim_build.ps1 -Target streamlit     # only the Streamlit/PyWebView exe
#   .\electrosim_build.ps1 -Target tkinter       # only the Tkinter exe
#   .\electrosim_build.ps1 -Clean                # delete previous build/ and dist/ first
#   .\electrosim_build.ps1 -SyncDeps             # pip install -r requirements.txt first

param(
    [ValidateSet("all", "streamlit", "tkinter")]
    [string]$Target = "all",

    [switch]$Clean,

    [switch]$SyncDeps
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$specs = @{
    streamlit = "ElectroSim-CVAnalysis-Suite.spec"
    tkinter   = "ElectroSim-CVAnalysis-Suite-Tkinter.spec"
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
        # NB: don't name this $target — PowerShell variables are
        # case-insensitive, so it would clobber the $Target parameter and
        # trip its [ValidateSet] on the next assignment.
        $cleanDir = Join-Path $root $d
        if (Test-Path $cleanDir) {
            Write-Output "Cleaning $cleanDir"
            Remove-Item -Recurse -Force $cleanDir
        }
    }
}

# Optionally sync all runtime dependencies (scipy, plotly, kaleido, openpyxl,
# streamlit, pywebview, ...) so the frozen build picks them up.
if ($SyncDeps) {
    $reqs = Join-Path $root "requirements.txt"
    if (Test-Path $reqs) {
        Write-Output "Syncing dependencies from requirements.txt..."
        & $python -m pip install -r $reqs
        if ($LASTEXITCODE -ne 0) {
            throw "Dependency sync failed with exit code $LASTEXITCODE"
        }
    } else {
        Write-Output "Warning: requirements.txt not found; skipping -SyncDeps."
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
