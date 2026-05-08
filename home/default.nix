{ pkgs, config, ... }:
{
  imports = [
    <plasma-manager/modules>
    ./hyprland
   ];

#  fonts = {
#    general = { family = "Noto Sans"; pointSize = 12; };
#    monospace = { family = "JetBrains Mono"; pointSize = 12; };
#    small = { family = "Noto Sans"; pointSize = 9; };
#  };

  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrains Mono";
      size = 10;
    };

    theme = "Tokyo Night";

    settings = {
      window_padding_width = 12;
      cursor-shape = "beam";
      enable_audio-bell = false;
    };
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  programs.git = {
    enable = true;
    userName = "User-Aditya-Dhyani";
    userEmail = "218492597+User-Aditya-Dhyani@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "kate";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "clean";
      plugins = [ "git" "cargo" "rust" "direnv" ];
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        user = "git";
      };
    };
  };

  home.packages = with pkgs; [
    
  ];

  stylix = {
    targets.hyprland.enable = false;
    targets.kitty.enable    = false;
    targets.waybar.enable   = false;
    targets.mako.enable     = false;
    targets.fuzzel.enable   = false;
  };

  home.stateVersion = "25.05";  
}
