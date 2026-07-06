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
      };

      lockscreen.tint = 0.5;

      bar.default = {
        background_opacity = 0.84999998100101948;
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
          "spacer_2"
          "media"
        ];
        thickness = 32;
        widget_spacing = 12;
      };
    };
  };
}
