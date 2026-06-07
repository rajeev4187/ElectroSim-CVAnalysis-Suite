# -*- mode: python ; coding: utf-8 -*-
"""PyInstaller spec for the ElectroSim-DunnECASA Suite.

Build with:
    pyinstaller ElectroSim-CVAnalysis-Suite.spec --noconfirm
"""

from PyInstaller.utils.hooks import collect_all, copy_metadata

# Streamlit ships its frontend assets, theming, and runtime metadata as
# package data. We need to pull all of it into the bundle, otherwise the
# frozen exe will fail to find the static directory or version metadata.
streamlit_datas, streamlit_binaries, streamlit_hidden = collect_all("streamlit")
altair_datas, altair_binaries, altair_hidden = collect_all("altair")
plotly_datas, plotly_binaries, plotly_hidden = collect_all("plotly")
# pywebview's package name is "webview" — bundle its platform backends and
# JS bridge assets so the native desktop window works inside the frozen exe.
webview_datas, webview_binaries, webview_hidden = collect_all("webview")

# Package metadata that Streamlit (and friends) look up at runtime via
# importlib.metadata. Missing metadata is the #1 cause of frozen-Streamlit
# crashes on first launch.
metadata = []
for pkg in (
    "streamlit",
    "altair",
    "plotly",
    "numpy",
    "pandas",
    "scipy",
    "scikit-learn",
    "matplotlib",
    "openpyxl",
    "h5py",
    "kaleido",
    "pywebview",
):
    try:
        metadata += copy_metadata(pkg)
    except Exception:
        # Optional packages — skip if not installed in the build env.
        pass

datas = [
    ("streamlined_app.py", "."),
    ("sample_data", "sample_data"),
    *streamlit_datas,
    *altair_datas,
    *plotly_datas,
    *webview_datas,
    *metadata,
]

hiddenimports = [
    "streamlit",
    "streamlit.web.cli",
    "streamlit.runtime.scriptrunner.magic_funcs",
    *streamlit_hidden,
    *altair_hidden,
    *plotly_hidden,
    *webview_hidden,
]


a = Analysis(
    ["electrosim_launcher.py"],
    pathex=[],
    binaries=[
        *streamlit_binaries,
        *altair_binaries,
        *plotly_binaries,
        *webview_binaries,
    ],
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="ElectroSim-CVAnalysis-Suite",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=True,
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
    name="ElectroSim-CVAnalysis-Suite",
)
