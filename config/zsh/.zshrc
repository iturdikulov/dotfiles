#!/usr/bin/env zsh
source $ZDOTDIR/config.zsh

# NOTE ZGEN_DIR and ZGEN_SOURCE are forward-declared in modules/shell/zsh.nix
# NOTE Using zgenom because zgen is no longer maintained
if [ ! -d "$ZGEN_DIR" ]; then
  echo "Installing jandamm/zgenom"
  git clone https://github.com/jandamm/zgenom "$ZGEN_DIR"
fi
source $ZGEN_DIR/zgenom.zsh

# Check for plugin and zgenom updates every 7 days
# This does not increase the startup time.
zgenom autoupdate

if ! zgenom saved; then
  echo "Initializing zgenom"
  rm -f $ZDOTDIR/*.zwc(N) \
        $XDG_CACHE_HOME/zsh/*(N) \
        $ZGEN_INIT.zwc

  # NOTE Be extra careful about plugin load order, or subtle breakage can
  #   emerge. This is the best order I've sussed out for these plugins.
  zgenom load junegunn/fzf shell
  zgenom load zsh-users/zsh-completions src
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load hlissner/zsh-autopair autopair.zsh

  zgenom save
  zgenom compile $ZDOTDIR
fi

## Bootstrap interactive sessions
if [[ $TERM != dumb ]]; then
  autoload -Uz compinit && compinit -u -d $ZSH_CACHE/zcompdump

  source $ZDOTDIR/keybinds.zsh
  source $ZDOTDIR/completion.zsh
  source $ZDOTDIR/aliases.zsh

  # Auto-generated by nixos
  _source $ZDOTDIR/extra.zshrc
  # If you have host-local configuration, put it here
  _source $ZDOTDIR/local.zshrc

  _cache fasd --init posix-alias zsh-{hook,{c,w}comp{,-install}}
  autopair-init
fi