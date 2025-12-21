#!/bin/bash

# --------------------------------------------------------------------------- #
#  Required                                                                   #
# --------------------------------------------------------------------------- #

# Neovim:
yay -Sy neovim-nightly-bin

# Packages:
sudo pacman -Sy tree-sitter-cli
sudo pacman -Sy ripgrep
sudo pacman -Sy texlive

# Language Servers:
sudo pacman -Sy llvm clang
yay -Sy jdtls
sudo pacman -Sy lua-language-server
sudo pacman -Sy pyright
sudo pacman -Sy texlab
sudo pacman -Sy typescript-language-server

# PDF Viewer for LaTeX:
sudo pacman -Sy zathura
sudo pacman -Sy zathura-pdf-mupdf

# --------------------------------------------------------------------------- #
#  Optional (uncomment to run)                                                #
# --------------------------------------------------------------------------- #

# Terminal:
# sudo pacman -Sy alacritty

# Font:
# sudo pacman -Sy ttf-hack-nerd
