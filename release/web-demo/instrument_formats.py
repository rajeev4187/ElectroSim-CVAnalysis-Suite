"""Thin bytecode loader for this module — mirrors ``electrosim_app.py``'s
engine loader. The full source ships as compiled Python bytecode in
version-suffixed sibling files:

    instrument_formats.cp312.pyc   <- for Python 3.12
    instrument_formats.cp313.pyc   <- for Python 3.13 (Streamlit Cloud default)
    instrument_formats.cp314.pyc   <- for Python 3.14

The loader auto-picks the .pyc matching the running Python and exec()s its
bytecode in this module's global scope, so ``import instrument_formats``
behaves exactly as if the original source were here.

The source code is deliberately distributed as bytecode only — see
../LICENSE for the legal terms. To add support for a new Python version,
run ``py -3.X -m py_compile instrument_formats.py`` on the upstream source
and drop the resulting ``__pycache__/*.cpython-3X.pyc`` here as
``instrument_formats.cp3X.pyc``.
"""
from __future__ import annotations

import marshal
import os
import sys

_HERE = os.path.dirname(os.path.abspath(__file__))
_MODULE_NAME = os.path.splitext(os.path.basename(__file__))[0]
_PY_TAG = f"cp{sys.version_info.major}{sys.version_info.minor}"
_PYC = os.path.join(_HERE, f"{_MODULE_NAME}.{_PY_TAG}.pyc")

if not os.path.isfile(_PYC):
    raise ImportError(
        f"No bytecode for {_MODULE_NAME} on Python {sys.version_info.major}."
        f"{sys.version_info.minor} (looked for {os.path.basename(_PYC)})."
    )

with open(_PYC, "rb") as _f:
    _blob = _f.read()

# Python >=3.7 .pyc header is 16 bytes: 4-byte magic + 4-byte flags +
# 8-byte source-hash-or-mtime+size. The remainder is the marshalled code.
_code = marshal.loads(_blob[16:])
exec(_code, globals())
