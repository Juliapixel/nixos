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

  networking.networkmanager.enable = true;

  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "2606:4700:4700::1111#one.one.one.one"
    "1.0.0.1#one.one.one.one"
    "2606:4700:4700::1001#one.one.one.one"
    "8.8.8.8#dns.google"
    "2001:4860:4860::8888#dns.google"
    "8.4.4.8#dns.google"
    "2001:4860:4860::8844#dns.google"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  systemd.oomd.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # stupid crackling!!!
    extraConfig.pipewire = {
      "10-custom" = {
        "context.properties" = {
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve.DNSOverTLS = "opportunistic";
  };

  services.fstrim.enable = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  users.users.julia = {
    isNormalUser = true;
    description = "Julia";
    extraGroups = [
      "networkmanager"
      "podman"
      "wheel"
      "dialout"
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
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
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
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-lgc-plus
  ];
}
