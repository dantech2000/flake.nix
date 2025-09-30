{
  programs.nixvim = {
    # Global options
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      # Compatibility and behavior
      compatible = false;
      termsync = true;
      hidden = true;
      updatetime = 1000;
      mouse = "";
      inccommand = "split";
      autoread = true;

      # Splits
      splitbelow = true;
      splitright = true;

      # Text display
      wrap = false;
      textwidth = 0;
      smoothscroll = true;

      # Indentation
      expandtab = true;
      smartindent = true;
      shiftwidth = 2;
      softtabstop = 4;
      tabstop = 4;

      # UI elements
      signcolumn = "yes";
      scrolloff = 10;
      sidescrolloff = 10;
      number = true;
      relativenumber = true;
      ruler = true;
      wildmenu = true;
      laststatus = 2;
      cursorline = true;
      colorcolumn = "80";

      # Files and backups
      swapfile = false;
      backup = false;
      undofile = true;
      # undodir needs to be set via Lua to properly expand paths

      # Search
      hlsearch = false;
      ignorecase = true;
      incsearch = true;

      # Completion
      completeopt = ["menu" "menuone" "noselect"];

      # Miscellaneous
      backspace = ["indent" "eol" "start"];
      spell = true;
      spelllang = ["en_us"];
      # spellfile needs to be set via Lua to properly expand ~
      grepprg = "rg --vimgrep --smart-case --follow";
      background = "dark";
      termguicolors = true;
    };

    # File type associations
    filetype = {
      extension = {
        tape = "vhs";
      };
    };

    # Append to shortmess
    extraConfigVim = ''
      set shortmess+=c
    '';

    # Insert mode abbreviations
    extraConfigLua = ''
      -- Set undodir with proper path expansion
      vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"

      -- Ensure undodir exists
      vim.fn.mkdir(vim.fn.stdpath("data") .. "/undodir", "p")

      -- Set spellfile with proper path expansion
      vim.opt.spellfile = vim.fn.expand("~/.spell.add")

      -- Common typos
      vim.cmd([[
      inoreabbrev Goreleaser GoReleaser
      inoreabbrev gorelesaer goreleaser
      inoreabbrev carlos0 caarlos0
      inoreabbrev descriptoin description
      inoreabbrev fucn func
      inoreabbrev sicne since
      inoreabbrev emtpy empty
      inoreabbrev udpate update
      inoreabbrev dont don't
      inoreabbrev lenght length
      inoreabbrev Lenght Length

      " ptbr
      inoreabbrev neh né
      inoreabbrev soh só
      inoreabbrev nao não
      inoreabbrev sao são
      ]])
    '';
  };
}