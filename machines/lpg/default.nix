{
  config,
  inputs,
  self,
  pkgs,
  ...
}: {
  cm.system.secrets.enable = true;
  ff = {
    common.enable = true;

    services = {
      ananicy.enable = true;
      virt-reality = {
        enable = true;
        bitrate = 150000000;
        autoStart = true;
      };

      consoles = {
        enable = true;
        getty = ["codman@tty1"];
        kmscon = ["tty2"];
      };
      # pipewire.enable = true;
    };

    system = {
      nix.enable = true;
      performance.enable = true;
      systemd-boot.enable = true;
      preservation = {
        enable = true;
        preserveHome = true;
        directories = ["/etc/ssh"];
      };
    };

    userConfig = {
      users = {
        testuser.hashedPasswordFile = config.age.secrets.testpassword.path;
        codman = {
          uid = 1000;
          role = "admin";
          tags = ["base"];
          hashedPassword = "$6$i8pqqPIplhh3zxt1$bUH178Go8y5y6HeWKIlyjMUklE2x/8Vy9d3KiCD1WN61EtHlrpWrGJxphqu7kB6AERg6sphGLonDeJvS/WC730";
          preservation.directories = [".local/share/Terraria"];
          extraGroups = ["libvirtd" "dialout"];
        };
      };
    };
  };

  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    openssh.enable = true;
  };

  home-manager.users.codman = {
    home.stateVersion = "25.05";
    imports = [
      self.homeModules.codmod
      inputs.ff.homeModules.freedpomFlake
    ];

    ff.programs.bash.enable = true;

    cm = {
      hyprland.enable = true;
      programs = {
        firefox.enable = true;
        git.enable = true;
        media.enable = true;
        nvf.enable = true;
        foot.enable = true;
        zsh.enable = true;
        bemenu.enable = true;
      };
    };
  };

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth = {
      theme = "spinner_alt";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = ["spinner_alt"];
        })
      ];
    };
  };

  fonts = {
    fontconfig.defaultFonts.monospace = ["BlexMono Nerd Font Mono"];
    packages = with pkgs; [noto-fonts liberation_ttf nerd-fonts.iosevka-term-slab nerd-fonts.blex-mono];
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [virtiofsd];
  };

  programs.virt-manager.enable = true;

  hardware.bluetooth.enable = true;

  services.tailscale.enable = true;
  systemd.tmpfiles.rules = [
    "d /home/codman 0750 codman users" #should maybe add to preservation
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
  };

  fileSystems."/home/codman/games" = {
    depends = ["/nix/persist/games"];
    device = "/nix/persist/games";
    fsType = "none";
    options = ["bind"];
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      allowUnfree = true;
      permittedInsecurePackages = ["qtwebengine-5.15.19"];
    };
  };
  system.stateVersion = "25.05";

  age = {
    secrets = {
      host_key.rekeyFile = "${inputs.secrets}/lpg/host_key.age";
      testpassword.rekeyFile = "${inputs.secrets}/lpg/testpassword.age";
    };
  };

  imports = [
    ./audio.nix
    ./programs
    ./disko.nix
    ./hardware.nix
    ./printers
  ];
}
