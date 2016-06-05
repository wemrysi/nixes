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
    enableAdobeFlashDRM = true;
  };

  packageOverrides = pkgs: rec {
    jre = pkgs.oraclejre8;
    jdk = pkgs.oraclejdk8;

    pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
      plugins = [ pkgs.pidginotr ];
    };

    # Both fail as they depend on jre.meta.platforms which the oracle jre
    # packages doesn't seem to provide.
    jython = {};
    yed = {};
  };
}
