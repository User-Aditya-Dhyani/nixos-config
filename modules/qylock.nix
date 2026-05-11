{ pkgs, lib, ... }:
let
  sources = import /etc/nixos/npins;

  qylock = pkgs.stdenv.mkDerivation {
    pname   = "qylock";
    version = "git";
    src     = sources.qylock;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/qylock
      cp -r . $out/share/qylock/
    '';
  };

  qylock-bin = pkgs.writeShellScriptBin "qylock-lock" ''
    export QML_XHR_ALLOW_FILE_READ=1
    export XDG_SESSION_TYPE="wayland"
    export NIXPKGS_QT6_QML_IMPORT_PATH="${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtmultimedia}/lib/qt-6/qml:$NIXPKGS_QT6_QML_IMPORT_PATH"

    CONFIG_FILE="$HOME/.config/qylock/theme"
    if [ -f "$CONFIG_FILE" ]; then
      export QS_THEME=$(cat "$CONFIG_FILE")
    else
      export QS_THEME="clockwork"
    fi
    export QS_THEME_PATH="${qylock}/share/qylock/themes/$QS_THEME"

    killall -9 hyprlock swaylock 2>/dev/null || true
    exec ${pkgs.quickshell}/bin/quickshell -p ${qylock}/share/qylock/quickshell-lockscreen/lock_shell.qml
    exec systemd-inhibit --what=idle --who=qylock --why="lockscreen active" \
      ${pkgs.quickshell}/bin/quickshell \
      -p ${qylock}/share/qylock/quickshell-lockscreen/lock_shell.qml
  '';
in
{
  environment.systemPackages = [ qylock qylock-bin pkgs.qt6.qt5compat pkgs.qt6.qtmultimedia ];

  # set clockwork as default theme
  home-manager.users.minun = { ... }: {
    home.file.".config/qylock/theme".text = "clockwork";
  };
}
