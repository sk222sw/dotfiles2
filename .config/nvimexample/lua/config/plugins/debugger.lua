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

      vim.keymap.set("n", "<leader>dh", function()
        require("dap.ui.widgets").hover()
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
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Debug with args",
            request = "launch",
            program = "${file}",
            args = require("dap-go").get_arguments, -- Function to prompt for arguments
          },
          {
            type = "go",
            name = "Debug with join command",
            request = "launch",
            program = "${workspaceFolder}/main.go",
            -- args = { "join", "--source", "1", "--target", "3" },
            args = require("dap-go").get_arguments, -- Function to prompt for arguments
            buildFlags = "",
          },
          {
            type = "go",
            name = "Debug with custom args",
            request = "launch",
            program = "${workspaceFolder}/main.go",
            args = function()
              local args_string = vim.fn.input("Arguments: ", "join --source 1 --target 3")
              return vim.split(args_string, " ")
            end,
          },
        },
      })
    end,
  },
}
