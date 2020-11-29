#!/bin/bash
set -e
INITDIR=~/code
cd $INITDIR
echo Finding Haskell projects...
for DIRLOC in ~/code/mine/haskell ~/code/mine/multi/projects/haskell
do
    echo Using repos location $DIRLOC
    cd $DIRLOC
    for STACKS in $(find $DIRLOC -name stack.yaml)
    do
        DIR=$(dirname $STACKS)
        BASE=$(basename $DIR)
        echo Updating $BASE...
        cd $DIR
        for FILE in $(find -path ".stack-work" -prune -o -name "*.hs" | grep -v .stack-work | grep -v dist-newstyle)
        do
            echo Fixing $FILE...
            # todo parallel
            hlint $FILE --refactor --refactor-options=-i || echo "Can't do that this time"
            stylish-haskell -i $FILE || echo "Can't do that this time"
        done
        echo Finished updating $BASE
        cd $INITDIR
    done
done