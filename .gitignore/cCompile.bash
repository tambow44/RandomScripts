#! /bin/bash

### 
# Example:
#     gcc -Wall -o hello hello.c -lm
###

varInFile=$1										# If any stdin, capture
varOutFile=$(printf $varInFile | sed 's/\..*$//')	# 'hello.c' becomes 'hello'
varLog=$varOutFile.log								# 'hello' becomes 'hello.log'

### 
# CHECK THAT INPUT OF PROGRAM NAME [$1] EXISTS
# If not provided, show current directory contents & have user choose
###

if ! [ -n "$1" ]; then
        printf "No input has been defined. Current directory has:\n"
        printf "\t"
        ls
        printf "Please enter program to compile: "
        read varInFile
        varOutFile=$(echo $varInFile | sed 's/\..*$//')
fi

### 
# CHECK THAT 'gcc' EXISTS, IF NOT use 'cc'
# If no gcc, try cc; if no cc, exit meekly
###

if ! [ -x "$(command -v gcc)" ]; then
        printf "Cannot locate 'gcc'\tTrying 'cc' ...\n"
        if ! [ -x "$(command -v cc)" ]; then
                printf "Cannot locate any C Compilers ... Exiting\n"
                exit 1
        else
                        varCCompiler=cc
        fi
else
        varCCompiler=gcc
fi

### Start your engines; logging

( $varCCompiler -Wall -o $varOutFile $varInFile -lm ) 2> $varLog

printf "Warnings and/or Errors are logged: $varLog.\n\n"
printf "###################################################################\n\n"
cat $varLog
exit
