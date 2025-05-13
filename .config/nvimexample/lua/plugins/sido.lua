local M = {}

function M.add_current_location()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")

  -- Create an input popup for the title
  vim.ui.input({
    prompt = "Title: ",
  }, function(title)
    if not title then
      return
    end -- User canceled

    -- After getting title, create a second popup for description
    vim.ui.input({
      prompt = "Description: ",
    }, function(description)
      if not description then
        return
      end -- User canceled

      -- Now run the command with all parameters
      local cmd = string.format(
        '~/bin/sido add -f "%s" -l %d --title "%s" --description "%s" --tag --sync',
        file,
        line,
        title:gsub('"', '\\"'),
        description:gsub('"', '\\"')
      )

      vim.notify("Running: " .. cmd)
      vim.cmd("!" .. cmd)
    end)
  end)
end

function M.move_task()
  local current_line = vim.fn.getline(".")
  local task_number = current_line:match("// _todo%-(%d+)")

  if not task_number then
    vim.notify("No todo ID found in current line. Expected format: // _todo-123", vim.log.levels.ERROR)
    return
  end

  local options = { "NOT STARTED", "IN PROGRESS", "DONE" }

  vim.ui.select(options, {
    prompt = "Select task status:",
    format_item = function(item)
      return item
    end,
  }, function(selected_directory, idx)
    if not selected_directory then
      return
    end -- User cancelled

    local cmd = string.format('~/bin/sido move --task %s --directory "%s"', task_number, selected_directory)

    vim.notify("Running: " .. cmd)
    vim.cmd("!" .. cmd)
  end)
end

return M
