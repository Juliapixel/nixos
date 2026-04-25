{
  config,
  pkgs,
  ...
}:
{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        barType = "floating";
        capsuleColorKey = "primary";
        capsuleOpacity = 0.1;
        frameThickness = 4;
        marginHorizontal = 14;
        widgets = {
          center = [
            {
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              fontWeight = "bold";
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              iconScale = 0.75;
              id = "Workspace";
              labelMode = "index";
              occupiedColor = "secondary";
              pillSize = 0.6;
              showApplications = true;
              showApplicationsHover = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
          ];
          left = [
            {
              colorizeSystemIcon = "primary";
              colorizeSystemText = "none";
              customIconPath = "";
              enableColorization = true;
              icon = "rocket";
              iconColor = "none";
              id = "Launcher";
              useDistroLogo = true;
            }
            {
              clockColor = "secondary";
              customFont = "";
              formatHorizontal = "HH:mm ddd, MM/dd";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
            }
            {
              compactMode = true;
              diskPath = "/";
              iconColor = "secondary";
              id = "SystemMonitor";
              showCpuCores = false;
              showCpuFreq = false;
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskAvailable = false;
              showDiskUsage = false;
              showDiskUsageAsPercent = false;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = true;
              showNetworkStats = false;
              showSwapUsage = false;
              textColor = "primary";
              useMonospaceFont = true;
              usePadding = false;
            }
            {
              colorizeIcons = false;
              hideMode = "hidden";
              id = "ActiveWindow";
              maxWidth = 145;
              scrollingMode = "hover";
              showIcon = true;
              showText = true;
              textColor = "secondary";
              useFixedWidth = false;
            }
            {
              compactMode = false;
              hideMode = "hidden";
              hideWhenIdle = false;
              id = "MediaMini";
              maxWidth = 145;
              panelShowAlbumArt = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = true;
              showProgressRing = true;
              showVisualizer = false;
              textColor = "none";
              useFixedWidth = false;
              visualizerType = "linear";
            }
          ];
          right = [
            {
              capsLockIcon = "square-letter-c";
              hideWhenOff = false;
              id = "LockKeys";
              numLockIcon = "square-letter-n";
              scrollLockIcon = "square-letter-s";
              showCapsLock = true;
              showNumLock = true;
              showScrollLock = true;
            }
            {
              blacklist = [ ];
              chevronColor = "secondary";
              colorizeIcons = false;
              drawerEnabled = true;
              hidePassive = false;
              id = "Tray";
              pinned = [ ];
            }
            {
              hideWhenZero = false;
              hideWhenZeroUnread = false;
              iconColor = "secondary";
              id = "NotificationHistory";
              showUnreadBadge = true;
              unreadBadgeColor = "primary";
            }
            {
              deviceNativePath = "__default__";
              displayMode = "icon-always";
              hideIfIdle = false;
              hideIfNotDetected = true;
              id = "Battery";
              showNoctaliaPerformance = true;
              showPowerProfiles = true;
            }
            {
              displayMode = "onhover";
              iconColor = "secondary";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
              textColor = "none";
            }
            {
              applyToAllMonitors = false;
              displayMode = "alwaysHide";
              iconColor = "secondary";
              id = "Brightness";
              textColor = "none";
            }
            {
              colorizeDistroLogo = false;
              colorizeSystemIcon = "secondary";
              colorizeSystemText = "none";
              customIconPath = "";
              enableColorization = true;
              icon = "menu";
              id = "ControlCenter";
              useDistroLogo = false;
            }
          ];
        };
      };
      colorSchemes = {
        generationMethod = "rainbow";
        predefinedScheme = "Ayu";
        useWallpaperColors = true;
      };
      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "brightness-card";
          }
          {
            enabled = false;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };
      dock = {
        backgroundOpacity = 0.51;
        floatingRatio = 0.6;
      };
      general = {
        avatarImage = "/home/julia/.face";
        enableLockScreenMediaControls = true;
        radiusRatio = 0.51;
        shadowDirection = "bottom";
        shadowOffsetX = 0;
      };
      location = {
        autoLocate = false;
      };
      nightLight = {
        enabled = true;
      };
      sessionMenu = {
        powerOptions = [
          {
            action = "lock";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "1";
          }
          {
            action = "suspend";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "2";
          }
          {
            action = "hibernate";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "3";
          }
          {
            action = "reboot";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "4";
          }
          {
            action = "logout";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "5";
          }
          {
            action = "shutdown";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "6";
          }
          {
            action = "rebootToUefi";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "7";
          }
          {
            action = "userspaceReboot";
            command = "";
            countdownEnabled = true;
            enabled = false;
            keybind = "";
          }
        ];
      };
      settingsVersion = 59;
      ui = {
        fontDefault = "Noto Sans";
        fontFixed = "monospace";
        panelBackgroundOpacity = 0.75;
        translucentWidgets = true;
      };
      wallpaper = {
        automationEnabled = true;
        randomIntervalSec = 900;
        transitionType = [ "fade" ];
        useOriginalImages = true;
      };
    };
  };
}
