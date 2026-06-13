{
  config,
  open_in_mpv,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # dont fry my ssd
  fileSystems."/" = {
    options = [
      "defaults"
      "noatime"
      "async"
      "errors=remount-ro"
      "commit=30"
    ];
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

  boot.kernelParams = [
    "nvme_core.default_ps_max_latency_us=5500"
  ];

  boot.initrd.luks.devices."root".allowDiscards = true;

  boot.initrd.availableKernelModules = [
    "aesni_intel"
    "cryptd"
  ];

  networking.hostName = "julia-nix"; # Define your hostname.

  systemd = {
    # limit charge to 90% if not limited
    services.bat_cap =
      let
        script = pkgs.writeShellScript "bat_cap" ''
          set -euo pipefail

          if [ ! -f /sys/class/power_supply/BAT1/charge_control_end_threshold ]; then
            echo "battery charge_control_end_threshold file does not exist"
            exit 0
          fi

          if [ $(cat /sys/class/power_supply/BAT1/charge_control_end_threshold) -eq 100 ]; then
            echo 90 > /sys/class/power_supply/BAT1/charge_control_end_threshold
          fi
        '';
      in
      {
        script = "${script}";
        name = "bat_cap.service";
        wantedBy = [ "multi-user.target" ];
      };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "julia";
  };
  services.displayManager.defaultSession = "niri";
  services.desktopManager.plasma6.enable = true;

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

  services.power-profiles-daemon.enable = true;

  # lets btop read intel Xe gpu usage
  security.wrappers.btop = {
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon+ep";
    source = "${pkgs.btop}/bin/btop";
  };

  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    package = pkgs.mesa;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  programs.captive-browser = {
    enable = true;
    interface = "wlo1";
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable.override { replace-service-with-usr-bin = false; };
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

  system.stateVersion = "25.05";
}
