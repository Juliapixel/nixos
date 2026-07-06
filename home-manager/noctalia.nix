{
  config,
  pkgs,
  ...
}:
{
  programs.noctalia = {
    enable = true;
    settings = {
      dock = {
        active_monitor_only = true;
        auto_hide = true;
        enabled = true;
        icon_size = 36;
        reserve_space = false;
      };

      notification.position = "bottom_right";

      theme = {
        source = "wallpaper";
        wallpaper_scheme = "m3-rainbow";
      };

      shell = {
        transparency_mode = "soft";

        launcher.session_search = true;

        panel = {
          clipboard_placement = "attached";
          open_near_click_clipboard = true;
          open_near_click_control_center = true;
          open_near_click_launcher = true;
          transparency_mode = "soft";
        };
      };

      wallpaper = {
        transition = [ "fade" ];
        automation = {
          enabled = true;
          interval_seconds = 900;
        };
      };

      widget = {
        media = {
          hide_when_no_media = true;
          title_scroll = "on_hover";
        };

        spacer_2.type = "spacer";

        network.show_label = false;

        workspaces.display = "none";

        clock = {
          font_weight = 600;
          format = "{:%x %R}";
          scale = 1.05;
          tooltip_format = "{:%c}";
        };

        cpu.show_label = false;
        ram.show_label = false;
      };

      lockscreen.tint = 0.5;

      bar.default = {
        background_opacity = 0.85;
        center = [ "workspaces" ];
        end = [
          "tray"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "session"
        ];
        margin_ends = 12;
        start = [
          "launcher"
          "clock"
          "group:g1"
          "spacer_2"
          "media"
        ];
        thickness = 32;
        widget_spacing = 12;

        capsule_group = [{
          enabled = true;
          id = "g1";
          members = ["cpu" "ram"];
          opacity = 0.5;
          padding = 6.0;
        }];
      };
    };
  };
}
