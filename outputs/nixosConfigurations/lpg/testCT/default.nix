{pkgs, ...}: {
  imports = [./klipper.nix];
  containers.printor = {
    autoStart = false;
    config = {
      users = {
        users.printman = {
          isNormalUser = true;
          createHome = true;
        };
      };

      environment.systemPackages = with pkgs; [
        novnc
        python3Packages.websockify
        tigervnc
        orca-slicer
        xterm
      ];

      systemd.tmpfiles.rules = [
        "d /home/printman/.config 0750 printman users"
      ];

      services = {
        nginx = {
          enable = true;

          virtualHosts.localhost = {
            locations = {
              "/" = {
                return = "200 '<html><body>It works</body></html>'";
                extraConfig = ''
                  default_type text/html;
                '';
              };

              "/slice/websockify" = {
                proxyPass = "http://127.0.0.1:6080";
                extraConfig = ''
                  proxy_http_version 1.1;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection "upgrade";
                  proxy_read_timeout 61s;
                  proxy_buffering off;
                '';
              };

              "/slice" = {
                return = "301 /slice/";
              };

              "/slice/" = {
                extraConfig = ''
                  alias ${pkgs.novnc}/share/webapps/novnc/;
                  index vnc.html;
                  try_files $uri $uri/ /vnc.html;
                '';
              };
            };
          };
        };
      };

      systemd.services = {
        websockify = {
          description = "Websockify VNC Bridge";
          after = ["orcaslicer-vnc.service"];
          requires = ["orcaslicer-vnc.service"];
          wantedBy = ["multi-user.target"];

          serviceConfig = {
            Type = "simple";
            DynamicUser = true;
            Restart = "on-failure";
            RestartSec = 5;

            ExecStart = ''
              ${pkgs.python3Packages.websockify}/bin/websockify \
                --heartbeat=30 \
                127.0.0.1:6080 localhost:5901
            '';
          };
        };
        orcaslicer-vnc = {
          description = "OrcaSlicer VNC Service";
          after = ["network.target"];
          wantedBy = ["multi-user.target"];

          serviceConfig = {
            User = "printman";
            Group = "users";
            Type = "simple";
            Environment = ["DISPLAY=:1"];
            Restart = "on-failure";
            RestartSec = 5;

            ExecStart = ''
              ${pkgs.tigervnc}/bin/Xvnc :1 \
                -geometry 1920x1080 \
                -depth 16 \
                -SecurityTypes None \
                -AlwaysShared \
                -AcceptKeyEvents \
                -AcceptPointerEvents \
                -AcceptCutText \
                -SendCutText \
                -fp ${pkgs.xorg.fontmiscmisc}/lib/X11/fonts/misc/
            '';
          };
        };

        orcaslicer-app = {
          description = "OrcaSlicer Application";
          after = ["orcaslicer-vnc.service"];
          requires = ["orcaslicer-vnc.service"];
          wantedBy = ["multi-user.target"];

          serviceConfig = {
            User = "printman";
            Group = "users";
            Type = "simple";
            Environment = ["DISPLAY=:1"];
            Restart = "on-failure";

            ExecStart = "${pkgs.orca-slicer}/bin/orca-slicer";
          };
        };
      };
    };
  };
}
