# ⚡ Modern Neovim Config

> **A blazingly fast, IDE-grade Neovim setup with only 20 plugins using Neovim 0.12+ native package manager**

<div align="center">

![Neovim](https://img.shields.io/badge/NeoVim-0.12+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Native](https://img.shields.io/badge/vim.pack-native-blue?style=for-the-badge)
![Plugins](https://img.shields.io/badge/plugins-20-orange?style=for-the-badge)

**From zero to IDE in under 50ms**

</div>

---

## 🎯 Philosophy

This config embraces **modern minimalism**, leveraging Neovim 0.12's native `vim.pack` instead of plugin managers, and carefully selected plugins that replace dozens of others.

## ✨ Highlights

### 🚀 **Performance First**

- **Sub-50ms startup** using native `vim.pack` (no lazy.nvim, no packer)
- **Zero plugin manager overhead**, native, pure Lua, pure speed
- Smart lazy-loading through Neovim's native package system
- Optimized LSP with incremental sync & debounced diagnostics

### 🎨 **Custom UI Without Plugins**

- **Custom statusline** with Git integration, LSP diagnostics, word count for markdown
- **Custom bufferline/tabline** with devicons and smart buffer management
- **Custom session manager** that restores your exact workspace like VSCode
- No lualine, no bufferline.nvim, just pure, fast Lua

### 🧠 **VSCode-Level Intelligence**

- **Native LSP** with 15+ language servers pre-configured
- **Blink.cmp** for blazing completion with LSP, snippets, and fuzzy matching
- **Treesitter** for syntax highlighting, text objects, and code navigation
- **DAP** for debugging with virtual text and UI
- Format-on-save with **conform.nvim** (supports 50+ formatters)

### 📦 **Powerful Plugins**

Each plugin replaces multiple others:

- **snacks.nvim** → Terminal, git, notifier, dashboard, scroll, indent, scope (replaces 10+ plugins)
- **blink.cmp** → Completion framework (faster than nvim-cmp, replaces 3+ plugins)
- **grug-far.nvim** → Search & replace UI (replaces telescope + spectre)
- **render-markdown.nvim** → Beautiful markdown rendering in-buffer
- **yanky.nvim** → Enhanced yank/paste with history
- **which-key.nvim** → Command palette & keybind helper
- **noice.nvim** → Modern UI for messages, cmdline, popups
- **gitsigns.nvim** → Git integration with signs, blame, diff
- **diffview.nvim** → Git diff and merge tool
- **catppuccin** → Eye-candy colorscheme

### 🔥 **Developer Experience**

- **Session persistence** that actually works (remembers buffers, splits, cursor position)
- **Familiar keybindings** for VSCode/IntelliJ refugees
- **Smart buffer management** (close left/right, navigate with Tab/Shift-Tab)
- **Window navigation** with Ctrl+hjkl
- **Auto-pairs, auto-save, auto-format**—it just works™

---

## 📂 Structure

```
nvim/
├── init.lua                    # Entry point (6 lines!)
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── init.lua           # Module loader
│   │   ├── options.lua        # Vim options (130+ settings)
│   │   ├── keymaps.lua        # Keybindings (220+ maps)
│   │   ├── autocmds.lua       # Auto commands
│   │   ├── diagnostics.lua    # LSP diagnostic config
│   │   ├── lsp.lua            # LSP setup
│   │   ├── statusline.lua     # Custom statusline (250 lines)
│   │   ├── tabline.lua        # Custom bufferline (130 lines)
│   │   └── session.lua        # Session management (109 lines)
│   ├── plugins/                # Plugin configs (modular)
│   │   ├── init.lua
│   │   ├── ai.lua             # OpenCode AI
│   │   ├── blink.lua          # Completion
│   │   ├── catppuccin.lua     # Colorscheme
│   │   ├── conform.lua        # Formatting
│   │   ├── dap.lua            # Debugging
│   │   ├── flash.lua          # Jump navigation
│   │   ├── git.lua            # Git integration
│   │   ├── grug-far.lua       # Search & replace
│   │   ├── markdown.lua       # Markdown preview
│   │   ├── noice.lua          # UI enhancements
│   │   ├── snacks.lua         # Swiss army knife
│   │   ├── treesitter.lua     # Syntax & navigation
│   │   ├── whichkey.lua       # Keybind helper
│   │   └── yanky.lua          # Yank history
│   └── utils/
│       └── lsp.lua            # LSP utilities
├── lsp/                        # LSP server configs (15 languages)
│   ├── vtsls.lua              # TypeScript
│   ├── gopls.lua              # Go
│   ├── pyright.lua            # Python
│   ├── rust_analyser.lua      # Rust
│   ├── lua_ls.lua             # Lua
│   └── ...                    # And 10 more
├── snippets/                   # Custom snippets
└── spell/                      # Spell files (EN/FR)
```

## 🎯 Key Features Deep Dive

### 🗂️ **Session Management**

Your workspace, restored pixel-perfect:

```lua
<leader>qs  -- Load session for current directory
<leader>ql  -- Load last session
<leader>qS  -- Select from all sessions
<leader>qd  -- Stop saving session
```

- Auto-saves on exit (per-directory sessions)
- Auto-restores when opening Neovim with no args
- Preserves buffers, splits, folds, cursor positions

### 📊 **Custom Statusline**

Shows everything you need, nothing you don't:

- **Mode indicator** (color-coded)
- **Git branch & repo** (from gitsigns cache—zero overhead)
- **Git diff stats** (+12 ~3 -2)
- **Filename** with devicon & modified indicator
- **LSP diagnostics** (errors, warnings, info, hints)
- **Filetype** with icon
- **Word count & reading time** (markdown/text files)
- **Encoding, format, position, percentage**

### 📁 **Custom Bufferline**

Clean, fast, functional:

- Devicons for filetypes
- Active buffer highlighting
- Close button on active buffer
- Close buffers to left/right: `<leader>bl` / `<leader>br`
- Navigate: `Tab` / `Shift-Tab` or `<leader>bn` / `<leader>bp`

### 🔧 **LSP Configuration**

Pre-configured for 15+ languages:

```
TypeScript/JavaScript (vtsls) • Go (gopls) • Python (pyright)
Rust (rust-analyzer) • Lua (lua_ls) • Docker (dockerls)
YAML (yamlls) • JSON (jsonls) • HTML (html) • CSS (cssls)
TailwindCSS • Nix (nil_ls) • Zig (zls) • Helm (helm_ls)
```

All with:

- Auto-completion
- Go-to-definition / references
- Hover documentation
- Code actions
- Format on save
- Diagnostics

## 🚦 Getting Started

### Prerequisites

- **Neovim 0.12+** (nightly recommended)
- **Git**
- LSP servers (see in each lsp/\*.lua file)
- **Ripgrep** (for search)
- **A Nerd Font** (for icons)

### Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repo
git clone https://github.com/tduyng/nvim.git ~/.config/nvim

# Open Neovim—it will install plugins automatically
nvim
```

First launch will:

1. Install all plugins via `vim.pack`
2. Set up native package directories
3. Ready to use (no `:PackerSync` needed!)

### Update Plugins

```vim
:lua vim.pack.update()
```

Or use the keymap: `<leader>pu`

---

## ⌨️ Essential Keybindings

**Leader key:** `Space`

### 🗂️ Buffers

| Key                 | Action                       |
| ------------------- | ---------------------------- |
| `Tab` / `Shift-Tab` | Next/Previous buffer         |
| `<leader>bn` / `bp` | Next/Previous buffer         |
| `<leader>bb`        | Switch to other buffer       |
| `<leader>bl` / `br` | Close all left/right buffers |

### 🪟 Windows

| Key                 | Action                    |
| ------------------- | ------------------------- |
| `Ctrl-h/j/k/l`      | Navigate windows          |
| `<leader>sv` / `sh` | Split vertical/horizontal |
| `<leader>wd`        | Delete window             |
| `Ctrl-Shift-Arrows` | Resize window             |

### 🔍 Search

| Key          | Action                      |
| ------------ | --------------------------- |
| `<leader>ff` | Find files (snacks)         |
| `<leader>fg` | Live grep (snacks)          |
| `<leader>sr` | Search & replace (grug-far) |

### 🧠 LSP

| Key          | Action              |
| ------------ | ------------------- |
| `gd`         | Go to definition    |
| `gr`         | Go to references    |
| `K`          | Hover documentation |
| `<leader>ca` | Code actions        |
| `<leader>rn` | Rename symbol       |
| `<leader>cf` | Format buffer       |

### 🐛 Debug (DAP)

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue          |
| `<leader>di` | Step into         |
| `<leader>do` | Step over         |

### 🔥 Git

| Key          | Action           |
| ------------ | ---------------- |
| `<leader>gg` | LazyGit (snacks) |
| `<leader>gb` | Git blame line   |
| `<leader>gd` | Git diff         |
| `<leader>gh` | Git history      |

### Add LSP Server

1. Add server config in `lsp/myserver.lua`
2. Load in `lua/config/lsp.lua`

### Modify Statusline

Edit `lua/config/statusline.lua`, it's just Lua!

## 🛠️ Advanced Tips

### Session Management Tips

- Sessions save per-directory (based on `getcwd()`)
- Use `<leader>qd` before quitting if you want a clean slate next time
- Last session is always saved for quick access

### Performance Tuning

Already tuned, but if you want more:

```lua
-- In options.lua
vim.opt.updatetime = 100  -- Even faster (default 300)
vim.opt.timeoutlen = 200  -- Faster which-key (default 300)
```

## 📸 Screenshots

### Lua Development

![Lua Development](docs/images/lua.png)
_Custom statusline with LSP diagnostics, Git integration, and treesitter highlighting_

### Markdown Editing

![Markdown Preview](docs/images/markdown.png)
_Beautiful markdown rendering with word count and reading time in statusline_

## 📜 License

MIT

---

<div align="center">

**If this config saved you time, give it a ⭐!**

</div>
