# Ryan Mash's Neovim Config

This config is designed for neovim v0.12.0 or later.

## Requirements
### Plugins
| Plugin          | Package(s)      |
| --------------- | --------------- |
| nvim-treesitter | tree-sitter-cli |
| nvim-telescope  | ripgrep, fd     |
| vimtex          | texlive         |


### Language Servers
| Language   | Langage Server             |
| ---------- | -------------------------- |
| C          | clangd/clang/llvm          |
| Java       | jdtls                      |
| Lua        | lua-language-server        |
| Python     | pyright                    |
| LaTeX      | texlab                     |
| Typescript | typescript-language-server |
| Markdown   | marksman                   |


## Installation
### Cloning the Repo
This repository contains configuration files for Neovim that must be installed to the Neovim config directory. If you have an existing configuration that you would like to keep, <ins>**make sure to backup your configuration**</ins> to another directory before performing the next steps. 

Run these commands to install the configuration:
```
cd ~/.config
sudo rm -r nvim
git clone https://github.com/RyanMash0/nvim.git
```

Now install the requirements either manually or through the provided installation scripts.

## Installation Scripts
There are currently two installation scripts which will automatically install all requirements. One is for MacOS through Homebrew and the other is for Arch Linux or any other Linux distribution that uses pacman as a package manager. Note that these scripts have optional requirements listed at the bottom which you can selectively uncomment.

### MacOS
Paste this line into your terminal to automatically install requirements through Homebrew:
```
~/.config/macos-install.sh
```

### Arch Linux/Pacman
Paste this line into your terminal to automatically install requirements through Pacman:
```
~/.config/pacman-install.sh
```

### WSL and Other Linux Distributions
There are currently no other installation scripts, but everything needed is listed in the requirements section.

## Configuring
If you wish to add your own configurations, you should do so in the `./lua/user` directory. There are instructions for how to do this in the `./lua/user/init.lua` file. I use the dvorak keyboard layout, so the default leader key is "," (comma). For this reason, it is highly recommended to read the instructions for adding your own configurations, at least to set up your own leader key. If you do not set your leader key in the outlined manner, then none of the predefined keymaps will work. 
