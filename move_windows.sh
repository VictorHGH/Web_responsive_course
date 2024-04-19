#!/bin/bash

# Function to move window to second monitor for Linux
move_to_second_monitor_linux() {
    
  flatpak run com.google.Chrome --new-window "http://localhost:5173"
  
  # Get the window IDs of the Chrome, Safari, and Terminal windows
  chrome_window_id=$(xdotool search --onlyvisible --class "google-chrome")
  terminal_window_id=$(xdotool search --onlyvisible --class "Terminal")

  # Set the new window size (width x height)
  chrome_new_width=960
  chrome_new_height=1080

  terminal_new_width=960
  terminal_new_height=1080

  # Move the windows to the second monitor
  xdotool windowsize "$chrome_window_id" "$chrome_new_width" "$chrome_new_height"
  xdotool windowmove "$chrome_window_id" 960 0  # Adjust the coordinates as needed

  xdotool windowsize "$terminal_window_id" "$terminal_new_width" "$terminal_new_height"
  xdotool windowmove "$terminal_window_id" 0 0  # Adjust the coordinates as needed
}

# Function to move window to second monitor for macOS
move_to_second_monitor_mac() {
  open -a "Google Chrome" --args --new-window "https://www.google.com"
  open -a "Safari" --args --new-window "https://www.google.com"
  open -a "Terminal"

  # Get the window ID of the Chrome window
  chrome_window_id=$(osascript -e 'tell application "Google Chrome" to id of window 1')
  safari_window_id=$(osascript -e 'tell application "Safari" to id of window 1')
  terminal_window_id=$(osascript -e 'tell application "Terminal" to id of window 1')

  # Set the new window size (width x height)
  chrome_new_width=5760
  chrome_new_height=1080

  safari_new_width=3840
  safari_new_height=1080

  terminal_new_width=1920
  terminal_new_height=1080

  # Move the window to the second monitor
  # This specifies the bounds of the window as a rectangle. The format is {left, top, right, bottom}. In this case, 
  # the left and top coordinates are set to 1920 and 0, respectively, indicating the position of the top-left corner 
  # of the window on the screen. The right and bottom coordinates are calculated based on the width and height of the 
  # window ($chrome_new_width and $chrome_new_height variables).
  osascript -e "tell application \"Google Chrome\" to set bounds of window id $chrome_window_id to {3840, 0, $chrome_new_width, $chrome_new_height}"
  osascript -e "tell application \"Safari\" to set bounds of window id $safari_window_id to {1920, 0, $safari_new_width, $safari_new_height}"
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

