{config, pkgs, ...}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    cleanTmpDir = true;

    blacklistedKernelModules = [ "i2c_hid" ];
    kernelParams = [ "pcie_aspm=force" "i915.enable_rc6=7" ];

    loader.efi.canTouchEfiVariables = true;
    loader.grub.device = "/dev/sda";
    loader.gummiboot.enable = true;
    loader.gummiboot.timeout = 4;

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
      dmenu
      haskellPackages.xmobar
      haskellPackages.yeganesh
      hicolor_icon_theme
      lsof
      nixbang
      patchelf
      pavucontrol
      python
      pythonPackages.docker_compose
      scrot
      silver-searcher
      stalonetray
      unzip
      vim
      wpa_supplicant_gui
      which
      xlibs.xdpyinfo
      xlibs.xmessage
      xscreensaver
    ];
  };

  fonts = {
    enableFontDir = true;

    fontconfig = {
      defaultFonts.monospace = [ "Source Code Pro" ];
      ultimate.substitutions = "combi";
    };

    fonts = [
      pkgs.corefonts
      pkgs.cm_unicode
      pkgs.dejavu_fonts
      pkgs.freefont_ttf
      pkgs.inconsolata
      pkgs.source-code-pro
      pkgs.ttf_bitstream_vera
    ];
  };

  hardware = {
    opengl.extraPackages = [
      pkgs.vaapiIntel
    ];

    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
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

    dmenu.enableXft = true;
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
    # For Firefox
    dbus.packages = [ pkgs.gnome.GConf ];

    printing = {
      enable = true;
      drivers = [
        pkgs.foomatic_filters
      ];
      gutenprint = true;
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

      multitouch = {
        enable = false;
        additionalOptions = ''
          Option "Sensitivity" "0.75"
          Option "ScrollDistance" "100"
        '';
        buttonsMap = [ 1 3 2 ];
        ignorePalm = true;
        invertScroll = true;
        tapButtons = false;
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
        horizEdgeScroll = false;
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

  time.timeZone = "America/Chicago";
# time.timeZone = "America/Los_Angeles";

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

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "devicemapper";
    };

    virtualbox.host.enable = true;
  };
}
