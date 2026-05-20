{ self, inputs, ... }: {

  flake.nixosModules.noctalia = { pkgs, inputs, ... }: {
#    imports = [ inputs.noctalia.nixosModules.default ];
    environment.pathsToLink = [ "/lib/qt-6/qml" ];
    environment.systemPackages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

}
