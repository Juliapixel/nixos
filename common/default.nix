{
  config,
  pkgs,
  make_it_braille,
  technorino,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    dates = "weekly";
    automatic = true;
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  systemd.oomd.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  users.users.julia = {
    isNormalUser = true;
    description = "Julia";
    extraGroups = [
      "networkmanager"
      "podman"
      "wheel"
    ];
    packages = with pkgs; [
      vesktop
      make_it_braille.packages.${pkgs.stdenv.hostPlatform.system}.default
      prismlauncher
      qbittorrent
      spotify
      technorino.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    shell = pkgs.zsh;
  };

  programs = {
    firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        Extensions = {
          Install = [
            "https://github.com/Juliapixel/open_in_mpv/releases/download/v1.0.3/c70ef7cd6f344053b5b0-1.0.3.xpi"
          ];
        };
        GenerativeAI.Chatbot = false;
      };
    };

    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
    };
  };

  fonts.packages = with pkgs; [
    source-code-pro
    monaspace
  ];
}
