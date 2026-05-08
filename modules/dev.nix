{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
        "clippy"
        "rustfmt"
      ];
    })

    pkg-config
    openssl
    gcc
    cmake


    cargo-watch
    cargo-edit
    cargo-expand
    cargo-flamegraph
    cargo-nextest

    
    nasm
    binutils
    #gcc
    gdb
    gdbgui
    radare2
    ghidra
    valgrind
    perf-tools
    hexyl
    xxd
    file
    strace

    autopsy
    sleuthkit
    detect-it-easy
    zsteg
    tcpdump

  ];

  environment.variables = {
    RUST_SRC_PATH = "${pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src"];
    }}/lib/rustlib/src/rust/library";
  };

  #in each project:
  #echo "use nix" > .envrc && direnv allow
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
