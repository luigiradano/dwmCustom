install_lazyvim() {
  local lazyvim_repo="LazyVim/LazyVim"
  local lazyvim_dir="$HOME/.config/nvim"

  if [[ -d "$lazyvim_dir" ]]; then
    read -p "LazyVim is already installed. Do you want to overwrite it? (y/n): " overwrite
    if [[ "$overwrite" != "y" ]]; then
      echo "Installation cancelled."
      return 1
    fi
    echo "Removing existing LazyVim installation..."
    rm -rf "$lazyvim_dir"
  fi

  echo "Installing LazyVim..."

  git clone --depth 1 "https://github.com/$lazyvim_repo" "$lazyvim_dir"

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
