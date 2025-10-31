{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ncdu
  ];
  programs = {
    # Multi-protocol downloader.
    aria2 = {
      enable = true;
    };
  };
}
