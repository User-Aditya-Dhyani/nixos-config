{ self, inputs, ... }: {

  flake.nixosConfigurations.myMachine = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.myMachineConfiguration
    ];
  };

}
