if vim.g.vscode then
    require("config.options")
    require("config.plainautocmds")
else
    require("config.globals")
    require("config.options")
    require("config.plainautocmds")
    require("config.lazy")
end
