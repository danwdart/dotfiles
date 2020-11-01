#!/bin/bash
INITDIR=~/code
cd $INITDIR
find -name stack.yaml.lock -delete
# Clear deps
# Update snapshot version
echo Finding Haskell projects...
for STACKS in $(find -name stack.yaml)
do
    DIR=$(dirname $STACKS)
    BASE=$(basename $DIR)
    echo Updating $BASE...
    cd $DIR
    stack build
    echo Finished updating $BASE
    cd $INITDIR
done
echo Done!