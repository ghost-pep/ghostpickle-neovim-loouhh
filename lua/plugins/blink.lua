-- blink.cmp tweaks: Tab navigates / triggers completion, Shift-Tab navigates back.
-- LazyVim 15.x replaced nvim-cmp with blink.cmp; this file replaces the old cmp.lua.
return {
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.is_visible() then
                            return cmp.select_next()
                        end
                        if cmp.snippet_active({ direction = 1 }) then
                            return cmp.snippet_forward()
                        end
                        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                        local has_words_before = col ~= 0
                            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                        if has_words_before then
                            return cmp.show()
                        end
                    end,
                    "fallback",
                },
                ["<S-Tab>"] = {
                    function(cmp)
                        if cmp.is_visible() then
                            return cmp.select_prev()
                        end
                        if cmp.snippet_active({ direction = -1 }) then
                            return cmp.snippet_backward()
                        end
                    end,
                    "fallback",
                },
            },
        },
    },
}
