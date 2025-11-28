# Modern Neovim Config

> Fast, IDE-grade Neovim setup with 20 plugins using native `vim.pack` (no plugin manager needed)

![Neovim](https://img.shields.io/badge/NeoVim-0.12+-57A143?style=flat-square&logo=neovim)
![Plugins](https://img.shields.io/badge/plugins-20-orange?style=flat-square)
![Startup](https://img.shields.io/badge/startup-<50ms-blue?style=flat-square)

- Sub-50ms startup using native `vim.pack` (no lazy.nvim/packer overhead)
- Custom UI components (statusline, bufferline, session manager) without extra plugins
- 15+ LSP servers pre-configured with format-on-save
- Session persistence that restores your exact workspace
- Smart plugin choices - each replaces multiple alternatives

## Core Plugins

| Plugin               | Purpose                                            | Replaces            |
| -------------------- | -------------------------------------------------- | ------------------- |
| snacks.nvim          | Terminal, git, notifier, dashboard, scroll, indent | 10+ plugins         |
| blink.cmp            | Completion with LSP, snippets, fuzzy matching      | nvim-cmp + deps     |
| treesitter           | Syntax highlighting, text objects, navigation      | —                   |
| gitsigns.nvim        | Git signs, blame, diff integration                 | —                   |
| grug-far.nvim        | Search & replace UI                                | telescope + spectre |
| which-key.nvim       | Command palette & keybind helper                   | —                   |
| conform.nvim         | Auto-formatting (50+ formatters)                   | —                   |
| noice.nvim           | Modern UI for messages/cmdline                     | —                   |
| flash.nvim           | Jump navigation                                    | hop/leap            |
| yanky.nvim           | Yank history with smart paste                      | —                   |
| render-markdown.nvim | Beautiful in-buffer markdown rendering             | —                   |
| diffview.nvim        | Git diff and merge tool                            | —                   |
| catppuccin           | Colorscheme                                        | —                   |
| nvim-dap             | Debugging with virtual text & UI                   | —                   |

## Custom features (no plugins required)

- Custom statusline - Git branch/diff, LSP diagnostics, word count for markdown
- Custom bufferline - Smart buffer management with devicons
- Session manager - Per-directory auto-save/restore
- LSP utilities - Unified setup helpers

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone https://github.com/tduyng/nvim.git ~/.config/nvim

# Launch (plugins install automatically)
nvim
```

Prerequisites: Neovim 0.12+, Git, Ripgrep, Nerd Font

Update plugins: `<leader>pu` or `:lua vim.pack.update()`

## Quick Start

Leader key: `Space`

### Essential Keybindings

```
Files & Search
  <leader><leader>  Find files
  <leader>L/  Live grep
  <leader>sr  Search & replace

Buffers
  Tab / S-Tab Navigate buffers
  <leader>bb  Switch to recent buffer
  <leader>bl  Close buffers to left
  <leader>br  Close buffers to right
  <leader>bo  Close all other buffers

Windows
  Ctrl-h/j/k/l  Navigate windows
  <leader>sv    Vertical split
  <leader>sh    Horizontal split

LSP
  gd           Go to definition
  gr           Go to references
  K            Hover documentation
  <leader>ca   Code actions
  <leader>cd   Diagnostic errors
  <leader>rn   Rename symbol
  <leader>cf   Format buffer

Git
  <leader>gg   LazyGit
  <leader>gb   Git blame
  <leader>gd   Git diff

Sessions
  <leader>qs   Load session (cwd)
  <leader>ql   Load last session
  <leader>qS   Select session
  <leader>qd   Stop auto-save

Debug (DAP)
  <leader>db   Toggle breakpoint
  <leader>dc   Continue
  <leader>di   Step into
  <leader>do   Step over
```

A lot of keymaps as in [Lazyvim/keymaps](https://www.lazyvim.org/keymaps)

## Screenshots

![Lua Development](docs/images/lua.png)

![Markdown Preview](docs/images/markdown.png)

---

## License

MIT
