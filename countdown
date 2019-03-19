#! /bin/sh

########################  HOW-TO  ########################
#
#  Track a file being written reports percentage of size
#  at current file size, when compared to full size.
#
#  ARGUMENTS:
#    $ countdown_scp.sh FILE SIZE
#
########################  HOW-TO  ########################

FILE="$1"
SIZE="$2"

### SANITY

if [ $# -ne 2 ]
then
  echo "Not enough arguments supplied"
  echo "$ $0 FILE SIZE"
  exit
fi

### FUNCTIONS
function SIZE_FUNCTION
{
  stat "$FILE" | awk '{print $8}'
}

function MATH_FUNCTION
{
  echo $(($(SIZE_FUNCTION)*100/$SIZE))
}

function BEEP_FUNCTION
{
  printf '\a'
}

function DATE_FUNCTION
{
  $(date '+%Y%m%d_%H%M%S')
}

if [ "$SIZE_FUNCTION" == "$SIZE" ]
then
  echo "------------------------------------"
  echo "      $FILE IS ALREADY COMPLETE     "
  echo "------------------------------------"
  exit
fi

### SPIEL
  echo "------------------------------------"
  echo "  WELCOME   TO  THE  SCP   TRACKER  "
  echo "------------------------------------"
  echo "   YOU HAVE SELECTED FILE: $FILE    "
  echo "        FULL FILE SIZE IS: $SIZE    "
  echo "------------------------------------"
  echo "    . . .  HERE   WE   GO  ! ! !    "
  echo "------------------------------------"

## LOOP TIME: START !

while true
do
  if [ "$SIZE" == "$(SIZE_FUNCTION)" ]
  then
    COUNT=10
      while [ "$COUNT" -ne 0 ]
      do
        $BEEP_FUNCTION
        COUNT="$((COUNT - 1))"
      done
    break
  else
    echo "Size of $FILE is $(SIZE_FUNCTION)"
    echo "Which is $(MATH_FUNCTION)%"
    sleep 60
  fi
done

## LOOP TIME: END !
echo "------------------------------------"
echo "     END  OF  THE  FILE,  YO  !     "
echo "------------------------------------"

exit 0
