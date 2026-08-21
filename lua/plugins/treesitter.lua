-- Markdown fenced-code-block highlighting.
--
-- Neovim highlights a fenced block by reading its info string (the text right
-- after the ```), resolving it through `vim.treesitter.language.get_lang()`,
-- and injecting that parser. If the label isn't a known parser name and has no
-- registered alias, the block gets no inner highlighting.
--
-- The `cpp`, `c_sharp` and `rust` parsers come from the clangd / dotnet / rust
-- LazyVim extras, so ```cpp / ```csharp / ```cs / ```rust already work. This
-- spec adds the common alternate labels and a best-effort MIDL3 mapping.
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "markdown",
                "markdown_inline",
                "bicep",
                "cpp",
                "c_sharp",
                "rust",
            })

            local register = vim.treesitter.language.register

            -- C++: ```cpp already works; add the other spellings.
            register("cpp", { "c++", "cxx", "cc" })

            -- C#: ```csharp / ```cs already work; add the literal ```c#.
            register("c_sharp", { "cs", "csharp", "c#" })

            -- Rust: ```rust already works; add the short ```rs.
            register("rust", { "rs" })

            -- Use the Bicep parser for both templates and parameter files.
            register("bicep", { "bicep", "bicep-params" })

            -- IDL (MIDL3): no dedicated tree-sitter grammar exists. MIDL3 is
            -- intentionally C#-shaped (namespace / runtimeclass / interface /
            -- attributes), so approximate it with the c_sharp parser. This also
            -- applies to real *.idl files. To stop hijacking real .idl files,
            -- drop "idl" here and keep only the ```midl / ```midl3 fence labels.
            register("c_sharp", { "idl", "midl", "midl3" })
        end,
    },
}
