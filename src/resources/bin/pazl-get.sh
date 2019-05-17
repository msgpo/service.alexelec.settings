#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

URL_MAIN="https://github.com/AlexELEC/ptv/releases/download"
URL_LAST="https://github.com/AlexELEC/ptv/releases/latest"

PTV_DIR="/storage/.config/ptv3"
TEMP_DIR="/storage/.kodi/temp"

BACKUP_DIR="/tmp/ptv3"

################################ MAIN ##########################################

UPD_VER=`curl -s "$URL_LAST" | sed 's|.*tag\/||; s|">redirected.*||')`

# download URL
  if [ "$1" == "url" ] ; then
      if curl --output /dev/null --silent --head --fail "$URL_MAIN/$UPD_VER/ptv-$UPD_VER.tar.bz2"
      then
        echo "$URL_MAIN/$UPD_VER/ptv-$UPD_VER.tar.bz2"
      else
        echo "error"
      fi

# unpack
  elif [ "$1" == "install" ] ; then
      rm -fR $PTV_DIR
      mkdir -p $PTV_DIR
      tar -jxf $TEMP_DIR/ptv-$UPD_VER.tar.bz2 -C $PTV_DIR
      rm -f $TEMP_DIR/ptv-$UPD_VER.tar.bz2

# current version
  elif [ "$1" == "old" ] ; then
      CURRENT_VER=`cat $PTV_DIR/latest`
      echo "$CURRENT_VER"

# update version
  elif [ "$1" == "new" ] ; then
      CURRENT_VER=`cat $PTV_DIR/latest`
      if [ "$CURRENT_VER" != "$UPD_VER" ]; then
        echo "$UPD_VER"
      else
        echo "NOT UPDATE"
      fi

# backup
  elif [ "$1" == "backup" ] ; then
      mkdir -p $BACKUP_DIR
      [ -d "$PTV_DIR/settings" ] && cp -rf $PTV_DIR/settings $BACKUP_DIR
      [ -d "$PTV_DIR/user" ] && cp -rf $PTV_DIR/user $BACKUP_DIR

# restore
  elif [ "$1" == "restore" ] ; then
      [ -d "$BACKUP_DIR/settings" ] && cp -rf $BACKUP_DIR/settings $PTV_DIR
      [ -d "$BACKUP_DIR/user" ] && cp -rf $BACKUP_DIR/user $PTV_DIR
      rm -fR $BACKUP_DIR

# clean DB
  elif [ "$1" == "clean" ] ; then
      mv -f $PTV_DIR/user $PTV_DIR/user.bk
      mv -f $PTV_DIR/DBcnl.py $PTV_DIR/DBcnl.py.bk
      mv -f $PTV_DIR/DefGR.py $PTV_DIR/DefGR.py.bk
      cp -f $PTV_DIR/DBcnl.empty $PTV_DIR/DBcnl.py
      mv -f $PTV_DIR/DefGR.empty $PTV_DIR/DefGR.py
      rm -fR $PTV_DIR/settings/*
      echo "'true'" > $PTV_DIR/settings/ace_local
      rm -fR $PTV_DIR/serv/*.cl
      rm -fR $PTV_DIR/temp

  fi

exit 0
