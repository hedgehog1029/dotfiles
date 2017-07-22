# hedgehog1029's theme

# Color shortcuts
R=$fg_no_bold[red]
B=$fg_no_bold[blue]
M=$fg_no_bold[magenta]
RESET=$reset_color

local return_side="%(?..%{$R%}%? ↵  %{$RESET%})"

function gitStatusF() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    user=$(git remote -v | grep "fetch" | cut -d'/' -f 4) || return
    repo=$(git remote -v | grep "fetch" | cut -d'/' -f 5 | cut -d'.' -f 1) || return
    echo "(%B${ref#refs/heads/}%b%{$RESET%}) "
}

# Prompt
PROMPT='%B%2~%b $(gitStatusF)%{$M%}➥ %{$RESET%}'
RPS1="${return_side}"
