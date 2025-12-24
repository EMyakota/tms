#!/bin/bash

FILES_NAME="$1"
PATH="$2"
EXTENSION="$3"

FILES=$(find "$PATH" -type f -name "*.$EXTENSION")

echo "$FILES" > "$FILES_NAME"
echo "List for file's name in '$FILES_NAME'"

