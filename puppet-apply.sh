#!/usr/bin/env bash

#if [[ "$1" =~ ^((-{1,2})([Hh]$|[Hh][Ee][Ll][Pp])|)$ ]]; then
#    echo 'USAGE: '; exit 1
#else
    while [[ $# -gt 0 ]]; do
      opt="$1"
      shift;
      current_arg="$1"
      if [[ "$current_arg" =~ ^-{1,2}.* ]]; then
        echo "WARNING: You may have left an argument blank. Double check your command."
      fi
      case "$opt" in
        "-b"|"--build"      ) BUILD=true; shift;;
        "-d"|"--debug"      ) DEBUG="$1"; shif t;;
        "-r"|"--role"       ) ROLE="$1"; shift;;
        *                   ) echo "ERROR: Invalid option: \""$opt"\"" >&2
                              exit 1;;
      esac
    done
#fi


ROLE_FILE=$"#!/bin/bash
echo role=$ROLE"

if [ "$BUILD" = true ]; then
    r10k deploy environment -pv
else
    echo "$ROLE_FILE" > /opt/puppetlabs/facter/facts.d/role.sh
    chmod +x /opt/puppetlabs/facter/facts.d/role.sh

    # Create environment folder if it doesn't exist - puppet apply failure otherwise
    environment=$(awk -F "=" '/environment=/ {print $2}' /etc/puppetlabs/puppet/puppet.conf)

    mkdir -p /etc/puppetlabs/code/environments/$environment
    echo "Running puppet apply for environment: $environment"

    puppet config set strict_variables false
    puppet config set hiera_config hiera.yaml
    puppet config set environmentpath environments
    puppet config set basemodulepath environments/$environment/modules:environments/$environment/site

    puppet apply environments/$environment/manifests/default.pp
fi