{
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

  packageOverrides = pkgs: rec {
    jre = pkgs.oraclejre8;
    jdk = pkgs.oraclejdk8;

    pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
      plugins = [ pkgs.pidginotr ];
    };

    # These fail due to attempting to use meta.platform from the jre, which doesn't
    # appear to exist in the oracle packages.
    jython = {};
    yed = {};
  };
}
