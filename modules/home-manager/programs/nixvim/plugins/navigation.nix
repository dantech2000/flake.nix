{
  programs.nixvim = {
    # Harpoon keymaps (using harpoon2 API)
    keymaps = [
      {
        mode = "n";
        key = "<leader>m";
        action.__raw = "function() require('harpoon'):list():add() end";
        options = {
          desc = "Harpoon mark current file";
        };
      }
      {
        mode = "n";
        key = "<A-e>";
        action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end";
        options = {
          desc = "Harpoon toggle quick menu";
        };
      }
      {
        mode = "n";
        key = "<A-h>";
        action.__raw = "function() require('harpoon'):list():select(1) end";
        options = {
          desc = "Harpoon go to file 1";
        };
      }
      {
        mode = "n";
        key = "<A-j>";
        action.__raw = "function() require('harpoon'):list():select(2) end";
        options = {
          desc = "Harpoon go to file 2";
        };
      }
      {
        mode = "n";
        key = "<A-k>";
        action.__raw = "function() require('harpoon'):list():select(3) end";
        options = {
          desc = "Harpoon go to file 3";
        };
      }
      {
        mode = "n";
        key = "<A-l>";
        action.__raw = "function() require('harpoon'):list():select(4) end";
        options = {
          desc = "Harpoon go to file 4";
        };
      }
      {
        mode = "n";
        key = "[j";
        action.__raw = "function() require('harpoon'):list():prev() end";
        options = {
          desc = "Harpoon previous";
        };
      }
      {
        mode = "n";
        key = "[k";
        action.__raw = "function() require('harpoon'):list():next() end";
        options = {
          desc = "Harpoon next";
        };
      }
    ];

    plugins = {
      # Telescope fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
        settings = {
          defaults = {
            prompt_prefix = "   ";
            selection_caret = " ❯ ";
            entry_prefix = "   ";
            multi_icon = "+ ";
            path_display = ["filename_first"];
            vimgrep_arguments = [
              "rg"
              "--color=never"
              "--no-heading"
              "--with-filename"
              "--line-number"
              "--column"
              "--smart-case"
              "--hidden"
              "--glob=!.git"
            ];
          };
        };
        keymaps = {
          "<C-p>" = {
            action = "find_files";
            options = {
              desc = "Find files";
            };
          };
          "<leader>of" = {
            action = "oldfiles";
            options = {
              desc = "Recent files";
            };
          };
          "<leader>lg" = {
            action = "live_grep";
            options = {
              desc = "Live grep";
            };
          };
          "<leader>fb" = {
            action = "buffers";
            options = {
              desc = "Find buffers";
            };
          };
          "<leader>fh" = {
            action = "help_tags";
            options = {
              desc = "Help tags";
            };
          };
          "<leader>fc" = {
            action = "commands";
            options = {
              desc = "Commands";
            };
          };
          "<leader>fr" = {
            action = "resume";
            options = {
              desc = "Resume";
            };
          };
          "<leader>fq" = {
            action = "quickfix";
            options = {
              desc = "Quickfix";
            };
          };
          "<leader>/" = {
            action = "current_buffer_fuzzy_find";
            options = {
              desc = "Buffer fuzzy find";
            };
          };
          "<leader>xx" = {
            action = "diagnostics";
            options = {
              desc = "Diagnostics";
            };
          };
        };
      };

      # Harpoon for quick file navigation
      harpoon = {
        enable = true;
      };

      # Tmux navigation
      tmux-navigator.enable = true;
    };

    # Custom telescope configuration for multi-select
    extraConfigLua = ''
      local telescope = require("telescope")

      -- Load telescope extensions
      pcall(telescope.load_extension, "gh")
      pcall(telescope.load_extension, "harpoon")

      -- Custom multi-select function
      local select_one_or_multi = function(prompt_bufnr)
        local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        if not vim.tbl_isempty(multi) then
          require("telescope.actions").close(prompt_bufnr)
          for _, j in pairs(multi) do
            if j.path ~= nil then
              vim.cmd(string.format("%s %s", "edit", j.path))
            end
          end
        else
          require("telescope.actions").select_default(prompt_bufnr)
        end
      end

      -- Override telescope mappings
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<CR>"] = select_one_or_multi,
              ["<C-y>"] = select_one_or_multi,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--hidden", "--files", "--smart-case", "--glob=!.git" },
          },
          oldfiles = {
            only_cwd = true,
          },
        },
      })

      -- GitHub issues keymap
      vim.keymap.set("n", "<leader>ghi", telescope.extensions.gh.issues, { noremap = true, silent = true, desc = "GitHub issues" })

      -- Harpoon telescope integration
      vim.keymap.set("n", "<leader>fj", function()
        require('telescope').extensions.harpoon.marks()
      end, { noremap = true, silent = true, desc = "Harpoon marks" })
    '';
  };
}
