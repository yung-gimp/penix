{ lib, ... }:
{
  containers.klipper = {
    autoStart = false;
    bindMounts."/dev/serial/by-id/usb-klipper-mcu" = {
      hostPath ="/dev/serial/by-id/usb-Klipper_stm32g0b1xx_1D002B001150415833323520-if00";
    };
    config = {
      users = {
        users.klipper = {
          isSystemUser = true;
          group = "klipper";
          extraGroups = ["dialout"];
        };
        groups.klipper = {};
      };

      systemd = {
        services.klipper.serviceConfig = {
          UMask = lib.mkForce "0000";
        };
      };

      services = {
        udev.extraRules = ''
          SUBSYSTEM=="tty", ATTRS{manufacturer}=="Klipper", MODE="0660", GROUP="dialout"
        '';

        klipper = {
          enable = true;
          configFile = ./printer.cfg;
        };

        moonraker = {
          port = 7125;
          enable = true;
          settings.authorization = {
          enable_api_key = false;
          force_logins = false;
          trusted_clients = ["0.0.0.0/0"];
          cors_domains = ["*"];
          };
        };

        mainsail = {
          enable = true;
        };
      };
    };
  };
}
