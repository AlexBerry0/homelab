{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 1. Unique hostname for the worker
  networking.hostName = "sandbox-worker";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 10250];
    allowedUDPPorts = [8472];
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg2RDPI3wzU7thDrxd5B9SeJkFdKWo3xJkPFaLmTeIF aberry5040@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://192.168.64.2:6443";
    token = "K109f02fcd210c0f96007bcd509dd5f17e741ed69f724505d5a1587b76fca1e6721::server:7cbd201e3aadd21c120ca0f00d970e81";
  };

  system.stateVersion = "24.11";
}
