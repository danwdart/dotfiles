#!/bin/bash
set -e
INITDIR=~/code
cd $INITDIR
echo Finding Haskell projects...
for DIRLOC in ~/code/mine/haskell ~/code/mine/multi/projects/haskell
do
    echo Using repos location $DIRLOC
    cd $DIRLOC
    find -name stack.yaml.lock -delete
    for STACKS in $(find $DIRLOC -name stack.yaml)
    do
        DIR=$(dirname $STACKS)
        BASE=$(basename $DIR)
        echo Updating $BASE...
        cd $DIR
        if [[ $(grep "resolver: nightly" stack.yaml) ]];
        then
            stack config set resolver nightly
        else
            if [[ $(grep "resolver: lts-16" stack.yaml) ]];
            then
                stack config set resolver lts
            fi
        fi
        stack build

        git add stack.yaml || echo nah
        git add stack.yaml.lock || echo nah
        git commit -m 'updates' || echo nah
        git push
        echo Finished updating $BASE
        cd $INITDIR
    done
done
echo Finding JS projects...
for DIRLOC in ~/code/mine/js ~/code/mine/multi/projects/js
do
    echo Using repos location $DIRLOC
    cd $DIRLOC
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
        git add package.json || echo nah
        git add package-lock.json || echo nah
        git commit -m 'updates' || echo nah
        git push
        echo Finished updating $BASE
        cd $INITDIR
    done
done
echo Done!