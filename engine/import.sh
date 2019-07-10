#!/bin/bash

# using the in-game editor, the javascript console can output changes.
# you can pipe that output text into this script to make corresponding changes to data heirarchy

IMPORTING=0
BLOCK=0
FILE=""
ARGS=""
while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
  if [ $IMPORTING == 1 ]; then
    if [ "@`echo $LINE | grep '===END_IMPORT==='`" != "@" ]; then
      IMPORTING=0
    else
      if [ $BLOCK == 0 ]; then
        ARGS="`echo $LINE | sed 's/.*SAVE //'`"
        FILE="`./filefrom.sh $ARGS`"
        echo $FILE...
        echo -n "" > $FILE
        BLOCK=1;
      else
        if [ ! -z "`echo $LINE | grep '^template.js'`" ]; then LINE=`echo $LINE | sed 's/^[^ ]* //'`; fi
        if [ "@$LINE" == "@" ]; then
          echo "" >> $FILE
          BLOCK=0;
        elif [ "@$LINE" == "@//" ]; then
          echo "" >> $FILE
        else
          echo $LINE >> $FILE
        fi
      fi
    fi
  else
    if [ "@`echo $LINE | grep '===BEGIN_IMPORT==='`" != "@" ]; then
      IMPORTING=1
    fi
  fi
done < "$1"

./quickgen.sh

