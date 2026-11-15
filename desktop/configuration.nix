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

  boot.kernelPackages = pkgs.linuxPackages_zen;

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
      version = "615.78.08";
      sha256_64bit = "sha256-Pj9t3cLudnoIGFMAr3vjyyhuznZpjS3eNSRZl4LQf/4=";
      sha256_aarch64 = "sha256-UHYBE1AYHoGgMfD9AS/jX+S+N8eCDWUft6qolK9Eejc=";
      openSha256 = "sha256-HBINiOjL0ZJLIAJeNIBYHBnwgUXtNwPPtnFpAI1YwF4=";
      settingsSha256 = "sha256-inDRpG02sdDgHmlqgu/DsgK8OFdOt1fZIYyXdhlGC/c=";
      persistencedSha256 = "sha256-RzeR6Ldct6MUxjnXRyThdh5Y3jjMehTVg85MtwuWNX4=";
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
    package = pkgs.niri-stable;
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
