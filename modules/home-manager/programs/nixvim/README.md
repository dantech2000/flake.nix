# Nixvim Configuration

This directory contains a modular, declarative Neovim configuration using nixvim. The configuration is fully reproducible and managed through Nix.

## Structure

```
nixvim/
├── default.nix          # Module coordinator
├── options.nix          # Vim options and settings
├── keymaps.nix          # All keybindings
├── lsp.nix             # LSP server configurations
├── completion.nix       # Completion, snippets, and Copilot
├── autocommands.nix     # Autocommands and file type settings
└── plugins/
    ├── default.nix      # Plugin module coordinator
    ├── ui.nix          # UI plugins (theme, statusline, notifications)
    ├── navigation.nix   # Telescope, Harpoon, Tmux Navigator
    ├── git.nix         # Git-related plugins
    ├── coding.nix      # Coding utilities (autopairs, surround, etc.)
    └── treesitter.nix  # Treesitter and text objects
```

## Key Features

### LSP Support
Full LSP support for 15+ languages:
- Go (gopls)
- TypeScript/JavaScript (ts_ls)
- Rust (rust_analyzer)
- Nix (nil_ls)
- Lua (lua_ls)
- Python, Bash, C/C++, CSS, Docker, JSON, YAML, HTML, Terraform, and more

### Plugins
- **Telescope**: Fuzzy finder for files, grep, buffers, and more
- **Harpoon**: Quick file navigation
- **Treesitter**: Advanced syntax highlighting and text objects
- **GitHub Copilot**: AI-powered code completion
- **Gitsigns**: Git integration in the gutter
- **Conform**: Code formatting with formatters by filetype
- **Todo Comments**: Highlight TODO, FIXME, NOTE, etc.

## Keybindings

### Leader Key
`<Space>` is the leader key for most commands.

### File Navigation

#### Telescope
- `<C-p>` - Find files
- `<leader>of` - Recent files (oldfiles)
- `<leader>lg` - Live grep (search in files)
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags
- `<leader>fc` - Commands
- `<leader>fr` - Resume last search
- `<leader>fq` - Quickfix list
- `<leader>/` - Fuzzy find in current buffer
- `<leader>xx` - Diagnostics

#### Harpoon
- `<leader>m` - Mark current file
- `<A-e>` - Toggle Harpoon quick menu
- `<A-h>` - Go to Harpoon file 1
- `<A-j>` - Go to Harpoon file 2
- `<A-k>` - Go to Harpoon file 3
- `<A-l>` - Go to Harpoon file 4
- `[j` - Previous Harpoon file
- `[k` - Next Harpoon file

### Buffer Management
- `<leader>n` - New buffer
- `<leader>q` - Delete current buffer
- `<leader>bad` - Delete all buffers
- `<leader>bsd` - Delete surrounding buffers (keep current)
- `<leader>w` - Save file
- `<leader>W` - Save file without autocommands

### LSP Commands
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Go to references
- `gi` - Go to implementation
- `gt` - Go to type definition
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `<C-k>` - Signature help
- `<leader>k` - Previous diagnostic
- `<leader>j` - Next diagnostic
- `gl` - Show diagnostic in floating window

### Quickfix List
- `<leader>co` - Open quickfix list
- `<leader>cc` - Close quickfix list
- `[q` - Previous quickfix item
- `]q` - Next quickfix item

### Window Management
- `<A-Up>` - Increase window height
- `<A-Down>` - Decrease window height
- `<A-Left>` - Decrease window width
- `<A-Right>` - Increase window width

### Navigation
- `n` - Next search result (centered)
- `N` - Previous search result (centered)
- `<C-u>` - Half page up (centered)
- `<C-d>` - Half page down (centered)
- `<C-o>` - Jump back (centered)
- `<C-i>` - Jump forward (centered)

### Insert Mode
- `jk` or `kj` - Exit insert mode
- `-`, `_`, `,`, `.`, `!`, `?` - Add undo breakpoints after these characters

### Visual Mode
- `<` - Unindent (stays in visual mode)
- `>` - Indent (stays in visual mode)
- `<A-j>` - Move selection down
- `<A-k>` - Move selection up
- `p` - Paste without replacing clipboard

### Clipboard
- `<leader>y` - Yank to system clipboard
- `<leader>Y` - Yank line to system clipboard
- `<leader>d` - Delete to blackhole register
- `<leader>D` - Delete line to blackhole register
- `<leader>py` - Copy current file path

### Blank Lines
- `]<Space>` - Insert blank line below
- `[<Space>` - Insert blank line above

### Git
- `<leader>gg` - Git status
- `<leader>gp` - Git push
- `<leader>gP` - Git pull
- `<leader>gb` - Git blame
- `<leader>ghi` - GitHub issues (via Telescope)

### Code Generation
- `<leader>nf` - Generate annotation/docstring (Neogen)

### Recording Macros
- `Q` - Record macro (remapped from q)
- `q` - Disabled (use Q instead)

## File Explorer

This configuration does not include a file tree plugin like NvimTree or Neo-tree. Instead, it relies on:

1. **Telescope** (`<C-p>`) - Fast file finding with fuzzy search
2. **Harpoon** (`<leader>m`, `<A-e>`) - Quick navigation between frequently used files
3. **Netrw** (built-in) - Use `:Ex` to open Netrw file explorer if needed

Netrw is Vim's built-in file explorer:
- `:Ex` - Open explorer in current window
- `:Sex` - Open explorer in horizontal split
- `:Vex` - Open explorer in vertical split

## Treesitter

Treesitter provides advanced syntax highlighting and text objects for 50+ languages.

### Text Objects
- `af` / `if` - Function outer/inner
- `ac` / `ic` - Class outer/inner
- `aa` / `ia` - Parameter outer/inner

### Navigation
- `]f` - Next function start
- `]F` - Next function end
- `[f` - Previous function start
- `[F` - Previous function end
- `]c` - Next class start
- `]C` - Next class end
- `[c` - Previous class start
- `[C` - Previous class end

### Incremental Selection
- `<CR>` - Init/expand selection
- `<TAB>` - Expand scope
- `<S-CR>` - Shrink selection

## Customization

### Adding a New Plugin

1. Check if nixvim has native support: https://nix-community.github.io/nixvim/plugins/
2. If supported, add to appropriate file in `plugins/`:
   ```nix
   plugins.plugin-name = {
     enable = true;
     settings = {
       # plugin settings
     };
   };
   ```
3. If not supported, add to `extraPlugins` in the relevant file:
   ```nix
   extraPlugins = with pkgs.vimPlugins; [
     plugin-name
   ];

   extraConfigLua = ''
     require('plugin-name').setup({
       -- plugin config
     })
   '';
   ```

### Adding a New Keymap

Edit `keymaps.nix` and add:
```nix
{
  mode = "n";  # or "i", "v", "x"
  key = "<leader>xx";
  action = ":Command<CR>";  # or action.__raw = "function() ... end";
  options = {
    noremap = true;
    silent = true;
    desc = "Description for which-key";
  };
}
```

### Adding a New LSP Server

Edit `lsp.nix` and add to `plugins.lsp.servers`:
```nix
your-lsp = {
  enable = true;
  settings = {
    # LSP-specific settings
  };
};
```

### Changing Theme

Edit `plugins/ui.nix` and change the colorscheme:
```nix
colorschemes.tokyonight = {
  enable = true;
  settings = {
    style = "night";  # or "storm", "day", "moon"
  };
};
```

### Modifying Vim Options

Edit `options.nix` to change any vim option:
```nix
opts = {
  number = true;
  relativenumber = true;
  tabstop = 4;
  # etc.
};
```

## Formatting

Formatting is handled by conform.nvim with the following formatters by filetype:

- **Go**: gofumpt, goimports
- **JavaScript/TypeScript**: prettier
- **Lua**: stylua
- **Nix**: alejandra
- **Python**: black
- **Rust**: rustfmt
- **JSON**: jq
- **YAML/Markdown/HTML/CSS**: prettier
- **Shell**: shfmt

Format on save is enabled by default with a 500ms timeout.

## Completion

Completion is powered by nvim-cmp with multiple sources:
1. LSP (primary source)
2. Luasnip (snippets)
3. GitHub Copilot
4. Buffer (words from current buffer)
5. Path (file paths)
6. Emoji
7. Calc (math expressions)

### Completion Keybindings
- `<C-Space>` - Trigger completion
- `<C-y>` - Confirm selection
- `<C-e>` - Abort completion
- `<C-n>` / `<C-p>` - Navigate items
- `<Up>` / `<Down>` - Navigate items
- `<C-u>` / `<C-d>` - Scroll documentation
- `<C-k>` / `<C-j>` - Jump between snippet placeholders

## Troubleshooting

### LSP Not Working
1. Check if the LSP server is installed: `:LspInfo`
2. Verify the filetype is correct: `:set filetype?`
3. Check LSP logs: `:LspLog`

### Treesitter Issues
1. Update parsers: `:TSUpdate`
2. Check installed parsers: `:TSInstallInfo`

### Keybinding Not Working
1. Check if the key is already mapped: `:nmap <key>` or `:imap <key>`
2. Review keymaps.nix for conflicts

### Undo File Errors
If you see errors about undo files, ensure the directory exists:
```bash
mkdir -p ~/.local/state/nvim/undodir
```

## Performance

This configuration is optimized for performance:
- Lazy loading where possible
- Minimal startup plugins
- Efficient treesitter queries
- Debounced LSP text changes (150ms)

## Further Reading

- Nixvim Documentation: https://nix-community.github.io/nixvim/
- Neovim Documentation: `:help`
- Plugin-specific help: `:help plugin-name`