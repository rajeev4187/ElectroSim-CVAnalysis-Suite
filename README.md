# ElectroSim-DunnECASA Suite

**A publication-ready toolkit for electrochemical cyclic voltammetry (CV) analysis: Dunn's Method, ECASA, and Randles–Sevcik.**

Maintained by **Rajeev Kumar** (<rkumar@nccu.edu>), North Carolina Central University.

---

## What it does

| Analysis | Output |
| --- | --- |
| **Dunn's Method** | b-value charge-storage mechanism classification (capacitive / battery / pseudocapacitor / hybrid), with capacitive vs diffusion current decomposition |
| **ECASA** | Electrochemically active surface area from non-Faradaic double-layer capacitance |
| **Randles–Sevcik** | Diffusion coefficient D from peak current vs √(scan rate) |

The suite ships in **three complementary forms**:

1. **Web app (PyWebView desktop window)** — Streamlit UI wrapped in a native desktop window. Full feature set.
2. **Tkinter desktop GUI** — lightweight native desktop application with the same analyses.
3. **Hosted web demo** — try it without installing anything *(link added once hosted)*.

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
A6629D0A51C23F17C34A921D80F2A55538AAC5CCBA6A2A5CC273FB02FC3D1505
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

For deeper material: [docs/user_guide.md](docs/user_guide.md) is the full walkthrough; [docs/methods.md](docs/methods.md) is the scientific background.

---

## Input data formats

| Format | Layout |
| --- | --- |
| **Wide Excel** | Header-encoded scan rate, one column pair per rate (e.g. `Potential at 50 mV/s`, `Current at 50 mV/s`) |
| **Stacked CSV / Excel** | Three columns: Potential, Current, ScanRate |
| **Single CV** | Two columns: Potential, Current (Dunn / ECASA / RS require multiple scan rates) |

See [sample_data/](sample_data/) for templates of each format.

---

## Citation

If you use this software in academic work, please cite it via the metadata in [CITATION.cff](CITATION.cff). A DOI is issued for each release through [Zenodo](https://zenodo.org/).

---

## License

Binary distribution only, with attribution required for academic and personal use. See [LICENSE](LICENSE) for the full text. Commercial use requires written permission.

---

## Support / bug reports

Open an [Issue](../../issues) on this repository. Please include:

- The exact build name from the **Help → About** menu of the app
- The input file format (anonymise data if needed)
- A screenshot of the error if applicable
