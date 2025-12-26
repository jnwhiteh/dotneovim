-- Leader key (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Line wrapping
opt.wrap = false

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "120"

-- Misc
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.updatetime = 250
opt.timeoutlen = 300
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"
opt.showmode = false -- statusline handles this
opt.completeopt = "menu,menuone,noselect"
