vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Open a terminal",
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Function to generate session name based on the folder name
local function get_session_name()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t") -- Uses folder name
end

-- Auto-save session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local session_name = get_session_name()
    require("mini.sessions").write(session_name)
  end,
})

-- Auto-load session on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local sessions = require("mini.sessions")
    local session_name = get_session_name()
    if sessions.select() ~= nil then
      sessions.read(session_name)
    end
  end,
})
