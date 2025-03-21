[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

**Hey,** you. You're finally awake. You were trying to configure your OS
declaratively, right? Walked right into that NixOS ambush, same as us, and those
dotfiles over there.

> **Disclaimer:** _This is not a community framework or distribution._ It's a
> private configuration and an ongoing experiment to feel out NixOS. I make no
> guarantees that it will work out of the box for anyone but myself. It may also
> change drastically and without warning.
>
> Until I can bend spoons with my nix-fu, please don't treat me like an
> authority or expert in the NixOS space. Seek help on [the NixOS
> discourse](https://discourse.nixos.org) instead.

TODO: add screenshoot

<p align="center">
TODO: add screenshoot
TODO: add screenshoot
TODO: add screenshoot
</p>

------

|                |                                                          |
|----------------|----------------------------------------------------------|
| **Shell:**     | zsh                                                      |
| **DM:**        | greetd + tuigreet                                        |
| **WM:**        | sway + swaybar                                           |
| **Editor:**    | neovim                                                   |
| **Terminal:**  | foot                                                     |
| **Launcher:**  | rofi                                                     |
| **Browser:**   | brave + firefox                                          |
| **GTK Theme:** | [Ant Dracula](https://github.com/EliverLara/Ant-Dracula) |

-----

## Quick start

1. Acquire NixOS 23.04 or newer:
   ```sh
   # Yoink nixos-unstable
   wget -O nixos.iso https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

   # Write it to a flash drive
   # TODO: add ventoy note
   cp nixos.iso /dev/sdX
   ```

2. Boot into the installer.

3. Switch to root user: `sudo su -`

4. Do your partitions and mount your root.

- Initial steps (network connection) - https://nixos.org/manual/nixos/stable/#sec-installation
- Here is full walkthrough - https://iturdikulov.com/NixOS_pre-install
- Backup link - https://github.com/iturdikulov/notes/blob/main/NixOS_pre-install.md

OR

- https://gist.github.com/iturdikulov/a359062a6f339a14d9863ae3af507801
- https://github.com/hlissner/dotfiles/blob/master/hosts/udon/README.org

5. Install these dotfiles:
   ```sh
   nix-shell -p git nixVersions.stable

   # Set HOST to the desired hostname of this system
   export HOST=...
   # Set USER to your desired username (defaults to hlissner)
   export USER=...
   # Optional, set architecture (defaults to x86_64-linux)
   export NIX_SYSTEM=x86_64-linux # or aarch64-linux

   git clone https://github.com/iturdikulov/dotfiles /home/inom/Computer/software/dotfiles
   cd /home/inom/Computer/software/dotfiles

   # Create a host config in `hosts/` and add it to the repo:
   mkdir -p hosts/$HOST
   nixos-generate-config --root /mnt --dir /home/inom/Computer/software/dotfiles/hosts/$HOST
   rm -f hosts/$HOST/configuration.nix
   cp hosts/volga/default.nix hosts/$HOST/default.nix
   # get some settings from hosts/volga/hardware-configuration.nix too!

   # configure this for your system; don't use it verbatim!
   # DON't forget about modules section!
   vim hosts/$HOST/default.nix

   # Optionally Check / adjust options file (default user name and autorized
   # keys at least)
   vim modules/options.nix
   vim modules/services/ssh.nix

   git add hosts/$HOST

   # Install nixOS
   # as alternative you can install flake from installed nixos
   USER=$USER nixos-install --root /mnt --impure --flake .#$HOST

   # Alternative install method with building
   # nix build /mnt/etc/nixos#nixosConfigurations.<HOSTNAME>.config.system.build.toplevel --experimental-features "flakes nix-command" --store "/mnt" --impure
   # nixos-install --root /mnt --system ./result

   # If you get 'unrecognized option: --impure', replace '--impure' with
   # `--option pure-eval no`.

   # Then move the dotfiles to the mounted drive!
   # TODO: need verify this
   mkdir -p /mnt/home/$USER/Computer/software/dotfiles
   mv /mnt/dotfiles /mnt/home/$USER/Computer/software/dotfiles

   # Reboot and change owner
   chown -R ...

   # NAS clients, create dedicated directory
   mkidr /media
   ```

6. Then reboot and you're good to go!

> :warning: **Don't forget to change your `root` and `$USER` passwords!** They
> are set to `nixos` by default.

7. Import gpg key
   `gpg --import-options restore --import private.gpg`

8. Optional. Setup git config
   - Get `sec` key from this output: `gpg --list-secret-keys --keyid-format LONG <EMAIL>`
   - Change git config: `vi config/git/config`
   - Rebuild configuration `hey rebuild`

9. When you configured git access, you can change dotfiles remote url:
   ```sh
   cd /home/inom/Computer/software/dotfiles
   git remote set-url origin git@github.com:Inom-Turdikulov/nix_dotfiles.git
   git status
   ```

### Share directory in VM

Sometimes if you want to test dotfiles in VM, you need access to some files outside guest
machine, here some steps required for QUEMU/VirtManager
- poweroff guest and enable shared memory (`memory` -> `enable shared memory`)
- add shared Filesystem (`add hardware` -> `File system` -> `Driver=virtiofs` -> select `soruce` and `target path`)
- mount shared Filesystem (`sudo mount -t virtiofs target_path mount_path`)

## Management

And I say, `bin/hey`, [what's going on?](http://hemansings.com/)

```
Usage: hey [global-options] [command] [sub-options]

Available Commands:
  check                  Run 'nix flake check' on your dotfiles
  gc                     Garbage collect & optimize nix store
  generations            Explore, manage, diff across generations
  help [SUBCOMMAND]      Show usage information for this script or a subcommand
  rebuild                Rebuild the current system's flake
  repl                   Open a nix-repl with nixpkgs and dotfiles preloaded
  rollback               Roll back to last generation
  search                 Search nixpkgs for a package
  show                   [ARGS...]
  ssh HOST [COMMAND]     Run a bin/hey command on a remote NixOS system
  swap PATH [PATH...]    Recursively swap nix-store symlinks with copies (and back).
  test                   Quickly rebuild, for quick iteration
  theme THEME_NAME       Quickly swap to another theme module
  update [INPUT...]      Update specific flakes or all of them
  upgrade                Update all flakes and rebuild system

Options:
    -d, --dryrun                     Don't change anything; perform dry run
    -D, --debug                      Show trace on nix errors
    -f, --flake URI                  Change target flake to URI
    -h, --help                       Display this help, or help for a specific command
    -i, -A, -q, -e, -p               Forward to nix-env
```

## Frequently asked questions

+ **Why NixOS?**

  Because managing hundreds of servers is the tenth circle of hell without a
  declarative, generational, and immutable single-source-of-truth configuration
  framework like NixOS.

  Sure beats the nightmare of capistrano/chef/puppet/ansible + brittle shell
  scripts I left behind.

+ **Should I use NixOS?**

  **Short answer:** no.

  **Long answer:** no really. Don't.

  **Long long answer:** I'm not kidding. Don't.

  **Unsigned long long answer:** Alright alright. Here's why not:

  - Its learning curve is steep.
  - You _will_ trial and error your way to enlightenment, if you survive long
    enough.
  - NixOS is unlike other Linux distros. Your issues will be unique and
    difficult to google.
  - If the words "declarative", "generational", and "immutable" don't make you
    _fully_ erect, you're considering NixOS for the wrong reasons.
  - The overhead of managing a NixOS config will rarely pay for itself with
    fewer than 3 systems (perhaps another distro with nix on top would suit you
    better?).
  - Official documentation for Nix(OS) is vast, but shallow.
  - Unofficial resources and example configs are sparse and tend to be either
    too simple or too complex (or outdated).
  - The Nix language is obtuse and its toolchain is unintuitive. This is made
    infinitely worse if you've never touched the shell or a functional language
    before, but you'll _need_ to learn it to do even a fraction of what makes
    NixOS worth all the trouble.
  - A decent grasp of Linux and its ecosystem is a must, if only to distinguish
    Nix(OS) issues from Linux (or upstream) issues -- as well as to debug them
    or report them to the correct authority (and coherently).
  - If you need somebody else to tell you whether or not you need NixOS, you
    don't need NixOS.

  If none of this has deterred you, then you didn't need my advice in the first
  place. Stop procrastinating and try NixOS!

+ **How do you manage secrets?**

  With [agenix].

+ **Why did you write bin/hey?**

  I envy Guix's CLI and want similar for NixOS, whose toolchain is spread across
  many commands, none of which are as intuitive: `nix`, `nix-collect-garbage`,
  `nixos-rebuild`, `nix-env`, `nix-shell`.

  I don't claim `hey` is the answer, but everybody likes their own brew.

+ **How 2 flakes?**

  Would it be the NixOS experience if I gave you all the answers in one,
  convenient place?

  No. Suffer my pain:

  + [A three-part tweag article that everyone's read.](https://www.tweag.io/blog/2020-05-25-flakes/)
  + [An overengineered config to scare off beginners.](https://github.com/divnix/devos)
  + [A minimalistic config for scared beginners.](https://github.com/colemickens/nixos-flake-example)
  + [A nixos wiki page that spells out the format of flake.nix.](https://nixos.wiki/wiki/Flakes)
  + [Official documentation that nobody reads.](https://nixos.org/learn.html)
  + [Some great videos on general nixOS tooling and hackery.](https://www.youtube.com/channel/UC-cY3DcYladGdFQWIKL90SQ)
  + A couple flake configs that I
    [may](https://github.com/LEXUGE/nixos)
    [have](https://github.com/bqv/nixrc)
    [shamelessly](https://git.sr.ht/~dunklecat/nixos-config/tree)
    [rummaged](https://github.com/utdemir/dotfiles)
    [through](https://github.com/purcell/dotfiles).
  + [Some notes about using Nix](https://github.com/justinwoo/nix-shorts)
  + [What helped me figure out generators (for npm, yarn, python and haskell)](https://myme.no/posts/2020-01-26-nixos-for-development.html)
  + [Learn from someone else's descent into madness; this journals his
    experience digging into the NTODO: kittyixOS
    ecosystem](https://www.ianthehenry.com/posts/how-to-learn-nix/introduction/)
  + [What y'all will need when Nix drives you to drink.](https://www.youtube.com/watch?v=Eni9PPPPBpg)


[nixos]: https://releases.nixos.org/?prefix=nixos/unstable/
[agenix]: https://github.com/ryantm/agenix

## TODO

https://github.com/hlissner/dotfiles/commits/master/?before=1e2ca74b02d2d92005352bf328acc86abb10efbd+141
refactor(lib): add and use mkWrapper & mkLauncherEntry

- [x] fix agenix secrets
- [ ] ngnix bind 80 port and set root url
- [ ] set root path for all services (www/..)
- [ ] taskwarrior workflow
- [ ] isync and himalaya workflow
- [ ] khard & khal workflow
- [ ] aegnix chatgpt/config.json
- [ ] inkscape settings / config...
- [ ] borgbackup integration
- [ ] check https://nixos.wiki/wiki/Qmk
- [ ] setup/configure calibre-web
- [ ] possible solution to fix QT styling: https://github.com/addy419/configurations/blob/master/modules/colorschemes/dracula.nix
- [ ] parametrize $GNUPGHOME/sshcontrol
- ~~[ ] [way-displays: Auto Manage Your Wayland Displays](https://github.com/alex-courtis/way-displays)~~