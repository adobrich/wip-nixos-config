/*
  module: ephemeral-root.nix
  prerequisites: ZFS on root, blank snapshot at `rpool/local/root@blank`
  description:
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
  # I promise I'll be good!
  security.sudo = {
    extraConfig = ''
      Defaults lecture=never
    '';
  };

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
          # how = "symlink";
          # configureParent = true;
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

  # systemd.services.systemd-machine-id-commit = {
  #   unitConfig.ConditionPathIsMountPoint = [
  #     ""
  #     "/persist/etc/machine-id"
  #   ];
  #   serviceConfig.ExecStart = [
  #     ""
  #     "systemd-machine-id-setup --commit --root /persist"
  #   ];
  # };
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
}
