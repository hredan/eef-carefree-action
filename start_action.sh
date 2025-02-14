#!/bin/bash
SCRIPT_DIR=${BASH_SOURCE[0]%/*}
PARAMS=""

echo Target: $INPUT_TARGET
echo Script dir: $SCRIPT_DIR
echo $PWD


# run build_sketch.sh with parameters
$SCRIPT_DIR/create_eef_packages.sh -t $INPUT_TARGET