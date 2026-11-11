#!/usr/bin/env bash
# Builds the web page, decomp/thps2/recomp-host/build/web/thps2_recomp.html, .js, .wasm and .data, from the USA dump,
# with the web support of the N64Recomp-browser tag lib/N64Recomp-browser pins. Linux, with emsdk active, naga and
# spirv-opt on PATH, clang, CMake, Ninja, git and Python 3.11+ (BUILDING.md, The web page):
#
#   bash tools/build_web.sh <USA dump> [--prepare] [--fast-link]
#   bash tools/build_web.sh --patches          the runtime and its patches alone: no ROM
#
# The shared host's tools/build_web.py (decomp/common/host/tools) does the work; its header says how.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
[[ -f lib/N64Recomp-browser/patches/apply.cmake && -f decomp/common/host/tools/build_web.py ]] ||
    git submodule update --init lib/N64Recomp-browser decomp/common
[[ $# -ge 1 ]] || { echo "usage: $0 <USA dump> [--prepare] [--fast-link] | --patches" >&2; exit 2; }
if [[ "$1" == --patches ]]; then
    exec python3 -I decomp/thps2/recomp-host/tools/build_web.py --browser lib/N64Recomp-browser --patches
fi
rom="$(realpath "$1")"; shift
exec python3 -I decomp/thps2/recomp-host/tools/build_web.py --browser lib/N64Recomp-browser --rom "$rom" "$@"
