#!/bin/bash
set -eou pipefail

# cross-compare all results

set -- $(
  ls results/*
)

while [ "${1:-}" ] ; do
  src_file="$1" ; shift
  for dst_file in "$@" ; do
    src=${src_file##*/}
    src=${src%.*}
    dst=${dst_file##*/}
    dst=${dst%.*}
    result_file=comparisons/"${src}_${dst}".png
    if divergance=$(
        compare -metric ae -compose src "$src_file" "$dst_file" "$result_file"  2>&1
      ) ; then
      echo "$src and $dst are identical"
    else
      echo "$src and $dst are different by $divergance"
    fi
  done
done
