#!/bin/bash
set -eou pipefail

[ "${1:-}" ] || {
  echo 1>&2 "Specify LibreOffice version as argument, e.g. 6.0.4.2 for a release or full URL to DEB tar.gz archive"
  echo 1>&2 "Check https://downloadarchive.documentfoundation.org/libreoffice/old/ for releases"
  exit 1
}

version=$(bin/prep.sh "$1")
bin/convert.sh "$version"
bin/compare.sh "$version"
