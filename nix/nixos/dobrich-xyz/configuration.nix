{ inputs
, pkgs
, ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.hjem.nixosModules.default

    inputs.self.nixosModules.common
    inputs.self.nixosModules.ephemeral-root

    ./hardware-configuration.nix
    ./disko-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
    zfs.devNodes = "/dev/disk/by-id";
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.hostId = "2d7d2265";
  networking.hostName = "dobrich-xyz";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Essential packages
  environment.systemPackages = with pkgs; [
    git
    helix
    wget
    zfs
    harper
  ];

  system.stateVersion = "26.05";
}
