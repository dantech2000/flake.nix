{
  programs.nixvim = {
    plugins = {
      # Git signs in the gutter
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {
              text = "▎";
            };
            change = {
              text = "▎";
            };
            delete = {
              text = "";
            };
            topdelete = {
              text = "";
            };
            changedelete = {
              text = "▎";
            };
            untracked = {
              text = "▎";
            };
          };
          current_line_blame = true;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 1000;
          };
        };
      };

      # Fugitive for Git commands
      fugitive.enable = true;

      # GitHub integration for fugitive
      rhubarb.enable = true;
    };

    # Git-related keymaps
    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = ":Git<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Git status";
        };
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = ":Git push<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Git push";
        };
      }
      {
        mode = "n";
        key = "<leader>gP";
        action = ":Git pull<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Git pull";
        };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = ":Git blame<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Git blame";
        };
      }
    ];
  };
}