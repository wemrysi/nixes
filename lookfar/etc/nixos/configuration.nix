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
    loader.systemd-boot.enable = true;
    loader.timeout = 4;
  };

  environment = {
    pathsToLink = [
      "/etc/gconf"
    ];

    shells = [
      "/run/current-system/sw/bin/zsh"
    ];

    systemPackages = with pkgs; [
      blueman
      dmenu
      dropbox-cli
      haskellPackages.xmobar
      haskellPackages.yeganesh
      hdparm
      hicolor_icon_theme
      iotop
      lsof
      networkmanagerapplet
      nixbang
      patchelf
      pasystray
      pavucontrol
      python
      rdiff-backup
      scrot
      smartmontools
      stalonetray
      sysstat
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

    "/var/lib/docker" = {
      device = "/dev/datavg/dockerlv";
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      enable = true;
      penultimate.enable = false;
      ultimate.enable = true;
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Liberation Sans" ];
        serif = [ "Liberation Serif" ];
      };
    };

    fonts = [
      pkgs.corefonts
      pkgs.dejavu_fonts
      pkgs.emojione
      pkgs.font-awesome-ttf
      pkgs.freefont_ttf
      pkgs.inconsolata
      pkgs.liberation_ttf
      pkgs.source-code-pro
      pkgs.ttf_bitstream_vera
    ];
  };

  hardware = {
    bluetooth.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    domain = "local";
    hostName = "lookfar";

    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };

    wireless = {
      enable = false;
      interfaces = [ "wlp2s0" ];
      userControlled.enable = true;
    };
  };

  nix = {
    buildCores = 4;
    gc.automatic = true;
    nrBuildUsers = 12;
  };

  nixpkgs.config = {
    allowUnfree = true;
    dmenu.enableXft = true;
  };

  powerManagement.enable = false;

  programs = {
    gnupg.agent.enable = true;
#   gnupg.agent.enableSSHSupport = true;
    ssh.startAgent = true;
    zsh.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "27 * * * * root /home/emrys/opt/bin/system-backup /mnt/backup/lookfar-nixos"
        "42 2 * * 0 root /home/emrys/opt/bin/trim-filesystems"
      ];
    };

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
        pkgs.gutenprint
      ];
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

      videoDrivers = [ "nvidia" ];

      windowManager = {
        default = "xmonad";
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
      };
    };

#   znc = {
#     confOptions = {
#       nick = "estewei";
#       useSSL = true;
#     };
#     dataDir = "/home/emrys/.znc/";
#     enable = true;
#     mutable = true;
#     user = "emrys";
#   };
  };

  sound.enable = true;

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  time.timeZone = "America/Chicago";

  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    extraUsers = {
      emrys = {
        createHome = true;
        description = "Emrys Ingersoll";
        extraGroups = [ "wheel" "docker" "networkmanager" ];
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
      enableOnBoot = false;
      storageDriver = "overlay2";
    };

    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };
  };
}

