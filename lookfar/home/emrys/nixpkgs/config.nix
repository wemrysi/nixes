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

  vim = {
    python = true;
  };

  packageOverrides = pkgs: rec {
    jre = pkgs.oraclejre8;
    jdk = pkgs.oraclejdk8;

    pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
      plugins = [ pkgs.pidginotr ];
    };

#   vim = pkgs.stdenv.lib.overrideDerivation pkgs.vim (oldAttrs : {
#     nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
#       pkgs.ncurses
#       pkgs.python
#       pkgs.pythonPackages.websocket_client
#     ];

#     configureFlags = [
#       "--enable-multibyte"
#       "--enable-nls"
#       "--enable-pythoninterp=yes"
#       "--with-python-config-dir=${pkgs.python}/lib"
#     ];
#   });

    # These fail due to attempting to use meta.platform from the jre, which doesn't
    # appear to exist in the oracle packages.
    jython = {};
    yed = {};
  };
}
