{
  description = "Flake for valenix: a vale config with all the styles";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      config = pkgs.writeTextFile {
        name = "vale.ini";
        text = ''
          StylesPath = ${./styles}
          MinAlertLevel = suggestion

          Vocab = Base

          [*]
          BasedOnStyles = alex, Google, Vale, Microsoft, proselint, Readability, Vocab, write-good
                 '';
        executable = false;
      };
      valenix = pkgs.writeScriptBin "valenix" ''
        #!${pkgs.stdenv.shell}
        ${pkgs.vale}/bin/vale --config=${config} $@
      '';
    in {
      packages.${system} = {
        inherit valenix config;
        default = valenix;
      };
      defaultPackage.${system} = valenix;
      defaultApp.${system} = {
        type = "app";
        program = "${valenix}/bin/valenix";
      };
    };
}
