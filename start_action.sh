#!/bin/bash
SCRIPT_DIR=${0%/*}
PARAMS=""

echo Target: $INPUT_TARGET

# run build_sketch.sh with parameters
$SCRIPT_DIR/load_eef.sh $INPUT_TARGET