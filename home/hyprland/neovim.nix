{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable       = true;
    defaultEditor = true;
    viAlias      = true;
    vimAlias     = true;

    # binaries available to neovim and its LSPs
    extraPackages = with pkgs; [
      rust-analyzer
      rustfmt
      clippy
      qt6.qtdeclarative   # provides qmlls
      nodePackages.prettier
    ];

    plugins = with pkgs.vimPlugins; [
      # --- LSP ---
      nvim-lspconfig
      rustaceanvim          # better rust-analyzer integration than plain lspconfig

      # --- Completion ---
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # --- Syntax ---
      (nvim-treesitter.withPlugins (p: with p; [
        rust toml lua nix json bash markdown
      ]))

      # --- Navigation ---
      oil-nvim              # file explorer (edit filesystem like a buffer)
      telescope-nvim
      plenary-nvim          # telescope dependency

      # --- UI ---
      which-key-nvim        # shows available keybinds as you type
      tokyonight-nvim       # has proper transparency support
      nvim-web-devicons
    ];

    extraLuaConfig = ''
      -- ─── Options ────────────────────────────────────────────────
      local o = vim.opt
      o.number         = true
      o.relativenumber = true
      o.tabstop        = 4
      o.shiftwidth     = 4
      o.expandtab      = true
      o.wrap           = false
      o.scrolloff      = 8
      o.signcolumn     = "yes"
      o.updatetime     = 50
      o.termguicolors  = true
      o.clipboard      = "unnamedplus"   -- system clipboard always

      -- ─── Transparency (wallpaper bleeds through kitty blur) ──────
      require("tokyonight").setup({
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats   = "transparent",
        },
      })
      vim.cmd("colorscheme tokyonight-night")

      -- make sure nothing paints a background over our transparency
      vim.api.nvim_set_hl(0, "Normal",     { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC",   { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat",{ bg = "NONE" })

      -- ─── Windows-like keybinds ───────────────────────────────────
      local map = vim.keymap.set

      map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>",           { desc = "Save" })
      map({ "n", "i" },      "<C-z>", "<cmd>undo<cr>",             { desc = "Undo" })
      map({ "n", "i" },      "<C-y>", "<cmd>redo<cr>",             { desc = "Redo" })
      map({ "n", "i" },      "<C-a>", "<esc>ggVG",                 { desc = "Select all" })
      map({ "n", "i" },      "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find file" })
      map({ "n", "i" },      "<C-f>", "<cmd>Telescope live_grep<cr>",  { desc = "Find in files" })
      map("n",               "<C-e>", "<cmd>Oil<cr>",              { desc = "File explorer" })
      map("n",               "<C-q>", "<cmd>q<cr>",                { desc = "Quit" })

      -- LSP
      map("n", "gd",         vim.lsp.buf.definition,               { desc = "Go to definition" })
      map("n", "K",          vim.lsp.buf.hover,                    { desc = "Hover docs" })
      map("n", "<leader>ca", vim.lsp.buf.code_action,              { desc = "Code action" })
      map("n", "<leader>rn", vim.lsp.buf.rename,                   { desc = "Rename symbol" })
      map("n", "[d",         vim.diagnostic.goto_prev,             { desc = "Prev diagnostic" })
      map("n", "]d",         vim.diagnostic.goto_next,             { desc = "Next diagnostic" })

      -- ─── Plugins ─────────────────────────────────────────────────
      require("oil").setup()
      require("which-key").setup()
      require("telescope").setup()

      -- Completion
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip"  },
          { name = "buffer"   },
          { name = "path"     },
        }),
      })

      -- LSP capabilities (with completion)
      local caps = require("cmp_nvim_lsp").default_capabilities()

      -- Rust — rustaceanvim picks up rust-analyzer automatically
      vim.g.rustaceanvim = {
        server = { capabilities = caps },
        tools  = {
          hover_actions    = { auto_focus = true },
          inlay_hints      = { auto = true },
        },
      }

      -- QML
      require("lspconfig").qmlls.setup({ capabilities = caps })
    '';
  };
}
