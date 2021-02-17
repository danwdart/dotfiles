#!/usr/bin/env bash
set -e
CODEDIR=$PWD/mine
cd $CODEDIR
echo Finding Nix projects...
for FILE in $(find $CODEDIR -name default.nix)
do
    DIRLOC=$(dirname $FILE)
    cd $DIRLOC
    nix-build shell.nix
    nix-store -qR --include-outputs $(nix-instantiate shell.nix) | cachix push websites
done
cd $CODEDIR
