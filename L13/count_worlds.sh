#!/bin/bash

set -xeuo pipefail

function usage(){
	echo "Usage: $0 file_path>"; exit 1;
}

if (( $# != 1)); then
	usage
fi

INPUT=$1
if [[ $INPUT != "-" && -e $INPUT || -r $INPUT ]]; then
	count=$( wc -w < "$INPUT")
else
	usage
	echo 'file not found'
fi

printf "word count: %d $count"
