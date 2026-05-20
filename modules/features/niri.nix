{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, inputs, ... }: {
    imports = [ self.nixosModules.noctalia ];

    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
    
  };

  perSystem = { pkgs, lib, self', inputs', ... }: {

    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
	spawn-at-startup = [
	"${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell"
	];

        input.keyboard = {
          xkb.layout = "us";
        };

        layout.gaps = 5;

        binds = {
	  "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
	  "Mod+Q".close-window = _: {};
	  "Mod+Space".spawn-sh = "${inputs'.noctalia.packages.default}/bin/noctalia-shell ipc call launcher toggle";
	  "Mod+M".quit = _: {};
	};
      };
    };

  };

}
