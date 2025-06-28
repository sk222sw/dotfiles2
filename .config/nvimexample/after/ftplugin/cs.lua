-- C# filetype-specific keymaps for csharp.nvim
local csharp = require("csharp")

-- Set up keymaps with <leader>C prefix
vim.keymap.set("n", "<leader>Cr", csharp.run_project, { desc = "Run C# project", buffer = true })
-- vim.keymap.set("n", "<leader>Cb", csharp.build_project, { desc = "Build C# project", buffer = true })
-- vim.keymap.set("n", "<leader>Ct", csharp.debug, { desc = "Debug C# project", buffer = true })
vim.keymap.set("n", "<leader>Cf", csharp.fix_all, { desc = "Fix all C# issues", buffer = true })
vim.keymap.set("n", "<leader>Cu", csharp.fix_usings, { desc = "Fix C# usings", buffer = true })

vim.keymap.set("n", "<leader>Cd", csharp.go_to_definition, { desc = "Go to definition", buffer = true })

vim.keymap.set("n", "<leader>CC", function()
  vim.cmd("!dotnet csharpier format " .. vim.fn.expand("%"))
end, { desc = "Format current file with CSharpier" })
