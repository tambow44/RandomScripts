#!/bin/bash

# File to search
FILE_NAME="$1"

# '/tmp/file.sh' = file
SCRIPT="$(echo $0 | sed 's/\.[^.]*$//g;s/.*\///')"

# Test bed
case "$1" in
   CREATE) # Make the monkey !
      COUNT=0
      mkdir /tmp/test
      
      while [ "$COUNT" -lt 10 ]
      do
         touch "/tmp/test/monkey_gibberish_$COUNT"
         COUNT="$((COUNT + 1))"
      done

      exit 0
   ;;
   RESET) # Destroy the monkey !

      rm -rf /tmp/test/

      exit 0
   ;;
esac

# Initialise temporary file : "script_name.tmp_20190318_234200"
TMP_FILE="/tmp/$SCRIPT.tmp_$(date +'%y%m%d_%H%M%S')"
touch $TMP_FILE


# Find files matching, send to $TMP_FILE; don't output
sudo find / -name *$FILE_NAME* | tee "$TMP_FILE" > /dev/null

# Read input from $TMP_FILE : output of find
readarray FILE_ARRAY < "$TMP_FILE"

# If nothing is found, why do anything?
if [ "${#FILE_ARRAY[@]}" -eq 0 ]
then
   echo "No matches found for $FILE_NAME"
   rm $TMP_FILE
   exit 0
fi

# Print output of files found
for i in "${FILE_ARRAY[@]}"; do
   printf "File found: $i"
done

# To delete, or not delete
read -p 'Do you wish do delete [Y/N]? ' TODO

case "$TODO" in
   Y|y) # Delete !

      for i in "${FILE_ARRAY[@]}"
      do
         printf "removing $i"
         rm -rf $i
      done
      ;;
   N|n) # Do not delete !
   ;;
esac

rm "$TMP_FILE"

exit 0
