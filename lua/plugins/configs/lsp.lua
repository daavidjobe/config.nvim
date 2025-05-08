local M = {}

function M.setup()
  local lspconfig = require("lspconfig")

  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = {
            vim.env.VIMRUNTIME,
            vim.fn.stdpath("config") .. "/lua",
          },
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })

  -- TypeScript / JavaScript
  lspconfig.ts_ls.setup({
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Use prettier
    end,
  })

  -- Tailwind CSS
  lspconfig.tailwindcss.setup({})


  -- Eslint
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    callback = function()
      -- Get current buffer file name
      local buf = vim.api.nvim_get_current_buf()
      local filename = vim.api.nvim_buf_get_name(buf)

      -- Run eslint_d --fix on the file
      vim.fn.jobstart({ "eslint_d", "--fix", filename }, {
        on_exit = function(_, code, _)
          if code ~= 0 then
            vim.notify("eslint_d failed to format " .. filename, vim.log.levels.WARN)
          else
            -- Reload the buffer if eslint_d changed the file
            vim.api.nvim_command("edit")
          end
        end,
      })
    end,
  })

end

return M
