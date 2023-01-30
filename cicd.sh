#!/usr/bin/env bash

# git setting
cd ~
git clone https://github.com/ajrms/k8s_cicd
cd k8s_cicd
git init
git config --global user.email "ajrms@gmail.com"
git config --global user.name "ajrms"

# create workflow
mkdir -p .github/workflows
cat <<EOF | sudo tee .github/workflows/test.yaml
name: test
on:
  push:
    branches:
      - main

jobs:
  run-shell-command:
    runs-on: ubuntu-18.04
    steps:
      - run: echo "Hello, world!"
EOF