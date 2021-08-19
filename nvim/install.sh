#!/bin/sh
mkdir .config # relative to home/appuser
if ! command -v git &> /dev/null; then
  echo "Please install git first"
  exit 1
fi

git clone https://github.com/dmatos2012/dotfiles.git
cd dotfiles
set_nvim_config() {
  cp -r nvim /home/appuser/.config/
}

set_nvim_config

