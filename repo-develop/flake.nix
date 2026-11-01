{
  description = "Fuzzy repository picker that enters a Nix development shell";

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
            pname = "repo-develop";
            version = "0.1.0";
            dontUnpack = true;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              runHook preInstall

              install -Dm755 ${./repo-develop} $out/bin/repo-develop
              substituteInPlace $out/bin/repo-develop \
                --replace-fail '#!/usr/bin/env bash' '#!${pkgs.bash}/bin/bash'
              wrapProgram $out/bin/repo-develop \
                --prefix PATH : ${pkgs.lib.makeBinPath [
                  pkgs.coreutils
                  pkgs.findutils
                  pkgs.fzf
                  pkgs.git
                  pkgs.nix
                ]}

              runHook postInstall
            '';

            meta = {
              description = "Select a Git repository and run nix develop in the current terminal";
              license = pkgs.lib.licenses.mit;
              mainProgram = "repo-develop";
              platforms = pkgs.lib.platforms.linux;
            };
          };
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/repo-develop";
        };
      });
    };
}
