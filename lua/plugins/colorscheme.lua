-- Minimal Dark+ theme that mirrors Windows Terminal's "Dark+" scheme,
-- with a transparent background so the terminal shows through.

local transparent_groups = {
    "Normal", "NormalNC", "NormalFloat",
    "FloatBorder", "FloatTitle",
    "SignColumn",
    "EndOfBuffer",
    "StatusLine", "StatusLineNC",
    "LineNr", "CursorLineNr",
    "WinSeparator", "VertSplit",
    "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb",
    "TabLine", "TabLineFill", "TabLineSel",
    "MsgArea",

    "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
    "NeoTreeFloatNormal", "NeoTreeFloatBorder", "NeoTreeWinSeparator",

    "SnacksDashboardNormal",
    "SnacksPicker", "SnacksPickerInput", "SnacksPickerList",
    "SnacksPickerPreview", "SnacksPickerBorder",
    "SnacksNotifierNormal", "SnacksNotifierBorder",

    "BlinkCmpMenu", "BlinkCmpMenuBorder",
    "BlinkCmpDoc", "BlinkCmpDocBorder",
    "BlinkCmpSignatureHelp", "BlinkCmpSignatureHelpBorder",

    "TelescopeNormal", "TelescopeBorder",
    "TelescopePromptNormal", "TelescopePromptBorder",
    "TelescopeResultsNormal", "TelescopeResultsBorder",
    "TelescopePreviewNormal", "TelescopePreviewBorder",
}

local function apply_transparency()
    for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
    -- Subtle column marker that still reads against the transparent bg.
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2a2a2a" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("terminal_transparent_bg", { clear = true }),
    callback = apply_transparency,
})

return {
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "dark",
            transparent = true,
            italic_comments = true,
            disable_nvimtree_bg = true,
        },
        config = function(_, opts)
            require("vscode").setup(opts)
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = { colorscheme = "vscode" },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.options = opts.options or {}
            opts.options.theme = "vscode"
            return opts
        end,
    },
}
