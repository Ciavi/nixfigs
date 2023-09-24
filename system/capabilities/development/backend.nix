{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs;
  let
    python-packages = ps: with ps; [
      pip
      (
        buildPythonPackage rec {
          pname = "pywalfox";
          version = "2.7.4";
          doCheck = false;
          src = fetchPypi {
            inherit pname version;
            sha256 = "0rpdh1k4b37n0gcclr980vz9pw3ihhyy0d0nh3xp959q4xz3vrsr";
          };
        }
      )
      virtualenv
    ];
  in
  [
    dotnet-sdk_7
    jdk20
    mono
    mono5
    mono4
    (python311.withPackages python-packages)
  ];
}