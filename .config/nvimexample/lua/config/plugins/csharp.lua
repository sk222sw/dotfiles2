return {
  "iabdelkareem/csharp.nvim",
  dependencies = {
    "williamboman/mason.nvim", -- Required, automatically installs omnisharp
    "mfussenegger/nvim-dap",
    "Tastyep/structlog.nvim",
  },
  config = function()
    require("mason").setup()
    require("csharp").setup()
  end,
  opts = {
    lsp = {
      cmd_path = "/home/sonny/.local/share/nvimexample/mason/packages/omnisharp/OmniSharp",
    },
  },
}
-- return {
--   "seblyng/roslyn.nvim",
--   ft = "cs",
--   ---@module 'roslyn.config'
--   ---@type RoslynNvimConfig
--   opts = {
--     -- your configuration comes here; leave empty for default settings
--   },
-- }
