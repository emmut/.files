function lt --wraps='ls -a --tree --icons --level=2 -I .git|node_modules' --description 'alias lt=ls -a --tree --icons --level=2 -I .git|node_modules'
    ls -a --tree --icons --level=2 -I '.git|node_modules' $argv
end
