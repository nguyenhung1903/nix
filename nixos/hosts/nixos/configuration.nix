# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      	./hardware-configuration.nix
	#./input-method.nix
    	./modules/zsh.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "en_US.UTF-8";
  };
  
  

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,vn";
    variant = "";
  };

  # Vietnamese input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # Use the engine from qt6Packages
      addons = with pkgs; [
        fcitx5-gtk # Specifically keep this for Brave/Firefox
        qt6Packages.fcitx5-unikey
      ];
    };
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # Use the WirePlumber session manager
    wireplumber.enable = true;
  };
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
  	modesetting.enable = true;
  	powerManagement.enable = true;
  	open = true;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."nguyenhung1903" = {
    isNormalUser = true;
    description = "An Hung Nguyen";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "input"];
    packages = with pkgs; [
    #  thunderbird
	#"networkmanager"
      	#"wheel"
      	#"audio"
      	#"docker"
      	#"adbusers"
      	#"libvirtd" # vm
      	#"input"
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  

  virtualisation.docker = {
   enable = true;
  };

  virtualisation.vmware.host.enable = true;
  virtualisation.vmware.guest.enable = true;


  boot.kernelModules = [ "kvm-intel" ]; 
  

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gh
    tree
    gcc
    htop
    stow
    tmux
    ghostty
    vscode
    neovim
    fastfetch
    home-manager
    pulseaudio
    pipewire
    alsa-tools
    alsa-utils
    sof-firmware
    pavucontrol
    docker-compose
    google-chrome
    microsoft-edge
    vmware-workstation
    gparted
    zip
    unzip
    lazydocker
    anydesk


    # ICON - GNOME
    gnome-tweaks
    dconf-editor
    tela-circle-icon-theme
    
    go
    gopls
    ntfs3g
    smartmontools  
  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
  
  services.fprintd.enable = true;
  services.logind = {
	lidSwitch = "suspend-then-hibernate";
	lidSwitchExternalPower = "suspend-then-hibernate";
	lidSwitchDocked = "ignore";
  };


  # Garbage Collector Setting
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";

  programs.steam = {
	enable = true;

	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
	extraCompatPackages = with pkgs; [
   		 proton-ge-bin
  	];
  };

}
