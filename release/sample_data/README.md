# Sample Data

These templates demonstrate the data layouts the ElectroSim-DunnECASA Suite expects. Load any file from the **Data Files** tab.

| File | Purpose | Layout |
| --- | --- | --- |
| `Dunn method template.xlsx` | Dunn's Method template with annotated header rows | Wide Excel, two-row header (Potential / Current pairs per scan rate) |
| `ECASA CV template.xlsx` | ECASA non-Faradaic window template | Wide Excel, two-row header |

## Recommended workflow

1. Open `Dunn method template.xlsx` in the **Data Files** tab.
2. Switch to **Data Plotting** → click **Plot** → confirm the CV looks correct.
3. Switch to **Dunn's Method** → set branch and prominence → **Run analysis**.

## Adapting your own data

If your data is in CSV form, the simplest layout is three columns:

```text
Potential   Current   ScanRate
-0.5         0.0012    0.005
-0.5         0.0024    0.010
...
```

with units in row 2 of the header in Excel (e.g. `V`, `mA`, `V/s`).

For wide Excel, column headers should contain the scan rate in `XX mV/s` form:

```text
Potential at 50 mV/s | Current at 50 mV/s | Potential at 100 mV/s | Current at 100 mV/s | ...
```
