#!/bin/bash

# Function to move window to second monitor for Linux
 move_to_second_monitor_linux() {
  # Open two instances of Google Chrome with new windows and different URLs
  flatpak run com.google.Chrome "http://localhost:5173" &
  sleep 1
  flatpak run com.google.Chrome --new-window "https://www.udemy.com/" &
  sleep 1

  # Get the window IDs of the Chrome windows and Terminal
  chrome_wmctrl_ids=($(wmctrl -l | grep "Google Chrome" | awk '{print $1}'))
  terminal_wmctrl_id=$(wmctrl -l | grep "Editor" | awk '{print $1}')
  sleep 1

  # Move and resize the first Chrome window to the second half of the first monitor (960 px from the left)
  wmctrl -i -r "${chrome_wmctrl_ids[0]}" -e "0,940,-20,995,1125"

  # Move and resize the second Chrome window to full size of the second monitor (1920 px from the left)
  wmctrl -i -r "${chrome_wmctrl_ids[1]}" -e "0,1950,-20,1950,1125"

  # Move and resize the Terminal window to the first half of the first monitor
  wmctrl -i -r "$terminal_wmctrl_id" -e "0,0,0,960,1100"
}

# Function to move window to second monitor for macOS
move_to_second_monitor_mac() {
  open -a "Google Chrome" "https://www.udemy.com/"
  open -a "Safari" "http://localhost:5173"
  open -a "Terminal"
  sleep 1

  # Get the window ID of the Chrome window
  chrome_window_id=$(osascript -e 'tell application "Google Chrome" to id of window 1')
  safari_window_id=$(osascript -e 'tell application "Safari" to id of window 1')
  terminal_window_id=$(osascript -e 'tell application "Terminal" to id of window 1')

  # Set the new window size (width x height)
  chrome_new_width=3840
  chrome_new_height=1080

  safari_new_width=1920
  safari_new_height=1080

  terminal_new_width=960
  terminal_new_height=1080

  # Move the window to the second monitor
  # This specifies the bounds of the window as a rectangle. The format is {left, top, right, bottom}. In this case, 
  # the left and top coordinates are set to 1920 and 0, respectively, indicating the position of the top-left corner 
  # of the window on the screen. The right and bottom coordinates are calculated based on the width and height of the 
  # window ($chrome_new_width and $chrome_new_height variables).
  osascript -e "tell application \"Google Chrome\" to set bounds of window id $chrome_window_id to {1920, 0, $chrome_new_width, $chrome_new_height}"
  osascript -e "tell application \"Safari\" to set bounds of window id $safari_window_id to {960, 0, $safari_new_width, $safari_new_height}"
  osascript -e "tell application \"Terminal\" to set bounds of window id $terminal_window_id to {0, 0, $terminal_new_width, $terminal_new_height}"
}

# Detect the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    move_to_second_monitor_mac
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    move_to_second_monitor_linux
else
    echo "Unsupported operating system"
    exit 1
fi

