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

    initrd.kernelModules = [
      "fbcon"
    ];
  };

  environment = {
    shells = [
      "/run/current-system/sw/bin/zsh"
    ];

    systemPackages = with pkgs; [
      ctags
      dmenu
      dropbox
      elinks
      evince
      git
      gnupg
      haskellPackages.xmobar
      haskellPackages.yeganesh
      hicolor_icon_theme
      irssi
      libreoffice
      lsof
      mutt
      nixbang
      offlineimap
      patchelf
      pavucontrol
      pidgin-with-plugins
      python
      rdiff-backup
      rxvt_unicode
      scrot
      silver-searcher
      stalonetray
      tmux
      unzip
      urlview
      vim
      which
      xfce.ristretto
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
    enableCoreFonts = true;
    enableFontDir = true;

    fontconfig = {
      defaultFonts.monospace = [ "Source Code Pro" ];
      ultimate.substitutions = "combi";
    };

    fonts = [
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

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
      enableWideVine = true;
    }; 

    virtualbox.enableExtensionPack = true;

    packageOverrides = pkgs: with pkgs; {
      pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
        plugins = [ pidginotr ];
      };
    };
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
    chrony.enable = true;

    openssh = {
      enable = true;
      challengeResponseAuthentication = false;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
        pkgs.foomatic_filters
      ];
    };

    virtualboxHost.enable = true;

    xserver = {
      desktopManager.xterm.enable = false;
      displayManager = {
        desktopManagerHandlesLidAndPower = false;
	lightdm.enable = true;
      };
      enable = true;
      multitouch.enable = false;
      startGnuPGAgent = true;
      videoDrivers = [ "nvidia" ];
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
      windowManager.default = "xmonad";
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

  virtualisation.docker = {
    enable = true;
    extraOptions = "--storage-driver devicemapper --storage-opt dm.basesize=5G --storage-opt dm.datadev=/dev/datavg/dockerdatalv --storage-opt dm.metadatadev=/dev/lookfarvg/dockermetalv";
  };

}

