{ pkgs, ... }:
{
  imports = [
    # TODO: home management?
  ];

  users.users.root.initialPassword = "password";

  users.users.andy = {
    isNormalUser = true;
    initialHashedPassword = "$6$ZvLzCMxbqsW2Qnu0$v0k1fnHCD09p6gFGoXGZlbOJ81jK5.8lD8DT535f6c3.PdAQ6dE/uA2vgoCqaNkmH0adY7Btxz/aE6Y9yxFJS/";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user
    packages = with pkgs; [
      tree
      nixd
      nixfmt
    ];
  };

  hjem.users.andy = {
    user = "andy";
    directory = "/home/andy";

    files = {
      ".config/helix/config.toml" = {
        generator = (pkgs.formats.toml { }).generate "config.toml";
        value = {
          theme = "catppuccin_mocha";
          editor = {
            true-color = true;
            line-number = "relative";
          };
        };
      };
      ".config/helix/languages.toml" = {
        generator = (pkgs.formats.toml { }).generate "languages.toml";
        value = {
          language = [
            {
              name = "nix";
              auto-format = true;
              formatter = {
                command = "nixfmt";
              };
              language-servers = [
                "nixd"
                "harper-ls"
              ];
            }
            {
              name = "git-commit";
              language-servers = [ "harper-ls" ];
            }
            {
              name = "markdown";
              language-servers = [
                "marksman"
                "harper-ls"
              ];
            }
          ];
          language-server = {
            nixd = {
              command = "nixd";
              args = [ "--semantic-tokens=true" ];
            };
          };
          language-server = {
            harper-ls = {
              command = "harper-ls";
              args = [ "--stdio" ];
            };
          };
        };
      };
    };
  };
}
