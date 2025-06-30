vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.softtabstop = 2

-- React-specific keymaps
vim.keymap.set("n", "<leader>rf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format file" })

vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("silent !npm run dev")
end, { desc = "Run React dev server" })