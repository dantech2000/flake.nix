{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      neodev-nvim
    ];

    plugins = {
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
            "gl" = "open_float";
          };
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gr" = "references";
            "gi" = "implementation";
            "gt" = "type_definition";
            "K" = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
            "<C-k>" = "signature_help";
          };
        };

        servers = {
          # Go
          gopls = {
            enable = true;
            settings = {
              gopls = {
                gofumpt = true;
                codelenses = {
                  gc_details = true;
                  generate = true;
                  run_govulncheck = true;
                  test = true;
                  tidy = true;
                  upgrade_dependency = true;
                };
                hints = {
                  assignVariableTypes = true;
                  compositeLiteralFields = true;
                  compositeLiteralTypes = true;
                  constantValues = true;
                  functionTypeParameters = true;
                  parameterNames = true;
                  rangeVariableTypes = true;
                };
                analyses = {
                  nilness = true;
                  unusedparams = true;
                  unusedvariable = true;
                  unusedwrite = true;
                  useany = true;
                };
                staticcheck = true;
                directoryFilters = ["-.git" "-node_modules"];
                semanticTokens = true;
              };
            };
          };

          # TypeScript/JavaScript
          ts_ls = {
            enable = true;
            settings = {
              javascript = {
                inlayHints = {
                  includeInlayEnumMemberValueHints = true;
                  includeInlayFunctionLikeReturnTypeHints = true;
                  includeInlayFunctionParameterTypeHints = true;
                  includeInlayParameterNameHints = "all";
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                  includeInlayPropertyDeclarationTypeHints = true;
                  includeInlayVariableTypeHints = true;
                };
              };
              typescript = {
                inlayHints = {
                  includeInlayEnumMemberValueHints = true;
                  includeInlayFunctionLikeReturnTypeHints = true;
                  includeInlayFunctionParameterTypeHints = true;
                  includeInlayParameterNameHints = "all";
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                  includeInlayPropertyDeclarationTypeHints = true;
                  includeInlayVariableTypeHints = true;
                };
              };
            };
          };

          # Lua
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace";
                };
                telemetry = {
                  enable = false;
                };
                hint = {
                  enable = true;
                };
              };
            };
          };

          # Nix
          nil_ls.enable = true;

          # Bash
          bashls.enable = true;

          # C/C++
          clangd.enable = true;

          # CSS
          cssls.enable = true;

          # Docker
          dockerls.enable = true;

          # JSON
          jsonls.enable = true;

          # Rust
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };

          # TOML
          taplo.enable = true;

          # Templ
          templ.enable = true;

          # Terraform
          terraformls.enable = true;
          tflint.enable = true;

          # Zig
          zls.enable = true;

          # HTML (with templ support)
          html = {
            enable = true;
            filetypes = ["html" "templ"];
          };

          # Tailwind CSS
          tailwindcss = {
            enable = true;
            filetypes = ["html" "templ" "javascript"];
            settings = {
              tailwindCSS = {
                includeLanguages = {
                  templ = "html";
                };
              };
            };
          };

          # YAML
          yamlls = {
            enable = true;
            settings = {
              yaml = {
                schemaStore = {
                  url = "https://www.schemastore.org/api/json/catalog.json";
                  enable = true;
                };
              };
            };
          };
        };
      };
    };

    # Diagnostic configuration
    diagnostic = {
      settings = {
        underline = true;
        update_in_insert = false;
        virtual_text = false;
        severity_sort = true;
        float = {
          focusable = false;
          style = "minimal";
          border = "rounded";
          source = "always";
          header = "";
          prefix = "";
        };
      };
    };

    # Custom LSP handlers configuration
    extraConfigLua = ''
      -- Setup neodev before LSP config
      require("neodev").setup({})

      -- Set up diagnostic signs
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " "
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Configure LSP handlers
      local float_config = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      }

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_config)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)

      -- Set semantic token priority
      vim.highlight.priorities.semantic_tokens = 95

      -- Make sure lspconfig uses rounded borders
      require('lspconfig.ui.windows').default_options.border = 'rounded'
    '';
  };
}
