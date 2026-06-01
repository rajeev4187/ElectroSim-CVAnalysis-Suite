"""ElectroSim-DunnECASA Suite — Streamlit web-demo entry point.

This file is a thin loader. The full analysis engine ships as
compiled Python bytecode in version-suffixed sibling files:

    electrosim_engine.cp312.pyc   <- for Python 3.12
    electrosim_engine.cp314.pyc   <- for Python 3.14
    electrosim_engine.cpXY.pyc    <- generally, ".cp" + major + minor

The loader auto-picks the .pyc matching the running Python and
exec()s its bytecode in this module's global scope, so Streamlit's
``streamlit run electrosim_app.py`` workflow behaves exactly as if
the original source were here.

Why versioned files? Python's .pyc format is keyed to the exact
interpreter version (its "magic number"). A .pyc built for 3.12
will not run on 3.14 and vice versa. Streamlit Cloud uses a fixed
Python (currently 3.12) while local maintainer testing typically
runs on whatever is in the dev venv — shipping one .pyc per target
version is the simplest way both paths work without reading source.

The source code is deliberately distributed as bytecode only —
see ../LICENSE for the legal terms. To add support for a new Python
version (e.g. when Streamlit Cloud upgrades to 3.13), run
``py -3.13 -m py_compile <upstream-source>.py`` on the upstream
source and drop the resulting ``__pycache__/*.cpython-313.pyc``
here as ``electrosim_engine.cp313.pyc``.
"""
from __future__ import annotations

import marshal
import os
import sys

# -- Streamlit-run guard ----------------------------------------------------
# Catch the most common misuse: running the loader with plain `python`
# instead of `streamlit run`. The engine bytecode calls `st.set_page_config`,
# `st.sidebar.*`, etc. at module load time — those require Streamlit's
# runtime ScriptRunContext, which is only attached to the thread when the
# script is executed by `streamlit run`. Without it, the user gets a long
# Streamlit-internals traceback that hides the real problem.
def _verify_under_streamlit_run() -> None:
    try:
        # Streamlit >= 1.12 keeps the script run context here.
        from streamlit.runtime.scriptrunner import get_script_run_ctx
    except ImportError:
        sys.stderr.write(
            "\n[electrosim_app] Streamlit is not installed in this Python.\n"
            "  Install it first:    pip install streamlit\n"
            "  Then launch with:    streamlit run "
            + os.path.basename(__file__) + "\n\n"
        )
        sys.exit(1)
    if get_script_run_ctx() is None:
        sys.stderr.write(
            "\n[electrosim_app] This script must be launched with "
            "`streamlit run`, not plain `python`.\n\n"
            "  WRONG:  python "
            + os.path.basename(__file__) + "\n"
            "  RIGHT:  streamlit run "
            + os.path.basename(__file__) + "\n\n"
            "Reason: the analysis engine calls st.set_page_config / "
            "st.sidebar / etc. at\nmodule load time, which need "
            "Streamlit's per-thread ScriptRunContext.\nThat context "
            "is only set up by `streamlit run`.\n\n"
        )
        sys.exit(1)


_verify_under_streamlit_run()

_HERE = os.path.dirname(os.path.abspath(__file__))
_PY_TAG = f"cp{sys.version_info.major}{sys.version_info.minor}"
_ENGINE_PYC = os.path.join(_HERE, f"electrosim_engine.{_PY_TAG}.pyc")


def _list_available_versions() -> list[str]:
    """Return the Python-version tags for every shipped engine .pyc."""
    out = []
    for name in os.listdir(_HERE):
        if name.startswith("electrosim_engine.cp") and name.endswith(".pyc"):
            tag = name[len("electrosim_engine.") : -len(".pyc")]
            out.append(tag)
    return sorted(out)


if not os.path.isfile(_ENGINE_PYC):
    _available = _list_available_versions()
    _human = ", ".join(_available) if _available else "none"
    raise FileNotFoundError(
        f"No engine bytecode for Python {sys.version_info.major}."
        f"{sys.version_info.minor} (looked for "
        f"electrosim_engine.{_PY_TAG}.pyc). "
        f"This deployment ships .pyc for: {_human}. "
        f"Either run with one of the supported Python versions, or "
        f"recompile the upstream source for Python "
        f"{sys.version_info.major}.{sys.version_info.minor} and drop "
        f"the resulting __pycache__/*.cpython-{sys.version_info.major}"
        f"{sys.version_info.minor}.pyc here as "
        f"electrosim_engine.{_PY_TAG}.pyc."
    )

with open(_ENGINE_PYC, "rb") as _f:
    _blob = _f.read()

# Python ≥3.7 .pyc header is 16 bytes: 4-byte magic + 4-byte flags +
# 8-byte source-hash-or-mtime+size. The remainder is the marshalled
# code object.
_PYC_HEADER_BYTES = 16
try:
    _code = marshal.loads(_blob[_PYC_HEADER_BYTES:])
except Exception as exc:
    raise RuntimeError(
        f"Failed to load {os.path.basename(_ENGINE_PYC)}. The file is "
        f"named for Python {_PY_TAG} but its bytecode header didn't "
        f"validate — most likely it was compiled with a different "
        f"interpreter and renamed by hand. Recompile with the matching "
        f"Python."
    ) from exc

# Execute the engine in *this* module's globals so all Streamlit
# decorators, page-config calls, and st.* writes happen in the
# running script context — same effect as if Streamlit ran the
# original .py file directly.
exec(_code, globals())
