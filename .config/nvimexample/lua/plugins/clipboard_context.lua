-- Global variable to store clipboard state
if not _G.clipboard_files then
  _G.clipboard_files = {}
end

-- Function to copy file with filename
function CopyWithFilename()
  -- Get full relative path and filename
  local filepath = vim.fn.expand("%:.") -- Relative path from current directory
  local filename = vim.fn.expand("%:t")
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- Check if file exists in state and update/add it
  local found = false
  for i, file in ipairs(_G.clipboard_files) do
    if file.path == filepath then
      _G.clipboard_files[i].content = content
      found = true
      break
    end
  end

  if not found then
    table.insert(_G.clipboard_files, {
      name = filename,
      path = filepath,
      content = content,
    })
  end

  -- Build clipboard content
  local clipboard = ""
  for i, file in ipairs(_G.clipboard_files) do
    if i > 1 then
      clipboard = clipboard .. "\n\n"
    end

    -- Get file extension
    local ext = file.name:match("%.([^%.]+)$") or "txt"

    -- Add file with path and markdown formatting
    clipboard = clipboard .. "# File: " .. file.path .. "\n"
    clipboard = clipboard .. "```" .. ext .. "\n"
    clipboard = clipboard .. file.content
    clipboard = clipboard .. "\n```"
  end

  -- Copy to clipboard
  vim.fn.setreg("+", clipboard)
  vim.notify("Copied " .. filepath .. " (Total files: " .. #_G.clipboard_files .. ")")
end

-- Function to clear the clipboard state
function ClearClipboardState()
  _G.clipboard_files = {}
  vim.notify("Clipboard state cleared")
end

-- Create commands
vim.api.nvim_create_user_command("CopyWithFilename", CopyWithFilename, {})
vim.api.nvim_create_user_command("ClearClipboardState", ClearClipboardState, {})

-- Create keybindings
vim.keymap.set("n", "<leader>cf", CopyWithFilename, {})
vim.keymap.set("n", "<leader>cc", ClearClipboardState, {})
