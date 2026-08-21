-- Add LSP servers for languages that don't have a dedicated LazyVim extra.
local function bicep_lsp_cmd()
    local home = vim.fn.expand("$HOME")
    local candidates = {}
    for _, root in ipairs({ ".vscode", ".vscode-insiders" }) do
        local pattern = table.concat({
            home,
            root,
            "extensions",
            "ms-azuretools.vscode-bicep-*",
            "bicepLanguageServer",
            "Bicep.LangServer.exe",
        }, "/")
        vim.list_extend(candidates, vim.fn.glob(pattern, false, true))
    end

    table.sort(candidates, function(left, right)
        local left_stat = vim.uv.fs_stat(left)
        local right_stat = vim.uv.fs_stat(right)
        local left_mtime = left_stat and left_stat.mtime.sec or 0
        local right_mtime = right_stat and right_stat.mtime.sec or 0
        return left_mtime == right_mtime and left < right or left_mtime < right_mtime
    end)

    return { candidates[#candidates] or "bicep-lsp" }
end

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                bashls = {
                    filetypes = { "sh", "bash", "zsh" },
                },
                -- `up` installs the VS Code Bicep extension that ships this server.
                bicep = {
                    cmd = bicep_lsp_cmd(),
                    mason = false,
                },
                powershell_es = {
                    filetypes = { "ps1", "psm1", "psd1" },
                    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
                },

                -- The LazyVim dotnet extra enables omnisharp by default, but
                -- omnisharp doesn't understand .slnx (the solution format used
                -- by aifabric). Disable it so roslyn.nvim is the only C#
                -- server that attaches.
                omnisharp = {
                    enabled = false,
                },

                -- Override the LazyVim clangd defaults so we can:
                --  * pin the executable to a clangd that's new enough for the
                --    repo's MSVC STL (which static_asserts that the compiler is
                --    Clang 20 or newer). The Mason "clangd" package can lag.
                --  * provide clang-style fallback flags for headers/files not
                --    in compile_commands.json.
                clangd = {
                    cmd = (function()
                        local candidates = {}
                        -- Manually-installed standalone clangd 20+ (64-bit).
                        -- The VS-bundled clangd at $VCINSTALLDIR\Tools\Llvm is
                        -- 32-bit on Windows and OOMs while parsing files in
                        -- aifabric (preambles are ~180 MB + AST won't fit in
                        -- 4 GB of virtual address space).
                        table.insert(candidates, vim.fn.expand("$LOCALAPPDATA/clangd-22/clangd_20.1.8/bin/clangd.exe"))
                        -- Other locations to try, in preference order.
                        for _, env in ipairs({ "VCINSTALLDIR" }) do
                            local v = vim.env[env]
                            if v and v ~= "" then
                                table.insert(candidates, v .. "\\Tools\\Llvm\\x64\\bin\\clangd.exe")
                            end
                        end
                        local on_path = vim.fn.exepath("clangd")
                        if on_path ~= "" then table.insert(candidates, on_path) end
                        table.insert(candidates, vim.fn.stdpath("data") .. "/mason/bin/clangd.cmd")

                        local function is_x64(exe)
                            local f = io.open(exe, "rb")
                            if not f then return false end
                            f:seek("set", 60)
                            local hi, lo = f:read(2):byte(1, 2)
                            local pe = (hi or 0) + (lo or 0) * 256
                            f:seek("set", pe + 4)
                            local m1, m2 = f:read(2):byte(1, 2)
                            f:close()
                            return (m1 + m2 * 256) == 0x8664
                        end
                        local function clangd_major(exe)
                            local out = vim.fn.system({ exe, "--version" })
                            return tonumber(out:match("clangd version (%d+)"))
                        end

                        local chosen
                        for _, exe in ipairs(candidates) do
                            if vim.fn.executable(exe) == 1 and is_x64(exe) then
                                local major = clangd_major(exe)
                                if major and major >= 20 then
                                    chosen = exe
                                    break
                                end
                            end
                        end
                        if not chosen then
                            chosen = candidates[1] or "clangd"
                            vim.schedule(function()
                                vim.notify(
                                    "No 64-bit clangd >= 20 found. aifabric files will likely OOM\n"
                                    .. "32-bit clangd. Install LLVM 20+ x64 (e.g. winget install LLVM.LLVM)\n"
                                    .. "or download the standalone release into %LOCALAPPDATA%\\clangd-22\\.",
                                    vim.log.levels.WARN
                                )
                            end)
                        end

                        return {
                            chosen,
                            "--background-index",
                            "--background-index-priority=background",
                            "--header-insertion=iwyu",
                            "--completion-style=detailed",
                            "--function-arg-placeholders",
                            "--fallback-style=file", -- respect repo .clang-format
                            "--pch-storage=disk",    -- WinRT preambles are ~180 MB each
                            "-j=4",
                            "--limit-results=20",
                            -- Note: --query-driver is intentionally NOT set.
                            -- clangd would try to invoke cl.exe outside the VS
                            -- dev environment and fail with "driver execution
                            -- failed; return code 2", spamming the LSP log.
                            -- Note: --clang-tidy is intentionally off. It produces
                            -- false positives on MSVC SAL/WIL/cppwinrt code that
                            -- the actual build doesn't flag.
                        }
                    end)(),
                    capabilities = {
                        offsetEncoding = { "utf-16" },
                    },
                    init_options = {
                        -- Flags clangd uses when a file is missing from
                        -- compile_commands.json (e.g. a header opened directly).
                        -- These are clang-style; clangd applies them in
                        -- default driver mode, so MSVC-style `/std:` etc.
                        -- would not be interpreted correctly here.
                        fallbackFlags = {
                            "--target=x86_64-pc-windows-msvc",
                            "-std=c++20",
                            "-fms-compatibility",
                            "-fms-extensions",
                            "-fdelayed-template-parsing",
                            "-DUNICODE", "-D_UNICODE",
                            "-DWIN32_LEAN_AND_MEAN",
                        },
                    },
                },
            },
        },
    },

    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "bash-language-server",
                "powershell-editor-services",
                -- Note: roslyn LSP is not in this Mason registry. roslyn.nvim
                -- downloads Microsoft.CodeAnalysis.LanguageServer itself, so
                -- we don't list it here.
            })
        end,
    },

    --[[ C#: use Microsoft.CodeAnalysis.LanguageServer (Roslyn) which is the
         only LSP that understands the .slnx solution format used by aifabric.
         The seblj/roslyn.nvim plugin wraps it for neovim.

         The plugin discovers the LS binary by probing for, in order:
           1. $MASON/bin/roslyn-language-server.cmd  (Mason install)
           2. roslyn-language-server.cmd on PATH    (`dotnet tool install`)
           3. $MASON/bin/roslyn.cmd                 (legacy Mason path)

         Mason's "roslyn" package is not in this registry, so install one of:
           a. dotnet tool install -g Microsoft.CodeAnalysis.LanguageServer
           b. Drop a CMD shim at $MASON/bin/roslyn-language-server.cmd that
              calls a copy bundled with another tool. For example, the VS Code
              C# extension ships a working LS at
              %USERPROFILE%\.vscode\extensions\ms-dotnettools.csharp-*\.roslyn\Microsoft.CodeAnalysis.LanguageServer.exe
              See docs/editor-clangd-setup.md for the shim contents. ]]
    {
        "seblyng/roslyn.nvim",
        ft = { "cs", "vb" },
        opts = {
            broad_search = true, -- find .slnx anywhere under the repo
            filewatching = "roslyn", -- let the server watch files (faster than nvim)
            config = {
                settings = {
                    ["csharp|inlay_hints"] = {
                        csharp_enable_inlay_hints_for_implicit_object_creation = true,
                        csharp_enable_inlay_hints_for_implicit_variable_types = false,
                    },
                    ["csharp|completion"] = {
                        dotnet_show_completion_items_from_unimported_namespaces = true,
                    },
                },
            },
        },
    },
}
