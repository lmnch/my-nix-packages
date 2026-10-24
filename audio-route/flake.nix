{
  description = "Interactive PipeWire audio stream router";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "audio-route";
            version = "0.1.0";
            dontUnpack = true;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              runHook preInstall

              install -Dm755 ${./audio-route} $out/bin/audio-route
              substituteInPlace $out/bin/audio-route \
                --replace-fail '#!/usr/bin/env bash' '#!${pkgs.bash}/bin/bash'
              wrapProgram $out/bin/audio-route \
                --prefix PATH : ${pkgs.lib.makeBinPath [
                  pkgs.coreutils
                  pkgs.fzf
                  pkgs.gawk
                  pkgs.pipewire
                  pkgs.pulseaudio
                ]}

              runHook postInstall
            '';

            meta = {
              description = "Select and reroute PipeWire playback streams with fzf";
              license = pkgs.lib.licenses.mit;
              mainProgram = "audio-route";
              platforms = pkgs.lib.platforms.linux;
            };
          };
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/audio-route";
        };
      });
    };
}
