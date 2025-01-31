local lspAttachTable = {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
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
  -- local capabilities = require("blink.cmp").get_lsp_capabilities()
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  lspconfig.lua_ls.setup({ capabilities = capabilities })
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    init_options = {
      disableSuggestions = true,
    },
  })
  lspconfig.html.setup({
    capabilities = capabilities,
  })
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
  })

  lspconfig.cssls.setup({
    capabilities = capabilities,
  })

  lspconfig.emmet_language_server.setup({
    capabilities = capabilities,
    filetypes = {
      "css",
      "eruby",
      "html",
      "javascript",
      "javascriptreact",
      "less",
      "sass",
      "scss",
      "pug",
      "typescriptreact",
      "heex",
      "ex",
      "html-eex",
      "elixir",
    },
    -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
    -- **Note:** only the options listed in the table are supported.
    init_options = {
      ---@type table<string, string>
      includeLanguages = {},
      --- @type string[]
      excludeLanguages = {},
      --- @type string[]
      extensionsPath = {},
      --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
      preferences = {},
      --- @type boolean Defaults to `true`
      showAbbreviationSuggestions = true,
      --- @type "always" | "never" Defaults to `"always"`
      showExpandedAbbreviation = "always",
      --- @type boolean Defaults to `false`
      showSuggestionsAsSnippets = false,
      --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
      syntaxProfiles = {},
      --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
      variables = {},
    },
  })

  lspconfig.tailwindcss.setup({
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern(
        "tailwind.config.ts",
        "tailwind.config.js",
        "tailwind.config.cjs",
        "package.json",
        ".git"
      )(fname) or vim.fn.getcwd()
    end,
    capabilities = capabilities,
    filetypes = { "html", "css", "scss", "javascript", "typescript", "react", "heex", "elixir", "eelixir" },
    init_options = {
      userLanguages = {
        elixir = "html",
        heex = "html",
        eelixir = "html",
      },
    },
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            'class[:]\\s*"([^"]*)"',
            'class\\s*=\\s*"([^"]+)"',           -- HTML & HEEx class attributes
            'class:\\s*"([^"]+)"',               -- JSX/TSX
            '~H""".*class="([^"]+)".*"""',       -- Phoenix HEEx ~H""" class attributes
            '~H".*class="([^"]+)".*"',           -- Another HEEx-style interpolation
            { 'class[:]\\s*"([^"]*)"', 1 },      -- For Phoenix `class="..."` syntax
            { '~H"([^"]*)"',           1 },      -- For Phoenix `~H` and `HEEx` tags
            'class\\s*=\\s*"([^"]+)"',           -- Standard class="" attributes (HTML, HEEx)
            'class:\\s*"([^"]+)"',               -- JSX/TSX
            '{\\s*class\\s*,\\s*"([^"]+)"\\s*}', -- Tailwind in Elixir maps
            'class:\\s*"([^"]+)"',               -- More JSX/TSX patterns
            "class=\\{(.*)\\}",                  -- Handle class={@variable} interpolation
          },
        },
        includeLanguages = {
          elixir = "html-eex",
          eelixir = "html-eex",
          heex = "html-eex",
          ["html-eex"] = "html",
          ["phoenix-heex"] = "html",
        },
      },
    },
    on_attach = function(client, bufnr)
      -- **Force Tailwind to recognize `heex` & `elixir` as `html-eex`**
      if client.name == "tailwindcss" then
        client.config.settings.tailwindCSS.includeLanguages = {
          heex = "html-eex",
          elixir = "html-eex",
          eelixir = "html-eex",
        }
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
    end,
  })

  -- lspconfig.tailwindcss.setup({
  -- })
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
