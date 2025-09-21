{ inputs, ... }: {
  # TouchID authentication for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Do not try to reconfigure the macOS firewall; managed Macs block CLI changes
  disabledModules = ["${inputs.nix-darwin.outPath}/modules/networking/applicationFirewall.nix"];
}
