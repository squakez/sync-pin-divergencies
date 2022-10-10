#!/bin/bash

set -e

display_usage() {
    cat <<EOT
Pin any change done on the files that are diverging back to their initialization directory.
Usage: pin-divergencies.sh </init/directory/>  [options]
EOT
}

BASE_DIR=$(pwd)
INIT_DIRECTORY=$1

if [ "$INIT_DIRECTORY" == "" ]; then
    echo "ERROR: you must provide a directory as an argument"
    display_usage
    exit 1
fi

pushd $1
for f in $(find .); do 
    if [[ ! -d $f ]]; then
        if [ -f $f ] && [ -f $BASE_DIR/$f ]; then
            echo "Synchronizing $BASE_DIR/$f --> $f"
            cp $BASE_DIR/$f $f
        else
            echo "ERROR: $f not found either in init path or project path"
            exit 2
        fi
    fi
done
popd

echo "Committing changes to Git"
git add --all
git commit -m "chore(ci): copying changes back to init directory"