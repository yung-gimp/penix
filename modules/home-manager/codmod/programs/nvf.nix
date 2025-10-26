{
  config,
  lib,
  ...
}: let
  cfg = config.cm.programs.nvf;
in {
  options.cm.programs.nvf.enable = lib.mkEnableOption "Enable NVF";

  config.programs.nvf = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      vim = {
        vimAlias = true;
        enableLuaLoader = true;

        options = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
        };

        autocomplete.blink-cmp = {
          enable = true;
          setupOpts.fuzzy.implementation = "prefer_rust_with_warning";
          friendly-snippets.enable = true;
        };

        languages = {
          enableTreesitter = true;
          bash = {
            enable = true;
            lsp.enable = true;
          };
          css = {
            enable = true;
            lsp.enable = true;
          };
          nix = {
            enable = true;
            lsp.enable = true;
            lsp.server = "nixd";
          };
          rust = {
            enable = true;
            lsp.enable = true;
          };
          markdown = {
            enable = true;
            extensions.markview-nvim.enable = true;
          };
        };

        clipboard.providers.wl-copy.enable = true;

        dashboard.dashboard-nvim.enable = true;

        filetree.neo-tree.enable = true;
      };
    };
  };
}
