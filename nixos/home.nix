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

    zsh = {
      enable = true;

      history.path = "/dev/null";
      history.size = 1000;

      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        theme = "sorin";
        plugins = [
          "git"
        ];
      };
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
