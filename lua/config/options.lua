-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

opt.wrap = true

opt.smartindent = true
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("LOCALAPPDATA") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.scrolloff = 8

opt.updatetime = 50
opt.colorcolumn = "120"

opt.shell = "pwsh.exe"
opt.shellxquote = ""
opt.shellcmdflag = "-NoLogo -NoProfile -Command "
opt.shellquote = ""
opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
