# User Guide

A practical walkthrough of the ElectroSim-CV Analysis Suite. The user interface is identical between the **Tkinter desktop build** and the **PyWebView/Streamlit hybrid build** — pick whichever you prefer.

---

## 1. Install

1. Download **`ElectroSim-CVAnalysis-Suite-Setup-2.1.exe`** from the [Releases](../../../releases) page.
2. Double-click it. The installer is per-user (no admin prompt): Welcome → Installing → Finish (~15 s).
3. Launch from the Desktop shortcut or the Start Menu (the Tkinter fallback is under **Tools**).

If Windows SmartScreen shows "Windows protected your PC", click **More info → Run anyway** (the installer is unsigned). See [QUICK_START.md](../../QUICK_START.md) for the plain-English walkthrough. The first launch may take a few seconds longer while Windows verifies the binary.

---

## 2. Load your data (Data Files tab)

Click **Load files…** and select one or more files. Supported formats:

| Extension | Notes |
| --- | --- |
| `.xlsx`, `.xls` | First two rows are treated as a two-level header (variable + unit). |
| `.csv`, `.tsv`, `.txt` | Single header row. Auto-detects comma vs tab separator. |

Loaded files appear in the left pane. Click one to preview the first 50 rows on the right. Use **Remove selected** or **Clear all** to manage the list.

---

## 3. Plot the raw data (Data Plotting tab)

The active file's columns are listed in the **Y columns** picker. The first column is used as X by convention (Potential, time, etc.). Select one or more Y columns and click **Plot**. The chart appears below, with matplotlib's standard toolbar for zoom, pan, and save.

If your file is a multi-scan-rate Excel template, each scan rate is plotted as a separate curve with the scan rate in the legend.

---

## 4. Dunn's Method tab

**What it does:** classifies the dominant charge-storage mechanism via b-value fitting, and decomposes the current into capacitive and diffusion contributions.

**Inputs:**

| Control | Meaning |
| --- | --- |
| Branch | Use anodic (positive) or cathodic (negative) peaks |
| Peak prominence | Fraction of per-scan-rate amplitude; lower it if peaks aren't detected |
| Potential for decomposition | Reference potential E for the k₁v + k₂√v decomposition; `auto` uses the anodic peak |

**Output:**

- b-value, R², and mechanism label (capacitive / supercapacitor / hybrid / pseudocapacitor).
- Per-scan-rate peak table (E, |i| for anodic and cathodic branches).
- Two plots: log–log b-value fit, and capacitive vs total current at the fastest scan rate.

---

## 5. Trasatti Analysis tab

**What it does:** partitions the voltammetric charge q* into outer (readily accessible), total (all sites), and inner (porous) contributions from its scan-rate dependence.

**Inputs:**

| Control | Meaning |
| --- | --- |
| Charge basis | Anodic, cathodic, or average (½∮\|i\|dE) charge |
| Integration window (V) | Potential range over which q* is integrated |
| Linear-region selector | Exclude scan rates that bend away from the straight line |

**Output:**

- Outer charge q*_o, total charge q*_T, inner charge q*_i = q*_T − q*_o (per cm²).
- The two extrapolation plots (q* vs ν^−½ and 1/q* vs ν^½), excluded points greyed.
- Contribution bar chart and accessibility ratio q*_o/q*_T. Needs ≥3 scan rates.

---

## 6. ECASA tab

**What it does:** computes the electrochemically active surface area from double-layer charging in the non-Faradaic window.

**Inputs:**

| Control | Meaning |
| --- | --- |
| Window low / high (V) | Bounds of the non-Faradaic region (a rectangle in the CV) |
| Specific capacitance (µF/cm²) | Material-class constant — default 40 µF/cm² for carbons |
| Geometric area (cm²) | Optional; reports C_dl per unit geometric area if supplied |

**Output:**

- C_dl in farads (and per cm² if area is given).
- ECASA = C_dl / Cs in cm².
- Per-scan-rate average |i| table and the linear fit of avg |i| vs scan rate.

**Choosing the window:** in the Data Plotting tab, identify the flat (rectangular) region between redox features. Read off its bounds and enter them here.

---

## 7. Areal Capacitance tab

**What it does:** computes the areal capacitance C_A (F cm⁻²) from the enclosed CV loop area at each scan rate, plus the rate-capability and retention curves.

**Inputs:**

| Control | Meaning |
| --- | --- |
| Potential-window slider | Range over which the CV loop area is integrated |
| Electrode area A (cm²) | Geometric area used to convert C → C_A |

**Output:**

- Per-scan-rate C_A table.
- Rate-capability plot (C_A vs scan rate) and retention curve (relative to the slowest scan rate).

Use a capacitive (non-Faradaic) window for a meaningful value. Gravimetric capacitance (F/g) is intentionally not computed from CV.

---

## 8. Randles–Sevcik tab

**What it does:** extracts the diffusion coefficient D from peak current vs √(scan rate).

**Inputs:**

| Control | Meaning |
| --- | --- |
| n electrons | Number of electrons transferred in the redox couple |
| Area A (cm²) | Geometric electrode area |
| Concentration C (mmol/L) | Bulk concentration of the redox species; converted internally to mol/cm³ |
| Branch | Anodic or cathodic peak |

**Output:**

- Slope, intercept, and R² of |i_p| vs √v.
- Diffusion coefficient D in cm²/s.
- Plot of the linear fit overlaying the detected peak points.

This is a Faradaic analysis — it refuses to run if no redox peak is detected.

---

## 9. Peak Area / Charge tab

**What it does:** integrates a single CV's redox peak after baseline subtraction to report the charge passed, surface coverage, and moles.

**Inputs:**

| Control | Meaning |
| --- | --- |
| Scan rate | Which single CV to integrate |
| Peak(s) | Anodic, cathodic, or both |
| Integration window | Set with a slider or by dragging a box on the CV plot (double-click clears) |
| Baseline | Linear endpoint-to-endpoint, horizontal, or none |
| n electrons | Leave blank to estimate n from the peak FWHM (confirm before Γ/N) |

**Output:**

- Charge Q, surface coverage Γ, moles N, and the Q_a/Q_c ratio (≈1 ⇒ reversible/stable couple).
- A Faradaic gate skips the analysis if the window has no genuine redox peak (the CV stays shown so you can re-select).

---

## 10. Electron-Transfer Kinetics tab

**What it does:** extracts the heterogeneous rate constant from how peak positions shift with scan rate — Nicholson (diffusing couples) and Laviron (surface-confined).

**Inputs:**

| Control | Meaning |
| --- | --- |
| n electrons | Leave blank to auto-estimate from reversible ΔEp or from FWHM (confirm first) |
| D (cm²/s) | Diffusion coefficient for the Nicholson k⁰ (e.g. from the Randles–Sevcik tab) |

**Output:**

- Detected-peak and ΔEp table per scan rate.
- Nicholson k⁰ (via the Lavagnini working-curve fit) and Laviron α, (1−α), k_s from Ep vs ln ν slopes.
- A Faradaic gate prevents running on a non-Faradaic CV.

---

## 11. Tutorials tab

The Tutorials tab contains the canonical equations for each analysis and a list of the sample templates shipped in `sample_data/`. Read this first if you are setting up a new dataset and want to match the expected column conventions.

---

## Troubleshooting

| Symptom | Likely cause / fix |
| --- | --- |
| "Could not normalise the active file to stacked CV" | Your data has no scan-rate column and no `XX mV/s` headers. Add a scan-rate column or rename Excel headers to include the scan rate. |
| "No peaks detected" | Lower the peak prominence value (Dunn's Method tab). |
| ECASA fit has low R² | Window probably contains redox features. Narrow it down in the Data Plotting tab first. |
| Randles–Sevcik returns negative D | Wrong branch selected, or concentration units mis-entered (use mmol/L, not mol/L). |
| The exe is flagged by antivirus | Common false positive for PyInstaller bundles. Verify the SHA256 against `checksums.txt` in the release and whitelist if it matches. |
