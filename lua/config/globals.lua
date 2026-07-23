vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable unused providers (skips slow startup probes on Windows)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Faster lua loader (uses bytecode cache)
if vim.loader then
    vim.loader.enable()
end
