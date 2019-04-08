{
  allowUnfree = true;

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
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

  oraclejdk.accept_license = true;

  vim = {
    python = true;
  };

  packageOverrides = pkgs: rec {
    pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
      plugins = [ pkgs.pidginotr ];
    };

    # These fail due to attempting to use meta.platform from the jre, which doesn't
    # appear to exist in the oracle packages.
    jython = {};
    yed = {};
  };
}
