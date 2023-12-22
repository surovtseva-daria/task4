#!/bin/bash
help=false
notchanges=false
withchanges=false
p=0
while getopts ":hdv" option; do
    p=1
    if [ $option != "--" ]; then
    case $option in
        h) 
            heip=true
            ;;
        d)
            notchanges=true
            ;;
        v)
            withchanges=true
            ;;
        :)
            echo "Not argument for option."
            exit 1
            ;;
        \?)
            echo "Wrong option."
            exit 1
            ;;
        esac
    fi
done
shift"$((OPTIND -1))"
if $heip; then
   echo "Usage: $0 [-h] [-d] [-v] <suffix> <file>>."
   exit 1
fi
if [ -z "$1" ]; then
    echo "Enter suffix."
    exit 1
fi

if [ $p -eq 1 ]; then
    shift
fi

if [ "$1"=="--" ]; then
    shift
fi

if [ $# -eq 1 ]; then
    echo "Enter files."
    exit 1
fi
suffix=$1
shift
for file in "$@"; do
    if [ ! -e $file ]; then
        echo "This file "$file" does not exist."
	continue
    fi
    if [ ! -w $file ]; then
	echo "The file cannot be renamed"
	continue
    fi
    new_name="${file%.*}${suffix}.${file##*.}"
    if $notchanges; then
        echo "Original name file: $file, new name file: $new_name"
    fi
    if $withchanges; then
        echo "New file name: $new_name"
    fi
    mv "$file" "$new_name"
done
