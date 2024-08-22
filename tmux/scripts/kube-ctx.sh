#!/usr/bin/env bash

if command -v kubectl &> /dev/null
then
  echo "k8s ctx: $(kubectl config current-context 2> /dev/null) | ns: $(kubectl config view --minify | grep namespace: | awk '{print $2}' 2> /dev/null)"
fi
