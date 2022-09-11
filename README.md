# My NixOS and Home Manager configurations

These configurations can be used differently to manage:

- the current user configuration;
- the system configuration;
- both system and user configurations at the same time.


## Principles

- NixOS should be easy to reinstall and be ready to use — so that I no longer feel attached to my machines.
- Each host should have its own configuration file inside `./hosts`.
- All frequently used boilerplate should be modularized in `./modules` so that a computer configuration is always clear and easy to be made intuitively.
- A user should not need be forced use `home-manager`. Each user is responsible for using the system as wished (imperatively or declaratively).
- Each user should be able to configure their own WM/GE without having to contact the system admin.


## Structure

- `hosts`
  - `adam`
    - `configuration.nix`
    - `system.nix`
    - `hardware-config.nix`
    - `home.nix`: extra home-manager base config for this machine
- `users`
  - `marcosrdac`
    - `home.nix`: main home-manager user configuration
    - `hosts`: extra home-manager machine-specific user configurations (for machines that are not mine or are not running NixOS)
  - `guest`
  - `vim`: just an easy to use neovim setup
- `overlays`: i.e.: my neovim configs and plugins as an overlay
- `modules`
  - `common`
  - `nixos`
  - `home-manager`


## Dependencies

You will need `Nix` with `Flakes` enabled to use my configurations, as well as `git`.


### Acquire Flakes

```sh
nix-channel --update
nix-env -f '<nixpkgs>' -iA nixUnstable
```


<!-- ### Are you a normal user and does not have sudo access? (not fully tested)

Download DavHau's [Nix Portable](https://github.com/DavHau/nix-portable)). It is a `Nix` executable and is `Flakes` enabled by default. -->


## Current user configuration

### Download

```sh
git clone https://github.com/marcosrdac/nixcfg $HOME/.config/home-manager
```


### <a name="user-install"/> Install

```sh
home-manager switch --flake "$HOME/.config/home-manager#$(hostname)-$USER"
# i.e.: if my hostname is `adam` and my username is `marcosrdac`:
home-manager switch --flake "$HOME/.config/home-manager#adam-marcosrdac"
```

Observation: host is defined in `hosts` and my user configurations are defined in `users/$USER`
TODO add a placeholder for non-NixOS machines I might use


## <a name="system-config"/> System configuration

### Clone the repository

As super user:

```sh
git clone https://github.com/marcosrdac/nixcfg /etc/nixos
```

### Set the system hostname

Set your hostname: `Flakes` will use it to setup the correct machine. Example for my `adam` desktop:

```sh
hostname adam
```


### Build system

Then to build the machine for the first time:

```sh
nixos-rebuild switch
# ...or directly specifying the hostname and folder with
nixos-rebuild switch --flake "/etc/nixos#$(hostname)"
```


## Both system and user configuration

Start by [configuring the system](#system-config), then symlink `/etc/nixos` to `/home/$USER/home-manager`. Make the user part of `nixcfg` group in the specific machine configuration, so that it can modify the configuration files without super powers.

```sh
ln -s /etc/nixos /home/$USER/.config/home-manager
```

Now, as a normal user, you can now run similar commands to [user install section](#user-install) section's to configure your home space, except that `$HOME/.config/home-manager` will become its original configuration directory (`/etc/nixos`):

```sh
home-manager switch --flake "/etc/nixos#$(hostname)-$USER"
# i.e.: if my hostname is `adam` and my username is `marcosrdac`:
home-manager switch --flake "/etc/nixos#adam-marcosrdac"
```


## Moving remote from HTTPS to SSH

To see current remotes:

```sh
git remote -v
```

To change to SSH:

```sh
set-url origin git@github.com:marcosrdac/nixcfg.git
```


## Configuring SSH keys

```sh
ssh-keygen
cat ~/.ssh/id_rsa.pub
```

Copy `cat` output and paste it into a new SSH key with name `username@hostname` where username and hostname are your current ones.


## Configuring git

```sh
git config --global user.email "mail@marcosrdac.com"
git config --global user.name "Marcos Conceição"
```

## System maintenance

### Remove unused packages (nix)

```sh
nix-collect-garbage -d
```

### Remove unused packages (home-manager)

```sh
TODO
```


## Inspiration

- [Pinpox' configurations](https://github.com/pinpox/nixos)
- [Jordan Isaacs' configurations](https://github.com/jordanisaacs/dotfiles)
- [Krutonium's configurations](https://github.com/Krutonium/My_Unified_NixOS_Config)
- [Misterio77's configurations](https://github.com/Misterio77/nix-config)


## TODO

- [ ] Make options in my `home-manager` modules (xorg vs wayland, etc).
- [ ] Default python env should be easily accessable for data analysis stuff.
- [ ] I want to be able to install and use my WM configuration from any computer (use xinit and stuff, instead of xinit-hm).


### Reading tips

- [NixOS modules](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/x11/window-managers/i3.nix)
- [Home-manager module](https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/bspwm/default.nix)
