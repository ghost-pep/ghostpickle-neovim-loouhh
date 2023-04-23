return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    ft = "cs",
    keys = {
      { "<F5>", "<cmd>lua require'dap'.continue()<cr>" },
      { "<F10>", "<cmd>lua require'dap'.step_over()<cr>" },
      { "<F11>", "<cmd>lua require'dap'.step_into()<cr>" },
      { "<F12>", "<cmd>lua require'dap'.step_out()<cr>" },
      { "<Leader>BB", "<cmd>lua require'dap'.toggle_breakpoint()<cr>" },
    },
    config = function()
      local dap = require("dap")
      dap.adapters.coreclr = {
        type = "executable",
        command = os.getenv("LOCALAPPDATA") .. "/netcoredbg/netcoredbg.exe",
        args = { "--interpreter=vscode" },
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "\\bin\\Debug", "file")
          end,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    ft = "cs",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("dapui").setup()
    end,
    keys = {
      { "<Leader>Bt", "<cmd>lua require'dapui'.toggle()<cr>" },
    },
  },
  {
    "folke/neodev.nvim",
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
      experimental = { pathStrict = true },
    },
  },
}
