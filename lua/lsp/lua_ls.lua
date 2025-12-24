-- lua/lsp/lua_ls.lua

vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".git", ".luarc.json", ".luarc.jsonc" },

  settings = {
    Lua = {
      runtime = {
        version = "Lua 5.1",
        path = vim.split(package.path, ";"),
      },

      diagnostics = {
        globals = { "vim" },
      },

      workspace = {
        library = {
          vim.env.VIMRUNTIME .. "/lua",
          vim.fn.stdpath("config") .. "/lua",
        },
        checkThirdParty = false,
      },

      telemetry = {
        enable = false,
      },
    },
  },
}

