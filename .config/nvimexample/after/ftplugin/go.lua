vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = false

vim.keymap.set("n", "<leader>td", function()
  require("dap-go").debug_test()
end, { silent = true, desc = "Debug Test" })
