---@type vim.lsp.Config
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        '.luacheckrc',
        '.git',
    },
    settings = {
        Lua = {
            runtime = {
                version = 'Lua 5.1.1',
            },
            codeLens = { enable = true },
            hint = { enable = true, semicolon = 'Disable' },
        },
    },
}

