local lsp, api = vim.lsp, vim.api

local util = require 'lspconfig/util'

api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
        lsp.buf.formatting_seq_sync(nil, 3000)
    end,
})

api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
        local params = lsp.util.make_range_params(nil, lsp.util._get_offset_encoding())
        params.context = { only = { 'source.organizeImports' } }

        local result = lsp.buf_request_sync(0, 'textDocument/codeAction', params, 3000)
        for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    lsp.util.apply_workspace_edit(r.edit, lsp.util._get_offset_encoding())
                else
                    lsp.buf.execute_command(r.command)
                end
            end
        end
    end,
})

return {
    cmd = { 'gopls', 'serve' },
    filetypes = { 'go', 'gomod' },
    root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
}
