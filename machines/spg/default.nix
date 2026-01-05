{
  config,
  inputs,
  self,
  pkgs,
  ...
}:
{
  ff = {
    common.enable = true;

    windowManagers.hyprland.enable = true;
    services = {
      ananicy.enable = true;
      consoles = {
        enable = true;
        getty = [
          "codman@tty1"
          "tty3"
        ];
        kmscon = [ "tty2" ];
      };
      # pipewire.enable = true;
    };

    system = {
      nix.enable = true;
      performance.enable = true;
      boot.enable = true;
      preservation = {
        enable = true;
        preserveHome = true;
      };
    };

    userConfig = {
      users = {
        codman = {
          role = "admin";
          tags = [ "base" ];
          preservation.directories = [ ".local/share/PrismLauncher" ];
          userOptions = {
            uid = 1000;
            hashedPasswordFile = config.age.secrets.password.path;
            extraGroups = [
              "libvirtd"
              "dialout"
            ];
          };
        };
      };
    };
  };

  cm.programs = {
    steam.enable = true;
    # hyprland.enable = true;
  };

  networking.networkmanager.enable = true;

  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };

  home-manager.users.codman = {
    home.stateVersion = "25.05";
    imports = [
      self.homeModules.codmod
      inputs.ff.homeModules.ff
      inputs.ff.homeModules.windowManagers
    ];

    ff = {
      windowManagers.hyprland.enable = true;
      programs.bash.enable = true;
    };

    cm = {
      hyprland.enable = true;
      programs = {
        firefox.enable = true;
        git.enable = true;
        nvf.enable = true;
        foot.enable = true;
        zsh.enable = true;
        bemenu.enable = true;
      };
    };
  };

  security.allowUserNamespaces = true;
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth = {
      theme = "spinner_alt";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ "spinner_alt" ];
        })
      ];
    };
  };

  programs = {
    uwsm.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    niri.enable = true;
  };

  fonts = {
    fontconfig.defaultFonts.monospace = [ "BlexMono Nerd Font Mono" ];
    packages = with pkgs; [
      noto-fonts
      liberation_ttf
      nerd-fonts.blex-mono
    ];
  };

  hardware.bluetooth.enable = true;

  services = {
    tailscale.enable = true;
    flatpak.enable = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
  };

  fileSystems."/home/codman/games" = {
    depends = [ "/nix/persist/games" ];
    device = "/nix/persist/games";
    fsType = "none";
    options = [ "bind" ];
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    overlays = [ inputs.niri.overlays.niri ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "qtwebengine-5.15.19" ];
    };
  };
  system.stateVersion = "25.05";

  imports = [
    inputs.ff.nixosModules.windowManagers
    inputs.secrets.nixosModules.spg
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    inputs.niri.nixosModules.niri
    ./disko.nix
    ./hardware.nix
    ./steam.nix
  ];
}
