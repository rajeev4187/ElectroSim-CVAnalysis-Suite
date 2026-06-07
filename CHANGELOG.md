# Changelog

All notable changes to the ElectroSim-CV Analysis Suite (formerly
ElectroSim-DunnECASA Suite) are recorded here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.1] — 2026-06-07

Expanded from three analyses to a seven-analysis CV suite and rebranded
to **ElectroSim-CV Analysis Suite**. The repository, hosted-demo URL, and
executable filenames were renamed from `ElectroSim-DunnECASA-Suite` to
`ElectroSim-CVAnalysis-Suite` to match (GitHub redirects the old repo URL).

### Added

- **Trasatti Analysis** tab: partitions the voltammetric charge q* into
  outer (q*_o), total (q*_T), and inner (q*_i = q*_T − q*_o) contributions
  from the two canonical scan-rate extrapolations, with a linear-region
  selector, a choice of charge basis (anodic / cathodic / average), and an
  accessibility ratio q*_o/q*_T. Needs ≥3 scan rates.
- **Areal Capacitance & Rate Capability** tab: areal capacitance C_A
  (F cm⁻²) from the enclosed CV area at each scan rate, plus the
  rate-capability and retention curves.
- **Peak Area / Charge** tab: integrates a single CV's redox peak after
  baseline subtraction to report charge Q, surface coverage Γ, moles N,
  and the Q_a/Q_c ratio. Supports box-drag window selection on the plot and
  n-from-FWHM estimation when the electron count is left blank.
- **Electron-Transfer Kinetics** tab: heterogeneous rate constant k⁰
  (Nicholson, via the Lavagnini fit) and α / k_s (Laviron) from peak shifts
  with scan rate, with a Faradaic gate and auto-calculate-n helpers.

### Changed

- Tab order is now Dunn → Trasatti → ECASA → Areal → Randles–Sevcik →
  Peak Area → Electron-Transfer Kinetics, each grouped beside its companion.
- Faradaic tabs (Peak Area, Electron-Transfer Kinetics) gate on genuine
  redox-peak detection and refuse to run on non-Faradaic data.
- Per-tab **▶️ Run Analysis** buttons; *Clear All Files* resets every tab's
  run state so no stale result is shown against new data.

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
