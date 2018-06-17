#!/bin/bash
set -eou pipefail

# compare single result with reference

[[ "${1:-}" && -s results/"$1".png ]] || {
  echo "Specify LibreOffice version in results dir as argument, e.g. LibreOffice_5.2.7.2_2b7f1e640c46ceb28adf43ee075a6e8b8439ed10"
  exit 1
}

src_file=demo_5.2.7.2.png
src=${src_file%.*}
dst_file=results/"$1".png

dst=${dst_file##*/}
dst=${dst%.*}
result_file=comparisons/"${src}_${dst}".png
if divergance=$(
    compare -metric ae -compose src "$src_file" "$dst_file" "$result_file" 2>&1
  ) ; then
  echo "$src and $dst are identical"
else
  echo "$src and $dst are different by $divergance"
fi