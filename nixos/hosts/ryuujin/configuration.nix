# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, config, pkgs, sshKeys, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/sway.nix
      ../../modules/syncthing.nix
      ../../modules/tailscale.nix
      ../../modules/docker.nix
      ../../modules/wireguard.nix
      ../../modules/rnl.nix
      # ../../modules/polkit.nix
    ];

  # Bootloader.
  boot = {
    kernelParams = [ "quiet" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 6;
    };
    plymouth.enable = true;
  };
  services.fstrim.enable = true;

  networking = {
    hostName = "ryuujin"; # Define your hostname.
    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
      };
    };
    firewall.checkReversePath = "loose";
    # hostId = "3fe951fb"; # For example: head -c 8 /etc/machine-id
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  time.timeZone = "Europe/Lisbon";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_PT.utf8";
      LC_IDENTIFICATION = "pt_PT.utf8";
      LC_MEASUREMENT = "pt_PT.utf8";
      LC_MONETARY = "pt_PT.utf8";
      LC_NAME = "pt_PT.utf8";
      LC_NUMERIC = "pt_PT.utf8";
      LC_PAPER = "pt_PT.utf8";
      LC_TELEPHONE = "pt_PT.utf8";
      LC_TIME = "pt_PT.utf8";
    };
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-configtool
      ];
    };
  };

  services.printing.enable = true;

  services.xserver.enable = true;

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
    autoSuspend = true;
  };
  services.fprintd = {
    enable = true;
  };

  services.xserver.libinput.enable = true;

  console.keyMap = "pt-latin1";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.crea = {
    isNormalUser = true;
    description = "Martim Moniz";
    extraGroups = [ "networkmanager" "video" "scanner" "qemu-libvirtd" "wheel" "input" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = sshKeys;
    hashedPassword = "$6$g3erPleT4pElaQQe$fDIA/dckjSAADHRtjQt3RGrLmFE6TjZ5acdaRSTOBWA/8OuQlnDGr0FZUfGGqxJlS0vJDPDtpPzm6pJo7i96j0";
  };
  users.users.root.hashedPassword = "*";
  users.mutableUsers = false;

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      font-awesome
      ibm-plex
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
      monospace = [ "IBM Plex Mono" ];
    };
  };

  environment.sessionVariables = rec {
    # environment variables go here
    # export GDK_SCALE=2
    # export QT_AUTO_SCREEN_SCALE_FACTOR=2
  };

  environment.systemPackages = with pkgs; [
          stow
	  networkmanagerapplet
	  qbittorrent
	  yt-dlp
	  fzf
	  exa
	  gettext
	  mpv
	  mpd
	  ncmpcpp
	  git
    alacritty
	  lf
	  wget
	  curl
	  tmux
	  pciutils
	  killall
	  ripgrep
	  htop
	  python3
    mpv
	  neofetch
	  xsettingsd
	  pavucontrol
	  home-manager
	  spotify
	  (discord.override { nss = pkgs.nss_latest; withOpenASAR = true; }) # unlatest breaks nss_latest fix for firefox, but has openasar
	  brightnessctl
	  xarchiver
	  p7zip
	  rar
	  unrar
	  zip
	  unzip
	  pamixer
	  grim
	  slurp
	  thefuck
    agenix
    wireguard-tools
    # sddm-lain-wired-theme
  ];

  powerManagement = {
    powertop.enable = true;
  };
  services.auto-cpufreq.enable = true;
  # services.throttled.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0="60";
      STOP_CHARGE_THRESH_BAT0="80";
    };
  };
  services.thinkfan.enable = true;

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true; # seems like a sddm issue

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Everything follows inputs
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  nix.nixPath = [ "nixpkgs=/etc/channels/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    openFirewall = false;
    permitRootLogin = "no";
    authorizedKeysFiles = pkgs.lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    shellAliases = {
      poweroff = "poweroff --no-wall";
      reboot = "reboot --no-wall";
      update = "nix flake update";
      rebuild = ''sudo nixos-rebuild switch --flake "github:creaaidev/dotfiles?dir=nixos"
      '';
      ssh = "TERM=xterm-256color ssh";
      ls = "exa --color=always --icons --group-directories-first";
    };
    interactiveShellInit = ''
   export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
   export FZF_BASE=${pkgs.fzf}/share/fzf/
   # Customize your oh-my-zsh options here
   plugins=(git fzf thefuck)
   HISTFILESIZE=5000
   HISTSIZE=5000
   setopt SHARE_HISTORY
   setopt HIST_IGNORE_ALL_DUPS
   setopt HIST_IGNORE_DUPS
   setopt INC_APPEND_HISTORY
   autoload -U compinit && compinit
   unsetopt menu_complete
   setopt completealiases
   source $ZSH/oh-my-zsh.sh
   eval "$(direnv hook zsh)"
    '';
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  # Clean /tmp on boot
  environment.etc."tmpfiles.d/tmp.conf".text = ''
  #  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

# See tmpfiles.d(5) for details

# Clear tmp directories separately, to make them easier to override
D! /tmp 1777 root root 0
D /var/tmp 1777 root root 30d
  '';

  ## Garbage collector
  nix.gc = {
    automatic = true;
    #Every Monday 01:00 (UTC)
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Run garbage collection whenever there is less than 500MB free space left, prob better increase this value
  nix.extraOptions = ''
    min-free = ${toString (500 * 1024 * 1024)}

    keep-outputs = true
    keep-derivations = true
  ''; # DIRENV

  system.stateVersion = "22.05";

}
