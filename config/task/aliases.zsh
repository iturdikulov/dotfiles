# Taskwarrior aliases
alias t=task
alias ta="task add"
alias tan="task add scheduled:today"
alias tm="task modify"
alias trol="task sch:yes status:pending modify sch:tod"
alias tal='task add dep:"$(task +LATEST uuids)"'
alias rnd='ta +rnd +@computer'

# Report
alias ti="task in -next"
alias tn="task +now"
alias td='task next +ACTIVE or +OVERDUE or due:today or scheduled:today or pri:H'

# Add tickle task function
# Usage example
# tat Monday Count from 1 to 10
tat () {
    local deadline=$1; shift
    task add +tickle wait:$deadline $@
}
alias think='tat +1d'

# Research and review
# usage: rnr http://cs-syd.eu/posts/2015-07-05-gtd-with-taskwarrior-part-4-processing.html
rnr (){
    local descr="\"Read and review: $1\""
    local id=$(task add +next +rnr "$descr" | sed -n 's/Created task \(.*\)./\1/p')
    task $id
}

# Taskwarrior TUI
alias tui=taskwarrior-tui