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
alias wget='wget -c'
alias wget_warc='wget --delete-after --no-directories --warc-file=epfl --recursive --level=1'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias info='info --vi-keys' # Info vi mode
alias watch='watch --color' # Color using watch
alias chown="chown --preserve-root" # Do not do chown for root directory
alias chmod="chmod --preserve-root"
alias E="SUDO_EDITOR=nvim sudo -e"

alias mk=make
alias gurl='curl --compressed'

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

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

alias y='xclip -selection clipboard -in'
alias p='xclip -selection clipboard -out'

alias jc='journalctl -xe'
alias sc=systemctl
alias ssc='sudo systemctl'

if (( $+commands[exa] )); then
  alias exa="exa --group-directories-first --git";
  alias l="exa -blF";
  alias ll="exa -abghilmu";
  alias llm='ll --sort=modified'
  alias la="LC_COLLATE=C exa -ablF";
  alias tree='exa --tree'
fi

if (( $+commands[fasd] )); then
  # fuzzy completion with 'z' when called without args
  unalias z 2>/dev/null
  function z {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }
fi

autoload -U zmv

function take {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

function zman {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
  local time=$1; shift
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched


# # Network
# # =======
# alias mylocalip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
# alias myips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
# alias ifactive="ifconfig -a" # Show active network interfaces
# alias flush="sudo systemctl restart systemd-resolved" # Flush Directory Service cache
# # URL-encode strings, usage: `urlencode "http://www.google.com/?q=Shell Script"`
# alias urlencode='python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"'
# # Download images from current page using wget
# # -nd no create directories, -P prefix, -A accept, -r recursive, -l depth
# alias get_images='wget -nd -r -l 1 -P . -A jpeg,jpg,bmp,gif,png'
# alias get_audio="yt-dlp -N 5 -f 'ba' -o '%(id)s-%(title)s.%(ext)s'"
# alias generate_playlist="fd . --base-directory=$HOME/Music -E archive -E '*.m3u' -t f > ~/Music/all.m3u"
#
# # Intuitive map function
# # For example, to list all directories that contain a certain file:
# # find . -name .gitattributes | map dirname
# alias map="xargs -n1"
#
# # Hardware
# # =========
# # Grep data from temp sensors
# alias systemperatures='sudo hddtemp /dev/disk/by-id/*ata*part1; sudo sensors'
# alias cpuinfo='cat /proc/cpuinfo'
# alias meminfo='cat /proc/meminfo'
# alias mem='smem -ktP ' # Get process total memory usage, with shared memory divided proportionally
# alias autorandr_save="autorandr --force --save default" # Save monitor configuration
#
#
# # Work with files
# # ======
# # Print each PATH entry on a separate line
# alias path='echo -e ${PATH//:/\\n}'
# alias latest_file='/usr/bin/ls -tap | grep -v / | head -n1'
# alias latest_dir='/usr/bin/ls -tad */ | head -n1'
# alias oldest_files='find -type f -printf "%T+ %p\n" | sort'
# alias fzf_history='cat ~/.cache/ytfzf/watch_hist | jq  ".[].title,.[].url"|tail -n 20'
#
# # Mount and unmount Kindle
# alias koreader_mount='sshfs -o ssh_command="ssh -p 2222" root@koreader:/mnt/us/documents ~/public/koreader/'
# alias koreader_umount='umount ~/public/koreader'
#
# # Merge PDF files, preserving hyperlinks
# # Usage: `mergepdf input{1,2,3}.pdf`
# alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'
#
# # Rename all files with numbers
# alias rename_all_numbers='ls -v | cat -n | while read n f; do mv -n "$f" "$n.ext"; done'
#
# # Merge, split or and manipulate audiobook files with chapters
# alias m4b-tool-merge='docker run -it --rm -u $(id -u):$(id -g) -v "$(pwd)":/mnt sandreas/m4b-tool:latest merge -v --jobs=6 --output-file="output/" --batch-pattern="input/%g/%a/%n/" "input/"'
#
# # Ripgrep over epub files
# alias rga_epub='rga --rga-adapters=pandoc'
#
# # Interactive helpers
# # ====================
# # Howdoi - stackoverflow from the terminal
# alias h='function hdi(){ howdoi $* -c -n 3|sed 's/================================================================================/=================================/g'|bat -p; }; hdi'
#
#
#
#
# # Operation system and MAINTENANCE
# # =================
# #
# alias systemd_timers="systemctl list-timers --all"
# alias systemd_services="systemctl list-units --type=service --all"
# alias failed_services='systemctl --failed'
# alias failed_user_services='systemctl --user --failed'
#
# alias xprop_hold='$TERMINAL --hold -e xprop' # get window info
# alias xprop_class="xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) WM_CLASS|xclip -selection c"
# alias broken_symlinks='sudo find / -xtype l -print'
# alias packages_sync_database='pikaur -Syuw'
# alias kernel_log='journalctl -o short-precise -k'
# alias packages_list='expac "%n %m" -l'\n' -Q $(pacman -Qq) | sort -rhk 2 | less'
# alias packages_clean='pikaur -Sc'
# alias packages_upgrade='pikaur -Syu'
# alias packages_orphans_clean='pacman -Qtdq | sudo pacman -Rns -'
# alias fonts_mono='fc-list :spacing=mono family style | sort'
# alias fonts_all='fc-list | sort'
# alias lastboot_log='journalctl -b -1 -n' # inspect previous boot
# alias regenerate_initramfs='sudo mkinitcpio -P'
# alias regenerate_grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
# # Connect to win10 machine
# alias vmconnect='virsh --connect qemu:///system start win10 & virt-viewer -c qemu:///system --attach -f win10'
# stouch() {
#       mkdir -p "$(dirname "$1")" && touch "$1"
# }
#
# colors() {
#       local fgc bgc vals seq0
#
#       printf "Color escapes are %s\n" '\e[${value};...;${value}m'
#       printf "Values 30..37 are \e[33mforeground colors\e[m\n"
#       printf "Values 40..47 are \e[43mbackground colors\e[m\n"
#       printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"
#
#       # foreground colors
#       for fgc in {30..37}; do
#               # background colors
#               for bgc in {40..47}; do
#                       fgc=${fgc#37} # white
#                       bgc=${bgc#40} # black
#
#                       vals="${fgc:+$fgc;}${bgc}"
#                       vals=${vals%%;}
#
#                       seq0="${vals:+\e[${vals}m}"
#                       printf "  %-9s" "${seq0:-(default)}"
#                       printf " ${seq0}TEXT\e[m"
#                       printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
#               done
#               echo; echo
#       done
# }
#
# #
# # # ex - archive extractor
# # # usage: ex <file>
# ex ()
# {
#   if [ -f $1 ] ; then
#   case $1 in
#     *.tar.bz2)   tar xjf $1   ;;
#     *.tar.gz)    tar xzf $1   ;;
#     *.bz2)       bunzip2 $1   ;;
#     *.rar)       unrar x $1     ;;
#     *.gz)        gunzip $1    ;;
#     *.tar)       tar xf $1    ;;
#     *.tbz2)      tar xjf $1   ;;
#     *.tgz)       tar xzf $1   ;;
#     *.zip)       unzip $1     ;;
#     *.Z)         uncompress $1;;
#     *.7z)        7z x $1      ;;
#     *)           echo "'$1' cannot be extracted via ex()" ;;
#   esac
#   else
#   echo "'$1' is not a valid file"
#   fi
# }
#
# # Create a new directory and enter it
# function mkd() {
# 	mkdir -p "$@" && cd "$_";
# }
#
# # Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
# function targz() {
# 	local tmpFile="${@%/}.tar";
# 	tar -cvf "${tmpFile}" --exclude="tmp/" "${@}" || return 1;
#
# 	size=$(
# 		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
# 		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
# 	);
#
# 	local cmd="";
# 	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
# 		# the .tar file is smaller than 50 MB and Zopfli is available; use it
# 		cmd="zopfli";
# 	else
# 		if hash pigz 2> /dev/null; then
# 			cmd="pigz";
# 		else
# 			cmd="gzip";
# 		fi;
# 	fi;
#
# 	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
# 	"${cmd}" -v "${tmpFile}" || return 1;
# 	[ -f "${tmpFile}" ] && rm "${tmpFile}";
#
# 	zippedSize=$(
# 		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
# 		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
# 	);
#
# 	echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
# }
#
# # Determine size of a file or total size of a directory
# function fs() {
# 	if du -b /dev/null > /dev/null 2>&1; then
# 		local arg=-sbh;
# 	else
# 		local arg=-sh;
# 	fi
# 	if [[ -n "$@" ]]; then
# 		du $arg -- "$@";
# 	else
# 		du $arg .[^.]* ./*;
# 	fi;
# }
#
# # Use Git’s colored diff when available
# hash git &>/dev/null;
# if [ $? -eq 0 ]; then
# 	function git_diff() {
# 		git diff --no-index --color-words "$@";
# 	}
# fi;
#
# # Create a data URL from a file
# function dataurl() {
# 	local mimeType=$(file -b --mime-type "$1");
# 	if [[ $mimeType == text/* ]]; then
# 		mimeType="${mimeType};charset=utf-8";
# 	fi
# 	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
# }
#
# # Run `dig` and display the most useful info
# function digga() {
# 	dig +nocmd "$1" any +multiline +noall +answer;
# }
#
# # Show all the names (CNs and SANs) listed in the SSL certificate
# # for a given domain
# function getcertnames() {
# 	if [ -z "${1}" ]; then
# 		echo "ERROR: No domain specified.";
# 		return 1;
# 	fi;
#
# 	local domain="${1}";
# 	echo "Testing ${domain}…";
# 	echo ""; # newline
#
# 	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
# 		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);
#
# 	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
# 		local certText=$(echo "${tmp}" \
# 			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
# 			no_serial, no_sigdump, no_signame, no_validity, no_version");
# 		echo "Common Name:";
# 		echo ""; # newline
# 		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
# 		echo ""; # newline
# 		echo "Subject Alternative Name(s):";
# 		echo ""; # newline
# 		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
# 			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
# 		return 0;
# 	else
# 		echo "ERROR: Certificate not found.";
# 		return 1;
# 	fi;
# }
#
# # `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# # the `.git` directory, listing directories first. The output gets piped into
# # `less` with options to preserve color and line numbers, unless the output is
# # small enough for one screen.
# function tre() {
# 	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
# }
#
# function abspath() {
#   if [ -d "$1" ]; then
#       echo "$(cd $1; pwd)"
#   elif [ -f "$1" ]; then
#       if [[ $1 == */* ]]; then
#           echo "$(cd ${1%/*}; pwd)/${1##*/}"
#       else
#           echo "$(pwd)/$1"
#       fi
#   fi
# }
# alias abspath="abspath "
#
# git_rm_cached(){
#   git rm -r --cached .
#   git add .
# }
#
# function gccd { git clone "$1" && cd "$(basename $1)"; }
#
# fzfman() {
# 	packages="$(awk {'print $1'} <<< $(pacman -Ss $1 | awk 'NR%2 {printf "\033[1;32m%s \033[0;36m%s\033[0m — ",$1,$2;next;}{ print substr($0, 5, length($0) - 4); }' | fzf -m --ansi --select-1))"
# 	[ "$packages" ] && pacman -S $(echo "$packages" | tr "\n" " ")
# }
#
# # The following bash function will compare the file listings from the zip files. The listings include verbose output (unzip -v), so checksums can be compared. Output is sorted by filename (sort -k8) to allow side by side comparison and the diff output expanded (W200) so the filenames are visible int he side by side view.
# function zipdiff() { diff -W200 -y <(unzip -vql "$1" | sort -k8) <(unzip -vql "$2" | sort -k8); }
#
# countdown() {
#   start="$(( $(date '+%s') + $1))"
#   while [ $start -ge $(date +%s) ]; do
#       time="$(( $start - $(date +%s) ))"
#       printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
#       sleep 0.1
#   done
# }
#
# stopwatch() {
#   start=$(date +%s)
#   while true; do
#       time="$(( $(date +%s) - $start))"
#       printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
#       sleep 0.1
#   done
# }
#
# # Initialize file at give path (better touch)
# t() { mkdir -pv "$(dirname "$1")" && touch "$1"; $EDITOR "$1"; }
#
# transfer() {
#   curl --progress-bar --upload-file "$1" https://transfer.sh/$(basename "$1") | xclip -selection clipboard && notify-send  "File uploaded $(xclip -selection clipboard -o)";
#   echo
# }
#
#
# function mergemp4() {
#   #######################################
#   # Merge mp4 files into one output mp4 file
#   # usage:
#   #   mergemp4 #merges all mp4 in current directory
#   #   mergemp4 video1.mp4 video2.mp4
#   #   mergemp4 video1.mp4 video2.mp4 [ video3.mp4 ...] output.mp4
#   #######################################
#   if [ $# = 1 ]; then return; fi
#
#   outputfile="output.mp4"
#
#   #if no arguments we take all mp4 in current directory as array
#   if [ $# = 0 ]; then inputfiles=($(ls -1v *.mp4)); fi
#   if [ $# = 2 ]; then inputfiles=($1 $2); fi
#   if [ $# -ge 3 ]; then
#   outputfile=${@: -1} # Get the last argument
#   inputfiles=(${@:1:$# - 1}) # Get all arguments besides last one as array
#   fi
#
#   # -y: automatically overwrite output file if exists
#   # -loglevel quiet: disable ffmpeg logs
#   ffmpeg -y \
#   -loglevel quiet \
#   -f concat \
#   -safe 0 \
#   -i <(for f in $inputfiles; do echo "file '$PWD/$f'"; done) \
#   -c copy $outputfile
#
#   if test -f "$outputfile"; then echo "$outputfile created"; fi
# }
#
# function mem_total(){
#   ps_mem -S -p $(pgrep "$1"|head -n 1)
# }
#
# lfiles() {
#   files="$(fzf --query="$1" --multi --select-1 --exit-0)"
#   if test -n "$files"; then
#       xdg-open "$files"
#   fi
# }
#
# function sync_with_ignore() {
#   rsync -av --delete --exclude-from=.gitignore "$@"
# }
#
#
# function get_local_projects() {
#   prj_path=$HOME/Projects
#   selected_dir=$(
#   find $prj_path/* -maxdepth 1 -mindepth 1 -type d |
#     sed "s~$prj_path/~~" |
#     fzf-tmux -p --cycle --layout=reverse --prompt 't> ' |
#     sed "s~^~$prj_path/~"
#   )
#
#   if test -n "$selected_dir"; then
#   tab_name=$(echo $selected_dir | sed "s~$prj_path/~~")
#   kitty @ focus-tab --match title:$tab_name 2>/dev/null || kitty @ new-window --new-tab --tab-title $tab_name --cwd $selected_dir
#   fi
# }
#
# # Copy path to file
# function link2clip() {
#   readlink -f $1 | xsel --clipboard
# }
#
# # Upload image to imgur
# function link2imgur() {
#   imgur $(readlink -f "$@")
# }
#
# # Download page recursive
# wget-recursive() wget \
#    --recursive \
#    -l 2 \
#    -A jpg,jpeg,png,gif \
#    -e robots=off \
#    --page-requisites \
#    --no-directories \
#    --html-extension \
#    --convert-links \
#    --restrict-file-names=windows \
#    --domains $1 \
#    --no-parent \
#    "$2"
#
#
# audio-join() {
#   ffmpeg -i "concat:${(j:|:)@[2,-1]}" -acodec copy $1
# }
#
# # Upload clipboard to imgur
# imgur-xclip() {
#   xclip -selection c -o | imgur && icat $(xclip -selection c -o)
# }
#
# # Check if 'venv' directory exists and activate it or create a new one
# python-venv() {
#   if [ -d "venv" ]
#   then
#       echo "Activating existing virtual environment..."
#       source venv/bin/activate
#       which python
#   else
#       echo "Creating new virtual environment..."
#       # Create a new virtual environment named 'venv'
#       python3 -m venv venv
#       # Activate the virtual environment
#       source venv/bin/activate
#       which python
#   fi
# }
#
# # Convert url to pdf
# chrome2pdf() {
#   chromium --headless --no-margins --disable-gpu \
#            --print-to-pdf-no-header \
#            --print-to-pdf="$2" $1
# }
#
# # Pick color using gpick
# color-picker() {
#   selected_color="$(gpick -o -s)"
#
#   [ -z "$selected_color" ] || {
#     echo "$selected_color" | xclip -sel c
#   }
# }
#
# # Pick color using maim
# average-color-picker() {
#   color=$(maim -st 0 | convert - -resize 1x1\! -format "#%[hex:u]\n" info:-)
#   xclip -selection clipboard <<< "$color"
# }
#
# # Pick recent file opened in Zathura
# zathura-recent() {
#   recent_file=$(cat ~/.local/share/zathura/history|grep -Po '\[\K[^\]]*'|dmenu -i)
#   zathura "$recent_file"
# }
#
# # Epub to pdf
# epub2pdf() {
#     pandoc -s --toc --top-level-division=chapter \
#            -V geometry:a4paper -V linkcolor:teal \
#            -V geometry:margin=1in --pdf-engine=wkhtmltopdf \
#            "$1" -o "$2"
# }
#
# # Set speed and duplex
# eth_speed() {
#   sudo ethtool -s $1 autoneg off speed $2 duplex full && sudo ethtool $1 | grep Speed
# }
