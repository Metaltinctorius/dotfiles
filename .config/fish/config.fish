if status is-interactive
#	test -f "/home/nicke/.ghcup/env"
#	source "/home/nicke/.ghcup/env"
end
# THEME PURE #
set fish_function_path /home/nicke/.config/fish/functions/theme-pure/functions/ $fish_function_path
source /home/nicke/.config/fish/functions/theme-pure/conf.d/pure.fish

# DEFAULT EDITOR #
set -gx EDITOR emacsclient -c -a 'emacs'


# ALIASES #
alias emacsc="emacsclient -c -a 'emacs'"
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias xmonc="emacsclient -c -a 'emacs'~/.xmonad/xmonad.hs"
