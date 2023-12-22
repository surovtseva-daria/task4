#!/bin/bash

help=false
notchanges=false
withchanges=false
withoptions=false

while getopts ":hdv" option; do
    withoptions=true
    if [ $option != "--" ]; then
      case $option in
        h)
            help=true
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

# удаляем опции из агрументов
if $withoptions; then
    shift "$((OPTIND -1))"
fi

if $help; then
   echo "Usage: $0 [-h] [-d] [-v] <suffix> -- <files>."
   exit 1
fi

# проверка наличия суффикса первым аргументом
if [ -z "$1" ]; then
    echo "Enter suffix."
    exit 1
fi

suffix=$1
# удаляем суффикс как первый аргумент
shift

# удаляем "--" как первый аргумент, при налчиии
if [ "$1" == "--" ]; then
    shift
fi

# все что осталось в аргументах - файлы. если их нет - ошибка

if [ $# -eq 0 ]; then
    echo "Enter files."
    exit 1
fi

for file in "$@"; do
    if [ ! -e "$file" ]; then
      echo "File \"$file\" does not exist."
	    continue
    fi
    if [ ! -w "$file" ]; then
	    echo "The file cannot be renamed"
	    continue
    fi
    # когда нет расширения файла
    if [ "${file}" == "${file##*.}" ]; then
      new_name="${file%.*}${suffix}"
    else
      new_name="${file%.*}${suffix}.${file##*.}"
    fi
    if $notchanges;
      then
        echo "Original name file: $file, new name file: $new_name"
      else
        if $withchanges; then
          echo "New file name: $new_name"
        fi
        mv "$file" "$new_name"
    fi
done

exit $?
