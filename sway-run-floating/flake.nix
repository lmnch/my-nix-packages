{
  description = "Run a command in a floating Alacritty window under Sway";

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
            pname = "sway-run-floating";
            version = "0.1.0";
            dontUnpack = true;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              runHook preInstall

              install -Dm755 ${./sway-run-floating} $out/bin/sway-run-floating
              substituteInPlace $out/bin/sway-run-floating \
                --replace-fail '#!/usr/bin/env bash' '#!${pkgs.bash}/bin/bash'
              wrapProgram $out/bin/sway-run-floating \
                --prefix PATH : ${pkgs.lib.makeBinPath [
                  pkgs.alacritty
                  pkgs.sway
                ]}

              runHook postInstall
            '';

            meta = {
              description = "Run a command in a new floating Alacritty window under Sway";
              license = pkgs.lib.licenses.mit;
              mainProgram = "sway-run-floating";
              platforms = pkgs.lib.platforms.linux;
            };
          };
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/sway-run-floating";
        };
      });
    };
}
