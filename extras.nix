let
  # Contains the NixOS package collection. ARTIQ depends on some of them, and
  # you may also want certain packages from there.
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = [
      (pkgs.python3.withPackages(ps: [
        # List desired Python packages here
        # from the NixOS package collection:
        ps.pandas
        ps.numba
        ps.bokeh
        ps.spyder
      ]))
      # List desired non-Python packages here
      artiq-full.openocd  # needed for flashing boards, also provides proxy bitstreams
    ];
  }

