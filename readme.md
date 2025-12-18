# Ryan Mash's Neovim Config

This config is designed for neovim v0.12.0+. 

## MacOS
There is a script titled macos-install.sh that installs dependencies through Homebrew. You should run this after cloning the repository. Note that there are several optional dependencies that are commented out.

Run these commands to clone the repo and install dependencies:
```
cd ~/.config
git clone https://github.com/RyanMash0/nvim.git
cd nvim
./macos-install.sh
```

## WSL and Linux
There are no scripts to install dependencies for other operating systems yet, but they will likely be added in the future.

Run these commands to clone the repo:
```
cd ~/.config
git clone https://github.com/RyanMash0/nvim.git
```

Install these dependencies:
- luarocks
- ripgrep
- llvm (clangd)
- jdtls
- lua-language-server
- pyright
- texlab
- typescript-language-server
