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
        for FILE in $(find -path ".stack-work" -prune -o -name "*.hs" | grep -v .stack-work | grep -v dist-newstyle)
        do
            echo Fixing $FILE...
            hlint $FILE --refactor --refactor-options=-i || echo "Can't do that this time"
            stylish-haskell -i $FILE || echo "Can't do that this time"
        done
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
        cd $DIR
        echo Pruning old branches...
        BRANCHES=$(git branch -a | grep "\(greenkeeper\|snyk\)" | sed 's/  remotes\/origin\///g')
        for BRANCH in $BRANCHES
        do
            echo Pruning $BRANCH...
            git branch -d $BRANCH || echo "Oh well"
            git push origin :$BRANCH || echo "Oh well"
            echo Pruned branch
        done
        echo Done pruning
        echo Updating $BASE...
        ncu -un
        npm install || echo "Nah"
        echo Finished updating $BASE
        cd $INITDIR
    done
done
echo Done!