#!/usr/bin/env sh

# Originally from https://github.com/latex3/latex3

# This script is used for building LaTeX files using Travis
# A minimal current TL is installed adding only the packages that are
# required
echo 0
# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  echo download
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar -xzf install-tl-unx.tar.gz
  cd install-tl-20*

  echo install
  # Install a minimal system
  ./install-tl --profile=../texlive/texlive.profile

  cd ..
fi

# Just including texlua so the cache check above works
echo init-usertree
tlmgr init-usertree
echo 1
tlmgr install luatex
echo 2
# We specify the directory in which it is located texlive_packages
tlmgr install $(sed 's/\s*#.*//;/^\s*$/d' texlive/texlive_packages)
echo 3
# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0
echo 4
# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
echo 5