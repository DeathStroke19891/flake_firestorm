{
  flake.nixosModules.pipewire = {pkgs, ...}: {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      extraConfig = {
        # cooler denoising
        pipewire."99-input-denoising" = {
          "context.modules" = [
            {
              "name" = "libpipewire-module-filter-chain";
              "args" = {
                "node.description" = "DeepFilter Noise Cancelling Source";
                "media.name" = "DeepFilter Noise Cancelling Source";
                "filter.graph" = {
                  "nodes" = [
                    {
                      "type" = "ladspa";
                      "name" = "DeepFilter Mono";
                      "plugin" = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                      "label" = "deep_filter_mono";
                      # "control" = {
                      #   "Attenuation Limit (dB)" = cfg.source.attenuation;
                      # };
                    }
                  ];
                };
                "audio.rate" = 48000;
                "capture.props" = {
                  "node.name" = "deep_filter_mono_input";
                  "node.passive" = true;
                };
                "playback.props" = {
                  "node.name" = "deep_filter_mono_output";
                  "media.class" = "Audio/Source";
                };
              };
            }
          ];
        };
      };
    };
  };
}
