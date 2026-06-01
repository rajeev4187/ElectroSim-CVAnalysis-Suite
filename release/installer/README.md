# Windows Installer

This folder contains the [Inno Setup](https://jrsoftware.org/isinfo.php) script that produces the official `ElectroSim-DunnECASA-Suite-Setup-X.Y.exe` installer shipped on the [Releases](../../../releases) page.

End users **do not need anything in this folder** — they download the prebuilt `Setup-X.Y.exe` and run it. This folder is for whoever cuts the release.

---

## What the installer does

When the end user runs `ElectroSim-DunnECASA-Suite-Setup-2.0.exe`, the flow is intentionally minimal — designed for non-technical users:

1. **Welcome** screen
2. **Installing** progress bar (no questions asked)
3. **Finish** screen with a `Launch ElectroSim-DunnECASA Suite` checkbox (ticked by default)

That's it — three screens, no UAC prompt, no directory picker, no license click-through.

### Where things end up

- **Install location:** `%LocalAppData%\Programs\ElectroSim-DunnECASA Suite\` — per-user, no admin required, works on locked-down lab/student PCs.
- **Desktop:** one shortcut, `ElectroSim-DunnECASA Suite`, pointing at the hybrid build (the recommended one).
- **Start Menu folder** `ElectroSim-DunnECASA Suite`:
  - `ElectroSim-DunnECASA Suite` (the main app)
  - `User Guide`
  - `Sample Data Folder`
  - `Tools\ElectroSim-DunnECASA Suite (Tkinter fallback)`
  - `Tools\Uninstall ElectroSim-DunnECASA Suite`
- **Install root** also contains `LICENSE`, `NOTICE`, `README.md`, `CHANGELOG.md`, `CITATION.cff`, `sample_data/`, and `docs/` for users who want to read them after install.
- Registered in **Settings → Apps & features** with publisher metadata and a working uninstaller.

### What the installer ships under the hood

The PyWebView/Streamlit hybrid is the main user-facing build. The Tkinter build is bundled as a fallback (only reachable from `Start Menu → Tools`) for the rare case where the hybrid fails to launch — usually because Edge WebView2 is missing or broken. Non-tech users don't need to know about it; the Desktop shortcut and the main Start Menu entry both point at the hybrid.

Requires Windows 10 1809 (build 17763) or later, x64.

---

## Building the installer (release engineer workflow)

### 1. Build the two PyInstaller bundles

The spec files and orchestrator are in [`../build/`](../build/). From the project root (the working tree containing the source modules):

```powershell
.\release\build\electrosim_build.ps1            # build both targets
# or, equivalently, invoke PyInstaller directly:
pyinstaller release\build\ElectroSim-DunnECASA-Suite.spec         --noconfirm
pyinstaller release\build\ElectroSim-DunnECASA-Suite-Tkinter.spec --noconfirm
```

This populates `dist/ElectroSim-DunnECASA-Suite/` and `dist/ElectroSim-DunnECASA-Suite-Tkinter/` at the project root.

### 2. Install Inno Setup 6

Either run `winget install --id JRSoftware.InnoSetup` (no admin needed; installs into `%LocalAppData%\Programs\Inno Setup 6\`) or download manually from <https://jrsoftware.org/isdl.php>.

### 3. Compile the .iss

From the project root:

```powershell
# If installed via winget (per-user):
& "${env:LocalAppData}\Programs\Inno Setup 6\ISCC.exe" release\installer\electrosim_setup.iss
# Or via the GUI installer (machine-wide):
& "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe" release\installer\electrosim_setup.iss
```

Output: `release\installer\Output\ElectroSim-DunnECASA-Suite-Setup-2.0.exe`.

Upload that `Setup-2.0.exe` to the GitHub Releases page; that's what end users download.

---

## Updating for a new release

When cutting `2.1`, `3.0`, etc.:

1. Bump `MyAppVersion` in `electrosim_setup.iss` (line ~52).
2. Update `CHANGELOG.md` (which Inno Setup shows on the post-install screen).
3. **Do NOT change `AppId`** — its GUID is what tells Windows "this is the same product, please upgrade in place" rather than "this is a new product, install side-by-side". Changing it would orphan the previous version's Add/Remove Programs entry.
4. Rebuild PyInstaller bundles, recompile the .iss, upload the new `Setup-X.Y.exe`.
5. **Recompute the SHA-256 hash and update both `../QUICK_START.md` and `../README.md`** — the published hash must match the new binary, otherwise users who verify will be told the download is corrupt:

   ```powershell
   Get-FileHash -Algorithm SHA256 release\installer\Output\ElectroSim-DunnECASA-Suite-Setup-X.Y.exe
   ```

   Update the value in both files (search for the previous version's hash string).
6. **Optional but recommended** — submit the new unsigned Setup.exe to Microsoft for SmartScreen analysis at <https://www.microsoft.com/en-us/wdsi/filesubmission>. Once Microsoft scans it and finds nothing malicious (typically 24–72 hours), the "Unknown publisher" warning fades for that specific binary's hash. Has to be re-submitted for each new release because the hash changes.

---

## Troubleshooting build issues

| Symptom | Likely cause |
| --- | --- |
| `ISCC error: Source file not found: ..\..\dist\…` | You didn't run PyInstaller first, or you ran ISCC from somewhere other than the project root. The `..\..\dist\…` paths in the .iss are relative to the .iss file's parent and assume the project root is two levels up. |
| `ISCC: command not found` | Inno Setup not installed or not on PATH. Either install it or invoke ISCC by its full path (see step 3 above). |
| Installer runs but crashes on first launch on a clean Windows VM | The PyInstaller bundle is incomplete. Diagnose by running the `.exe` from `dist\…\` directly on the same VM — if that crashes, the issue is in the PyInstaller spec, not the installer. |
| Add/Remove Programs shows two entries after upgrade | Someone changed `AppId`. Rebuild the .iss with the original GUID and ship that as a patch release; the duplicate entry can be removed via the uninstaller. |

---

## License

The installer script itself is part of the proprietary distribution covered by [../LICENSE](../LICENSE). Inno Setup, the tool used to build it, is independently distributed under its own license (Modified BSD); see <https://jrsoftware.org/isinfo.php>.
