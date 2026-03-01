{ config, lib, pkgs, ... }:
{ imports =[ ./hardware-configuration.nix ];

  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics = { enable = true; enable32Bit = true; };

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };

  networking.hostName = "nixbtw";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console = { font = "Lat2-Terminus16"; useXkbConfig = true; };

  users.users.guidxa = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio"];
    packages = with pkgs; [ tree eww nitrogen obsidian ];
  };

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    pkgs.picom
    kitty
    neovim
    git
    bash
    jq
    coreutils
    socat
    usbutils
    gnome-themes-extra
    arc-theme
    glib
    gtk3
    pkg-config
    rustup
  ];

  qt.enable = true;
  qt.platformTheme = "gtk2";
  qt.style = "adwaita-dark";
}
