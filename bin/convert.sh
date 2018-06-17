#!/bin/bash
set -eou pipefail

[[ "${1:-}" && -x work/"$1"/soffice ]] || {
  echo "Specify LibreOffice version in work dir as argument, e.g. LibreOffice_5.2.7.2_2b7f1e640c46ceb28adf43ee075a6e8b8439ed10"
  exit 1
}

version="$1"

result_file=results/"$version".png
work/"$version"/soffice --convert-to png --outdir work/"$version" demo.odt
cp -v work/"$version"/demo.png "$result_file"
