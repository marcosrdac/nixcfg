# My NixOS machines' configurations

## First instalation

### Acquire flakes

I am not really confident of my first steps, but I know that, as far as NixOS 21.05, I had to install the unstable version of Nix to have access to `flakes` via:

```sh
nix-channel --update
nix-env -f '<nixpkgs>' -iA nixUnstable
```

### Set system hostname

Set your hostname: `flakes` will use it to setup the correct machine. Example for my `adam` desktop:

```sh
hostname adam
```

### Build system

Then to build the machine for the first time:

```sh
nixos-rebuild switch --flake "/etc/nixos#${HOSTNAME}"
```

## Rebuilding in the future

```sh
nixos-rebuild switch
```

## Principles

- NixOS should be easy to reinstall and be ready to use --- so that I no longer feel attached to my machines
- Each host should have its own configuration file inside ./hosts
- Almost every config should be modularized in ./lib/modules so that a computer configuration is always clear
- Personal stuff should not be in this repository
- Each user is responsible for using the system as wished (via personal config repositories and HomeManager or not)
- Each user configures their own WM/GE without having to ask root
- Users are to be able to use xinit from DM (if a DM is really wanted)
- Consider creating nix file for overlays (maybe a module?)

## Inspiration

- [Pinpox' configurations](https://github.com/pinpox/nixos)
- [Jordan Isaacs' configurations](https://github.com/jordanisaacs/dotfiles)
- [Krutonium's configurations](https://github.com/Krutonium/My_Unified_NixOS_Config)

## TODO - General

- [X] Overlay for unfree software
- [X] Make system configuration default as a module
- [X] Use configUsers module to create users listed for the host
- [ ] Create usual GPT boot config in module
- [ ] Handle overlays better (use ./lib/overlays)

## TODO - user configurable X/Wayland sessions

- [ ] Make a system module to create a system-wide xinit-session based on NixOS version of bspwm or any other wm to be selectable from DM
- [ ] start with startxfce4 in ~/.xinit
- [ ] Change from xfce to bspwm
- [ ] Make home-manager modules for writing ~/.xinitrc ~/.xserverrc

... if doesn't work for riverwm
- [ ] Make a system module to create a system-wide wayland-session based on NixOS version of sway or any other wayland wm to be selectable from DM

### Reading tips

- [NixOS module](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/x11/window-managers/i3.nix)
- [Home-manager module](https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/bspwm/default.nix)


## My personal desires
- [ ] Default python env should be easily accessable for data analysis stuff
