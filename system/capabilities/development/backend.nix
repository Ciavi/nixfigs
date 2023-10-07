{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs;
  let
    python-packages = ps: with ps; [
      pip
      (
        buildPythonPackage rec {
          pname = "pywal";
          version = "3.3.0";
          doCheck = false;
          src = fetchgit {
            url = "https://github.com/dylanaraps/pywal";
            hash = "sha256-La6ErjbGcUbk0D2G1eriu02xei3Ki9bjNme44g4jAF0=";
          };
        }
      )
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
    gcc13
    ghdl
    gnumake
    gtkwave
    jdk17
    mono
    mono4
    mono5
    nvc
    (python311.withPackages python-packages)
    vhdl-ls
  ];
}