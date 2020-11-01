#!/bin/bash
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
echo Done!