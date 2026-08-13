{
  config,
  pkgs,
  lib,
  open_in_mpv,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # dont fry my ssds
  fileSystems =
    let
      mkSsdOptions = lib.foldl (
        a: b:
        {
          ${b}.options = [
            "defaults"
            "noatime"
            "async"
            "errors=remount-ro"
            "commit=30"
          ];
        }
        // a
      ) { };
    in
    lib.mkMerge [
      (mkSsdOptions [
        "/"
        "/mnt/wahoo"
        "/mnt/ssdeeznuts"
      ])
      { "/mnt/wahoo".options = [ "nofail" ]; }
      { "/mnt/ssdeeznuts".options = [ "nofail" ]; }
      { "/mnt/backup".options = [ "nofail" ]; }
    ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    videoAcceleration = true;
    open = true;
    modesetting.enable = true;
    nvidiaSettings = false;
    branch = "latest";
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "610.57.04";
      sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
      sha256_aarch64 = "sha256-QCefrMBCmpOwuOyXv1k5Gj0iB2CYlPgnG3JToUw/j54=";
      openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
      settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
      persistencedSha256 = "sha256-aXmD2VY1RLlgAnlHhOUMWzvMyhI6JTClcFLm4imF/mA=";
    };
  };

  # only add cudaSupport for a few packages cuz i dont wanna rebuild all of nixpkgs
  nixpkgs.overlays = [
    (
      final: prev:
      let
        cudaOverlay = lib.foldl (acc: p: acc // { ${p} = prev.${p}.override { cudaSupport = true; }; }) { };
      in
      cudaOverlay [
        "btop"
        "obs-studio"
      ]
    )
  ];

  services.fstrim.enable = true;

  networking.hostName = "julia-desktop"; # Define your hostname.

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable.override { replace-service-with-usr-bin = false; };
  };

  programs.nix-ld.enable = true;

  home-manager.users.julia.programs.niri.settings.outputs = {
    "DP-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 143.981;
      };
      variable-refresh-rate = true;
      position = {
        x = 1920;
        y = 0;
      };
    };
    "HDMI-A-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 60.000;
      };
      position = {
        x = 0;
        y = 160;
      };
    };
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    sddm.theme = "${pkgs.kdePackages.plasma-desktop}/share/sddm/themes/breeze";
    autoLogin.enable = false;
    defaultSession = "niri";
  };

  services.desktopManager.plasma6.enable = true;

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  services.tailscale = {
    useRoutingFeatures = "both";
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    hardwareAcceleration = {
      enable = true;
      type = "nvenc";
      device = "/dev/dri/by-path/pci-0000:0a:00.0-render";
    };
    openFirewall = true;
    transcoding = {
      threadCount = 4;
      throttleTranscoding = true;
      hardwareDecodingCodecs = {
        av1 = false;
        vp8 = true;
        vp9 = true;
        h264 = true;
        hevc = true;
        hevc10bit = true;
      };
      hardwareEncodingCodecs = {
        hevc = true;
        av1 = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    open_in_mpv.packages.${pkgs.stdenv.hostPlatform.system}.default
    mpv
    binutils
    btrfs-progs
    curl
    ffmpeg-full
    gamescope
    gcc
    git
    gnumake
    htop
    just
    kitty
    libqalculate
    pkg-config
    python314
    nixd
    nixfmt
    nil
    podman-compose
    tmux
    vim
    (vscode.override {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    })
    xwayland-satellite
  ];

  system.stateVersion = "26.05";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
