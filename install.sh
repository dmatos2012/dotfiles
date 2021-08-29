#!/bin/sh
deps=(git curl gcc g++)
for dep in ${deps[@]};do
  if ! command -v ${dep} &> /dev/null;then
    install_dep+=(${dep})
  fi
done
echo "Installing ${install_dep[@]}"
install_dependencies() {
  for d in ${install_dep[@]};do
    echo "Installing ${d}"
    sudo apt-get install ${d} &> /dev/null
  done
  ! command -v rg &> /dev/null && \
    echo "Installing ripgrep" && \
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb 2> /dev/null && \
    sudo dpkg -i ripgrep_12.1.1_amd64.deb &> /dev/null
  
}


# if ! command -v git &> /dev/null; then
#   echo "Git Could not be found. Do you want to install it? "
#   select yn in "Yes" "No"; do
#     case $yn in
#       Yes ) sudo apt-get install git; break;;
#       No ) exit ;;
#     esac
#   done
# fi
# 
install_nvim(){
  echo "Installing neovim"
  sudo apt-get install -y apt-utils software-properties-common &> /dev/null && \
  echo "Adding neovim unstable ppa"
  sudo add-apt-repository -y ppa:neovim-ppa/unstable &> /dev/null && \
  sudo apt-get update &> /dev/null && \
  sudo apt-get install -y neovim &> /dev/null && \
  # curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb && \
  # sudo dpkg -i ripgrep_12.1.1_amd64.deb
  echo "Finished installing neovim. Adding configuration from my dotfiles"
}

set_nvim_config() {
  # Install packer 
  git clone https://github.com/wbthomason/packer.nvim\
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  git clone https://github.com/dmatos2012/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  [ ! -d "$HOME/.config" ] && mkdir ~/.config
  cp -r nvim ~/.config
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}
install_dependencies
install_nvim
set_nvim_config
