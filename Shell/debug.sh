#!/usr/bin/bash

###
##
## Requires mailx & zgrep
## Might get around to implementing condition checks with 'command'
##
## How to use:
##   bash script.sh "string" "me@email.xyz"
##
###

STRING="$1"                                       # String to search
RECIPIENT="$2"                                    # Email address i.e. "me@email.xyz; you@email.xyz"

LOG_DIR="/var/opt/gcti/logs/urs/"

DATE="$(date '+%Y%m%d')"                          # i.e. "20190329"
TIME="$(date '+%H%M%S')"                          # i.e. "122231"
MINUS_HOUR="$(( $(date '+%H') -1 ))"              # If the current hour is 11, becomes 10
SEARCH=urs_P.$DATE\_$MINUS_HOUR                   # We are collecting previous hours logs, for router logs
SCRIPT="$(basename "$0" | sed 's/\.[a-z]*$//g')"  # Formatting

TMP_FILE="/tmp/$SCRIPT$TIME.tmp"
TMP_FILE2=$TMP_FILE\2

   touch "$TMP_FILE" "$TMP_FILE2"

   zgrep "$STRING" $LOG_DIR"$SEARCH"* >> "$TMP_FILE"

   awk '{print $1"\n"$4}' "$TMP_FILE" | sed 's/:[0-9]*:[0-9]*:[0-9]*.[0-9]*//g' > "$TMP_FILE2"
   mv "$TMP_FILE2" "$TMP_FILE"

   sed 's|/var/opt/gcti/logs/urs/||g' "$TMP_FILE" > "$TMP_FILE2"
   mv "$TMP_FILE2" "$TMP_FILE"

NUM_RESULTS=$(echo "($(wc -l "$TMP_FILE" | awk '{print $1}'))" | /usr/bin/bc)
[ -z "$NUM_RESULTS" ] && NUM_RESULTS=0

   if [ "$NUM_RESULTS" -gt 0 ]; then
         printf "Total Found: %s\n\n" "$NUM_RESULTS" | cat - "$TMP_FILE" > "$TMP_FILE2" && mv "$TMP_FILE2" "$TMP_FILE"
         mailx -s "RESULTS FROM $SCRIPT FOR STRING: $STRING" -r "DEBUG_XFER_TRACKER" "$RECIPIENT" < "$TMP_FILE"
   else
         mailx -s "NO RESULTS FROM $SCRIPT FOR STRING: $STRING"  -r "DEBUG_XFER_TRACKER" "$RECIPIENT" < /dev/null
   fi

   rm "$TMP_FILE" "$TMP_FILE2"

exit 0
