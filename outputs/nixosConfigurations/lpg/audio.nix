{
  services.pipewire.wireplumber.extraConfig = {
    "clarettPro" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {"device.name" = "alsa_card.usb-Focusrite_Clarett__4Pre_00009991-00";}
          ];
          actions = {
            update-props = {
              "device.profile" = "pro-audio";
            };
          };
        }
        {
          matches = [
            {"node.name" = "alsa_input.usb-Focusrite_Clarett__4Pre_00009991-00.pro-input-0";}
          ];
          actions = {
            update-props = {
              "priority.session" = "1500";
            };
          };
        }
      ];
      "wireplumber.components" = [
        {
          name = "libpipewire-module-loopback";
          type = "pw-module";
          arguments = {
            "node.description" = "headphones";
            "capture.props" = {
              "node.name" = "hedfone";
              "media.class" = "Audio/Sink";
              "audio.position" = "[ FL FR ]";
              "priority.session" = "2000";
            };
            "playback.props" = {
              "node.name" = "playback.hedfone";
              "audio.position" = "[ AUX0 AUX1 ]";
              "target.object" = "alsa_output.usb-Focusrite_Clarett__4Pre_00009991-00.pro-output-0";
              "stream.dont-remix" = "true";
              "node.passive" = "true";
            };
          };
          provides = "hedfone-sink";
          #requires = [ "node.alsa_output.usb-Focusrite_Clarett__4Pre_00009991-00.pro-output-0" ];
        }
        {
          name = "libpipewire-module-loopback";
          type = "pw-module";
          arguments = {
            "node.description" = "microphone";
            "capture.props" = {
              "node.name" = "capture.microphone";
              "audio.position" = "[ AUX2 ]";
              "target.object" = "alsa_input.usb-Focusrite_Clarett__4Pre_00009991-00.pro-input-0";
              "node.passive" = "true";
              "stream.dont-remix" = "true";
            };
            "playback.props" = {
              "node.name" = "microphone";
              "audio.position" = "[ MONO ]";
              "media.class" = "Audio/Source";
              "priority.session" = "2500";
            };
          };
          provides = "microphone-source";
          # requires = [ "device.alsa_card.usb-Focusrite_Clarett__4Pre_00009991-00" ];
        }
      ];
      "wireplumber.profiles" = {
        main = {
          "hedfone-sink" = "required";
          "microphone-source" = "required";
        };
      };
    };
  };
}
