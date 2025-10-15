-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>qq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>qv", function()
  print(vim.inspect(vim.diagnostic.get(0)))
end, { desc = "Diagnostics Verbose" })

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<space>xf", "<cmd>source %<CR>", { desc = "E[x]ecute current [f]ile" })
-- vim.keymap.set("n", "<space>xx", ":.lua<CR>", { desc = 'E[x]ecute lua vet inte' })
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "E[x]ecute current selection" })

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

vim.keymap.set("n", "grn", vim.lsp.buf.rename)
vim.keymap.set("n", "gra", vim.lsp.buf.code_action)
vim.keymap.set("n", "grr", vim.lsp.buf.references)
vim.keymap.set("n", "gri", vim.lsp.buf.implementation)

vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end)

vim.api.nvim_set_keymap(
  "n",
  "<leader>daf",
  "va{Vd",
  { noremap = true, silent = true, desc = "[D]elete [a] [f]unction" }
)

vim.keymap.set("n", "<leader>la", function()
  require("plugins.sido").add_current_location()
end, { desc = "Add current location to sido" })

vim.keymap.set("n", "<leader>lm", function()
  require("plugins.sido").move_task()
end, { desc = "Move task under cursor" })

vim.keymap.set("n", "<leader>ll", function()
  require("plugins.sido").show_tasks()
end, { desc = "" })

vim.keymap.set("n", "<leader>\\", function()
  require("oil").toggle_float()
end, { desc = "" })

-- _todo-0 figure out a better keybinding
-- vim.keymap.set("n", "<leader>ett", function()
--   require("plugins.go_test").run_current_go_test()
-- end, { desc = "Run Go test under cursor" })
--
-- vim.keymap.set("n", "<leader>eta", function()
--   require("plugins.go_test").run_all_go_tests_in_file()
-- end, { desc = "Run all Go tests in file" })
--
-- vim.keymap.set("n", "<leader>En", function()
--   require("plugins.go_test").run_all_go_tests_in_file()
-- end, { desc = "Run all Go tests in file" })

vim.keymap.set("n", "<leader>en", vim.diagnostic.goto_next, { desc = "[E]rror [n]ext" })
vim.keymap.set("n", "<leader>ep", vim.diagnostic.goto_prev, { desc = "[E]rror [p]revious" })
