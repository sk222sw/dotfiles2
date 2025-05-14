-- Global variable to store clipboard state
if not _G.clipboard_files then
  _G.clipboard_files = {}
end

-- Global variable to store project structure
if not _G.project_structure then
  _G.project_structure = nil
end

-- Function to get file structure like tree command
function GetProjectStructure()
  -- Find git root directory for the project
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

  if vim.v.shell_error ~= 0 then
    -- Fallback to current working directory if not in a git repo
    git_root = vim.fn.getcwd()
  end

  -- Get the project name from the root directory
  local project_name = vim.fn.fnamemodify(git_root, ":t")

  -- Run tree command to get file structure (with some common excludes)
  local cmd = "find "
      .. git_root
      .. " -type f -not -path '*/\\.*' -not -path '*/node_modules/*' -not -path '*/target/*' -not -path '*/build/*'"
      .. " | sort"

  local files = vim.fn.systemlist(cmd)

  -- Remove the git_root prefix from each file path for cleaner output
  for i, file in ipairs(files) do
    files[i] = file:sub(#git_root + 2) -- +2 to account for the trailing slash
  end

  -- Build tree structure
  local structure = "# Project structure: " .. project_name .. "\n"
  structure = structure .. "```\n"
  structure = structure .. project_name .. "/\n"

  -- Track directories to create proper tree indentation
  local dirs = {}
  local prev_parts = {}

  for _, file in ipairs(files) do
    local parts = {}
    for part in string.gmatch(file, "[^/]+") do
      table.insert(parts, part)
    end

    -- Figure out the common prefix with previous entry
    local common_prefix = 0
    for i = 1, math.min(#prev_parts, #parts - 1) do
      if prev_parts[i] == parts[i] then
        common_prefix = i
      else
        break
      end
    end

    -- Add directories that weren't in the previous line
    for i = common_prefix + 1, #parts - 1 do
      structure = structure .. string.rep("│   ", i - 1) .. "├── " .. parts[i] .. "/\n"
    end

    -- Add the file itself
    local indent = string.rep("│   ", #parts - 1)
    local prefix = "└── "
    if #files > 1 then
      prefix = "├── "
    end
    structure = structure .. indent .. prefix .. parts[#parts] .. "\n"

    prev_parts = parts
  end

  structure = structure .. "```"

  return structure
end

-- Function to update the clipboard with all content
function UpdateClipboard()
  -- Build clipboard content
  local clipboard = ""

  -- Add project structure if it exists
  if _G.project_structure then
    clipboard = _G.project_structure .. "\n\n"
  end

  -- Add all files
  for i, file in ipairs(_G.clipboard_files) do
    if i > 1 or _G.project_structure then
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

  -- Update clipboard
  UpdateClipboard()

  vim.notify("Copied " .. filepath .. " (Total files: " .. #_G.clipboard_files .. ")")
end

-- Function to add project structure to clipboard
function AddProjectStructure()
  -- Generate the project structure
  _G.project_structure = GetProjectStructure()

  -- Update clipboard with new structure
  UpdateClipboard()

  vim.notify("Added project structure to clipboard")
end

-- Function to clear the clipboard state
function ClearClipboardState()
  _G.clipboard_files = {}
  _G.project_structure = nil
  vim.fn.setreg("+", "")
  vim.notify("Clipboard state cleared")
end

-- Function to show a window with all the currently copied files
function ShowClipboardFiles()
  -- If there are no files and no project structure, show a notification
  if #_G.clipboard_files == 0 and not _G.project_structure then
    vim.notify("No files in clipboard state", vim.log.levels.INFO)
    return
  end

  -- Create a new buffer for the list
  local buf = vim.api.nvim_create_buf(false, true)

  -- Generate content for the buffer
  local content = { "Clipboard Contents:", "" }

  if _G.project_structure then
    table.insert(content, "- Project Structure (tree)")
  end

  for i, file in ipairs(_G.clipboard_files) do
    table.insert(content, i .. ". " .. file.path .. " (" .. #file.content .. " bytes)")
  end

  table.insert(content, "")
  table.insert(content, "Press 'd' + number to delete a file")
  table.insert(content, "Press 'ds' to delete project structure")
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

      -- Update the clipboard content
      UpdateClipboard()

      vim.notify("Removed " .. filename .. " from clipboard (Total files: " .. #_G.clipboard_files .. ")")

      -- Reopen the window to show updated list
      if #_G.clipboard_files > 0 or _G.project_structure then
        ShowClipboardFiles()
      end
    end
  end

  local function delete_structure()
    _G.project_structure = nil

    -- Close the window
    vim.api.nvim_win_close(win, true)

    -- Update the clipboard content
    UpdateClipboard()

    vim.notify("Removed project structure from clipboard")

    -- Reopen the window to show updated list
    if #_G.clipboard_files > 0 then
      ShowClipboardFiles()
    end
  end

  -- Set key mappings
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    callback = close_window,
    noremap = true,
    silent = true,
  })

  -- Add mapping to delete project structure
  vim.api.nvim_buf_set_keymap(buf, "n", "ds", "", {
    callback = delete_structure,
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
vim.api.nvim_create_user_command("AddProjectStructure", AddProjectStructure, {})

-- Create keybindings
vim.keymap.set("n", "<leader>cf", CopyWithFilename, { desc = "Copy buffer with filename" })
vim.keymap.set("n", "<leader>cc", ClearClipboardState, { desc = "Clear clipboard state" })
vim.keymap.set("n", "<leader>cs", ShowClipboardFiles, { desc = "Show clipboard files" })
vim.keymap.set("n", "<leader>ct", AddProjectStructure, { desc = "Add project tree structure" })
