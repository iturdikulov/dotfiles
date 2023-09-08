#!/usr/bin/env bash
LANGUAGES=$(cat <<-END
golang
solidity
vlang
v
nodejs
javascript
tmux
typescript
zsh
cpp
c
lua
rust
python
bash
php
haskell
ArnoldC
css
html
gdb
END
)

COMMANDS=$(cat <<-END
find
man
tldr
sed
awk
tr
cp
ls
grep
xargs
rg
ps
mv
kill
lsof
less
head
tail
tar
cp
rm
rename
jq
cat
ssh
cargo
git
git-worktree
git-status
git-commit
git-rebase
docker
docker-compose
stow
chmod
chown
make
END
)

selected=`echo "$LANGUAGES\n$COMMANDS" | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi