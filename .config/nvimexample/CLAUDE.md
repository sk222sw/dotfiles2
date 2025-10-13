# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modular Neovim configuration organized around lazy.nvim plugin management with a clear separation of concerns:

- **Entry point**: `init.lua` sets leader keys and loads modules in order
- **Core configuration**: `lua/options.lua`, `lua/keymaps.lua`, `lua/auto_commands.lua`
- **Plugin management**: `lua/config/lazy.lua` bootstraps lazy.nvim with automatic loading from `lua/config/plugins/`
- **Custom plugins**: `lua/plugins/` contains custom functionality modules

## Key Patterns

### Plugin Configuration
Each plugin file in `lua/config/plugins/` returns a lazy.nvim spec table:
```lua
return {
  "plugin/name",
  config = function()
    -- configuration here
  end,
}
```

### Custom Plugin Development
Custom plugins in `lua/plugins/` expose module functions and integrate with external tools:
- **clipboard_context.lua**: Project-aware clipboard with file collection and tree export
- **go_test.lua**: TreeSitter-powered Go test runner with floating terminal output
- **sido.lua**: External task management system integration

### Language-Specific Configuration
- **File-type settings**: `after/ftplugin/` for language-specific configurations
- **Custom snippets**: `snippets/` directory for language-specific snippets
- **LSP integration**: Comprehensive language server setup in `lua/config/plugins/lsp.lua`

## Development Environment Integration

### Tmux Integration
- Uses tpipeline for tmux statusline integration (`vim.g.tpipeline_autoembed = 1`)
- Seamless pane navigation with tmux-navigator
- Statusline is disabled in favor of tmux integration (`vim.opt.laststatus = 0`)

### Go Development
- Custom test runner accessible via keymaps that uses TreeSitter to identify current test function
- Floating terminal output for test results
- Debug configuration in `after/ftplugin/go.lua`

### Completion and LSP
- Uses blink.cmp (modern alternative to nvim-cmp)
- Comprehensive LSP setup with multiple language servers
- Mason for automatic LSP installation

## Important Configuration Details

### Leader Keys
- Both `mapleader` and `maplocalleader` are set to space (`" "`)

### UI and UX
- TokyoNight colorscheme set as default
- Nerd Font support enabled (`vim.g.have_nerd_font = true`)
- Oil.nvim for directory editing instead of traditional file trees
- Noice.nvim for enhanced command line and notification UI

### File Management
- Neo-tree for file exploration
- Harpoon for quick file switching
- Telescope for fuzzy finding

## Custom Functionality

### Clipboard Context System
The clipboard_context plugin provides project-aware clipboard functionality that can collect files and export project structure. This is particularly useful for sharing code context with AI tools.

### Go Test Integration
The go_test plugin uses TreeSitter to parse Go files and identify test functions, allowing targeted test execution with visual feedback in floating windows.