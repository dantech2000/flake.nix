{
  programs.nixvim = {
    autoGroups = {
      Dockerfile = {
        clear = true;
      };
      AutoInsert = {
        clear = true;
      };
      Mkdir = {
        clear = true;
      };
      Highlight = {
        clear = true;
      };
      HelpWindowRight = {
        clear = true;
      };
    };

    autoCmd = [
      # Set filetype for .dockerfile files
      {
        event = ["BufNewFile" "BufRead"];
        pattern = "*.dockerfile";
        group = "Dockerfile";
        callback = {
          __raw = ''
            function()
              vim.opt_local.ft = "dockerfile"
            end
          '';
        };
      }

      # Start insert mode in git commit messages
      {
        event = "FileType";
        pattern = "gitcommit";
        group = "AutoInsert";
        command = "startinsert";
      }

      # Create parent directories when creating new file
      {
        event = "BufNewFile";
        pattern = "*";
        group = "Mkdir";
        callback = {
          __raw = ''
            function()
              local dir = vim.fn.expand("<afile>:p:h")
              if vim.fn.isdirectory(dir) == 0 then
                vim.fn.mkdir(dir, "p")
                vim.cmd([[ :e % ]])
              end
            end
          '';
        };
      }

      # Highlight on yank
      {
        event = "TextYankPost";
        pattern = "*";
        group = "Highlight";
        callback = {
          __raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        };
      }

      # Resize splits on window resize
      {
        event = "VimResized";
        callback = {
          __raw = ''
            function()
              vim.cmd("tabdo wincmd =")
            end
          '';
        };
      }

      # Open help in vertical split to the right
      {
        event = "BufWinEnter";
        pattern = "*.txt";
        group = "HelpWindowRight";
        callback = {
          __raw = ''
            function()
              if vim.o.filetype == "help" then
                vim.cmd.wincmd("L")
              end
            end
          '';
        };
      }
    ];
  };
}
