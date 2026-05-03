vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.formatoptions = "qrn1"
vim.opt.showmode = true
vim.opt.updatetime = 100
vim.wo.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.wo.linebreak = true
vim.opt.virtualedit = "block"
vim.opt.undofile = true

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Shorter messages
vim.opt.shortmess:append("c")

-- Indetation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

-- Fillchars
vim.opt.fillchars = {
  vert = "│",
  fold = " ",
  eob = " ",
  diff = "╱",
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸"
}

