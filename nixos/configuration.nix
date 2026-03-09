{ config, lib, pkgs, ... }:
{ imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.11";
  system.copySystemConfiguration = true;
  nixpkgs.config.allowUnfree = true;

  # boot/driver
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics = { enable = true; enable32Bit = true; };
  hardware.cpu.amd.updateMicrocode = true;
  # network
  networking.hostName = "nixbtw";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # geo
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
  # WM
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      xwayland
    ];
  };
  # DM
  services.displayManager.ly = {
    enable = true;
    settings.save = true;
  };
  services.displayManager.defaultSession = "sway";
  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # users
  users.users.guidxa = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    packages = with pkgs; [
      kitty
      quickshell
      autotiling
      wofi
      swww
      firefox
      obsidian
      ranger
    ] ++ [
      unzip
      wl-clipboard
      kooha
      grim
      slurp
      playerctl
      networkmanagerapplet
    ];
  };
  # pkgs
  programs.firefox = {
    enable = true;
    languagePacks = [ "pt-BR" "en-US" ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";};};
      Preferences = {
        "media.gmp-widevinecdm.enabled" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.uidensity" = 1;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    jq
    killall
    tree
    coreutils
    usbutils
  ];
  # fonts
  fonts.packages = with pkgs; [
    open-sans
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
  ];
}
