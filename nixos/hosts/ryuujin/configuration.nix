{ config, pkgs, sshKeys, profiles, ... }:
{
  imports = with profiles; [
    types.laptop # type of machine
    gnome # window manager
    work
    polkit
    gdt
    docker
    entertainment
    ./hardware-configuration.nix
  ];

  home-manager.users.crea = {
    imports = with profiles.home; [ core neovim gammastep ];
    home.stateVersion = "23.05";
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  networking.hostId = "1dc334bc"; # For example: head -c 8 /etc/machine-id
  services.zfs.autoScrub.enable = true;

  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_PT.utf8";
      LC_IDENTIFICATION = "pt_PT.utf8";
      LC_MEASUREMENT = "pt_PT.utf8";
      LC_MONETARY = "pt_PT.utf8";
      LC_NAME = "pt_PT.utf8";
      LC_NUMERIC = "pt_PT.utf8";
      LC_PAPER = "ja_JP.utf-8";
      LC_TELEPHONE = "pt_PT.utf8";
      LC_TIME = "ja_JP.utf-8";
    };
  };

  users.users.crea = {
    isNormalUser = true;
    description = "Martim Moniz";
    extraGroups = [ "networkmanager" "video" "scanner" "qemu-libvirtd" "wheel" "input" ];
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = sshKeys;
    hashedPassword = "$6$g3erPleT4pElaQQe$fDIA/dckjSAADHRtjQt3RGrLmFE6TjZ5acdaRSTOBWA/8OuQlnDGr0FZUfGGqxJlS0vJDPDtpPzm6pJo7i96j0";
  };
  users.users.root.hashedPassword = "*";
  users.mutableUsers = false;

  services.printing.enable = true;
  # services.fprintd = {
  #   enable = true;
  # };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true; # seems like a sddm issue

  environment.systemPackages = with pkgs; [
	  qbittorrent
	  yt-dlp
	  python3
	  xsettingsd
	  home-manager
	  (discord.override { nss = pkgs.nss_latest; withOpenASAR = true; }) # unlatest breaks nss_latest fix for firefox, but has openasar
  ];

  system.stateVersion = "22.11"; # Did you read the comment?
}
