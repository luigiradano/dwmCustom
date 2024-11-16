-- Keymaps are automatically loaded on the VeryLazy event
--i
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ~/.config/nvim/lua/config/keymaps.lua

-- Keybindings for folding
vim.keymap.set("n", "za", "za", { desc = "Toggle fold" }) -- Toggle fold under cursor
vim.keymap.set("n", "zc", "zc", { desc = "Close fold" }) -- Close fold
vim.keymap.set("n", "zo", "zo", { desc = "Open fold" }) -- Open fold
vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" }) -- Open all folds
vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" }) -- Close all folds
vim.keymap.set("n", "<leader><tab>t", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader><tab>b", "<cmd>tabprevious<cr>", { desc = "Next tab" })
vim.keymap.set("i", "<C-BS>", "db", { noremap = true, desc = "Delete prev. word" })
