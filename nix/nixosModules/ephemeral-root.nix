{ inputs, ... }:
{
  imports = [
    inputs.preservation.nixosModules.preservation
  ];

  preservation = {
    enable = true;
    preserveAt."/persist" = {
      commonMountOptions = [ "x-gvfs-hide" "x-gdu.hide" ];

      files = [
        { file = "/etc/machine-id"; inInitrd = true; }
      ];

      directories = [
        "/var/lib/bluetooth"
        "/var/lib/systemd/timers"
        "/var/lib/nixos"
        "var/log"
        "/etc/NetworkManager/system-connections"
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

  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
}
