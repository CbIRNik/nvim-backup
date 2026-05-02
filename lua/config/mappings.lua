vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Focus left window" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Focus lower window" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Focus upper window" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Focus right window" }))

map("t", "<C-h>", "<C-\\><C-n><C-w>h", vim.tbl_extend("force", opts, { desc = "Focus left window" }))
map("t", "<C-j>", "<C-\\><C-n><C-w>j", vim.tbl_extend("force", opts, { desc = "Focus lower window" }))
map("t", "<C-k>", "<C-\\><C-n><C-w>k", vim.tbl_extend("force", opts, { desc = "Focus upper window" }))
map("t", "<C-l>", "<C-\\><C-n><C-w>l", vim.tbl_extend("force", opts, { desc = "Focus right window" }))

map("n", "<S-h>", "<cmd>bprevious<CR>", vim.tbl_extend("force", opts, { desc = "Previous buffer" }))
map("n", "<S-l>", "<cmd>bnext<CR>", vim.tbl_extend("force", opts, { desc = "Next buffer" }))
