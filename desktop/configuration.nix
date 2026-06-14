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

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    videoAcceleration = true;
    open = false;
    modesetting.enable = true;
    branch = "legacy_580";
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable.override { replace-service-with-usr-bin = false; };
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    sddm.theme = "${pkgs.kdePackages.plasma-desktop}/share/sddm/themes/breeze";
    autoLogin.enable = false;
    defaultSession = "niri";
  };

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
