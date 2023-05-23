return {
  "nvim-neotest/neotest",
  dependencies = {
    "Issafalcon/neotest-dotnet",
  },
  opts = function(_, opts)
    opts.adapters = {
      require("neotest-dotnet"),
    }
  end,
  keys = {
    {
      "<leader>tr",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest",
    },
    {
      "<leader>tR",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Show Output",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Output Panel",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop",
    },
    {
      "<leader>tt",
      function()
        require("neotest").run.run({ suite = true })
      end,
      desc = "Run Suite",
    },
  },
}
