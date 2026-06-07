# -*- mode: python ; coding: utf-8 -*-
"""PyInstaller spec for the ElectroSim-DunnECASA Suite Tkinter desktop build.

Build with:
    pyinstaller ElectroSim-CVAnalysis-Suite-Tkinter.spec --noconfirm

Produces dist/ElectroSim-CVAnalysis-Suite-Tkinter/ElectroSim-CVAnalysis-Suite-Tkinter.exe
"""

from PyInstaller.utils.hooks import collect_all, copy_metadata

# matplotlib's TkAgg backend pulls in tk binaries on Windows; collect_all
# ensures the bundled exe finds its data files (font cache, backend stubs).
mpl_datas, mpl_binaries, mpl_hidden = collect_all("matplotlib")

metadata = []
for pkg in (
    "numpy",
    "pandas",
    "scipy",
    "scikit-learn",
    "matplotlib",
    "openpyxl",
    "h5py",
):
    try:
        metadata += copy_metadata(pkg)
    except Exception:
        pass

datas = [
    ("sample_data", "sample_data"),
    *mpl_datas,
    *metadata,
]

hiddenimports = [
    # Ensure the Tk Agg backend is included even though matplotlib loads
    # backends lazily by string name.
    "matplotlib.backends.backend_tkagg",
    "tkinter",
    "tkinter.ttk",
    "tkinter.filedialog",
    "tkinter.messagebox",
    "openpyxl",
    *mpl_hidden,
]


a = Analysis(
    ["electrosim_tkinter.py", "electrosim_analysis.py"],
    pathex=[],
    binaries=[*mpl_binaries],
    datas=datas,
    hiddenimports=[*hiddenimports, "electrosim_analysis"],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        # Keep the Tkinter exe lean — none of these are imported by
        # electrosim_tkinter.py.
        "streamlit",
        "altair",
        "webview",
        "plotly",
        "kaleido",
    ],
    noarchive=False,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="ElectroSim-CVAnalysis-Suite-Tkinter",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    # console=False → no stray command window when launched from Explorer.
    # If you need stderr for debugging, flip to True.
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)

coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=False,
    upx_exclude=[],
    name="ElectroSim-CVAnalysis-Suite-Tkinter",
)
