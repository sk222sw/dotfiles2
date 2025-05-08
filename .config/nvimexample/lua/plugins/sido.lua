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
        '~/bin/sido add -f "%s" -l %d --title "%s" --description "%s"',
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

return M
