#!/bin/bash
set -e
INITDIR=~/code
cd $INITDIR
# Clear deps
# Update snapshot version
echo Finding Haskell projects...
for DIRLOC in ~/code/mine/haskell ~/code/mine/multi/projects/haskell
do
    echo Using repos location $DIRLOC
    find -name stack.yaml.lock -delete
    for STACKS in $(find $DIRLOC -name stack.yaml)
    do
        DIR=$(dirname $STACKS)
        BASE=$(basename $DIR)
        echo Updating $BASE...
        cd $DIR
        stack build
        echo Finished updating $BASE
        cd $INITDIR
    done
done
echo Finding JS projects...
for DIRLOC in ~/code/mine/js ~/code/mine/multi/projects/js
do
    echo Using repos location $DIRLOC
    find -name package-lock.json -delete
    find -name yarn.lock -delete
    for STACKS in $(find $DIRLOC -path "*node_modules*" -prune -o -name package.json)
    do
        DIR=$(dirname $STACKS)
        BASE=$(basename $DIR)
        echo Updating $BASE...
        cd $DIR
        ncu -un
        npm install || echo "Nah"
        echo Finished updating $BASE
        cd $INITDIR
    done
done
echo Done!