-- File: lua/plugins/go_test.lua
local M = {}

-- Define the function inside the module file
local function get_current_go_test_function()
  -- Ensure treesitter is available
  local has_ts, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if not has_ts then
    print("nvim-treesitter is not available")
    return nil
  end

  -- Get current node at cursor
  local node = ts_utils.get_node_at_cursor()
  if not node then
    return nil
  end

  -- Walk up the tree to find a function declaration
  while node do
    if node:type() == "function_declaration" then
      -- Get the function name node
      local name_node = nil
      for i = 0, node:named_child_count() - 1 do
        local child = node:named_child(i)
        if child:type() == "identifier" then
          name_node = child
          break
        end
      end

      if name_node then
        local func_name = vim.treesitter.get_node_text(name_node, 0)
        -- Check if it's a test function (starts with Test)
        if string.match(func_name, "^Test") then
          return func_name
        end
      end
    end
    node = node:parent()
  end

  return nil
end

function M.run_current_go_test()
  local test_name = get_current_go_test_function()
  if not test_name then
    print("No Go test function found at cursor position")
    return
  end

  -- Get current file path
  local file_path = vim.fn.expand("%:p")
  local dir_path = vim.fn.expand("%:p:h")

  -- Create the go test command
  local cmd = string.format("cd %s && go test -v -run ^%s$", dir_path, test_name)

  -- Display which test we're running
  print("Running test: " .. test_name)

  -- Create a floating window for test output
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create buffer for the floating window
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer options - use the newer API
  vim.bo[buf].bufhidden = "wipe"

  -- Window options
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = "Go Test: " .. test_name,
    title_pos = "center",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window options - use the newer API
  vim.wo[win].winblend = 0
  vim.wo[win].winhl = "Normal:Normal"

  -- Set buffer name
  vim.api.nvim_buf_set_name(buf, "Go Test: " .. test_name)

  -- Run the test command in a terminal in this buffer
  vim.fn.termopen(cmd, {
    on_exit = function(job_id, exit_code, event_type)
      -- Optional: Add key mapping to close the window
      vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })

      -- Set the buffer to be modifiable
      vim.bo[buf].modifiable = true

      -- Append status message based on exit code
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local message = exit_code == 0 and { "", "✅ Test completed successfully" }
          or { "", "❌ Test failed with exit code: " .. exit_code }

      vim.api.nvim_buf_set_lines(buf, #lines, #lines, false, message)

      -- Make it unmodifiable again
      vim.bo[buf].modifiable = false
    end,
  })
end

function M.run_all_go_tests_in_file()
  -- Get current file path
  local file_path = vim.fn.expand("%:p")
  local dir_path = vim.fn.expand("%:p:h")
  local file_name = vim.fn.expand("%:t")

  -- Make sure we're in a Go test file
  if not string.match(file_name, "_test%.go$") then
    print("Not in a Go test file")
    return
  end

  -- Create the go test command for the current file only
  local cmd = string.format("cd %s && go test -v ./%s", dir_path, file_name)

  -- Display which file we're testing
  print("Running all tests in: " .. file_name)

  -- Create a floating window for test output
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create buffer for the floating window
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.bo[buf].bufhidden = "wipe"

  -- Window options
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = "Go Tests: " .. file_name,
    title_pos = "center",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window options
  vim.wo[win].winblend = 0
  vim.wo[win].winhl = "Normal:Normal"

  -- Set buffer name
  vim.api.nvim_buf_set_name(buf, "Go Tests: " .. file_name)

  -- Run the test command in a terminal in this buffer
  vim.fn.termopen(cmd, {
    on_exit = function(job_id, exit_code, event_type)
      -- Add key mapping to close the window
      vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })

      -- Set the buffer to be modifiable
      vim.bo[buf].modifiable = true

      -- Append status message based on exit code
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local message = exit_code == 0 and { "", "✅ All tests completed successfully" }
          or { "", "❌ Tests failed with exit code: " .. exit_code }

      vim.api.nvim_buf_set_lines(buf, #lines, #lines, false, message)

      -- Make it unmodifiable again
      vim.bo[buf].modifiable = false
    end,
  })
end

return M
