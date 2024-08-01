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
alias td="task next status:pending -WAITING limit:page '(+ACTIVE or +OVERDUE or due:today or scheduled:today or pri:H)'"

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
_read_and_review (){
    title=$(url2title $1)
    project=${2:-inbox}
    echo "$title\n---"
    descr="\"Read and review: $title\""
    id=$(task add +rnr due:eow project:$project "$descr" | sed -n 's/Created task \(.*\)./\1/p')
    task "$id" annotate "$1"
}

alias rnr=_read_and_review

# Taskwarrior TUI
alias tui=taskwarrior-tui