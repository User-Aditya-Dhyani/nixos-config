{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };

    environment.systemPackages = [
     self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia
    ];
  };

  perSystem = { pkgs, lib, self', ... }: {

    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
	spawn-at-startup = [
	  (lib.getExe self'.packages.myNoctalia)
	];

        input.keyboard = {
          xkb.layout = "us";
        };

        layout.gaps = 5;

        binds = {
	  "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
	  "Mod+Q".close-window = _: {};
	  "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
	  "Mod+M".quit = _: {};
	};
      };
    };

  };

}
