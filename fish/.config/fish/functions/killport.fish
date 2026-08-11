function killport --description 'Kill process listening on specified port(s)'
    if test (count $argv) -eq 0
        echo "Usage: killport PORT [PORT2 PORT3 ...]"
        echo "Example: killport 3000"
        echo "Example: killport 3000 3001 3002"
        return 1
    end

    for port in $argv
        set pids (lsof -ti :$port 2>/dev/null)
        
        if test -z "$pids"
            echo "No process found on port $port"
        else
            for pid in $pids
                set process_info (ps -p $pid -o comm= 2>/dev/null)
                if kill $pid 2>/dev/null
                    echo "✓ Killed process $pid ($process_info) on port $port"
                else
                    echo "✗ Failed to kill process $pid on port $port (try sudo?)"
                end
            end
        end
    end
end
