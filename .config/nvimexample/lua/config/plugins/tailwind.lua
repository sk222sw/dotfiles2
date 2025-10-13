-- return {
--   "MaximilianLloyd/tw-values.nvim",
--   -- enabled = false,
--   keys = {
--     { "<leader>tw", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
--   },
--   opts = {
--     border = "rounded",          -- Valid window border style,
--     show_unknown_classes = true, -- Shows the unknown classes popup
--     focus_preview = true,        -- Sets the preview as the current window
--     copy_register = "",          -- The register to copy values to,
--     keymaps = {
--       -- copy = "<C-y>", -- Normal mode keymap to copy the CSS values between {}
--     },
--   },
-- }

return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
    "neovim/nvim-lspconfig",         -- optional
  },
  opts = {},                         -- your configuration
}
