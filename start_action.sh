#!/bin/bash
SCRIPT_DIR=${0%/*}
PARAMS=""

echo Target: $INPUT_TARGET
echo Script dir: $SCRIPT_DIR
echo $PWD

# run build_sketch.sh with parameters
# $SCRIPT_DIR/load_eef.sh $INPUT_TARGET