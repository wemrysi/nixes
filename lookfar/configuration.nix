{config, pkgs, ...}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
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
      chromium
      ctags
      dmenu
      dropbox
      elinks
      evince
      firefox-bin
      gcc
      git
      gnumake
      gnupg
      haskellPackages.xmobar
      haskellPackages.yeganesh
      irssi
      libreoffice
      mutt
      nixbang
      offlineimap
      oraclejdk8
      patchelf
      pidgin-with-plugins
      pidginotr
      python
      rdiff-backup
      rxvt_unicode
      sbt
      scrot
      silver-searcher
      stalonetray
      tmux
      unzip
      urlview
      vim
      vlc
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
        extraGroups = [ "wheel" "docker" ];
        hashedPassword = "THE PASSWORD";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ "THE_KEY" ];
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

