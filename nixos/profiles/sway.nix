{ config, pkgs, user, profiles, lib, ... }:

let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
  dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
  systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
  };

  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
        gsettings set $gnome_schema icon-theme 'kora'
        gsettings set $gnome_schema cursor-theme 'Bibata_Ghost'
        '';
  };
in
{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    light.enable = true;
    dconf.enable = true;
  };

  # import wm config
  home-manager.users.${user} = {
    imports = with profiles.home; [ sway waybar ];
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = false;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
        wayland = true;
      };
    };
    # displayManager = {
    #    defaultSession = "none+i3";
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  environment.sessionVariables.GTK_USE_PORTAL = "1"; # /NixOS/nixpkgs/pull/179204

  environment.systemPackages = with pkgs; [
    sway
    dbus-sway-environment
    glib
    swaylock-effects
    swayidle
    swaybg
    qt6.qtwayland
  ];
}
