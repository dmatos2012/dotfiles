#!/bin/sh
mkdir .config # relative to home/appuser
if ! command -v git &> /dev/null; then
  echo "Please install git first"
  exit 1
fi
set_nvim_config() {
  # Install packer 
  git clone https://github.com/wbthomason/packer.nvim\
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  git clone https://github.com/dmatos2012/dotfiles.git
  cd dotfiles
  cp -r nvim /home/appuser/.config/
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}
set_nvim_config


