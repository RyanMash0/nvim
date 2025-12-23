#!/bin/bash

# --------------------------------------------------------------------------- #
#  Required                                                                   #
# --------------------------------------------------------------------------- #

# Neovim:
yay -Syu --needed neovim-nightly-bin

# Packages:
sudo pacman -Sy --needed tree-sitter-cli
sudo pacman -Sy --needed ripgrep
sudo pacman -Sy --needed texlive

# Language Servers:
sudo pacman -Sy --needed llvm clang
yay -Sy --needed jdtls
sudo pacman -Sy --needed lua-language-server
sudo pacman -Sy --needed pyright
sudo pacman -Sy --needed texlab
sudo pacman -Sy --needed typescript-language-server

# PDF Viewer for LaTeX:
sudo pacman -Sy --needed zathura
sudo pacman -Sy --needed zathura-pdf-mupdf

# --------------------------------------------------------------------------- #
#  Optional (uncomment to run)                                                #
# --------------------------------------------------------------------------- #

# Terminal:
# sudo pacman -Sy --needed alacritty

# Font:
# sudo pacman -Sy --needed ttf-hack-nerd
