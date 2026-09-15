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
            # Use zoxide for everything else
            z $argv
    end
end

