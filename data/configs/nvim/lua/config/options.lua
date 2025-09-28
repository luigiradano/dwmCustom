-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- ~/.config/nvim/lua/config/options.lua

-- Set folding to use Treesitter
vim.opt.foldmethod = "expr" -- Use expression folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Treesitter as folding expression

-- Set default fold level (all folds open by default)
vim.opt.foldlevel = 99 -- Start with all folds open

-- Optional: Set fold level to start closed (foldlevel=0 will close all folds by default)
vim.opt.foldlevelstart = 99

vim.opt.fillchars = {
  fold = ".", -- Space (empty), can also set to "•" or "·" for a dotted line
  foldopen = ">", -- Icon for open folds
  foldclose = "-", -- Icon for closed folds
  foldsep = "│", -- Separator between folds, optional
}
vim.o.termguicolors = false
vim.o.wrap = false
