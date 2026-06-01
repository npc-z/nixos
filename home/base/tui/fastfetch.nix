{...}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      "modules" = [
        {
          "type" = "host";
          "key" = "├   PC        ";
        }
        {
          "type" = "board";
          "key" = "├ 󱔼  Board     ";
        }
        {
          "type" = "cpu";
          "key" = "├   CPU       ";
        }
        {
          "type" = "gpu";
          "key" = "├ 󰾲  GPU       ";
        }
        {
          "type" = "display";
          "key" = "├ 󰍹  Display   ";
        }
        {
          "type" = "sound";
          # "format"= "{platform-api}/{2} ({3})";
          "key" = "├   Sound     ";
        }
        {
          "type" = "battery";
          "key" = "├ 󰢟  Battery   ";
          "format" = "{manufacturer} {model-name} ({capacity})";
        }
        {
          "type" = "memory";
          "key" = "├   Memory    ";
          "percent" = {
            "type" = 3; # 3 = show number + bar + percentage
            "green" = 30; # <30% is green
            "yellow" = 70; # 30-70% is yellow; >70% is red
          };
        }
        {
          "type" = "swap";
          "key" = "├ 󰯍  Swap      ";
          "percent" = {
            "type" = 3; # 3 = show number + bar + percentage
            "green" = 30; # <30% is green
            "yellow" = 70; # 30-70% is yellow; >70% is red
          };
        }

        {
          "type" = "disk";
          "key" = "├   NixOS     ";
          "folders" = ["/"];
          "percent" = {
            "type" = 3; # 3 = show number + bar + percentage
            "green" = 30; # <30% is green
            "yellow" = 70; # 30-70% is yellow; >70% is red
          };
        }
        {
          "type" = "disk";
          "key" = "└   Home      ";
          "folders" = ["/home"];
          "percent" = {
            "type" = 3; # 3 = show number + bar + percentage
            "green" = 30; # <30% is green
            "yellow" = 70; # 30-70% is yellow; >70% is red
          };
        }
        {
          "type" = "os";
          "key" = "├   Distro    ";
          "format" = "{name} {build-id} ({codename}) {arch}";
        }
        {
          "type" = "kernel";
          "key" = "├   Kernel    ";
        }
        {
          "type" = "bios";
          "key" = "├ 󰚗  BIOS      ";
        }
        {
          "type" = "packages";
          "key" = "├ 󰏖  Packages  ";
        }
        {
          "type" = "Processes";
          "key" = "├ 󰑮  Processes ";
        }
        {
          "type" = "shell";
          "key" = "├   Shell     ";
        }
        {
          "type" = "terminal";
          "key" = "├   Terminal  ";
        }
        {
          "type" = "terminalfont";
          "key" = "├ 󰛖  Term Font ";
        }
        {
          "type" = "de";
          "key" = "├   DE        ";
        }
        {
          "type" = "lm";
          "key" = "├ 󰧨  Login     ";
        }
        {
          "type" = "wm";
          "key" = "├   Window    ";
        }
        {
          "type" = "wmtheme";
          "key" = "├ 󰉼  Theme     ";
        }
        {
          "type" = "font";
          "key" = "├ 󰛖  Font      ";
        }
        {
          "type" = "opengl";
          "key" = "├ 󰆧  OpenGL    ";
        }
        {
          "type" = "vulkan";
          "key" = "└ 󰈸  Vulkan    ";
        }
        {
          "type" = "bluetooth";
          "key" = "├ 󰂱  Bluetooth ";
          "format" = "{1} - {4}";
        }
        {
          "type" = "bluetoothradio";
          "key" = "├ 󰂯  BT Radio  ";
          "format" = "{5}";
        }
        {
          "type" = "wifi";
          "key" = "├   WiFi      ";
          "format" = "{4} - {7} - {13} GHz - {10}";
          "showErrors" = "never";
        }
        {
          "type" = "dns";
          "key" = "├ 󱦂  DNS       ";
        }
        {
          "type" = "localip";
          "key" = "├ 󰩟  Local IP  ";
          "format" = "{1} - {3}";
          "showMac" = true;
        }
        {
          "type" = "publicip";
          "key" = "└ 󰩠  Public IP ";
          "format" = "{1} - {2}";
        }
        {
          "type" = "DateTime";
          "key" = "├ 󰥔  Date/Time ";
        }
        {
          "key" = "├   OS Age    ";
          "type" = "disk";
          "folders" = "/";
          "format" = "{create-time:10} ({days} days)";
        }
        {
          "type" = "uptime";
          "key" = "└   Uptime    ";
        }
      ];
    };
  };
}
