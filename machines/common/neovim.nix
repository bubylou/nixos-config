{...}: {
  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;

      clipboard.enable = true;
      spellcheck.enable = true;

      assistant = {
        supermaven-nvim.enable = true;
      };

      lsp = {
        enable = true;

        formatOnSave = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        otter-nvim.enable = true;
      };

      debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        markdown.enable = true;
        bash.enable = true;
        clang.enable = true;
        html.enable = true;
        sql.enable = true;
        go.enable = true;
        lua.enable = true;
        python.enable = true;
      };

      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;

        highlight-undo.enable = true;
        indent-blankline.enable = true;
      };

      statusline = {
        lualine = {
          enable = true;
          theme = "catppuccin";
        };
      };

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      autopairs.nvim-autopairs.enable = true;
      snippets.luasnip.enable = true;
      treesitter.context.enable = true;

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      telescope.enable = true;

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # error message
      };

      notify = {
        nvim-notify.enable = true;
      };

      utility = {
        ccc.enable = false;
        vim-wakatime.enable = false;
        diffview-nvim.enable = true;
        yanky-nvim.enable = false;
        oil-nvim.enable = true;
        sleuth.enable = true;

        motion = {
          hop.enable = true;
          leap.enable = true;
        };

        images = {
          image-nvim.enable = false;
        };
      };

      notes = {
        todo-comments.enable = true;
      };

      terminal = {
        toggleterm = {
          enable = true;
          lazygit.enable = true;
        };
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        modes-nvim.enable = false; # the theme looks terrible with catppuccin
        illuminate.enable = true;
        smartcolumn = {
          enable = true;
        };
        fastaction.enable = true;
      };

      comments = {
        comment-nvim.enable = true;
      };
    };
  };
}
