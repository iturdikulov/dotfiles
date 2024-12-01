# Taskwarrior aliases
alias t="noglob task"

alias tm="noglob task modify"
alias trol="task sch:yes status:pending modify sch:tod"

alias ta="noglob task add"
alias tan="ta due:today"
alias tal='ta dep:"$(task +LATEST uuids)"'

# Report
alias ti="task in limit:20"
alias td_raw="task next \
    rc._forcecolor=on \
    rc.defaultwidth=`tput cols` \
    rc.verbose=affected,blank,context,edit,header,footnote,label,new-id,project,special,sync,recur \
    status:pending -BLOCKED -WAITING \
    '(+ACTIVE or +OVERDUE or due:today or scheduled:today or pri:H)'"
alias td="td_raw|bat --wrap=never --plain"

# Add tickle task function
# Usage example
# tat Monday Count from 1 to 10
tat () {
    local deadline=$1; shift
    noglob task add +tickle wait:$deadline $@
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

# Taskwarrior TUI
alias tui=taskwarrior-tui