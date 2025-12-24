#!/bin/bash

DIR="$1"

for files in $(find "$DIR" -type f); do
	permiss=(stat -c "%s" "$files")
	size=(stat c "%A" "$files")
	echo "File: $files Permiss: $permiss Size: $size"
done
	
