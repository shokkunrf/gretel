#!/bin/bash

parameter=$(python ./parser.py $@)
if [ "$parameter" = '' ]; then
  echo 'args is invalid'
  exit 1
fi

user=$(echo $parameter | jq -r .user)
ip=$(echo $parameter | jq -r .ip)
identity_file=$(echo $parameter | jq -r .identity_file)
minecraft_version=$(echo $parameter | jq -r .minecraft_version)

ansible-playbook -i $ip, -u $user --private-key=$identity_file --extra-vars minecraft_version=$minecraft_version ./playbook.yml
