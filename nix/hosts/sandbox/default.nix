{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sandbox";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443 6443];
    allowedUDPPorts = [8472]; # Flannel VXLAN overlay
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    k3s
  ];

  users.users.devops = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg2RDPI3wzU7thDrxd5B9SeJKFdKWo3xJkPFaLmTeIF aberry5040@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable=traefik" # Disabled so ArgoCD/Helm manages Ingress later
      "--flannel-backend=vxlan"
    ];
  };

  system.stateVersion = "24.11";
}
