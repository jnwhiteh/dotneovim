# NeoVim Configuration

A modern NeoVim (0.11.5+) configuration built with lazy loading, native LSP, and a focus on Lua and Java development.

## Features

### Plugin Management
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Fast, modern plugin manager with lazy loading

### Language Server Protocol (LSP)
- **Native vim.lsp.config** - Uses NeoVim 0.11+ native LSP configuration (no deprecated lspconfig framework)
- **Lazy-loaded LSPs** - Language servers only load when you open relevant files
- **Auto-install prompts** - Missing LSPs prompt for installation via Mason

#### Lua Support
- **lua-language-server** - Full LSP support
- **.luacheckrc integration** - Automatically parses project `.luacheckrc` for globals (single source of truth)
- **WoW Lua 5.1** - Configured for World of Warcraft addon development

#### Java Support
- **Dual LSP setup**:
  - **jdtls** (nvim-jdtls) - For Maven/Gradle projects
  - **java-language-server** - For Bazel projects (auto-detected via `BUILD.bazel`)
- **Graceful degradation** - Warns if Java or LSP not available with install instructions

### Completion
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Autocompletion with multiple sources
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** - Snippet engine with friendly-snippets

### Fuzzy Finding
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder for files, grep, buffers, and more
- **VS Code-style shortcuts**: `Ctrl+P` (files), `Ctrl+Shift+P` (commands)
- **telescope-fzf-native** - Native FZF sorter for performance

### File Explorer
- **[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)** - Modern file explorer with git integration

### Syntax Highlighting
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Advanced syntax highlighting and code navigation
- **Treesitter textobjects** - Navigate by functions, classes, etc.

### UI
- **[tokyonight.nvim](https://github.com/folke/tokyonight.nvim)** - Dark colorscheme
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)** - Fast statusline
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git signs in gutter
- **[indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)** - Indent guides
- **[dressing.nvim](https://github.com/stevearc/dressing.nvim)** - Improved vim.ui interfaces
- **[which-key.nvim](https://github.com/folke/which-key.nvim)** - Keybinding discovery

## Requirements

- NeoVim 0.11.5+
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Optional: [ripgrep](https://github.com/BurntSushi/ripgrep) for faster file searching

## Installation

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this config
git clone https://github.com/YOUR_USERNAME/nvim-config.git ~/.config/nvim

# Start NeoVim - plugins will auto-install
nvim
```

## Key Bindings

Leader key: `<Space>`

### General
| Key | Action |
|-----|--------|
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>-` | Horizontal split |
| `<Space>\|` | Vertical split |
| `jk` or `jj` | Exit insert mode |

### File Navigation
| Key | Action |
|-----|--------|
| `Ctrl+P` | Find files (VS Code style) |
| `Ctrl+Shift+P` | Command palette |
| `<Space>e` | Toggle file explorer |
| `<Space>E` | Reveal current file in explorer |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Buffers |
| `<Space>fr` | Recent files |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover documentation |
| `<Space>ca` | Code action |
| `<Space>cr` | Rename |
| `<Space>cf` | Format |

### Git (via gitsigns)
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next/previous hunk |
| `<Space>ghs` | Stage hunk |
| `<Space>ghr` | Reset hunk |
| `<Space>ghp` | Preview hunk |
| `<Space>ghb` | Blame line |

### Window Navigation
| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Navigate windows |
| `Ctrl+arrows` | Resize windows |
| `Shift+H/L` | Previous/next buffer |

## File Structure

```
~/.config/nvim/
├── init.lua                 # Entry point, bootstraps lazy.nvim
├── ftplugin/
│   ├── java.lua             # Java LSP (jdtls/java-language-server)
│   └── lua.lua              # Lua LSP with .luacheckrc parsing
└── lua/
    ├── config/
    │   ├── options.lua      # Core Vim options
    │   ├── keymaps.lua      # Key mappings
    │   └── autocmds.lua     # Autocommands
    └── plugins/
        ├── lsp.lua          # LSP configuration
        ├── cmp.lua          # Completion
        ├── telescope.lua    # Fuzzy finder
        ├── treesitter.lua   # Syntax highlighting
        ├── neo-tree.lua     # File explorer
        ├── ui.lua           # Colorscheme, statusline, etc.
        └── which-key.lua    # Keybinding help
```

## Adding New Languages

1. Create `ftplugin/<language>.lua`
2. Check if LSP is installed, prompt to install if not
3. Use `vim.lsp.start()` to start the LSP for the current buffer
4. Add to Mason's install list if desired

See `ftplugin/lua.lua` for a complete example with auto-install prompts.

## License

MIT
