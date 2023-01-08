{ config, pkgs, lib, ... }:

let
  cfg = config.services.hd-idle;
in
with lib;
{
  options.services.hd-idle = {
    enable = mkEnableOption "hd-idle";

    package = mkOption {
      type = types.package;
      default = pkgs.hd-idle;
      defaultText = "pkgs.hd-idle";
      description = ''
        The hd-idle package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hd-idle = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "hd-idle system service";
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/hd-idle"; # Send logs to var/lib
      };
    };
  };
}
