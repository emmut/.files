function tm --wraps='tmux a || tmux' --description 'alias tm=tmux a || tmux'
    tmux a || tmux $argv
end
