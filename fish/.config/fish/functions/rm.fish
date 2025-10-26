function rm --wraps=trash --wraps='trash -v' --description 'alias rm=trash -v'
    trash -v $argv
end
