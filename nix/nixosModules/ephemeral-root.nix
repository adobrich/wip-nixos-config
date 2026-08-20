/*
  module: ephemeral-root.nix
  description: Using a blank ZFS snapshot, wave goodbye to last boot's root
               and hello to a brand new one populated with only the things we want...
               Unless you forgot to persist it, in which case it's gone.
               Just gone - but it's okay, you'll do better next time! Hang in there!
*/
{ inputs, pkgs, ... }:
{
  imports = [
    inputs.preservation.nixosModules.preservation
  ];

  # Eliminate root on each boot.
  boot.initrd.systemd = {
    enable = true;
    services.initrd-rollback-root = {
      after = [ "zfs-import-rpool.service" ];
      wantedBy = [ "initrd.target" ];
      before = [ "sysroot.mount" ];
      path = [ pkgs.zfs ];
      description = "Rollback roof fs";
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = "zfs rollback -r rpool/local/root@blank";

    };
  };

  # Prevent sudo from lecturing after each boot.
  # I promise I'll be good! Don't remind me again.
  security.sudo = {
    extraConfig = ''
      Defaults lecture=never
    '';
  };

  # All the things we care about. Didn't forget anything, right?
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      commonMountOptions = [
        "x-gvfs-hide"
        "x-gdu.hide"
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
      ];

      directories = [
        "/var/lib/bluetooth"
        "/var/lib/systemd/timers"
        "/var/lib/nixos"
        "/var/log"
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
      ];

      users = {
        andy = {
          files = [
            # TODO
          ];

          directories = [
            {
              directory = ".ssh";
              mode = "0700";
            }
          ];
        };
      };
    };
  };

  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persist/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persist"
    ];
  };
  # systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
}
