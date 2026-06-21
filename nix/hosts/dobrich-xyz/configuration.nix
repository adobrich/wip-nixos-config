{ self, nixpkgs, ... }:
nixpkgs.lib.nixosSystem {
  # imports = []; TODO: remove?

  system = "x86_64-linux";
  modules = [
    ./hardware-configuration.nix
    ./disko-configuration.nix
    ({ pkgs, ... }: {
      
      # ZFS specific settings
      boot.supportedFilesystems = [ "zfs" ];
      boot.zfs.devNodes = "/dev/disk/by-id";
      networking.hostId = "2d7d2265"; # Replace with a unique 8-character hex string

      # Enable UEFI booting
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.zfs.forceImportRoot = false;

      # Configure network connections interactively with nmcli or nmtui
      networking.networkmanager.enable = true;

      # Set your time zone
      time.timeZone = "Melbourne/Australia";

      # Select internationalisation properties
      i18n.defaultLocale = "en_AU.UTF-8";

      # Basic network & user configuration
      networking.hostName = "nixos-zfs-vm";
      services.openssh.enable = true;
      users.users.root.initialPassword = "password";

      users.users.andy = {
        isNormalUser = true;
        initialHashedPassword = "$6$ZvLzCMxbqsW2Qnu0$v0k1fnHCD09p6gFGoXGZlbOJ81jK5.8lD8DT535f6c3.PdAQ6dE/uA2vgoCqaNkmH0adY7Btxz/aE6Y9yxFJS/";
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user
        packages = with pkgs; [
          tree
          rclone
        ];
      };

      # Enable sound
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };

      # Essential packages
      environment.systemPackages = with pkgs; [
        git
        neovim
        helix
        wget
        zfs
      ];

      system.stateVersion = "26.05";
    })
  ];
}
