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

function M.show_tasks()
  local function pick_files_recursive(folder_path)
    local items = {}
    -- Helper function to recursively get files
    local function scan_dir(path, prefix)
      prefix = prefix or ""
      for name, type in vim.fs.dir(path) do
        local full_path = path .. "/" .. name
        local display_name = prefix .. name
        if type == "file" then
          table.insert(items, {
            text = display_name,
            file = full_path,
            path = full_path,
          })
        elseif type == "directory" and name ~= "." and name ~= ".." then
          scan_dir(full_path, display_name .. "/")
        end
      end
    end

    scan_dir(folder_path)

    -- Sort items numerically by filename
    table.sort(items, function(a, b)
      local num_a = tonumber(a.text:match("(%d+)%.md$"))
      local num_b = tonumber(b.text:match("(%d+)%.md$"))

      if num_a and num_b then
        return num_a < num_b
      end
      if num_a and not num_b then
        return true
      end
      if num_b and not num_a then
        return false
      end
      return a.text < b.text
    end)

    Snacks.picker.pick({
      source = "static",
      items = items,
      title = "Tasks (Tab to select, m to move selected)",
      -- Remove multi = true for now
      keys = {
        ["<Tab>"] = {
          desc = "Toggle selection",
          action = function(picker)
            picker:toggle()
          end,
        },
        ["m"] = {
          desc = "Move selected to IN PROGRESS",
          action = function(picker)
            local selected = picker:selected()
            if not selected or #selected == 0 then
              vim.notify("No files selected")
              return
            end

            -- Create IN_PROGRESS folder if it doesn't exist
            local in_progress_dir = vim.fn.expand("./.sido/tasks/IN PROGRESS")
            vim.fn.mkdir(in_progress_dir, "p")

            local moved_count = 0
            for _, item in ipairs(selected) do
              local filename = vim.fn.fnamemodify(item.file, ":t")
              local new_path = in_progress_dir .. "/" .. filename

              local success = vim.fn.rename(item.file, new_path)
              if success == 0 then
                moved_count = moved_count + 1
              else
                vim.notify("Failed to move: " .. filename, vim.log.levels.ERROR)
              end
            end

            vim.notify("Moved " .. moved_count .. " files to IN PROGRESS")
            picker:close()
          end,
        },
      },
      on_select = function(item)
        -- Single file selection - just open it
        vim.cmd("edit " .. item.file)
      end,
    })
  end
  -- Usage
  pick_files_recursive(vim.fn.expand("./.sido/tasks"))
end

return M
