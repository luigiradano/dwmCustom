#!/bin/bash

add_luigi_user() {
  if id -u "luigi" &>/dev/null; then
    echo "User 'luigi' already exists."
  else
    echo "Adding user 'luigi'..."
    sudo adduser luigi
    if [[ $? -ne 0 ]]; then
      echo "Error: Failed to add user 'luigi'."
      return 1
    fi
    echo "User 'luigi' added successfully."
    echo "Adding password to user luigi"
    sudo passwd luigi
    sudo usermod -aG wheel luigi
    sudo usermod -aG sudo luigi
    mkdir /home/luigi
  fi
  return 0
}

# Example usage:
add_luigi_user
