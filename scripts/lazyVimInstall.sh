install_lazyvim() {
  local lazyvim_repo="LazyVim/starter"
  local lazyvim_dir="$HOME/.config/nvim"

  if [[ -d "$lazyvim_dir" ]]; then
    read -p "LazyVim is already installed. Do you want to overwrite it? (y/n): " overwrite
    if [[ "$overwrite" != "y" ]]; then
      echo "Installation cancelled."
      return 1
    fi
    echo "Removing existing LazyVim installation..."
    rm -rf "$lazyvim_dir"
    rm -rf "$HOME/.local/share/nvim/lazy"
    sudo rm -rf "/usr/local/share/nvim/lazy"
  fi

  echo "Installing LazyVim..."

  git clone "https://github.com/$lazyvim_repo" "$lazyvim_dir"
  rm -rf "$lazyvim_dir/.git"

  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to clone LazyVim repository."
    return 1
  fi

  echo "LazyVim installed successfully!"
  echo "You can now open nvim."
  return 0
}

# Example usage (you can call this function from your script or terminal)
install_lazyvim
cp ../data/configs/lua/ "$HOME/.config/nvim/lua/" -r
