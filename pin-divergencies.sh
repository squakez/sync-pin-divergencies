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

pushd $1
for f in $(find .); do 
    if [[ ! -d $f ]]; then
        echo "Synchronizing $f ..."
        cp $BASE_DIR/$f $f
    fi
done
popd

echo "Committing changes to Git"
git add --all
git commit -m "chore(ci): copying changes back to init directory"