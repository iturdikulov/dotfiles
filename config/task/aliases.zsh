# Taskwarrior aliases
alias t=task
alias ta="task add"
alias tan="task add due:today"
alias tm="task modify"
alias trol="task sch:yes status:pending modify sch:tod"
alias tal='task add dep:"$(task +LATEST uuids)"'
alias rnd='ta +rnd +@computer'

# Report
alias ti="task in limit:20"
alias td_raw="task next \
    rc._forcecolor=on \
    rc.defaultwidth=`tput cols` \
    rc.verbose=affected,blank,context,edit,header,footnote,label,new-id,project,special,sync,recur \
    status:pending -BLOCKED -WAITING \
    '(+ACTIVE or +OVERDUE or due:today or scheduled:today or pri:H)'"
alias td="td_raw|bat --plain"

# Add tickle task function
# Usage example
# tat Monday Count from 1 to 10
tat () {
    local deadline=$1; shift
    task add +tickle wait:$deadline $@
}
alias think='tat +1d'
fin (){
    local task_id=$1
    task $task_id done && td
}
delay (){
    local delay=$1; shift
    task "$@" modify wait:$delay && td
}

# Research and review
# usage: rnr http://cs-syd.eu/posts/2015-07-05-gtd-with-taskwarrior-part-4-processing.html
_read_and_review (){
    title=$(url2title $1)
    project=${2:-inbox}
    echo "$title\n---"
    descr="\"$title\""
    id=$(task add +rnr due:eow project:$project "$descr" | sed -n 's/Created task \(.*\)./\1/p')
    task "$id" annotate "$1"
}

alias rnr=_read_and_review

# Taskwarrior TUI
alias tui=taskwarrior-tui