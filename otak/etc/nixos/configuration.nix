{config, pkgs, ...}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    cleanTmpDir = true;

    blacklistedKernelModules = [ "i2c_hid" ];
    kernelParams = [ "pcie_aspm=force" ];

    loader.efi.canTouchEfiVariables = true;
    loader.grub.device = "/dev/sda";
    loader.systemd-boot.enable = true;
    loader.timeout = 4;

    initrd.luks.devices = [ { name = "luksroot"; device = "/dev/sda6"; preLVM = true; } ];
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
      lsof
      networkmanagerapplet
      nixbang
      patchelf
      pavucontrol
      pasystray
      powertop
      python
      pythonPackages.docker_compose
      scrot
      silver-searcher
      stalonetray
      unzip
      vdpauinfo
      vim
      which
      xlibs.xdpyinfo
      xlibs.xmessage
      xscreensaver
    ];
  };

  fonts = {
    enableFontDir = true;

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
      pkgs.cm_unicode
      pkgs.dejavu_fonts
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

    opengl = {
      driSupport32Bit = true;
      s3tcSupport = true;
      extraPackages = [
        pkgs.vaapiIntel
        pkgs.libvdpau-va-gl
        pkgs.vaapiVdpau
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        pkgs.vaapiIntel
        pkgs.libvdpau-va-gl
        pkgs.vaapiVdpau
      ];
    };

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
    hostName = "otak";

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
    buildCores = 2;
    gc.automatic = true;
    nrBuildUsers = 4;
  };

  nixpkgs.config = {
    allowUnfree = true;

    dmenu.enableXft = true;
  };

  programs = {
    gnupg.agent = {
      enable = true;
#     enableSSHSupport = true;
    };
    light.enable = true;
    ssh.startAgent = true;
    zsh.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  services = {
    printing = {
      enable = true;
      drivers = [
        pkgs.foomatic_filters
        pkgs.gutenprint
      ];
    };

    tlp = {
      enable = true;
      extraConfig = ''
        CPU_SCALING_GOVERNOR_ON_AC=performance
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        CPU_MIN_PERF_ON_AC=0
        CPU_MAX_PERF_ON_AC=100
        CPU_MIN_PERF_ON_BAT=0
        CPU_MAX_PERF_ON_BAT=100
        CPU_BOOST_ON_AC=1
        CPU_BOOST_ON_BAT=1
      '';
    };

    upower.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };

      displayManager = {
        lightdm.enable = true;
      };

      libinput = {
        enable = true;
        accelProfile = "adaptive";
        buttonMapping = "1 2 3";
        clickMethod = "clickfinger";
        middleEmulation = false;
        naturalScrolling = true;
        tapping = false;
      };

      videoDrivers = [ "intel" ];

      windowManager = {
        default = "xmonad";
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
      };

      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
    };
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
# time.timeZone = "America/Denver";
# time.timeZone = "America/Los_Angeles";
# time.timeZone = "America/New_York";

  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    extraUsers = {
      emrys = {
        createHome = true;
        description = "Emrys Ingersoll";
        extraGroups = [ "wheel" "docker" "networkmanager" ];
        isNormalUser = true;
        uid = 1000;
      };
    };
    mutableUsers = false;
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };
}
