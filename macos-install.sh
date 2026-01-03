#!/bin/bash

# --------------------------------------------------------------------------- #
#  Required                                                                   #
# --------------------------------------------------------------------------- #

# Neovim:
brew install neovim
brew unlink neovim
brew install neovim --HEAD
brew link neovim --HEAD

# Packages:
brew install tree-sitter-cli
brew install ripgrep
brew install --cask mactex-no-gui

# Language Servers:
brew install llvm
brew install jdtls
brew install lua-language-server
brew install pyright
brew install texlab
brew install typescript-language-server

# PDF Viewer for LaTeX:
# Skim (https://skim-app.sourceforge.io)

# --------------------------------------------------------------------------- #
#  Optional (uncomment to run)                                                #
# --------------------------------------------------------------------------- #

# Terminal:
# brew install alacritty

# Font:
# brew install font-hack-nerd-font
