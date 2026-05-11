{ pkgs, lib, ... }:
let
  sources = import /etc/nixos/npins;

  # ── awww (wallpaper setter, not in nixpkgs) ─────────────────────
  awww = pkgs.rustPlatform.buildRustPackage {
    pname   = "awww";
    version = "git";
    src     = sources.awww;
    cargoLock.lockFile = "${sources.awww}/Cargo.lock";
    nativeBuildInputs  = with pkgs; [ pkg-config wayland-scanner wayland-scanner.dev ];
    buildInputs        = with pkgs; [ wayland wayland-protocols lz4 ];
    PKG_CONFIG_PATH = "${pkgs.wayland-scanner.dev}/lib/pkgconfig";
  };

  # ── skwd-daemon (already working, reuse same derivation) ────────
  skwd-daemon = pkgs.rustPlatform.buildRustPackage {
    pname   = "skwd-daemon";
    version = "git";
    src     = sources.skwd-daemon;
    cargoLock.lockFile = "${sources.skwd-daemon}/Cargo.lock";
    nativeBuildInputs  = with pkgs; [ pkg-config ];
    buildInputs        = with pkgs; [ sqlite ];
  };

  # ── quickshell with required Qt modules compiled in ─────────────
quickshellWithModules = pkgs.quickshell.overrideAttrs (old: {
  buildInputs = (old.buildInputs or []) ++ (with pkgs.qt6; [
    qtimageformats
    qtmultimedia
    qtsvg
    qt5compat
    qtwayland
  ]) ++ [
    pkgs.kdePackages.kirigami
    pkgs.kdePackages.qqc2-desktop-style
  ];
});

matugen-new = pkgs.rustPlatform.buildRustPackage {
  pname   = "matugen";
  version = "git";
  src     = sources.matugen-src;
  cargoLock.lockFile = "${sources.matugen-src}/Cargo.lock";
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs       = with pkgs; [ ];
};


  # ── runtime dependencies (added to PATH in wrappers) ────────────
  runtimeDeps = (with pkgs; [
    skwd-daemon
    ffmpeg
    imagemagick
    inotify-tools
    sqlite
    curl
    file
    mpvpaper
    jq
    awww
    quickshellWithModules
    kdePackages.kirigami
    kdePackages.qqc2-desktop-style
  ]) ++ [
    matugen-new
  ];

  # ── skwd-wall QML frontend + wrappers ───────────────────────────
  skwd-wall = pkgs.stdenv.mkDerivation {
    pname   = "skwd-wall";
    version = "git";
    src     = sources.skwd-wall;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    # bring custom templates into the build
    postUnpack = ''
      cp ${/etc/nixos/home/hyprland/skwd-templates/waybar-colors.css} \
        $sourceRoot/data/matugen/templates/waybar-colors.css
      cp ${/etc/nixos/home/hyprland/skwd-templates/mako.ini} \
        $sourceRoot/data/matugen/templates/mako.ini
      cp ${/etc/nixos/home/hyprland/skwd-templates/fuzzel.ini} \
        $sourceRoot/data/matugen/templates/fuzzel.ini
      cp ${/etc/nixos/home/hyprland/skwd-templates/hyprland-colors.conf} \
        $sourceRoot/data/matugen/templates/hyprland-colors.conf
    '';

    installPhase = ''
      # Only copy what's needed (not the entire repo)
      mkdir -p $out/share/skwd-wall/data
      cp -a shell.qml qml/ $out/share/skwd-wall/
      cp -a data/matugen/ $out/share/skwd-wall/data/
      cp -a data/scripts/ $out/share/skwd-wall/data/
      install -Dm644 data/config.json.example \
        $out/share/skwd-wall/data/config.json.example
      install -Dm644 data/skwd-wall.desktop \
        $out/share/applications/skwd-wall.desktop

      # skwd-wall launcher
      makeWrapper ${quickshellWithModules}/bin/quickshell $out/bin/skwd-wall \
        --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps} \
        --add-flags "-p $out/share/skwd-wall/shell.qml"

      # skwd CLI (talks to daemon)
      makeWrapper ${skwd-daemon}/bin/skwd $out/bin/skwd \
        --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps} \
        --set SKWD_SHELL_QML "$out/share/skwd-wall/shell.qml" \
        --set SKWD_DATA_DIR  "$out/share/skwd-wall/data"

      # skwd-daemon wrapper with data dir
      makeWrapper ${skwd-daemon}/bin/skwd-daemon $out/bin/skwd-daemon \
        --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps} \
        --set SKWD_SHELL_QML "$out/share/skwd-wall/shell.qml" \
        --set SKWD_DATA_DIR  "$out/share/skwd-wall/data"
    '';
  };

in
{
  environment.systemPackages = [
    skwd-wall
    awww
    matugen-new
    pkgs.mpvpaper
    pkgs.imagemagick
    pkgs.inotify-tools
    pkgs.jq
  ];

  # fonts skwd-wall needs for its UI
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    roboto
    material-design-icons
  ];

  home-manager.users.minun = { ... }: {
    home.file.".config/skwd-wall/data/matugen".source =
      "${skwd-wall}/share/skwd-wall/data/matugen";

    home.file.".config/qt6ct/colors/.keep".text = "";

    home.file.".config/skwd-wall/data/matugen/templates/waybar-colors.css".source = 
      /etc/nixos/home/hyprland/skwd-templates/waybar-colors.css;

home.file.".config/skwd-wall/config.json".text = builtins.toJSON {
  compositor = "hyprland";
  monitor = "";
  general = {
    locale = "";
    closeOnSelection = false;
    reopenAtLastSelection = false;
  };
  paths = {
    wallpaper = "~/Pictures/wallpaper";
    videoWallpaper = "~/Pictures/wallpaper";
    cache = "";
    templates = "";
    scripts = "";
    steam = "";
    steamWorkshop = "";
    steamWeAssets = "";
  };
  features = {
    matugen = true;
    ollama = false;
    steam = false;
    wallhaven = true;
  };
  colorSource = "magick";
  matugen = {
    schemeType = "scheme-content";
    mode = "dark";
  };
  integrations = [
    {
      name = "skwd-wall";
      template = "quickshell-colors.json";
      output = "colors.json";
    }
    {
      name = "kitty";
      template = "kitty.conf";
      output = "~/.config/kitty/skwd-theme.conf";
      reload = "pkill -USR1 kitty";
    }
    {
      name = "qt6ct";
      template = "qt6ct-colors.conf";
      output = "~/.config/qt6ct/colors/matugen.conf";
    }
    {
      name = "waybar";
      template = "waybar-colors.css";
      output = "~/.config/waybar/colors.css";
      reload = "pkill -SIGUSR2 waybar";
    }
    {
      name = "mako";
      template = "mako.ini";
      output = "~/.config/mako/skwd-colors.ini";
      reload = "makoctl reload";
    }
    {
      name = "fuzzel";
      template = "fuzzel.ini";
      output = "~/.config/fuzzel/skwd-colors.ini";
    }
    {
      name = "hyprland";
      template = "hyprland-colors.conf";
      output = "~/.config/hypr/hyprland-colors.conf";
      reload = "hyprctl keyword general:col.active_border \"$(grep 'active_border' ~/.config/hypr/hyprland-colors.conf | grep -o 'rgba([^)]*)')\" ; hyprctl keyword general:col.inactive_border \"$(grep 'inactive_border' ~/.config/hypr/hyprland-colors.conf | grep -o 'rgba([^)]*)')\"";
    }
  ];
  components.wallpaperSelector = {
    displayMode = "slices";
    sliceSpacing = -30;
    hexScrollStep = 1;
    customPresets = {};
  };
  wallpaperMute = true;
  pickOnlyMode = false;
  postProcessing = [];
};

  };
}
