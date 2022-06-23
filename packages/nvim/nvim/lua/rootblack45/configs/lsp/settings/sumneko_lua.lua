local api, lsp = vim.api, vim.lsp

api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.lua',
    callback = function()
        lsp.buf.formatting_seq_sync(nil, 3000)
    end,
})

return {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = {
                    'vim',
                },
            },
            workspace = {
                library = api.nvim_get_runtime_file('', true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
