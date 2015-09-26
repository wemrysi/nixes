{config, pkgs, ...}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    cleanTmpDir = true;

    kernelPackages = pkgs.linuxPackages_3_17;
    kernelParams = [ "pcie_aspm=force" "i915.enable_fbc=1" "i915.enable_rc6=7" ];

    loader.efi.canTouchEfiVariables = true;
    loader.grub.device = "/dev/sda";
    loader.gummiboot.enable = true;
    loader.gummiboot.timeout = 4;

    initrd.kernelModules = [ "fbcon" ];
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
      ctags
      dmenu
      dropbox
      elinks
      evince
      git
      gnupg
      haskellPackages.xmobar
      haskellPackages.yeganesh
      irssi
      mutt
      nixbang
      offlineimap
      patchelf
      pidgin-with-plugins
      python
      rxvt_unicode
      scrot
      silver-searcher
      stalonetray
      tmux
      unzip
      urlview
      vim
      vlc
      wpa_supplicant_gui
      which
      xfce.ristretto
      xlibs.xdpyinfo
      xlibs.xmessage
      xscreensaver
    ];
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
    pulseaudio.enable = true;
  };

  networking = {
    domain = "local";
    hostName = "otak";

    wireless = {
      enable = true;
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

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
      enableWideVine = true;
    };

    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };

    dmenu.enableXft = true;

    packageOverrides = pkgs: with pkgs; {
      pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
        plugins = [ pidginotr ];
      };
    };
  };

  powerManagement.enable = true;

  programs = {
    light.enable = true;
    ssh.startAgent = false;
    zsh.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  services = {
    chrony.enable = true;

    # For Firefox
    dbus.packages = [ pkgs.gnome.GConf ];

    printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
        pkgs.foomatic_filters
      ];
    };

    upower.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };

      displayManager = {
        desktopManagerHandlesLidAndPower = false;
        lightdm.enable = true;
      };

      startGnuPGAgent = true;

      synaptics = {
        enable = true;
        accelFactor = "0.01";
        additionalOptions = ''
          Option "VertScrollDelta" "-100"
          Option "HorizScrollDelta" "-100"
        '';
        buttonsMap = [ 1 3 2 ];
        fingersMap = [ 0 0 0 ];
        palmDetect = true;
        tapButtons = false;
        twoFingerScroll = true;
        vertEdgeScroll = false;
      };

      vaapiDrivers = [ pkgs.vaapiIntel ];

      videoDrivers = [ "intel" ];

      windowManager = {
        default = "xmonad";

        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
      };

      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
    };
  };

  time.timeZone = "America/Chicago";
  time.hardwareClockInLocalTime = true;

  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    extraUsers = {
      emrys = {
        createHome = true;
        description = "Emrys Ingersoll";
        extraGroups = [ "wheel" "docker" ];
        isNormalUser = true;
        uid = 1000;
      };
    };
    mutableUsers = false;
  };

  virtualisation.docker.enable = true;
}
