# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# Programs remap
# ===============
alias q=exit
alias clr=clear
alias sudo='sudo '
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias wget='wget2 -c'
alias wget_img='wget2 -nd -r -l 1 -P . -A jpeg,jpg,bmp,gif,png,webp,webm' # TODO: convert to chrome based wget/use long arguments

alias path_dirs='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias info='info --vi-keys' # Info vi mode
alias watch='watch --color' # Color using watch
alias chown="chown --preserve-root" # Do not do chown for root directory
alias chmod="chmod --preserve-root"
alias E="SUDO_EDITOR=nvim sudo -e"
gpt() {
    noglob llm "$@" | fold | bat --language=markdown --plain
}

# disable globbing for some specific programs
alias c="noglob qalc"
alias tplay="noglob tplay"

alias mk=make
alias gurl='curl --compressed'
alias gaudio="yt-dlp -N 5 -f 'ba' -o '%(id)s-%(title)s.%(ext)s'"
alias yt-dlp-all="yt-dlp --embed-metadata --embed-subs --embed-chapters --embed-thumbnail --embed-info-json"

# An rsync that respects gitignore
rcp() {
  # -a = -rlptgoD
  #   -r = recursive
  #   -l = copy symlinks as symlinks
  #   -p = preserve permissions
  #   -t = preserve mtimes
  #   -g = preserve owning group
  #   -o = preserve owner
  # -z = use compression
  # -P = show progress on transferred file
  # -J = don't touch mtimes on symlinks (always errors)
  rsync -azPJ \
    --include=.git/ \
    --filter=':- .gitignore' \
    --filter=":- $XDG_CONFIG_HOME/git/ignore" \
    "$@"
}; compdef rcp=rsync
alias rcpd='rcp --delete --delete-after'
alias rcpu='rcp --chmod=go='
alias rcpdu='rcpd --chmod=go='

alias stag='sed -E "s/<[^>]*>//g"'
alias y='wl-copy'
alias p='wl-paste'

alias jc='journalctl -xe'
alias sc=systemctl
alias scu='systemctl --user'
alias ssc='sudo systemctl'

if (( $+commands[eza] )); then
  alias eza="eza --group-directories-first --git";
  alias l="eza -bl";
  alias ll="eza -abghilmu";
  alias lm='ll --sort=modified'
  alias la="LC_COLLATE=C eza -ablF";
  alias tree='eza --tree'
  alias tree_bat='eza --color=always --tree|bat'
  alias fd_non_ascii='fd "[^\u0000-\u007F]+"'  # find non-ascii filenames
fi

if (( $+commands[ddgr] )); then
    alias ddgr="ddgr -n 7";
    alias bang="ddgr --gb --np"
fi

if (( $+commands[7zz] )); then
  alias 7z='7zz'
fi

autoload -U zmv

function take {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

# Documentation related aliases
alias man='batman'
function zman {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}
function tman {
  tldr --color=always "$@"|bat --style=plain
}

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
# Used the zsh/sched module
# TODO: add examples, check ding
function r {
  local time=$1; shift
  echo $time
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched


alias urlencode='python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print (ul.unquote_plus(sys.argv[1]))"'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# fd .env | map dirname
alias map="xargs -n1"


alias latest_dir='ls -tad */ | head -n1'
alias oldest_files='ls -Atr | head -n10'
alias broken_symlinks='find / -xtype l -print'
alias fc-list-mono='fc-list :spacing=mono'
alias cpu_hogs='ps axch -o cmd:15,%cpu --sort=-%cpu | head'
alias memory_hogs='ps_mem -p $(pgrep -d, -u $USER)'

# Print colors from 1 to 255, 0 is background
function print_colors {
  for colour in {1..225}
      do echo -en "\033[38;5;${colour}m38;5;${colour} \n"
  done | column -x
}

function abspath {
  if [ -d "$1" ]; then
      echo "$(cd $1; pwd)"
  elif [ -f "$1" ]; then
      if [[ $1 == */* ]]; then
          echo "$(cd ${1%/*}; pwd)/${1##*/}"
      else
          echo "$(pwd)/$1"
      fi
  fi
}

function pomodoro {
  time="${1:-25m}"
  timer "$time" && piper_speak "Hey Inom, something important is happening now."
}

function relax {
  # 5m break
  timer "5m" && piper_speak "Hey Inom, time to back to work."
}

# The following bash function will compare the file listings from the zip files.
# The listings include verbose output (unzip -v), so checksums can be compared.
# Output is sorted by filename (sort -k8) to allow side by side comparison and
# the diff output expanded (W200) so the filenames are visible int he side by
# side view.
function zipdiff {
  diff -W200 -y <(unzip -vql "$1" | sort -k8) <(unzip -vql "$2" | sort -k8);
}

# TODO: use quick-emu here, test on actual system
function vmconnect {
  local vm_running=$(virsh --connect qemu:///system  list --name --state-running)
  # If $1 not in $vm_running list start
  if [[ ! " $vm_running " =~ " $1 " ]]; then
    echo "Starting virtual machine: $1"
    virsh --connect qemu:///system start "$1"
  fi

  looking-glass-client
}

function nullify {
  "$@" >/dev/null 2>&1
}

function nopen {
  nullify xdg-open "$@" &
}