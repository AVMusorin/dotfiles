## Installation

```bash
./bootstrap.sh
```

### Neovim icons

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

### Treesitter error after upgrading to Neovim 0.12


```bash
sudo pacman -S tree-sitter-cli base-devel
```

Run `:PackerSync`, restart Neovim, then update and install parsers:

```vim
:TSUpdate
:TSInstall lua vim vimdoc markdown markdown_inline
```

### Language servers

Servers are no longer managed by mason — install them yourself and keep the
binary on `$PATH`. Neovim enables them from
`.config/nvim/lua/user/lsp/servers.lua`; a server whose binary is missing simply
never starts.

```bash
# apt
sudo apt install clangd gopls

# pipx
pipx install ty                    # Python type checker + language server

# rust-analyzer comes with the toolchain
rustup component add rust-analyzer
```

### Keyboard layout

```bash
sudo mkdir -p /etc/udev/hwdb.d
sudo ln -sf "$(pwd)/udev/90-key-remap.hwdb" /etc/udev/hwdb.d/90-key-remap.hwdb
sudo systemd-hwdb update
# no reboot needed
sudo udevadm trigger -s input
```
