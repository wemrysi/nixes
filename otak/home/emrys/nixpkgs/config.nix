{
  allowUnfree = true;

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
    enableAdobeFlashDRM = true;
  };

  neovim = {
    withJemalloc = true;

    withPython = true;
    extraPythonPackages = [
    ];

    withPython3 = true;
    extraPython3Packages = [
    ];
  };

  packageOverrides = pkgs: rec {
    pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
      plugins = [ pkgs.pidginotr ];
    };

    # Both fail as they depend on jre.meta.platforms which the oracle jre
    # packages doesn't seem to provide.
    jython = {};
    yed = {};
  };
}
