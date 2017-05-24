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
      haskellPackages.xmobar
      haskellPackages.yeganesh
      hdparm
      hicolor_icon_theme
      lsof
      nixbang
      patchelf
      pavucontrol
      powertop
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
    bluetooth.enable = true;

    opengl.extraPackages = [
      pkgs.vaapiIntel
    ];

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
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

  programs = {
    light.enable = true;
#   ssh.startAgent = false;
    zsh.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  services = {
    # For Firefox
    dbus.packages = [ pkgs.gnome3.gconf ];

    printing = {
      enable = true;
      drivers = [
        pkgs.foomatic_filters
      ];
      gutenprint = true;
    };

    tlp.enable = true;

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
  };
}
