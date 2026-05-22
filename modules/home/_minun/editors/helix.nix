{ pkgs, ... }: {

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      
      editor = {
	line-number = "relative";
	cursorline = true;
	color-modes = true;
	cursor-shape = {
	  normal = "block";
	  insert = "bar";
	  select = "underline";
	};
	indent-guides.render = true;
	statusline = {
	  left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
	  right = [ "diagnostics" "selections" "position" "file-encoding" "file-type" ];
	};

	lsp = {
	  display-messages = true;
	  display-inlay-hints = true;
	};
      };

      keys.normal = {
	space.q = ":q";
	space.w = ":w";
      };
    };

    languages = {
      language-server.rust-analyzer.config.check.command = "clippy";
    };
  };  

}

