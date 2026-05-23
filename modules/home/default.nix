{ inputs, ... }:
{

  flake.nixosModules.home =
    { ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users.minun = import ./_minun/default.nix;
      };
    };

}
