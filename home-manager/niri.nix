{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.niri.settings = {
    input.keyboard.xkb.layout = "br";
    input.keyboard.numlock = true;

    input.touchpad = {
      natural-scroll = true;
      tap = true;
      dwt = true;
    };

    outputs.eDP-1 = {
      scale = 1.25;
    };

    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];

    prefer-no-csd = true;

    window-rules = [
      {
        clip-to-geometry = true;
        geometry-corner-radius = {
          bottom-left = 8.0;
          bottom-right = 8.0;
          top-left = 8.0;
          top-right = 8.0;
        };
        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          color = "#0007";
        };
      }
    ];

    # Soon TM
    # layer-rules = [
    #   {
    #     match.namespace = "noctalia";
    #     background-effect = {
    #       blur = true;
    #       xray = false;
    #     };
    #   }
    # ];

    layout.gaps = 10;
    layout.struts = {
      top = 2;
      right = 4;
      bottom = 4;
      left = 4;
    };

    layout.preset-column-widths = [
      { proportion = 1. / 3.; }
      { proportion = 0.5; }
      { proportion = 2. / 3.; }
    ];
    layout.default-column-width.proportion = 2. / 3.;

    layout.preset-window-heights = [
      { proportion = 1. / 3.; }
      { proportion = 0.5; }
      { proportion = 2. / 3.; }
    ];

    layout.focus-ring = {
      active.color = "#00aaff80";
      inactive.color = "#00aaff20";
      width = 2;
    };

    binds =
      let
        noctalia_ipc =
          arg:
          config.lib.niri.actions.spawn (
            [
              "noctalia-shell"
              "ipc"
              "call"
            ]
            ++ arg
          );
      in
      with config.lib.niri.actions;
      {
        "Mod+T".action = spawn "kitty";
        "Mod+D".action = noctalia_ipc [
          "launcher"
          "toggle"
        ];
        "Super+L".action = noctalia_ipc [
          "lockScreen"
          "lock"
        ];

        "Mod+Shift+E".action = quit;
        "Ctrl+Alt+Delete".action = quit;
        "Mod+Shift+S".action.screenshot = [ ];

        "Super+Tab".action = toggle-overview;

        "Mod+Shift+Q".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;

        "Mod+Left".action = focus-column-or-monitor-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-or-monitor-right;
        # "Mod+H".action = focus-column-or-monitor-left;
        # "Mod+J".action = focus-window-down;
        # "Mod+K".action = focus-window-up;
        # "Mod+L".action = focus-column-or-monitor-right;

        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Down".action = move-window-down;
        "Mod+Shift+Up".action = move-window-up;
        "Mod+Shift+Right".action = move-column-right;
        # "Mod+Shift+H".action = move-column-left;
        # "Mod+Shift+J".action = move-window-down;
        # "Mod+Shift+K".action = move-window-up;
        # "Mod+Shift+L".action = move-column-right;

        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;

        "Mod+Ctrl+Left".action = focus-monitor-left;
        "Mod+Ctrl+Down".action = focus-monitor-down;
        "Mod+Ctrl+Up".action = focus-monitor-up;
        "Mod+Ctrl+Right".action = focus-monitor-right;
        # "Mod+Ctrl+H".action = focus-monitor-left;
        # "Mod+Ctrl+J".action = focus-monitor-down;
        # "Mod+Ctrl+K".action = focus-monitor-up;
        # "Mod+Ctrl+L".action = focus-monitor-right;

        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;

        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;

        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action = focus-workspace-down;
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action = focus-workspace-up;
        };
        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action = move-column-to-workspace-down;
        };
        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action = move-column-to-workspace-up;
        };

        "Mod+WheelScrollRight".action = focus-column-right;
        "Mod+WheelScrollLeft".action = focus-column-left;
        "Mod+Ctrl+WheelScrollRight".action = move-column-right;
        "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

        "Mod+Shift+WheelScrollDown".action = focus-column-right;
        "Mod+Shift+WheelScrollUp".action = focus-column-left;
        "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
        "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Shift+1".action = {
          move-window-to-workspace = 1;
        };
        "Mod+Shift+2".action = {
          move-window-to-workspace = 2;
        };
        "Mod+Shift+3".action = {
          move-window-to-workspace = 3;
        };
        "Mod+Shift+4".action = {
          move-window-to-workspace = 4;
        };
        "Mod+Shift+5".action = {
          move-window-to-workspace = 5;
        };
        "Mod+Shift+6".action = {
          move-window-to-workspace = 6;
        };
        "Mod+Shift+7".action = {
          move-window-to-workspace = 7;
        };
        "Mod+Shift+8".action = {
          move-window-to-workspace = 8;
        };
        "Mod+Shift+9".action = {
          move-window-to-workspace = 9;
        };

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Mod+W".action = switch-preset-column-width;

        "XF86AudioRaiseVolume".action = noctalia_ipc [
          "volume"
          "increase"
        ];
        "XF86AudioLowerVolume".action = noctalia_ipc [
          "volume"
          "decrease"
        ];
        "XF86AudioMute".action = noctalia_ipc [
          "volume"
          "muteOutput"
        ];
        "XF86AudioMicMute".action = noctalia_ipc [
          "volume"
          "muteInput"
        ];
        "XF86AudioPlay".action = noctalia_ipc [
          "media"
          "playPause"
        ];
        "XF86AudioPause".action = noctalia_ipc [
          "media"
          "playPause"
        ];
        "XF86AudioNext".action = noctalia_ipc [
          "media"
          "next"
        ];
        "XF86AudioPrev".action = noctalia_ipc [
          "media"
          "previous"
        ];

        "XF86MonBrightnessDown".action = noctalia_ipc [
          "brightness"
          "decrease"
        ];
        "XF86MonBrightnessUp".action = noctalia_ipc [
          "brightness"
          "increase"
        ];
      };
  };
}
