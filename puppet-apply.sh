#!/usr/bin/env bash

cat >> /opt/puppetlabs/facter/facts.d/role.sh << EOF
#!/bin/bash
echo "role=::role"
EOF
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