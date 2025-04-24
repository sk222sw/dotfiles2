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

-- Function to show a window with all the currently copied files
function ShowClipboardFiles()
  -- If there are no files, show a notification
  if #_G.clipboard_files == 0 then
    vim.notify("No files in clipboard state", vim.log.levels.INFO)
    return
  end

  -- Create a new buffer for the list
  local buf = vim.api.nvim_create_buf(false, true)

  -- Generate content for the buffer
  local content = { "Clipboard Files:", "" }
  for i, file in ipairs(_G.clipboard_files) do
    table.insert(content, i .. ". " .. file.path .. " (" .. #file.content .. " bytes)")
  end
  table.insert(content, "")
  table.insert(content, "Press 'd' + number to delete a file")
  table.insert(content, "Press 'q' to close this window")

  -- Set the content of the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

  -- Set the buffer to be non-modifiable
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Calculate window dimensions
  local width = 60
  local height = #content + 1
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create a floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Set window options
  vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
  vim.api.nvim_win_set_option(win, "wrap", false)

  -- Set mappings for the buffer
  local function close_window()
    vim.api.nvim_win_close(win, true)
  end

  local function delete_file(num)
    if num >= 1 and num <= #_G.clipboard_files then
      local filename = _G.clipboard_files[num].path
      table.remove(_G.clipboard_files, num)

      -- Close the window
      vim.api.nvim_win_close(win, true)

      -- Rebuild the clipboard content
      if #_G.clipboard_files > 0 then
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
      else
        -- Clear clipboard if no files left
        vim.fn.setreg("+", "")
      end

      vim.notify("Removed " .. filename .. " from clipboard (Total files: " .. #_G.clipboard_files .. ")")

      -- Reopen the window to show updated list
      if #_G.clipboard_files > 0 then
        ShowClipboardFiles()
      end
    end
  end

  -- Set key mappings
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    callback = close_window,
    noremap = true,
    silent = true,
  })

  -- Add mappings for numbers 1-9 to delete files
  for i = 1, 9 do
    vim.api.nvim_buf_set_keymap(buf, "n", "d" .. i, "", {
      callback = function()
        delete_file(i)
      end,
      noremap = true,
      silent = true,
    })
  end

  -- Set buffer name
  vim.api.nvim_buf_set_name(buf, "ClipboardFiles")

  -- Set buffer local options
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
end

-- Create commands
vim.api.nvim_create_user_command("CopyWithFilename", CopyWithFilename, {})
vim.api.nvim_create_user_command("ClearClipboardState", ClearClipboardState, {})
vim.api.nvim_create_user_command("ShowClipboardFiles", ShowClipboardFiles, {})

-- Create keybindings
vim.keymap.set("n", "<leader>cf", CopyWithFilename, { desc = "Copy buffer with filename" })
vim.keymap.set("n", "<leader>cc", ClearClipboardState, { desc = "Clear clipboard state" })
vim.keymap.set("n", "<leader>cs", ShowClipboardFiles, { desc = "Show clipboard files" })
