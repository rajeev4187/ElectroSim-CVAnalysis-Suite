# Build Reference

This folder contains the PyInstaller specs and the build-orchestration script used to produce the `.exe` bundles that ship in `release/installer/Output/`. It is here for **transparency** — anyone can read these files to verify exactly what's bundled into the binary distribution.

Reading the files

| File | What it is |
| --- | --- |
| [`ElectroSim-DunnECASA-Suite.spec`](ElectroSim-DunnECASA-Suite.spec) | PyInstaller config for the **PyWebView/Streamlit hybrid** build (the main user-facing app). Lists every third-party package, hidden import, and data file PyInstaller pulls into the `.exe`. |
| [`ElectroSim-DunnECASA-Suite-Tkinter.spec`](ElectroSim-DunnECASA-Suite-Tkinter.spec) | PyInstaller config for the lighter **Tkinter desktop** build (the fallback shipped under Start Menu → Tools). |
| [`electrosim_build.ps1`](electrosim_build.ps1) | PowerShell wrapper that runs PyInstaller against both specs. Selectable target (`-Target streamlit` / `-Target tkinter` / `-Target all`) and optional `-Clean` flag to wipe previous `build/` and `dist/` first. |

## Note for end users

**You don't run any of this.** End users download the prebuilt installer (`ElectroSim-DunnECASA-Suite-Setup-X.Y.exe`) from the [Releases](../../../releases) page. See [`../QUICK_START.md`](../QUICK_START.md).

## Note for release engineers / maintainers

The spec files reference Python source modules (`streamlined_app.py`, `electrosim_launcher.py`, etc.) which are **not** distributed in this public repository — the Suite is distributed in binary form only per [`../LICENSE`](../LICENSE). Running the build script in a clone of the public repo will fail with "module not found" errors, which is expected. The maintainer builds from a private working tree that contains the source modules.

If you are the maintainer and have the source tree, the workflow is:

```powershell
# From the project root (the parent of release/, which contains streamlined_app.py et al.)
.\release\build\electrosim_build.ps1 -Clean
& "${env:LocalAppData}\Programs\Inno Setup 6\ISCC.exe" release\installer\electrosim_setup.iss
# Upload release\installer\Output\ElectroSim-DunnECASA-Suite-Setup-X.Y.exe to GitHub Releases.
```
