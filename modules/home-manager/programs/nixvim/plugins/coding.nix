{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      # Auto pairs
      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
        };
      };

      # Auto close tags
      ts-autotag.enable = true;

      # Surround
      nvim-surround.enable = true;

      # Better escape
      better-escape = {
        enable = true;
        settings = {
          mapping = ["jk" "kj"];
        };
      };

      # Comment plugin
      comment.enable = true;

      # Todo comments
      todo-comments = {
        enable = true;
        settings = {
          signs = true;
        };
      };

      # Auto highlight search
      # Note: nixvim might not have this plugin, we'll add it via extraPlugins

      # Formatting with conform
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            go = ["gofumpt" "goimports"];
            javascript = ["prettier"];
            typescript = ["prettier"];
            lua = ["stylua"];
            nix = ["alejandra"];
            python = ["black"];
            rust = ["rustfmt"];
            json = ["jq"];
            yaml = ["prettier"];
            markdown = ["prettier"];
            html = ["prettier"];
            css = ["prettier"];
            sh = ["shfmt"];
          };
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
        };
      };

      # Neogen for annotations
      neogen = {
        enable = true;
        snippetEngine = "luasnip";
      };

      # Split/join blocks
      treesj = {
        enable = true;
        settings = {
          use_default_keymaps = true;
        };
      };
    };

    # Plugins that might not be in nixvim
    extraPlugins = with pkgs.vimPlugins; [
      auto-hlsearch-nvim
      cloak-nvim
      nui-nvim
      telescope-github-nvim
      hmts-nvim
      other-nvim
      vim-speeddating
      vim-abolish
      vim-sleuth
      vim-repeat
      vim-dadbod
      vim-dadbod-ui
      vim-dadbod-completion
      bufdelete-nvim
    ];

    extraConfigLua = ''
      -- Auto highlight search
      require("auto-hlsearch").setup()

      -- Cloak for hiding secrets
      require("cloak").setup()

      -- Other.nvim for alternate files
      require("other-nvim").setup({
        mappings = { "golang", "react" }
      })

      -- Neogen keymaps
      vim.keymap.set("n", "<leader>nf", require("neogen").generate, { noremap = true, silent = true, desc = "Generate annotation" })
    '';
  };
}
