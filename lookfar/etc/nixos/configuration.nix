{config, pkgs, ...}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    cleanTmpDir = true;

    loader.efi.canTouchEfiVariables = true;
    loader.grub.device = "/dev/sda";
    loader.gummiboot.enable = true;
    loader.gummiboot.timeout = 4;
  };

  environment = {
    pathsToLink = [
      "/etc/gconf"
    ];

    shells = [
      "/run/current-system/sw/bin/zsh"
    ];

    systemPackages = with pkgs; [
      dmenu
      haskellPackages.xmobar
      haskellPackages.yeganesh
      hdparm
      hicolor_icon_theme
      lsof
      nixbang
      patchelf
      pavucontrol
      python
      pythonPackages.docker_compose
      rdiff-backup
      scrot
      stalonetray
      unzip
      vim
      which
      xlibs.xmessage
      xscreensaver
    ];
  };

  fileSystems = {
    "/home" = {
      device = "/dev/lookfarvg/homelv";
    };

    "/mnt/backup" = {
      device = "/dev/datavg/backuplv";
    };

    "/mnt/iffish" = {
      device = "/dev/datavg/iffishlv";
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts.monospace = [ "Source Code Pro" ];
      ultimate.substitutions = "combi";
    };

    fonts = [
      pkgs.corefonts
      pkgs.dejavu_fonts
      pkgs.freefont_ttf
      pkgs.inconsolata
      pkgs.source-code-pro
      pkgs.ttf_bitstream_vera
    ];
  };

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
  };

  networking = {
    domain = "local";
    enableIPv6 = false;
    hostName = "lookfar";
  };

  nix = {
    buildCores = 4;
    gc.automatic = true;
    nrBuildUsers = 12;
  };

  nixpkgs.config = {
    allowUnfree = true;
    dmenu.enableXft = true;
    virtualbox.enableExtensionPack = true;
  };

  powerManagement.enable = false;

  programs = {
    ssh.startAgent = false;
    zsh.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  services = {
    dbus.packages = [ pkgs.gnome.GConf ];

    openssh = {
      enable = true;
      challengeResponseAuthentication = false;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    printing = {
      enable = true;
      drivers = [
        pkgs.foomatic_filters
      ];
      gutenprint = true;
    };

    xserver = {
      enable = true;

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };

      displayManager = {
	lightdm.enable = true;
      };

      multitouch.enable = false;

      startGnuPGAgent = true;

      videoDrivers = [ "nvidia" ];

      windowManager = {
        default = "xmonad";
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
      };
    };

    znc = {
      confOptions = {
        nick = "estewei";
        useSSL = true;
      };
      dataDir = "/home/emrys/.znc/";
      enable = true;
      mutable = true;
      user = "emrys";
    };
  };

  time.timeZone = "America/Chicago";

  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    extraUsers = {
      emrys = {
        createHome = true;
        description = "Emrys Ingersoll";
        extraGroups = [ "wheel" "docker" "vboxusers" ];
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAteBdaiHbu2hkWy13m3eIBu6wxMLBlFwPJvS5S6q2mqlL/me7hoCwABHIyGhlm2rHGwl2+wn14kP2HSDhGFadVBSmFS6Ww9d/qSIMIF4IzBM/T4KBDvvJEzBjbmL6mQv73dIm+5Sq0LAyMDXzpakkViiHfNGRpHQb+apE2SqACAnZpr6DLLP3nG/PPDR2CVWZQ7NC2COBOobmrTHzO0KzE8059POiVMfClbtEalzn4MrbIQ3S0hCUKRyTDjNGc8ZMhM7c/2SS4u/ZoYiw/AbJexNcPXDZlSXT1Y6z7ZLsp0BSIJG+Z+S8Fuu+eJyy2+21mZ/WL8Hhkws7Bx3CkcKFuQ== emrys_rsa" ];
        uid = 1000;
      };
    };
    mutableUsers = false;
  };

  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--storage-opt dm.basesize=8G --storage-opt dm.datadev=/dev/datavg/dockerdatalv --storage-opt dm.metadatadev=/dev/lookfarvg/dockermetalv";
      storageDriver = "devicemapper";
    };

    virtualbox.host.enable = true;
  };
}

