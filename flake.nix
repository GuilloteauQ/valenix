{
  description = "Flake for valenix: a vale config with all the styles";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      styles = builtins.attrNames (builtins.readDir ./styles);
      all_styles =
        "alex, Google, Vale, Microsoft, proselint, Readability, Vocab, write-good";
      config = style:
        pkgs.writeTextFile {
          name = "vale.ini";
          text = ''
            StylesPath = ${./styles}
            MinAlertLevel = suggestion

            Vocab = Base

            [*]
            BasedOnStyles = ${style}
                   '';
          executable = false;
        };
      valenix_style = style: style_name:
        let config_style = config style;
        in pkgs.writeScriptBin "valenix_${style_name}" ''
          #!${pkgs.stdenv.shell}
          ${pkgs.vale}/bin/vale --config=${config_style} $@
        '';
      valenix = valenix_style all_styles "all";
      valenix_versions = builtins.listToAttrs (builtins.map (style: {
        name = "valenix_${style}";
        value = valenix_style style style;
      }) styles);
    in {
      packages.${system} = valenix_versions // { inherit valenix; };
      defaultPackage.${system} = valenix;
    };
}
