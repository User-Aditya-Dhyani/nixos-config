{ ... }:
{

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "User-Aditya-Dhyani";
        email = "218492597+User-Aditya-Dhyani@users.noreply.github.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "hx";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
        user = "git";
      };
    };
  };

}
