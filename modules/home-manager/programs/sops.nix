# SOPS secrets management for home-manager
{
  config,
  pkgs,
  ...
}: {
  home = {
    # Install sops and age tools
    packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

    # Ensure .ssh directory exists with correct permissions
    activation.sshDirPermissions = config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${config.home.homeDirectory}/.ssh
      chmod 700 ${config.home.homeDirectory}/.ssh
    '';

    # Public key (not a secret, can be stored directly)
    file.".ssh/id_ed25519.pub" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3qgIc7JsGV1gRSRC5sA+TGxTa1krMKm05NoDtOnYYX drodriguez@codecademy.com\n";
      executable = false;
    };
  };

  sops = {
    # Age key file location (derived from SSH key)
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # Default secrets file
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # SSH private key secret
    secrets = {
      "ssh/id_ed25519" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
    };
  };
}
