{ config, lib, pkgs, ... }:
{
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      files = [
        { file = "/etc/machine-id"; inInitrd = true; }
      ];

      directories = [
        "/var/lib/bluetooth"
        "/var/lib/systemd/timers"
        "/var/lib/nixos"
        "var/log"
      ];

      users = {
        andy = {
          files = [
            # TODO
          ];

          directories = [
            { directory = ".ssh"; mode = "0700"; }
          ];
        };

        root = {
          home = "/root";
          directories = [
            { directory = ".ssh"; mode = "0700"; }
          ];
        };
      };
    };
  };

  systemd.supressedSystemUnits = [ "systemd-machine-id-commit.service" ];
}
