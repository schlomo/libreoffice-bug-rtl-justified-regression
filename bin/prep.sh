#!/bin/bash
set -eou pipefail

[ "${1:-}" ] || {
  echo 1>&2 "Specify LibreOffice version as argument, e.g. 6.0.4.2 for a release or full URL to DEB tar.gz archive"
  echo 1>&2 "Check https://downloadarchive.documentfoundation.org/libreoffice/old/ for releases"
  exit 1
}

if [[ "$1" = */* ]] ; then
  url="$1"
  archive="${url##*/}"
  version="${archive%%_Linux*}"
  echo 1>&2 "Archive Version: $version"
else
  version="$1"
  archive="LibreOffice_${version}_Linux_x86-64_deb.tar.gz"
  url="https://downloadarchive.documentfoundation.org/libreoffice/old/$version/deb/x86_64/$archive"
fi

rm -Rf work/temp
mkdir -p work/temp cache

echo 1>&2 "Downloading LibreOffice archive"
wget --directory-prefix cache --no-verbose --show-progress --continue "$url"
echo 1>&2 "Unpacking LibreOffice archive"
tar -xz --directory work/temp --file cache/"$archive"
echo 1>&2 "Unpacking LibreOffice packages"
for package in ./work/temp/*/DEBS/*deb ; do
  dpkg-deb -x "$package" work/temp
done
version_info="$(work/temp/opt/libreoffice*/program/soffice --version)" || {
  echo 1>&2 Could not run soffice from work/temp
  exit 1
}

real_version="${version_info// /_}"

rm -Rf work/"$real_version"
mv work/temp work/"$real_version"

ln -s $(readlink -f work/"$real_version")/opt/libreoffice*/program/soffice work/"$real_version"/soffice
echo 1>&2 Prepared work/"$real_version"/soffice
echo 1>&2 $version_info
echo "$real_version"