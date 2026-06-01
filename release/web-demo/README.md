# ElectroSim-DunnECASA Suite — Live Web Demo

Try the Streamlit version of the ElectroSim-DunnECASA Suite right in your browser, no installation required.

**Live demo:** *(add URL once deployed to Streamlit Community Cloud)*

Maintained by **Rajeev Kumar** (<rkumar@nccu.edu>), North Carolina Central University.

---

## What this does

This is the hosted web version of the ElectroSim-DunnECASA Suite. It implements:

- **Dunn's Method** — b-value charge-storage mechanism classification, capacitive/diffusion decomposition.
- **ECASA** — electrochemically active surface area from non-Faradaic double-layer capacitance.
- **Randles–Sevcik** — diffusion coefficient from peak current vs √(scan rate).

For the full feature set, including the **native desktop applications** (Tkinter and Streamlit-PyWebView builds), download the official binaries from the [Releases](../../releases) page of this repository.

---

## Running the demo locally (for testing before deploy)

This is a Streamlit web app. It **must** be launched with `streamlit run`, not plain `python`:

```powershell
# RIGHT — Streamlit boots its runtime, then exec's the loader
streamlit run electrosim_app.py

# RIGHT — pick a specific Python version (must match a shipped .pyc)
py -3.12 -m streamlit run electrosim_app.py

# WRONG — plain python will print a friendly error and exit:
#   "This script must be launched with `streamlit run`, not plain `python`."
python electrosim_app.py
```

The reason: the analysis engine calls `st.set_page_config`, `st.sidebar.*`, etc. at module load time, which need Streamlit's per-thread `ScriptRunContext`. That context is only set up by `streamlit run`.

The loader detects the missing context and prints a clear "WRONG / RIGHT" message instead of letting Streamlit emit a confusing internals traceback — but the cleanest experience is to just use `streamlit run`.

## Input data formats

| Format | Layout |
| --- | --- |
| **Wide Excel** | Header-encoded scan rate, one column pair per rate (e.g. `Potential at 50 mV/s`, `Current at 50 mV/s`) |
| **Stacked CSV / Excel** | Three columns: Potential, Current, ScanRate |

Sample templates are in [../sample_data/](../sample_data/) of this repository.

---

## Source

The Python source in this folder is **compiled bytecode**:

- `electrosim_app.py` — small Streamlit entry-point loader (the only `.py` here).
- `electrosim_engine.pyc` — the full analysis engine as Python bytecode (compiled from the upstream source via `python -m py_compile`).

Streamlit Cloud runs `electrosim_app.py`, which loads `electrosim_engine.pyc` and executes it in the running script's global scope — behaves identically to running the original source.

The bytecode-only distribution is intentional: the Suite is distributed under a proprietary license (see below). Compiled bytecode lets us offer a free hosted demo without publishing the original source.

> **Python-version pinning.** `.pyc` is tagged to the Python version that produced it. If Streamlit Cloud upgrades and the demo refuses to start with a "magic number" error, recompile: `python -m py_compile <upstream-source>.py` on the upstream source using the deployment's Python, then copy the resulting `__pycache__/*.cpython-XYZ.pyc` here as `electrosim_engine.pyc`. The shipped `electrosim_engine.pyc` was compiled with Python 3.14.

## License & permitted use

Copyright (c) 2026 Rajeev Kumar. All rights reserved. This demo is distributed as **compiled Python bytecode only**; the same proprietary license that applies to the main release applies here — see [../LICENSE](../LICENSE) for the full legal text.

**Permitted:**

- Personal use of the hosted demo for evaluation and learning.
- Academic and non-commercial research use; results produced by the demo may be used in publications provided the Suite is cited per [../CITATION.cff](../CITATION.cff).

**Not permitted without prior written permission:**

- Commercial use of the demo or its outputs.
- Re-deployment of this code (obfuscated or otherwise) under any other name or hosting.
- Decompilation, disassembly, or other reverse-engineering of the compiled bytecode.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND. Contact: <rkumar@nccu.edu>.
