#!/bin/bash

###
# Example:
#     gcc -Wall -o hello hello.c -lm
###

###
# CHECK THAT INPUT OF PROGRAM NAME [$1] EXISTS
# If not provided, show current directories '.c' files, and ask user to choose
# They can define any full path, sure (i.e. /tmp/files/hello.c)
###

if [ -n "$1" ]; then

        varInFile=$1

elif [ -z "$1" ]; then

        printf "No input has been defined. Current directory has:\n"
        printf "\t"
        ls | grep *.c
        printf "Please enter program to compile: "
        read varInFile

fi

        varOutFile=$(printf $varInFile | sed 's/\..*$/.out/')   # 'hello.c' becomes 'hello.out'
            varLog=$(printf $varInFile | sed 's/\..*$/.log/')   # 'hello.c' becomes 'hello.log'

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

if [ -f $varLog ]; then
        if [ -s $varLog ]; then
                printf "Warnings and/or Errors are logged: $varLog.\n\n"
                printf "###################################################################\n\n"
                cat $varLog
                printf "\n###################################################################\n"
        else
                rm $varLog
        fi
fi

exit 0
