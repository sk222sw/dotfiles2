return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",      -- Change theme if needed
          globalstatus = true, -- Unified statusline
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch", -- Uses gitsigns automatically if installed
            {
              "diff",
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
              symbols = { added = " ", modified = " ", removed = " " }, -- Customize icons
              color_added = "#a3be8c", -- Color for added lines
              color_modified = "#ebcb8b", -- Color for modified lines
            },
          },
          lualine_c = {
            "filename",
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
          },
          lualine_x = {
            "filetype",
            -- "encoding",
            -- "fileformat",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        -- extensions = { "fugitive", "nvim-tree" },
      })
    end,
  },
  {
    "vimpostor/vim-tpipeline",
    event = "VeryLazy",
  },
}
