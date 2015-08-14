# NixOS 14.12 on a Dell XPS 13 (2015) laptop

Working configuration for LUKS + NixOS + XMonad and a fairly comprehensive xmobar.

As of August 2015, with the A05 BIOS most features of the laptop are working, including sound (I haven't tried bluetooth or the camera yet). Sometimes resuming from suspend results in display flickering, but it usually sorts itself out (or try locking the screen via xscreensaver, then unlocking).

Installation was a bit of a chore, due to the broadcom wireless module, but thanks to Bernerd Schafer for his writeup of [installing NixOS on a MacBook air](https://robots.thoughtbot.com/install-linux-on-a-macbook-air) I was able to get everything installed.

