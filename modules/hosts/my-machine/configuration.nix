{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { config, pkgs, lib, ... }: {

    imports =
      [
        self.nixosModules.myMachineHardware
	self.nixosModules.niri
      ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
    boot.kernelModules = [ "acpi_call" ];

    networking.hostName = "nixos";
    # networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;

    time.timeZone = "Asia/Kolkata";

    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };

    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";

      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";

      extraPackages = with pkgs; [
	kdePackages.qtmultimedia
	kdePackages.qtsvg
	kdePackages.qtvirtualkeyboard

	sddm-astronaut
	bibata-cursors
      ];

      settings = {
        Theme = {
	  Current = "sddm-astronaut-theme";
          CursorTheme = "Bibata-Modern-Ice";
	  CursorSize = 16;
        };
      };
    };

#    services.desktopManager.plasma6.enable = true;
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    services.printing.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    nixpkgs.config.allowUnfree=true;

    users.users.minun = {
      isNormalUser = true;
      description = "Aditya";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
#        kdePackages.kate
      ];
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      wget
      curl
      tree
      git
      libreoffice-fresh
      bibata-cursors
      kdePackages.qtmultimedia
      sddm-astronaut

      fzf
      ripgrep
      bat
      eza
      fd
      jq
      btop
      htop
      powertop
      s-tui
      parted
      p7zip
      kdePackages.kate
      helix

      nvd
      nvtopPackages.full
      lm_sensors
      pciutils
      usbutils
      fwupd
      psmisc
    ];

    environment.sessionVariables = {
      TERMINAL = "kitty";
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hybrid-sleep.enable = false;


    system.stateVersion = "25.11";
  };

}
