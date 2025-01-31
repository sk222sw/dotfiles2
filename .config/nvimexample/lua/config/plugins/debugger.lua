return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("dapui").setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.keymap.set("n", "<leader>dt", ":DapUiToggle<CR>", {})
      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, {})
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, {})
      vim.keymap.set("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", {})

      vim.keymap.set("n", "<F5>", function()
        require("dap").continue()
      end)
      vim.keymap.set("n", "<F10>", function()
        require("dap").step_over()
      end)
      vim.keymap.set("n", "<F11>", function()
        require("dap").step_into()
      end)
      vim.keymap.set("n", "<S-F11>", function()
        require("dap").step_out()
      end)

      -- Define the highlight group for the breakpoint icon (red)
      vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = "#FF0000" })

      -- Define the highlight group for the line background (gray)
      vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#31353f" }) -- Adjust the gray color as needed

      -- Set the debugger icon and apply the highlight groups
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "●", texthl = "DapBreakpointSign", linehl = "DapBreakpointLine", numhl = "DapBreakpointLine" }
      )
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dap-go").setup()
    end,
  },
}
