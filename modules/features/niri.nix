{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard.xkb.layout = "us,ua";

        layout.gaps = 5;

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = _: {};
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
	  "Mod+M".quit = _: {};
	  "Mod+Shift+\".show-hotkey-overlay = _: {};

	  "Mod+A".focus-column-left = _: {};
	  "Mod+D".focus-column-right = _: {};
	  "Mod+Shift+A".move-column-left = _: {};
	  "Mod+Shift+D".move-column-right = _: {};
	  "Mod+W".focus-workspace-up = _: {};
	  "Mod+S".focus-workspace-down = _: {};
	  "Mod+Shift+W".move-column-to-workspace-up = _: {};
	  "Mod+Shift+S".move-column-to-workspace-down = _: {};

	  "Mod+R".switch-preset-column-width = _: {};
	  "Mod+F".maximize-column = _: {};
	  "Mod+BracketLeft".consume-or-expel-window-left = _: {};
	  "Mod+BracketRight".consume-or-expel-window-right = _: {};
	  "Mod+V".toggle-window-floating = _: {};
	  "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: {};
	  "Mod+O".toggle-overview = _: {};

	  "Print".screenshot = _: {};
	  "XF86AudioRaiseVolume".spawn-sh = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
	  "XF86AudioLowerVolume".spawn-sh = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
	  "XF86AudioMute".spawn-sh = "{pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
	  "XF86MonBrightnessUp".spawn-sh = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
	  "XF86MonBrightnessDown".spawn-sh = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

        };
      };
    };
  };
}

