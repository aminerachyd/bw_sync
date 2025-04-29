#!/bin/bash

# These variables should be defined
# You can list them in a .env file
#BW_SOURCE_INSTANCE=
#BW_SOURCE_CLIENTID=
#BW_SOURCE_CLIENTSECRET=
#BW_SOURCE_MASTERPWD=

#BW_DEST_INSTANCE=
#BW_DEST_CLIENTID=
#BW_DEST_CLIENTSECRET=
#BW_DEST_MASTERPWD=

source .env

if ! command -v bw 2>&1 > /dev/null
then
  echo "bw command is required"
  exit 1
fi

check_source_args() {
  if [ -z "$BW_SOURCE_INSTANCE" ]; then
    echo "Variable BW_SOURCE_INSTANCE is unset"
    read -p "Enter varialbe: " BW_SOURCE_INSTANCE
  fi

  if [ -z "$BW_SOURCE_CLIENTID" ]; then
    echo "Variable BW_SOURCE_CLIENTID is unset, specify the variable:"
    read -p "Enter variable: " BW_SOURCE_CLIENTID
  fi

  if [ -z "$BW_SOURCE_CLIENTSECRET" ]; then
    echo "Variable BW_SOURCE_CLIENTSECRET is unset, specify the variable:"
    read -p "Enter variable: " BW_SOURCE_CLIENTSECRET
  fi

  if [ -z "$BW_SOURCE_MASTERPWD" ]; then
    echo "Variable BW_SOURCE_MASTERPWD is unset, specify the variable:"
    read -p "Enter variable: " BW_SOURCE_MASTERPWD
  fi
}

check_dest_args() {
  if [ -z "$BW_DEST_INSTANCE" ]; then
    echo "Variable BW_DEST_INSTANCE is unset"
    read -p "Enter varialbe: " BW_DEST_INSTANCE
  fi

  if [ -z "$BW_DEST_CLIENTID" ]; then
    echo "Variable BW_DEST_CLIENTID is unset, specify the variable:"
    read -p "Enter variable: " BW_DEST_CLIENTID
  fi

  if [ -z "$BW_DEST_CLIENTSECRET" ]; then
    echo "Variable BW_DEST_CLIENTSECRET is unset, specify the variable:"
    read -p "Enter variable: " BW_DEST_CLIENTSECRET
  fi

  if [ -z "$BW_DEST_MASTERPWD" ]; then
    echo "Variable BW_DEST_MASTERPWD is unset, specify the variable:"
    read -p "Enter variable: " BW_DEST_MASTERPWD
  fi
}

login_to_instance() {
  instance=$1
  clientid=$2
  secret=$3
  password=$4

  echo -n "Logging into Bitwarden instance $instance"
  echo

  bw logout
  bw config server $instance
  BW_CLIENTID=$clientid BW_CLIENTSECRET=$secret bw login --apikey
  export BW_SESSION=$(bw unlock $password --raw)
}

logout_from_instance() {
  echo -n "Logging out of Bitwarden instance"
  echo

  bw logout
}

export_vault_to_file() {
  file=$1
  echo -n "=== Exporting from Bitwarden instance to file $file ==="
  echo

  bw export --output $1
}

import_file_to_vault() {
  file=$1
  echo -n "=== Import file $file to Bitwarden instance ==="
  echo

  bw import bitwardencsv $1
}

check_source_args && \
check_dest_args && \
login_to_instance $BW_SOURCE_INSTANCE $BW_SOURCE_CLIENTID $BW_SOURCE_CLIENTSECRET $BW_SOURCE_MASTERPWD && \
export_vault_to_file bw_export.source.csv && \
logout_from_instance $BW_SOURCE_INSTANCE && \
login_to_instance $BW_DEST_INSTANCE $BW_DEST_CLIENTID $BW_DEST_CLIENTSECRET $BW_DEST_MASTERPWD && \
import_file_to_vault bw_export.source.csv && \
logout_from_instance $BW_DEST_INSTANCE
