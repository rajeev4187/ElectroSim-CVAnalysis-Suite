# Changelog

All notable changes to ElectroSim-DunnECASA Suite are recorded here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0] — 2026-05-31

First public release.

### Added

- Three distribution forms: PyWebView/Streamlit hybrid `.exe`, Tkinter desktop `.exe`, and (planned) hosted web demo.
- **Dunn's Method** tab: power-law b-value fit with mechanism classification (capacitive / supercapacitor / hybrid / pseudocapacitor), and capacitive vs diffusion current decomposition i(V) = k₁v + k₂√v.
- **ECASA** tab: double-layer capacitance C_dl from the non-Faradaic window across scan rates; ECASA = C_dl / Cs.
- **Randles–Sevcik** tab: diffusion coefficient D from the linear fit of |i_p| vs √v.
- **Data Files** tab: load CSV / Excel / TSV with two-row header support (preserves unit annotations).
- **Data Plotting** tab: scan-rate-aware multi-curve plotting with matplotlib's interactive navigation toolbar.
- **Tutorials** tab: reference equations and template-data pointers.

### Notes

- Excel files with the "wide" multi-scan-rate layout (e.g. `Potential at 50 mV/s` / `Current at 50 mV/s` column pairs) are auto-normalised into the stacked form internally.
- Specific capacitance for ECASA defaults to 40 µF/cm² (carbon-like materials) and is user-adjustable.
- Per-tab matplotlib figures support pan, zoom, save-as-PNG, and live axis editing via the standard matplotlib toolbar.
