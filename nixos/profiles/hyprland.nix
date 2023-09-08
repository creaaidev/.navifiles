{ config, pkgs, lib, ... }:

let
 # dbus-sway-environment = pkgs.writeTextFile {
 #   name = "dbus-sway-environment";
 #   destination = "/bin/dbus-sway-environment";
 #   executable = true;

 #   text = ''
 # dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
 # systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
 # systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
 #     '';
 # };

 # configure-gtk = pkgs.writeTextFile {
 #     name = "configure-gtk";
 #     destination = "/bin/configure-gtk";
 #     executable = true;
 #     text = let
 #       schema = pkgs.gsettings-desktop-schemas;
 #       datadir = "${schema}/share/gsettings-schemas/${schema.name}";
 #     in ''
 #       export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
 #       gnome_schema=org.gnome.desktop.interface
 #       gsettings set $gnome_schema gtk-theme 'Dracula'
 #       gsettings set $gnome_schema icon-theme 'kora'
 #       gsettings set $gnome_schema cursor-theme 'Bibata_Ghost'
 #       '';
 # };
in
{

  environment.systemPackages = with pkgs; [
    # dbus-sway-environment
    # configure-gtk
    wayland
    # glib # gsettings
    # dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    # swaylock-effects
    # swayidle
    # swaybg
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    qt6.qtwayland
    # xdg-utils # for opening default programs when clicking links

    xwayland
    # waybar
    imv
    # sirula # doesnt work well with env vars thingies idk
    ulauncher
    mako
    firefox-wayland

    kora-icon-theme
    bibata-cursors-translucent
    wlogout
  ];

  #services.dbus.enable = true;
  #xdg.portal = {
  #  enable = true;
  #  wlr.enable = true;
  #  # gtk portal needed to make gtk apps happy
  #  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };
  # environment.sessionVariables.GTK_USE_PORTAL = "1"; # /NixOS/nixpkgs/pull/179204

  # enable sway window manager
  programs.hyprland = {
    enable = true;
    # wrapperFeatures.gtk = true;
    # extraSessionCommands = ''
    #  export QT_QPA_PLATFORM=wayland
    #  export NIXOS_OZONE_WL=1
    # '';
  };


  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      # defaultSession = "sway";
      gdm = {
        enable = true;
        # autoSuspend = false;
        wayland = true;
      };
    };
    # displayManager = {
    #    defaultSession = "none+i3";
  };
}