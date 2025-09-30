{
  programs.nixvim = {
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
      };
    };

    plugins = {
      # Icons
      web-devicons.enable = true;

      # Notifications
      notify = {
        enable = true;
        settings = {
          top_down = false;
        };
      };

      # Status line
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "tokyonight";
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "";
              right = "";
            };
          };
        };
      };

      # Better UI for vim.ui.select and vim.ui.input
      dressing = {
        enable = true;
        settings = {
          input = {
            insert_only = false;
          };
        };
      };

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          scope = {
            enabled = true;
          };
        };
      };
    };
  };
}
