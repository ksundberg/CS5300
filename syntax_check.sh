#!/bin/bash
# This script uses the CS6300 compiler (https://github.com/ksundberg/CS6300)
# to verify files are free of syntax errors.
DARK_GREY='\033[1;30m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -z $1 ]; then
    echo "usage: syntax_check.sh pattern_for_test_files /path/to/compiler"
    exit 1;
fi

filelist=($@)
echo -e "${DARK_GREY} ${#filelist[@]} file(s) being parsed${NC}"
mkdir parser_logs
mkdir asm_output
for ((i=0; i < ${#filelist[@]}-1; i++)); do
    filepatharr=(${filelist[$i]//\// })
    filename=${filepatharr[${#filepatharr[@]}-1]}
    echo -e "${DARK_GREY}Parsing ${filelist[$i]}${NC}"
    result="$(${@: -1} -i ${filelist[$i]} -o asm_output/${filename}.asm)"
    echo "${result}" > parser_logs/${filename}_output.txt
    if [[ $result == *"syntax error"* ]]; then
      echo -e "${RED}Syntax errors in ${filename}${NC}"
    elif [[ $result != "" ]]; then
      echo -e "${YELLOW}Other compile time errors in ${filename}${NC}"
    else
      echo -e "${GREEN}Successfully compiled ${filename}${NC}"
    fi
done