{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    lazygit
  ];

  hjem.users.andy = {
    clobberFiles = true;
    files = {
      ".config/git/config".source = ./config;
    };
  };
}
