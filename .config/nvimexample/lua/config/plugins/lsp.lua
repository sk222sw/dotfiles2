local lspAttachTable = {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    if client and client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
        end,
      })
    end
  end,
}

local function setupCapabilities()
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  lspconfig.lua_ls.setup({ capabilities = capabilities })

  lspconfig.html.setup({
    capabilities = capabilities,
  })
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
  })

  lspconfig.cssls.setup({
    capabilities = capabilities,
  })

  lspconfig.html.setup({
    capabilities = capabilities,
  })

  lspconfig.svelte.setup({
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
    end,
  })

  -- React/JavaScript development
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    settings = {
      typescript = {
        preferences = {
          includePackageJsonAutoImports = "auto",
        },
      },
    },
  })

  -- BiomeJS for linting and formatting
  lspconfig.biome.setup({
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "Bilal2453/luvit-meta", lazy = true },
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      setupCapabilities()

      vim.api.nvim_create_autocmd("LspAttach", lspAttachTable)
    end,
  },
}
