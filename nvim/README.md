# Install Neovim from source
I will build it from source to the home directory. 

Build preriquisites

`sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl`

```
git clone https://github.com/neovim/neovim ~/build/neovim 
cd ~/build/neovim
make CMAKE_BUILD_TYPE=Release
sudo make install

```
For some of the plugins, I need couple of dependencies
## Packer
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
## LSP related
* Sumneko Lua

Needs  `ninja` and `c++17`. Install gcc-9 and g++-9


```
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install gcc-9 g++-9

```
Clone project and install
Make sure you are compiling it with gcc-9 so, do 

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 600 --slave /usr/bin/g++ g++ /usr/bin/g++-9( higher number is higher priority)

then 
sudo update-alternatives --config gcc and select gcc-9 instead.

```
git clone https://github.com/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild

```
Move it to the cache directory so the exe can be found.

`mv lua-language-server ~/.cache/nvim/nlua/sumneko_lua/ `

Other language servers
* Python, Bash, Vimscript
```
npm i -g pyright
npm i -g bash-language-server
npm i -g vim-language-server

```
## DAP 
Install debugpy for python
```
python3 -m venv ~/debugpy
~/debugpy/bin/python -m pip install debugpy

```

  

