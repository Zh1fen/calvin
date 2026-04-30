#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN="${PYTHON_BIN:-python}"
PYTHON_BIN_DIR="$(cd "$(dirname "${PYTHON_BIN}")" && pwd)"

# Keep build tools aligned with the selected Python environment.
export PATH="${PYTHON_BIN_DIR}:${PATH}"

# Calvin still depends on pyhash, which only installs cleanly with setuptools < 58.
# Wheel is never depended on, but always needed. MulticoreTSNE requires a lower CMake release.
"${PYTHON_BIN}" -m pip install "setuptools<58" wheel cmake==3.18.4.post1

if [ ! -f "${ROOT_DIR}/calvin_env/setup.py" ]; then
    echo "Missing calvin_env submodule checkout at ${ROOT_DIR}/calvin_env"
    echo "Run: git submodule update --init --recursive"
    exit 1
fi

if [ ! -f "${ROOT_DIR}/calvin_env/tacto/setup.py" ]; then
    echo "Missing tacto package inside calvin_env at ${ROOT_DIR}/calvin_env/tacto"
    echo "Run: git submodule update --init --recursive"
    exit 1
fi

cd "${ROOT_DIR}/calvin_env/tacto"
"${PYTHON_BIN}" -m pip install -e .

cd "${ROOT_DIR}/calvin_env"
"${PYTHON_BIN}" -m pip install -e .

cd "${ROOT_DIR}/calvin_models"
"${PYTHON_BIN}" -m pip install -e .
