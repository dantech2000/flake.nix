{
  programs.nixvim = {
    keymaps = [
      # Normal mode
      # Disable Ex mode
      {
        mode = "n";
        key = "Q";
        action = "q";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "q";
        action = "<Nop>";
        options = {
          noremap = true;
          silent = true;
        };
      }

      # Buffer management
      {
        mode = "n";
        key = "<leader>n";
        action = ":enew<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "New buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>q";
        action = ":Bdelete<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Delete buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bad";
        action = ":%bd!<cr>:intro<cr>";
        options = {
          noremap = true;
          silent = true;
          desc = "Delete all buffers";
        };
      }

      # Quickfix list
      {
        mode = "n";
        key = "<leader>co";
        action = ":copen<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Open quickfix";
        };
      }
      {
        mode = "n";
        key = "<leader>cc";
        action = ":cclose<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Close quickfix";
        };
      }
      {
        mode = "n";
        key = "[q";
        action = ":cprevious<CR>zz";
        options = {
          noremap = true;
          silent = true;
          desc = "Previous quickfix";
        };
      }
      {
        mode = "n";
        key = "]q";
        action = ":cnext<CR>zz";
        options = {
          noremap = true;
          silent = true;
          desc = "Next quickfix";
        };
      }

      # Window resizing
      {
        mode = "n";
        key = "<A-Up>";
        action = ":resize +2<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<A-Down>";
        action = ":resize -2<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<A-Left>";
        action = ":vertical resize -2<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<A-Right>";
        action = ":vertical resize +2<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }

      # Save
      {
        mode = "n";
        key = "<leader>w";
        action = ":write<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Save file";
        };
      }
      {
        mode = "n";
        key = "<leader>W";
        action = ":noautocmd write<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Save file (no autocommands)";
        };
      }

      # Paste over without replacing default register
      {
        mode = "n";
        key = "<leader>p";
        action = ''"_dP'';
        options = {
          noremap = true;
          silent = true;
          desc = "Paste without replacing register";
        };
      }

      # Center screen after navigation
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-o>";
        action = "<C-o>zz";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-i>";
        action = "<C-i>zz";
        options = {
          noremap = true;
          silent = true;
        };
      }

      # Insert blank lines
      {
        mode = "n";
        key = "]<Space>";
        action = "m`o<Esc>``";
        options = {
          noremap = true;
          silent = true;
          desc = "Insert blank line below";
        };
      }
      {
        mode = "n";
        key = "[<Space>";
        action = "m`O<Esc>``";
        options = {
          noremap = true;
          silent = true;
          desc = "Insert blank line above";
        };
      }

      # System clipboard
      {
        mode = "n";
        key = "<leader>y";
        action = ''"+y'';
        options = {
          noremap = true;
          silent = true;
          desc = "Yank to system clipboard";
        };
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = ''"+Y'';
        options = {
          noremap = true;
          silent = true;
          desc = "Yank line to system clipboard";
        };
      }

      # Copy current file path
      {
        mode = "n";
        key = "<leader>py";
        action = '':let @" = expand("%:p")<CR>'';
        options = {
          noremap = true;
          silent = true;
          desc = "Copy file path";
        };
      }

      # Delete to blackhole
      {
        mode = "n";
        key = "<leader>d";
        action = ''"_d'';
        options = {
          noremap = true;
          silent = true;
          desc = "Delete to blackhole";
        };
      }
      {
        mode = "n";
        key = "<leader>D";
        action = ''"_D'';
        options = {
          noremap = true;
          silent = true;
          desc = "Delete line to blackhole";
        };
      }

      # Insert mode
      # Undo breakpoints
      {
        mode = "i";
        key = "-";
        action = "-<c-g>u";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "i";
        key = "_";
        action = "_<c-g>u";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "i";
        key = ",";
        action = ",<c-g>u";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "i";
        key = ".";
        action = ".<c-g>u";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "i";
        key = "!";
        action = "!<c-g>u";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "i";
        key = "?";
        action = "?<c-g>u";
        options = {
          noremap = true;
          silent = true;
        };
      }

      # Quick escape
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "i";
        key = "kj";
        action = "<ESC>";
        options = {
          noremap = true;
          silent = true;
        };
      }

      # Visual mode
      # Stay in indent mode
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options = {
          noremap = true;
          silent = true;
        };
      }

      # Move text up and down
      {
        mode = "v";
        key = "<A-j>";
        action = ":m .+1<CR>==";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m .-2<CR>==";
        options = {
          noremap = true;
          silent = true;
        };
      }

      # Paste without replacing clipboard
      {
        mode = "v";
        key = "p";
        action = ''"_dP'';
        options = {
          noremap = true;
          silent = true;
        };
      }

      # System clipboard
      {
        mode = "v";
        key = "<leader>y";
        action = ''"+y'';
        options = {
          noremap = true;
          silent = true;
          desc = "Yank to system clipboard";
        };
      }
      {
        mode = "v";
        key = "<leader>Y";
        action = ''"+Y'';
        options = {
          noremap = true;
          silent = true;
          desc = "Yank lines to system clipboard";
        };
      }

      # Delete to blackhole
      {
        mode = "v";
        key = "<leader>d";
        action = ''"_d'';
        options = {
          noremap = true;
          silent = true;
          desc = "Delete to blackhole";
        };
      }
      {
        mode = "v";
        key = "<leader>D";
        action = ''"_D'';
        options = {
          noremap = true;
          silent = true;
          desc = "Delete lines to blackhole";
        };
      }

      # Visual Block mode
      # Move text up and down
      {
        mode = "x";
        key = "J";
        action = ":move '>+1<CR>gv-gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "x";
        key = "K";
        action = ":move '<-2<CR>gv-gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "x";
        key = "<A-j>";
        action = ":move '>+1<CR>gv-gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "x";
        key = "<A-k>";
        action = ":move '<-2<CR>gv-gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];

    # Complex keymap that requires Lua function
    extraConfigLua = ''
      -- Delete surrounding buffers
      vim.keymap.set("n", "<leader>bsd", function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local current = vim.fn.expand("%:p")
        vim.cmd("%bd")
        vim.cmd("e " .. current)
        vim.api.nvim_win_set_cursor(0, cursor)
        vim.cmd("zz")
      end, { noremap = true, silent = true, desc = "Delete surrounding buffers" })
    '';
  };
}
