{ inputs, pkgs, lib, ... }:
{
  imports = [
    inputs.preservation.nixosModules.preservation
    # TODO: home management?
  ];

  users.users.root.initialPassword = "password";

  users.users.andy = {
    isNormalUser = true;
    initialHashedPassword = "$6$ZvLzCMxbqsW2Qnu0$v0k1fnHCD09p6gFGoXGZlbOJ81jK5.8lD8DT535f6c3.PdAQ6dE/uA2vgoCqaNkmH0adY7Btxz/aE6Y9yxFJS/";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user
    packages = with pkgs; [
      tree
    ];
  };
}
