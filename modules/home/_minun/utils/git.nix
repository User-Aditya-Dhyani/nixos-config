{ ... }:
{

  programs.git = {
    enable = true;
    userName = "User-Aditya-Dhyani";
    userEmail = "218492597+User-Aditya-Dhyani@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "hx";
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

}
