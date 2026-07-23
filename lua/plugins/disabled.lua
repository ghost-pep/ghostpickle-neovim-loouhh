-- Disable LazyVim plugins that aren't needed for a minimal "fast editor" setup.
-- These are dropped at startup; run `:Lazy clean` to actually delete them from disk.
return {
    -- Completion stack (cmp-git not used; uncomment if you want completion in git commit buffers)
    { "petertriho/cmp-git", enabled = false },

    -- UI fluff
    { "akinsho/bufferline.nvim", enabled = false },
    { "folke/noice.nvim", enabled = false },
    { "rcarriga/nvim-notify", enabled = false },
    { "stevearc/dressing.nvim", enabled = false },
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
    { "iamcco/markdown-preview.nvim", enabled = false },
    { "nvimdev/dashboard-nvim", enabled = false },

    -- File tree: neo-tree is configured in plugins/neo-tree.lua;
    -- telescope-file-browser remains available via <leader>fe / <leader>fE.

    -- Editing extras user didn't pick
    { "nvim-mini/mini.ai", enabled = false },
    { "windwp/nvim-ts-autotag", enabled = false },
    { "folke/ts-comments.nvim", enabled = false },
    { "folke/flash.nvim", enabled = false },
    { "MagicDuck/grug-far.nvim", enabled = false },
    { "folke/persistence.nvim", enabled = false },

    -- Formatting / linting
    { "stevearc/conform.nvim", enabled = false },
    { "mfussenegger/nvim-lint", enabled = false },

    -- Treesitter textobjects (the parser itself stays for highlighting)
    { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },

    -- Colorschemes (using built-in default instead)
    { "rebelot/kanagawa.nvim", enabled = false },
    { "folke/tokyonight.nvim", enabled = false },
    { "catppuccin/nvim", enabled = false },
}
