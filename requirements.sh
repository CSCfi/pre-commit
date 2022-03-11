#!/usr/bin/env bash
installer=""
guess_installer() {
  if [ -z "${installer}" ]; then
    if apt --version; then
      installer='apt install'
    elif yum --version; then
      installer='yum install'
    elif dnf --version; then
      installer='dnf install'
    elif pacman --version; then
      installer='pacman -U'
    elif snap --version; then
      installer='snap install'
    else
      installer='<your-system-installer>'
    fi
  fi
}

guess_installer
sudo ${installer} yamllint pylint shellcheck jq puppet-lint
