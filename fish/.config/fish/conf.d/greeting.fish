function fish_greeting
  echo "   ________  ________  ________  ________  ________ "
  echo "  /        \\/        \\/        \\/    /   \\/        \\"
  echo " /         /         /         /         /        _/"
  echo "/        _/         /         /         //       /  "
  echo "\\________/\\__/__/__/\\__/__/__/\\________/ \\______/   "
  printf "\n"
  printf "// $(whoami) // uptime $(uptime | sed -E 's/.*up *([^,]+).*/\1/') //"
  printf "\n"
end
