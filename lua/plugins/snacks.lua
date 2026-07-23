-- Disable all snacks.nvim animations: smooth scroll on G/<C-d>/<C-u>,
-- animated indent scope, dim, etc. Everything jumps instantly.
return {
    {
        "folke/snacks.nvim",
        opts = {
            animate = { enabled = false },
            scroll = { enabled = false },
            indent = { animate = { enabled = false } },
            dim = { enabled = false },
        },
    },
}
