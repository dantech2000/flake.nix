{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      # Luasnip for snippets
      luasnip = {
        enable = true;
        settings = {
          region_check_events = "InsertEnter";
          delete_check_events = "InsertLeave";
        };
        fromVscode = [
          {
            lazyLoad = true;
            paths = "${pkgs.vimPlugins.friendly-snippets}";
          }
        ];
      };

      # Copilot
      copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = false;
          };
          panel = {
            enabled = false;
          };
        };
      };

      copilot-cmp.enable = true;

      # nvim-cmp for completion
      cmp = {
        enable = true;
        settings = {
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';

          window = {
            documentation = {
              border = ["╭" "─" "╮" "│" "╯" "─" "╰" "│"];
            };
            completion = {
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";
              col_offset = -3;
              side_padding = 0;
            };
          };

          view = {
            entries = {
              name = "custom";
              selection_order = "top_down";
            };
          };

          completion = {
            keyword_length = 3;
          };

          mapping = {
            "<C-u>" = "cmp.mapping.scroll_docs(-4)";
            "<C-d>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-y>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
            "<Up>" = "cmp.mapping.select_prev_item()";
            "<Down>" = "cmp.mapping.select_next_item()";
            "<C-p>" = ''
              cmp.mapping(function()
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  cmp.complete()
                end
              end)
            '';
            "<C-n>" = ''
              cmp.mapping(function()
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  cmp.complete()
                end
              end)
            '';
            "<C-k>" = ''
              cmp.mapping(function()
                local luasnip = require('luasnip')
                if luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                end
              end, { "i", "s" })
            '';
            "<C-j>" = ''
              cmp.mapping(function()
                local luasnip = require('luasnip')
                if luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                end
              end, { "i", "s" })
            '';
          };

          formatting = {
            fields = ["kind" "abbr" "menu"];
            format = ''
              function(_, item)
                local icons = {
                  Text = "",
                  Method = "󰆧",
                  Function = "󰊕",
                  Constructor = "",
                  Field = "󰇽",
                  Variable = "󰂐",
                  Class = "󰠱",
                  Interface = "",
                  Module = "",
                  Property = "󰜢",
                  Unit = "",
                  Value = "󰎠",
                  Enum = "",
                  Keyword = "󰌋",
                  Snippet = "",
                  Color = "󰏘",
                  File = "󰈙",
                  Reference = "",
                  Folder = "󰉋",
                  EnumMember = "",
                  Constant = "󰏿",
                  Struct = "",
                  Event = "",
                  Operator = "󰆕",
                  TypeParameter = "󰅲",
                }
                if icons[item.kind] then
                  item.kind = icons[item.kind] .. " " .. item.kind
                end
                local strings = vim.split(item.kind, "%s", { trimempty = true })
                item.kind = " " .. strings[1] .. " "
                if #strings > 1 then
                  item.menu = "    (" .. strings[2] .. ")"
                end
                return item
              end
            '';
          };

          sources = [
            {name = "nvim_lsp_signature_help";}
            {name = "nvim_lsp";}
            {
              name = "luasnip";
              keyword_length = 2;
              priority = 50;
            }
            {name = "copilot";}
            {
              name = "buffer";
              keyword_length = 5;
            }
            {name = "path";}
            {name = "emoji";}
            {name = "calc";}
          ];

          experimental = {
            native_menu = false;
            ghost_text = false;
          };
        };

        # Filetype-specific sources
        filetype = {
          sql = {
            sources = [
              {name = "vim-dadbod-completion";}
              {name = "buffer";}
            ];
          };
        };

        # Command-line completion
        cmdline = {
          ":" = {
            mapping = {
              __raw = "cmp.mapping.preset.cmdline()";
            };
            sources = [
              {
                name = "cmdline";
                option = {
                  ignore_cmds = ["Man" "!"];
                };
              }
              {name = "path";}
            ];
          };
          "/" = {
            mapping = {
              __raw = "cmp.mapping.preset.cmdline()";
            };
            sources = [
              {name = "buffer";}
            ];
          };
          "?" = {
            mapping = {
              __raw = "cmp.mapping.preset.cmdline()";
            };
            sources = [
              {name = "buffer";}
            ];
          };
        };
      };

      # Completion sources
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-cmdline.enable = true;
      cmp_luasnip.enable = true;
      cmp-emoji.enable = true;
      cmp-calc.enable = true;
    };

    # Integrate autopairs with cmp
    extraConfigLua = ''
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    '';
  };
}
