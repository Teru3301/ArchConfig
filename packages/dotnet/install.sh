#!/bin/bash
# .NET SDK + LSP (OmniSharp) — вместе, т.к. без SDK OmniSharp бесполезен.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../../lib/common.sh"

pkg_install dotnet-sdk-10.0
pkg_install omnisharp-roslyn-bin
