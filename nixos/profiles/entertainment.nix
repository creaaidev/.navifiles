{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    jellyfin-media-player
    stremio
    mgba
    moonlight-qt
    steam-run
    protontricks
    lutris
    wine-wayland
    # unstable.nexusmods-app # in the future maybe
  ];
  programs.steam.enable = true;
  # Waydroid
  # virtualisation.waydroid.enable = true;

  # install steam link thru flathub
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  services.flatpak.enable = true;
}
