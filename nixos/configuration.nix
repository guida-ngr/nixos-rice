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
    packages = with pkgs;
    [ # personal
    autotiling
    eww
    nitrogen 
    obsidian
    ] ++ [ # eww dependencies
    rustup
    gtk3
    gtk-layer-shell
    pango
    gdk-pixbuf
    libdbusmenu-gtk3
    cairo
    glib
    glibc
    gcc
  ];};

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; 
  [ # essencials
    tree
    pkgs.picom
    kitty
    neovim
    git
    coreutils
    usbutils
    unzip
    bash
    jq
    pkg-config
  ]
fonts.packages = with pkgs;
  [
  open-sans
  nerd-fonts.caskaydia-cove
  ];
}
