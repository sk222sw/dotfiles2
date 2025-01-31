return {
  "elixir-tools/elixir-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local elixir = require("elixir")
    local elixirls = require("elixir.elixirls")

    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "elixir",
        "heex",
        "eex",
      },
      highlight = { enable = true },
    })

    elixir.setup({
      nextls = { enable = true },
      credo = { enable = true },
      elixirls = {
        enable = true,
        settings = elixirls.settings({
          dialyzerEnabled = true,
          enableTestLenses = false,
        }),
        on_attach = function(client, bufnr)
          -- vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          -- vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        end,
      },
      projectionist = {
        enable = true,
      },
    })
  end,
}
