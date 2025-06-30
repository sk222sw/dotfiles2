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

-- Component extraction keymap
vim.keymap.set("v", "<leader>rc", function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  
  local component_name = vim.fn.input("Component name: ")
  if component_name ~= "" then
    local component_content = table.concat(lines, "\n")
    local new_component = string.format("const %s = () => {\n  return (\n    %s\n  );\n};\n\nexport default %s;", 
      component_name, component_content, component_name)
    
    -- Replace selection with component usage
    vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, {"<" .. component_name .. " />"})
    
    -- Create new file
    local filename = string.format("%s.jsx", component_name)
    vim.cmd("tabnew " .. filename)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(new_component, "\n"))
  end
end, { desc = "Extract React component" })