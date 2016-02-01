#!/bin/sh
# ***************************************************************************************
#
#     Increases IP sockets buffer rx/tx size
#
# ***************************************************************************************

OS_NAME=`uname --`

if [ "$1" = "" ]; then
  SIZE=10485760
else
  SIZE=$1
fi

if [ "$OS_NAME" = "SunOS" ]; then
    USER=`/usr/xpg4/bin/id -u -n`
fi

echo "Setting socket maximum buffer size to $SIZE"


  PROC_ROOT=/proc/sys/net/core

  if [ ! -w $PROC_ROOT/wmem_max ]; then
    echo "Cannot write to $PROC_ROOT/wmem_max"
    exit 1
  fi

  if [ ! -w $PROC_ROOT/rmem_max ]; then
    echo "Cannot write to $PROC_ROOT/rmem_max"
    exit 1
  fi

  echo $SIZE > $PROC_ROOT/wmem_max
  echo $SIZE > $PROC_ROOT/rmem_max

	cat $PROC_ROOT/wmem_max
	cat $PROC_ROOT/rmem_max


