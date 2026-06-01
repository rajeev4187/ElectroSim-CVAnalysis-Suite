# User Guide

A practical walkthrough of the ElectroSim-DunnECASA Suite. The user interface is identical between the **Tkinter desktop build** and the **PyWebView/Streamlit hybrid build** — pick whichever you prefer.

---

## 1. Install

1. Download the latest release zip from the [Releases](../../../releases) page.
2. Extract anywhere. No installer is run.
3. Double-click the `.exe` to launch.

The first launch may take a few seconds longer (Windows verifies the binary).

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

## 5. ECASA tab

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

## 6. Randles–Sevcik tab

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

---

## 7. Tutorials tab

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
