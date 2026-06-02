# ElectroSim-DunnECASA Suite

**A publication-ready toolkit for electrochemical cyclic voltammetry (CV) analysis: Dunn's Method, ECASA, and Randles–Sevcik.**

Maintained by **Rajeev Kumar** (<rkumar@nccu.edu>), North Carolina Central University.

> This is the **single, canonical README** for the whole project. End-user, web-demo, sample-data, build, and installer documentation are all consolidated here — there are no separate README files in the subfolders.

---

## What it does

| Analysis | Output |
| --- | --- |
| **Dunn's Method** | b-value charge-storage mechanism classification (capacitive / battery / pseudocapacitor / hybrid), with capacitive vs diffusion current decomposition |
| **ECASA** | Electrochemically active surface area from non-Faradaic double-layer capacitance |
| **Randles–Sevcik** | Diffusion coefficient D from peak current vs √(scan rate) |

The suite ships in **three complementary forms**:

1. **Hosted web demo (Streamlit)** — the fastest way in: run every analysis in your browser at **[electrosim-dunnecasa-suite.streamlit.app](https://electrosim-dunnecasa-suite.streamlit.app/)**, nothing to install.
2. **Web app (PyWebView desktop window)** — the same Streamlit app wrapped in a native desktop window, fully offline.
3. **Tkinter desktop GUI** — lightweight native desktop application with the same analyses.

---

## ▶️ Try it now (Streamlit web app)

The quickest way to use the Suite is the **hosted Streamlit web app** — open it in your browser, upload a CV file (wide Excel or stacked CSV), and get Dunn's Method, ECASA, and Randles–Sevcik results instantly. No download, no setup, nothing to configure.

> **▶️ Live demo — <https://electrosim-dunnecasa-suite.streamlit.app/>** — try it right now in your browser, no install.

Prefer the same app on your own machine, or need the full offline desktop builds? See **[Running the web app locally](#running-the-web-app-locally)** or **[Downloads](#downloads)** below.

---

## Running the web app locally

The web app lives in [`release/web-demo/`](release/web-demo/). It is a Streamlit app and **must** be launched with `streamlit run`, not plain `python`:

```powershell
cd release\web-demo

# RIGHT — Streamlit boots its runtime, then exec's the loader
streamlit run electrosim_app.py

# RIGHT — pick a specific Python version (must match a shipped .pyc; see below)
py -3.12 -m streamlit run electrosim_app.py

# WRONG — plain python prints a friendly error and exits:
#   "This script must be launched with `streamlit run`, not plain `python`."
python electrosim_app.py
```

**Why `streamlit run`?** The analysis engine calls `st.set_page_config`, `st.sidebar.*`, etc. at module-load time, which need Streamlit's per-thread `ScriptRunContext` — only set up by `streamlit run`. The loader detects a missing context and prints a clear "WRONG / RIGHT" message instead of a confusing internals traceback.

**Pick the right Python.** Use a Python that has **both** Streamlit installed **and** a matching engine `.pyc` shipped (currently `cp312` for 3.12 and `cp314` for 3.14). If your target Python lacks the deps, install them first:

```powershell
py -3.14 -m pip install -r release\web-demo\requirements.txt
```

> ⚠️ A running Streamlit server loads the engine bytecode **once at startup** and does not hot-reload a recompiled `.pyc` — **restart the server** after any engine change.

### How the web app is packaged (bytecode-only)

The Python source in `release/web-demo/` is **compiled bytecode** — the Suite is distributed in binary form only (see [License](#license--permitted-use)):

- [`electrosim_app.py`](release/web-demo/electrosim_app.py) — a small Streamlit entry-point **loader** (the only `.py` there; contains no analysis logic). This is the file Streamlit Cloud runs.
- `electrosim_engine.cp312.pyc` / `electrosim_engine.cp314.pyc` — the full analysis engine as Python bytecode, one per supported Python version. The loader auto-picks the one matching the running interpreter and `exec()`s it in the script's global scope, behaving identically to running the original source.

> **Python-version pinning.** A `.pyc` is keyed to the exact interpreter version. If Streamlit Cloud upgrades and the demo fails with a "magic number" error, recompile the upstream source for that Python (`py -3.XX -m py_compile streamlined_app.py`) and drop the resulting `__pycache__/*.cpython-3XX.pyc` in as `electrosim_engine.cp3XX.pyc`.

---

## Downloads

Latest stable build (Windows 64-bit):

- **[ElectroSim-DunnECASA-Suite-Setup-2.0.exe](../../releases/latest)** — single Windows installer (163 MB). Includes both the PyWebView/Streamlit hybrid build (main) and the Tkinter desktop build (fallback).

The installer is a 3-screen flow (Welcome → Installing → Finish, ~15 s) that does NOT require admin rights. See [QUICK_START.md](QUICK_START.md) for the step-by-step walkthrough.

### Verifying the download

`Setup-2.0.exe` is unsigned (no Authenticode code-signing certificate yet). Windows SmartScreen will show "Windows protected your PC" the first time — click **More info → Run anyway**. To independently confirm the file is genuine, check its SHA-256 hash before running:

```powershell
Get-FileHash -Algorithm SHA256 $env:USERPROFILE\Downloads\ElectroSim-DunnECASA-Suite-Setup-2.0.exe
```

Expected hash (case-insensitive):

```text
7DC6F05D6EA99ACB5E6551FB862064BB6C5B80D4B10EFE7CF65E949C91DF7B99
```

### System requirements

- Windows 10 1809 (build 17763) or later, 64-bit
- ~700 MB free disk space (installer + extracted app + sample data)
- Edge WebView2 (preinstalled on Windows 10/11; required only for the hybrid build — the Tkinter fallback works without it)

> **Note:** the source code (`.py`) is intentionally not published in this repository. The suite is distributed in binary form only. See [LICENSE](LICENSE) and [NOTICE](NOTICE).

---

## Quick start

**New here? Read [QUICK_START.md](QUICK_START.md) — a 1-page plain-English walkthrough designed for non-technical users.** It covers downloading, running the installer (including what to do if Windows SmartScreen blocks it), opening the app, and loading sample data.

Already familiar with installing Windows applications? The short version:

1. Download `ElectroSim-DunnECASA-Suite-Setup-2.0.exe` from the [Releases](../../releases) page.
2. Double-click it. Three screens (Welcome → Installing → Finish) and the app launches.
3. Inside the app, click **Load files…** → pick a template from `sample_data/` → switch to the analysis tab you need.

For deeper material: [docs/user_guide.md](release/docs/user_guide.md) is the full walkthrough; [docs/methods.md](release/docs/methods.md) is the scientific background.

---

## Input data formats

| Format | Layout |
| --- | --- |
| **Wide Excel** | Header-encoded scan rate, one column pair per rate (e.g. `Potential at 50 mV/s`, `Current at 50 mV/s`) |
| **Stacked CSV / Excel** | Three columns: Potential, Current, ScanRate |
| **Single CV** | Two columns: Potential, Current (Dunn / ECASA / RS require multiple scan rates) |

### Sample templates

Ready-to-load templates live in [`release/sample_data/`](release/sample_data/) — open any from the **Data Files** tab:

| File | Purpose | Layout |
| --- | --- | --- |
| `Dunn method template.xlsx` | Dunn's Method template with annotated header rows | Wide Excel, two-row header (Potential / Current pairs per scan rate) |
| `ECASA CV template.xlsx` | ECASA non-Faradaic window template | Wide Excel, two-row header |

> **📋 Using a template?** Copy-paste your data directly into the provided template and upload it as-is. **Do not modify the first two rows** — row 1 (scan-rate headers) and row 2 (Potential / Current sub-headers) are required for the analysis tabs to read your file correctly. Add or remove data *rows* freely, but leave the two header rows intact.

**Recommended workflow:** open `Dunn method template.xlsx` in **Data Files** → **Data Plotting** → **Plot** (confirm the CV looks right) → **Dunn's Method** → set branch and prominence → **Run analysis**.

**Adapting your own data.** For CSV, the simplest layout is three columns with units in the Excel header (e.g. `V`, `mA`, `V/s`):

```text
Potential   Current   ScanRate
-0.5         0.0012    0.005
-0.5         0.0024    0.010
...
```

For wide Excel, column headers should carry the scan rate in `XX mV/s` form: `Potential at 50 mV/s | Current at 50 mV/s | Potential at 100 mV/s | …`

---

## Citation

If you use this software in academic work, please cite it via the metadata in [CITATION.cff](CITATION.cff). A DOI is issued for each release through [Zenodo](https://zenodo.org/).

---

## License & permitted use

Copyright (c) 2026 Rajeev Kumar. All rights reserved. Binary / compiled-bytecode distribution only, with attribution required for academic and personal use. See [LICENSE](LICENSE) for the full text and [NOTICE](NOTICE) for third-party components.

**Permitted:**

- Personal use (desktop app or hosted demo) for evaluation and learning.
- Academic and non-commercial research use; results may be used in publications provided the Suite is cited per [CITATION.cff](CITATION.cff).

**Not permitted without prior written permission:**

- Commercial use of the app, the demo, or their outputs.
- Re-deployment of this code (obfuscated or otherwise) under any other name or hosting.
- Decompilation, disassembly, or other reverse-engineering of the compiled bytecode.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND. Contact: <rkumar@nccu.edu>.

---

## For maintainers — building from source

> End users don't need this section — they download the prebuilt installer from [Releases](../../releases). The Python source (`streamlined_app.py`, `electrosim_launcher.py`, etc.) is **not** in this public repo; the maintainer builds from a private working tree. Building in a clone of the public repo will fail with "module not found" — expected.

**Build reference files** (kept tracked for transparency, in [`release/build/`](release/build/)):

| File | What it is |
| --- | --- |
| `ElectroSim-DunnECASA-Suite.spec` | PyInstaller config for the **PyWebView/Streamlit hybrid** build (main app). |
| `ElectroSim-DunnECASA-Suite-Tkinter.spec` | PyInstaller config for the lighter **Tkinter** fallback build. |
| `electrosim_build.ps1` | PowerShell wrapper running PyInstaller against both specs (`-Target streamlit\|tkinter\|all`, optional `-Clean`). |

**Full release workflow** (from the private source tree at the project root):

```powershell
# 1. Build both PyInstaller bundles -> dist\ at the project root
.\release\build\electrosim_build.ps1 -Clean

# 2. Install Inno Setup 6 (once): winget install --id JRSoftware.InnoSetup
# 3. Compile the installer
& "${env:LocalAppData}\Programs\Inno Setup 6\ISCC.exe" release\installer\electrosim_setup.iss
# -> release\installer\Output\ElectroSim-DunnECASA-Suite-Setup-X.Y.exe  (upload to GitHub Releases)
```

**What the installer produces:** a 3-screen, no-UAC, per-user install into `%LocalAppData%\Programs\ElectroSim-DunnECASA Suite\` with a Desktop shortcut (hybrid build), a Start Menu folder (main app, User Guide, Sample Data Folder, Tkinter fallback + Uninstall under `Tools\`), and `LICENSE`/`NOTICE`/`README.md`/`CHANGELOG.md`/`CITATION.cff`/`sample_data/`/`docs/` at the install root. The Tkinter build is a fallback for when the hybrid can't launch (e.g. missing/broken Edge WebView2).

**Cutting a new release (2.1, 3.0, …):**

1. Bump `MyAppVersion` in `release/installer/electrosim_setup.iss`.
2. Update [CHANGELOG.md](CHANGELOG.md) (shown on the post-install screen).
3. **Do NOT change `AppId`** — its GUID is what makes Windows upgrade in place instead of installing side-by-side.
4. Rebuild bundles, recompile the `.iss`, upload the new `Setup-X.Y.exe`.
5. **Recompute the SHA-256** of the new `.exe` and update the hash in this README and in [QUICK_START.md](QUICK_START.md).
6. **Recommended:** submit the new unsigned `Setup.exe` to Microsoft (<https://www.microsoft.com/en-us/wdsi/filesubmission>) so SmartScreen/Defender clears it (24–72 h; re-submit per release since the hash changes).

**Build troubleshooting:** `ISCC error: Source file not found: ..\..\dist\…` → run PyInstaller first / run ISCC from the project root. `ISCC: command not found` → Inno Setup not installed or not on PATH. Installer runs but crashes on a clean VM → incomplete PyInstaller bundle (run the `.exe` from `dist\…\` directly to confirm). Two Add/Remove Programs entries after upgrade → someone changed `AppId`.

---

## Support / bug reports

Open an [Issue](../../issues) on this repository. Please include:

- The exact build name from the **Help → About** menu of the app
- The input file format (anonymise data if needed)
- A screenshot of the error if applicable
