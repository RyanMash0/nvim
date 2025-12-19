#!/bin/bash

# --------------------------------------------------------------------------- #
#  Required                                                                   #
# --------------------------------------------------------------------------- #

# Neovim:
brew install neovim
brew unlink neovim
brew install neovim --HEAD
brew link neovim --HEAD

# Treesitter:
brew install luarocks
brew install ripgrep

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

# Markdown:
# cd ~/Downloads
# git clone https://github.com/latex-lsp/tree-sitter-latex
# cd tree-sitter-latex
# brew install tree-sitter-cli
# tree-sitter generate
# tree-sitter build
# mv ~/Downloads/tree-sitter-latex/latex.dylib ~/.local/share/nvim/lazy/nvim-treesitter/parser/latex.dylib
# rm -rf ~/Downloads/tree-sitter-latex
