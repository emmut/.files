# Override cd to support multiple dots for going up directories
# Works with zoxide
function cd
    # Check if argument matches dot pattern
    switch "$argv[1]"
        case '...'
            builtin cd ../..
        case '....'
            builtin cd ../../..
        case '.....'
            builtin cd ../../../..
        case '......'
            builtin cd ../../../../..
        case '*'
            # Use zoxide when loaded (interactive only), else plain cd
            if functions -q z
                z $argv
            else
                builtin cd $argv
            end
    end
end

