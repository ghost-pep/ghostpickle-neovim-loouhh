-- Re-enable neo-tree (a tree-style file explorer) and keep telescope-file-browser
-- bound to <leader>fe / <leader>fE. Tree view is launched with <leader>e (cwd).
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = true,
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            -- Drop LazyVim's <leader>fe / <leader>fE so telescope-file-browser keeps them.
            { "<leader>fe", false },
            { "<leader>fE", false },

            { "<leader>e", "<cmd>Neotree toggle filesystem reveal left<cr>", desc = "Explorer (Neo-tree)" },
            { "<leader>E", "<cmd>Neotree toggle filesystem reveal_force_cwd left<cr>", desc = "Explorer cwd (Neo-tree)" },
            { "<leader>be", "<cmd>Neotree toggle buffers right<cr>", desc = "Buffer Explorer (Neo-tree)" },
            { "<leader>ge", "<cmd>Neotree toggle git_status float<cr>", desc = "Git Explorer (Neo-tree)" },
        },
        opts = {
            close_if_last_window = true,
            filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                hijack_netrw_behavior = "open_default",
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
            window = {
                width = 35,
                mappings = {
                    ["<space>"] = "none",
                    ["l"] = "open",
                    ["h"] = "close_node",
                },
            },
            default_component_configs = {
                indent = { with_markers = true },
                git_status = {
                    symbols = {
                        unstaged = "M",
                        staged = "S",
                    },
                },
            },
        },
    },

    -- nui.nvim is a neo-tree dependency; make sure it's enabled too.
    { "MunifTanjim/nui.nvim", enabled = true },
}
