vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=3")
vim.cmd("set shiftwidth=3")

vim.g.autoformat = true

local opt = vim.opt
-- config tabs
opt.expandtab = true      -- Use spaces instead of tabs

opt.number = true         -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true     -- Enable highlighting of the current line
opt.linebreak = true      -- Wrap lines at convenient points
opt.list = true           -- Show some invisible characters (tabs...
opt.mouse = "a"           -- Enable mouse mode
