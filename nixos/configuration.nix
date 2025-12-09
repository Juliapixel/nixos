{
  config,
  open_in_mpv,
  technorino,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    dates = "weekly";
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."root".allowDiscards = true;

  boot.initrd.availableKernelModules = [
    "aesni_intel"
    "cryptd"
  ];

  networking.hostName = "julia-nix"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "br";
  #   variant = "";
  # };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      brlaser
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.resolved = {
    enable = true;
    dnsovertls = "true";
  };

  services.power-profiles-daemon.enable = true;

  services.fstrim.enable = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # lets btop read intel Xe gpu usage
  security.wrappers.btop = {
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon+ep";
    source = "${pkgs.btop}/bin/btop";
  };

  users.users.julia = {
    isNormalUser = true;
    description = "Julia";
    extraGroups = [
      "networkmanager"
      "podman"
      "wheel"
    ];
    packages = with pkgs; [
      discord-canary
      spotify
      technorino.packages.${pkgs.stdenv.hostPlatform.system}.default

    ];
    shell = pkgs.zsh;
  };

  hardware.graphics = {
    enable = true;
    package = pkgs.mesa;
    extraPackages = with pkgs; [
      intel-vaapi-driver
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  programs.vim.enable = true;
  programs.vim.defaultEditor = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.firefox = {
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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    open_in_mpv.packages.${pkgs.stdenv.hostPlatform.system}.default
    mpv
    binutils
    btrfs-progs
    curl
    ffmpeg-full
    gcc
    git
    gnumake
    htop
    kitty
    libqalculate
    pkg-config
    python314
    nixd
    nixfmt
    nil
    podman-compose
    source-code-pro
    tmux
    vim
    vscode
  ];

  system.stateVersion = "25.05";
}
