-- Telescope extensions: file-browser (replaces a file tree), undo history.
-- Trouble + todo-comments are re-enabled in disabled.lua so their default LazyVim
-- keymaps come back (<leader>xx for diagnostics list, <leader>st for TODOs).
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-file-browser.nvim",
            "debugloop/telescope-undo.nvim",
        },
        keys = {
            {
                "<leader>fe",
                "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
                desc = "File Browser (buffer dir)",
            },
            { "<leader>fE", "<cmd>Telescope file_browser<CR>", desc = "File Browser (cwd)" },
            { "<leader>su", "<cmd>Telescope undo<CR>", desc = "Undo History" },
        },
        opts = {
            extensions = {
                file_browser = {
                    hijack_netrw = true,
                    grouped = true,
                    respect_gitignore = false,
                    hidden = { file_browser = true, folder_browser = true },
                },
            },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            pcall(telescope.load_extension, "fzf")
            telescope.load_extension("file_browser")
            telescope.load_extension("undo")
        end,
    },
}
