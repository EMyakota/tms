#!/bin/bash

for arg in "$@"; do
	echo "$arg"
	echo "$arg" > arguments.txt
done


