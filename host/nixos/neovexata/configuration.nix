{ config, pkgs, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl88xxau-aircrack
  ];

  environment.systemPackages = with pkgs; [
    vscode
  ];

  programs.firefox.enable = true;

  system.stateVersion = "25.05";
}
