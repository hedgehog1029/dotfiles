# hedgehog1029's theme

# Color shortcuts
R=$fg_no_bold[red]
B=$fg_no_bold[blue]
M=$fg_no_bold[magenta]
RESET=$reset_color

local return_side="%(?..%{$R%}%? ↵  %{$RESET%})"

function gitStatusF() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(%B${ref#refs/heads/}%b%{$RESET%}) "
}

# Prompt
PROMPT='%B%2~%b $(gitStatusF)%{$M%}➥ %{$RESET%}'
RPS1="${return_side}"

