{ pkgs, lib, config, ... }: {
  home = {
    username = "julia";
    homeDirectory = "/home/julia";
    stateVersion = "25.05";
  };

  programs = {
    git = {
      enable = true;
      signing = {
        format = "ssh";
        signByDefault = true;
        key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      lfs.enable = true;
      extraConfig = {
        user.email = "git@juliapixel.com";
        user.name = "Juliapixel";
        init.defaultBranch = "main";
      };
    };

    kitty = {
      enable = true;
      font.package = pkgs.source-code-pro;
      font.name = "Source Code Pro";
      themeFile = "ayu_mirage";
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$directory"
          "$git_branch"
          "$git_status"
          "$git_state"
          "$character"
        ];

        directory = {
          style = "bold blue";
          truncate_to_repo = false;
          truncation_symbol = "…/";
        };

        fill = {
          symbol = " ";
          style = "";
        };

        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style) ";
          symbol = "";
        };

        git_status = {
          format = "$all_status$ahead_behind";
          diverged = "$ahead_count⇅$behind_count ";
          ahead = "[$count↑](bold green) ";
          behind = "[$count↓](bold green) ";
          modified = "[$count!](bold yellow) ";
          staged = "[$count+](bold yellow) ";
          conflicted = "[$count=](bold red) ";
          renamed = "[$count»](bold yellow) ";
          untracked = "[$count?](bold yellow) ";
        };
      };
    };

    zsh = {
      enable = true;

      history.path = "/dev/null";
      history.size = 1000;

      enableCompletion = true;
      plugins = [
          {
            name = "zsh-syntax-highlighting";
            file = "zsh-syntax-highlighting.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "0.8.0";
              sha256 = "iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
            };
          }
      ];
    };
  };
}
